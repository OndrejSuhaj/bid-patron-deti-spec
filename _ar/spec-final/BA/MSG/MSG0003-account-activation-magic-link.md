---
doc_id: MSG0003
title: Account Activation (Magic-Link)
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0014
  - UC0001
references:
  - EN0008
  - EN0006
  - EN0001
  - ES0006
---

# MSG0003 – Aktivace účtu (magic-link)

## Účel

Umožnit prvnímu patronovi, nebo samoregistrujícímu se rodiči/žadateli (fundraiserovi) či podporovateli/
dárci, aktivovat svůj účet v zóně kliknutím na magic-link, aby se mohl přihlásit a jednat ve věci své
žádosti nebo daru, aniž by mu bylo kdy zobrazeno nebo po něm vyžadováno zadání hesla [UC0014; UC0001].

---

## Spouštěcí událost

UC0014 – Autentizace a správa přístupu (dílčí flow samoregistrace, UC0014.2) a UC0001 – Podání žádosti
(samoregistrace zákazníka, UC0001.1) — krok aktivace vyvolaný volající stranou, který následuje po
vytvoření nového uživatele (EN0008). Obě spouštěcí cesty vytvářejí účet v odlišných stavech: cesta
samoregistrace vede k aktivnímu, bezheslovému uživateli; cesta vytvořená žádostí (blokovaný uživatel)
vede k blokovanému uživateli, jehož aktivace jako interní vedlejší efekt resetuje heslo (životní cyklus
EN0008). Důsledky tohoto rozdílu vnímatelné příjemcem jsou popsány v sekci Obsah zprávy.

Spouští se:

- Při podání vlastní části žádosti prvním patronem (stav dle Notification Matrix `waiting_for_fundraiser`,
  odpovídá SC-1B krok 9 / SC-11B krok 2 — "Pokud jde o PRVNÍ žádost patrona: odešle e-mail s aktivací
  účtu").
- Při samoregistraci, která automaticky vytvoří účet rodiče/fundraisera nebo podporovatele/dárce (stav
  dle Notification Matrix `new`; SC-11A krok 3 — "Odešle e-mail s aktivací účtu / uvítací e-mail
  rodiči").

**Nespouští** se opakovaně pro stranu, která už má aktivovaný účet: existující uživatel, který znovu
podává žádost, je nasměrován do svého účtu místo obdržení nové aktivační zprávy (SC-11B krok 7 —
"NEODESÍLÁ další aktivační e-mail již registrovanému patronovi"; AF2 UC0001 znovu odesílá pouze obecný
aktivační/účtový e-mail, nikoli duplicitní zprávu o první aktivaci, existujícímu uživateli).

---

## Příjemci

- Nově (nebo dosud ne-) aktivovaná strana podle role — patron, rodič/žadatel (fundraiser), nebo
  podporovatel/dárce — identifikovaná právě vytvořeným nebo znovu použitým uživatelem (EN0008) a jeho
  propojeným kontaktem (EN0006).
- Kanál: pouze e-mail, prostřednictvím transakční komunikační funkce platformy nad Mautic (ES0006).
  Neexistuje žádný protějšek v podobě notifikace v zóně — příjemce ještě nemá autentizovanou relaci,
  ve které by se dala zobrazit.
- Nepotvrzena žádná odlišnost obsahu pro CZ/RO/MD nad rámec obecného rozlišení šablon podle země
  aplikovaného na všechny transakční zprávy [ES0006]. Mapování šablon podle země pro MD nemusí tuto
  zprávu definovat pro každou roli — zaznamenáno níže jako otevřená mezera v evidenci, nikoli tvrzeno
  jako fakt.

---

## Obsah zprávy

Konceptuální informační prvky, které zpráva musí nést:

- Uvítací výzva / výzva k aktivaci účtu adresovaná roli příjemce (patron, rodič/fundraiser, nebo
  podporovatel/dárce).
- Aktivační odkaz (magic-link), který po otevření aktivuje účet a rovnou přihlásí příjemce do jeho
  zóny — bez samostatného zadávání hesla.
- Dostatek kontextu, aby příjemce věděl, kam ho odkaz zavede: nový příjemce pokračuje na svůj rozpracovaný
  formulář žádosti; již registrovaný příjemce se dostane do svého existujícího účtu/zóny.
- Přihlašovací údaje (heslo) nejsou nikdy zobrazeny ani přenášeny v čitelné podobě na žádné ze
  spouštěcích cest. Cesta samoregistrace ponechává účet bezheslový; cesta vytvořená žádostí (blokovaný
  uživatel) provádí jako vedlejší efekt aktivace interní reset hesla (životní cyklus EN0008), avšak toto
  heslo není příjemci nikdy zpřístupněno — odkaz je v obou případech mechanismem aktivace vnímaným
  příjemcem.

Značkování šablony, znění předmětu ani styling zde nejsou specifikovány — jde o záležitosti
doručování/šablony ve vlastnictví odchozího transportu, nikoli tohoto kontraktu [ES0006].

---

## Nejistoty / Poznámky

- Odlišuje se od MSG0004 (přihlašovací magic-link): tato zpráva se spouští při prvním vytvoření/aktivaci
  účtu jako vedlejší efekt registrace nebo prvního podání patronem (UC0014, UC0001); MSG0004 pokrývá
  přihlašovací odkaz vyžádaný na vyžádání proti **již aktivovanému** existujícímu účtu. Oba sdílejí
  stejný mechanismus doručení přes magic-link, ale jsou spouštěny odlišnými událostmi pro odlišné stavy
  účtu.
- Doba platnosti aktivačního odkazu je dlouhá (zdokumentováno na úrovni identity/access-control
  kapability, zde neopakováno) a jeho odeslání jako vedlejší efekt znovu aktivuje dříve blokovaný účet —
  jde o current-state behaviorální charakteristiku sdíleného aktivačního mechanismu, nikoli o vlastnost
  obsahu této zprávy.
- `Uncertain`: zda je aktivační odkaz jednorázový, nebo zůstává použitelný opakovaně v rámci své doby
  platnosti, není potvrzeno. Odkaz je zde popsán neutrálně (jako aktivační magic-link), nikoli jako
  "jednorázový"; podkladový mechanismus se zdá spoléhat na víceúčelový rehash token spíše než na
  jednorázový token, avšak toto nebylo v evidenci přezkoumané pro tento dokument potvrzeno — označeno
  jako otevřená mezera, nikoli tvrzeno žádným směrem.
- `Uncertain`: zda je sada šablon podle země použitá pro tuto zprávu plně definována pro nasazení MD pro
  každou roli příjemce (patron/fundraiser/podporovatel), není v evidenci přezkoumané pro tento dokument
  potvrzeno — označeno zde jako otevřená mezera, nikoli tvrzeno žádným směrem.
- Záměrně ponecháno obecněji: Notification Matrix a scénáře SC-1B/SC-11A/SC-11B dokládají spouštěcí
  událost, role příjemců a chování zabraňující duplicitě, avšak nespecifikují znění zprávy ani text
  předmětu, které jsou z tohoto kontraktu záměrně vyloučeny.
