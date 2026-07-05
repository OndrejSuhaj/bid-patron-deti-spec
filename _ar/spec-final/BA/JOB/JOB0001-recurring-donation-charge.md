---
doc_id: JOB0001
title: Recurring Donation Charge
canonical_layer: JOB
spec_type: job-contract
status: canonical
modules: []
job_type: scheduler
references:
  - FN0010
  - FN0008
  - FN0007
  - EN0009
  - EN0010
  - ES0001
  - ES0002
  - MSG0022
  - MSG0023
---

# JOB0001 – Zúčtování trvalého daru

## Účel

Zúčtovat aktivní plány trvalého daru (**recurring donation**, glosář C017), u kterých nastalo
měsíční datum splatnosti, vytvořit pro každý plán novou dceřinou dárcovskou Transaction a zaúčtovat
ji přes regionální platební bránu. Realizuje zúčtovací větev FN0010 (Recurring Donation Scheduling &
Charging).

Klasifikace: **Confirmed** (cron trigger, výběr splatných plánů, zúčtování i kaskáda vedlejších
efektů jsou doloženy ve zdrojovém kódu).

## Model spouštění

- Plánované. Dvě nezávislé cron jednotky per region, každá jako implementace platformového cron
  hooku:
  - CZ brána (ComGate) — podmíněno `environment=production AND country=cz`.
  - RO brána (Netopia/MobilPay) — podmíněno `country=ro` (pozn.: RO větev **nemá** žádnou pojistku
    na environment — i neprodukční RO instance se pokouší zúčtovávat platby).
- Hlavní frekvence: platformový cron tick běží **hodinově** (`0 * * * *`, dedikovaný cron kontejner
  — evidence `intake/current-solution/_source/patronus/docker-compose.yml:70`). Každá jednotka se
  sama omezuje prostřednictvím persistovaného stavového klíče na **maximálně jednou denně**, přičemž
  příští okno je zaokrouhleno na 04:00. Úplně první běh pouze inicializuje stavový klíč a vrátí se
  bez zúčtování.
- MD (MAIB) **nemá** ve zdrojovém kódu žádný cron pro zúčtování trvalého daru. `Confirmed` absence.
- Evidence: `comgate/comgate.module:15` → `comgate/src/ComgateCron.php:15`; `netopia/netopia.module:15`
  → `netopia/src/NetopiaCron.php:17`. Plná dokumentace: FLW0007.

## Rozsah vstupu

- Splatné plány trvalého daru se vybírají syrovým SQL dotazem nad tabulkou plánů trvalého daru: den
  v měsíci se shoduje s dnešním dnem (den `>28` je sbalen na `1`), plán není zrušen a od posledního
  zúčtování uplynulo ≥28 dní.
- ComGate navíc požaduje, aby rodičovská Transaction nesla id gateway recurring/preauth.
- Netopia navíc požaduje neexpirovaný uložený token karty a navíc cool-off skip vázaný na sbalení dne
  (uživatel je vynechán, pokud jeho poslední zrušená recurring Transaction není starší než 4 dny).

## Pravidla zpracování

- Pro každý splatný plán: načte se rodičovská Transaction a její záznam recurring; vytvoří se nová
  dceřiná Transaction, která kopíruje cenu/uživatele/kampaň/příznaky s výchozím čekajícím platebním
  stavem a nastaveným příznakem recurring; zavolá se brána pro zúčtování (ComGate recurring endpoint
  / Netopia token charge SOAP); při vrácení id od gateway se toto id zapíše na dceřinou Transaction a
  posune se časová značka posledního zúčtování plánu.
- ComGate napevno směruje dceřinou Transaction na CZ transparentní účet kampaně, čímž se ztrácí
  původní atribuce k příběhu. Netopia směruje na živou kampaň, pokud je aktivní, jinak na
  nakonfigurovaný transparentní účet.

## Vedlejší efekty

- Pro každý splatný plán se vytvoří jedna dceřiná dárcovská Transaction s platebním stavem PAID
  (optimisticky) nebo CANCELLED. Časová značka posledního zúčtování plánu se posune pouze v případě,
  že volání gateway neselhalo (plán se selháním zůstává splatný a je znovu vyzkoušen následující
  cron den). Viz EN0009, EN0010.
- Uložení dceřiné Transaction se stavem PAID spouští plnou kaskádu PAID pro dar (vlastní FN0007):
  poděkovací zpráva (MSG0022 potvrzení o platbě trvalého daru přes FN0019), přepočet vybrané částky
  kampaně, automatické rozdělení přeplatku, zařazení do fronty pro index vyhledávání (→ JOB0013),
  reaktivace blokovaného vlastníka a Slack notifikace pro CZ+prod.
- Větev Netopia CANCELLED navíc odesílá uživateli upomínkovou zprávu o neúspěšném zúčtování
  (MSG0023). ComGate obdobnou upomínkovou zprávu nemá.
- Volání jiných systémů: ComGate (ES0001) recurring charge; Netopia/MobilPay (ES0002) token charge;
  Telegram provozní upozornění při chybějících datech / chybě zúčtování (→ FN0023).

## Idempotence

- **Slabá / rizikové.** Jediná deduplikace je aplikační SQL pojistka na 28 dní; nad plánem během
  zúčtování neexistuje žádný zámek/rezervace a časová značka posledního zúčtování se zapisuje až po
  volání gateway. Překryv cron běhů, nebo selhání mezi zúčtováním a zápisem časové značky, může vést
  k dvojímu zúčtování téhož plánu. Žádné unique omezení nevynucuje jedno zúčtování za období.
- ComGate zaznamená dceřinou Transaction jako PAID pouze na základě toho, že volání zúčtování
  nevyhodilo výjimku (autoritativní výsledek přichází později přes asynchronní platební callback),
  takže čekající nebo zamítnutá platba může být lokálně zaznamenána jako PAID.

## Zpracování chyb

- Chyby zúčtování jednotlivého plánu jsou zachyceny uvnitř smyčky a zalogovány (Telegram); plán
  není odebrán z plánu zpracování, takže se opakuje následující cron den, bez politiky zrušení po
  N selháních.
- Chyby v nastavení/SQL jsou zalogovány a **znovu vyhozeny (re-throw)** wrapperem cron hooku, což
  může přerušit celý běh platformového cronu pro daný tick.
- Rizika narušení integrity peněz a dvojího zúčtování jsou dokumentovaným current-state chováním
  (viz FLW0007 Failure Modes; poznámky FN0010).

## Odkazy

- FN: FN0010, FN0008, FN0007, FN0019
- UC: UC0007, UC0006
- EN: EN0009, EN0010, EN0004
- ES: ES0001, ES0002
- MSG: MSG0022 (potvrzení o zúčtování trvalého daru), MSG0023 (neúspěšné zúčtování trvalého daru /
  RO upomínka)
- Evidence: FLW0007

## Otevřené body

- Přesná interakce hodinového vs. denního cyklu (self-throttle zaokrouhluje na 04:00, ale cron tick
  je hodinový); skutečný čas zúčtování závisí na tom, kdy nastane první tick po 04:00. `Partial`.
- Zda zrušení překlopí plán do neaktivního stavu, není zde doloženo (Hypothesis — viz FN0010).
