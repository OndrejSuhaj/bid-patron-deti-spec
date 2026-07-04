---
doc_id: UC0006
title: Confirm Payment (Gateway Callback)
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0006 — Potvrzení platby (callback platební brány)

## Záhlaví

| Pole | Hodnota |
|---|---|
| ID UC | UC0006 |
| Název | Potvrzení platby (callback platební brány) |
| Ohraničený kontext | C4 |
| Primární aktér(y) | Integration(PaymentGateway), System |
| Typ spouštění | Webhook |

## Aktéři a odpovědnosti

- **Integration(ComGate)** — CZ platební brána; odesílá server-to-server status callback pro platby v CZK a reportuje stav brány a poplatek.
- **Integration(Netopia)** — RO platební brána (MobilPay); odesílá zašifrované server-to-server potvrzení (IPN) pro RO platby a odděleně vrací prohlížeč kupujícího na read-only stránku s výsledkem.
- **Integration(MAIB)** — MD platební brána; vrací prohlížeč kupujícího s referenčním id, které systém následně použije k aktivnímu dotazování MAIB na autoritativní stav.
- **System** — validuje každý callback/návrat, dohledává cílovou transakci (EN0009), mapuje slovník stavů specifický pro danou bránu na doménový stav, ukládá výsledek a spouští všechny navazující peněžní vedlejší účinky (celkové částky kampaně, promoci poukazu, aktivaci trvalého daru, přidělení role, potvrzovací zprávy, indexaci pro vyhledávání).
- **Customer** — dárce, jehož prohlížeč je přesměrován zpět z brány (Netopia, MAIB); obdrží vizuální výsledek úspěchu/neúspěchu, ale neprovádí žádnou akci měnící stav.

## Záměr

Potvrdit výsledek platby zahájené na platební bráně a při potvrzení aktualizovat transakci (EN0009) a na ní závislý doménový stav (celkové částky kampaně, poukaz, trvalý dar, role uživatele, potvrzovací zprávy) tak, aby byl dar věrně promítnut napříč platformou — bez ohledu na to, která ze tří regionálních bran (ComGate/CZ, Netopia/RO, MAIB/MD) je zdrojem pravdy pro danou transakci.

## Předpoklady

- Transakce (EN0009) již existuje v nefinálním stavu (typicky PENDING), vytvořená dříve při zahájení daru/platby (viz UC0005 — Provedení daru), a nese korelační identifikátor brány, proti kterému bude callback párován (externí id transakce, UUID objednávky nebo reference brány, v závislosti na bráně).
- Příslušná konfigurace brány (přihlašovací údaje obchodníka, sdílený secret/klíče, prostředí) je pro daný region k dispozici.
- Pro MAIB: transakce dále nese IP adresu volajícího zachycenou při zahájení, kterou systém použije při zpětném dotazu na MAIB ohledně stavu.

## Hlavní tok

### UC0006.1 — Potvrzení ComGate (CZ)

1. Integration(ComGate): Odešle server-to-server status callback obsahující identifikaci obchodníka, sdílený secret, částku, měnu, referenci brány, id transakce brány, stav brány a poplatek.
2. System: Zvaliduje callback porovnáním odeslané identifikace obchodníka a sdíleného secretu s nakonfigurovanými hodnotami; pokud se neshodují, callback odmítne.
3. System: Vyhledá transakci (EN0009) odpovídající částce, referenci brány a id transakce brány z callbacku.
4. System: Pokud není nalezena žádná odpovídající transakce, odpoví Integration(ComGate) potvrzením o neúspěchu a nepodnikne žádnou další akci.
5. System: Pokud je nalezena odpovídající transakce, zaznamená na ni stav brány (PENDING / PAID / CANCELLED / AUTHORIZED / REFUNDED) a poplatek brány a uloží ji.
6. System: Odpoví Integration(ComGate) potvrzením o úspěchu.
7. System: Uplatní sdílené vedlejší účinky po uložení popsané v UC0006.4 pro tuto transakci.

### UC0006.2 — Potvrzení Netopia a návrat prohlížeče (RO)

1. Integration(Netopia): Odešle zašifrované server-to-server potvrzení (IPN) obsahující zašifrovaný výsledek platby a referenci objednávky daru.
2. System: Dešifruje potvrzení pomocí nakonfigurovaného klíče obchodníka; pokud dešifrování selže, odpoví potvrzením o dočasné chybě a nepodnikne žádnou další akci.
3. System: Dohledá cílovou transakci (EN0009) z dešifrované reference objednávky.
4. System: Namapuje akci reportovanou bránou na doménový stav (confirmed → PAID; confirmed-pending/paid-pending/paid → PENDING; canceled → CANCELLED; credit → REFUNDED; nerozpoznaná akce nebo chybový kód → CANCELLED).
5. System: Pokud byla dohledána odpovídající transakce a namapovaný stav se liší od aktuálního stavu transakce, zaznamená na ni nový stav a uloží ji; jinak nepodnikne žádnou další akci.
6. System: Pokud je transakce navázána na trvalý dar (RecurringTransaction, EN0010), zaznamená na trvalý dar platební token brány a jeho expiraci.
7. System: Odpoví Integration(Netopia) potvrzením odrážejícím úspěch nebo neúspěch.
8. System: Uplatní sdílené vedlejší účinky po uložení popsané v UC0006.4 pro tuto transakci.
9. Customer: Vrátí se na stránku s výsledkem daru po dokončení platby na bráně.
10. System: Dohledá transakci podle její reference objednávky a zobrazí zákazníkovi výsledek úspěchu nebo neúspěchu, aniž by měnil jakýkoli stav (pouze pro čtení).

### UC0006.3 — Potvrzení MAIB (MD)

1. Customer: Vrátí se z brány MAIB na potvrzovací endpoint platformy s referencí transakce od brány.
2. System: Vyhledá transakci (EN0009), jejíž uložená reference brány odpovídá vrácené hodnotě.
3. System: Pokud není nalezena žádná odpovídající transakce, přesměruje zákazníka na výchozí vstupní stránku a nepodnikne žádnou další akci.
4. System: Pokud je nalezena odpovídající transakce, aktivně se dotáže Integration(MAIB) na autoritativní stav dané reference brány (server-to-server, s použitím vlastních přihlašovacích údajů platformy — referenci dodané prohlížečem samotné nedůvěřuje).
5. System: Namapuje výsledek reportovaný MAIB na doménový stav (OK → PAID; PENDING → PENDING; FAILED nebo DECLINED → CANCELLED; nerozpoznaná odpověď nebo nedostupná brána → PENDING).
6. System: Zaznamená namapovaný stav na transakci a uloží ji.
7. System: Uplatní sdílené vedlejší účinky po uložení popsané v UC0006.4 pro tuto transakci.
8. System: Přesměruje zákazníka na stránku kampaně daru (EN0004) s indikátorem úspěchu nebo neúspěchu; jakýkoli stav kromě CANCELLED je zákazníkovi zobrazen jako úspěch, včetně výsledku, který je stále PENDING.

### UC0006.4 — Sdílené vedlejší účinky potvrzení (všechny brány)

1. System: Pokud je toto uložení prvním přechodem transakce do stavu PAID, odešle dárci poděkovací potvrzení platby (Transactional-Messaging-Orchestrator).
2. System: Označí na transakci, že toto potvrzení bylo odesláno.
3. System: Pokud je vlastník transakce (User, EN0008) v okamžiku potvrzení PAID aktuálně zablokován, odešle danému vlastníkovi zprávu o aktivaci účtu.
4. System: Pokud transakce dosáhne stavu PAID a její vlastník ještě nemá roli podporovatele, přidělí vlastníkovi roli podporovatele.
5. System: Pokud je s touto transakcí spojen nákup poukazu (Voucher, EN0013) a transakce dosáhne stavu PAID, označí odpovídající neuhrazený poukaz jako uhrazený/připravený k použití.
6. System: Odešle příjemci poukazu potvrzení o nákupu poukazu.
7. System: Pokud transakce dosáhne stavu PAID a nese data pro generování poukazu, ke kterým ještě nebyl vytvořen žádný poukaz, vygeneruje odpovídající záznam(y) poukazu a jejich dokumenty pro vyřízení (Document-Generation-&-Fulfilment).
8. System: Přepočítá vybranou částku a procento naplnění cílové kampaně (EN0004) ze všech transakcí ve stavu PAID vůči ní a uloží kampaň.
9. System: Pokud přepočítaná vybraná částka nyní dosahuje cílové částky kampaně nebo ji přesahuje, označí kampaň a její nadřazenou žádost jako dokončenou a v produkci odešle potvrzení o úspěšném naplnění kampaně.
10. System: Pokud přepočítaná vybraná částka přesahuje cílovou částku kampaně (přeplatek), sníží zaznamenanou částku této transakce na zbývající potřebnou částku.
11. System: Vytvoří novou transakci na rozdíl vůči transparentnímu/obecnému účtu platformy.
12. System: Pokud transakce dosáhne stavu PAID a je navázána na dosud neaktivní trvalý dar (RecurringTransaction, EN0010), aktivuje tento trvalý dar.
13. System: Zařadí transakci do fronty pro synchronizaci indexu vyhledávání.

## Alternativní toky

### AF1 — Autentičnost callbacku nelze ověřit (ComGate)

1. Integration(ComGate): Odešle status callback s chybějícím nebo neshodujícím se sdíleným secretem nebo identifikací obchodníka.
2. System: Odmítne callback, aniž by změnil transakci; odpoví potvrzením o neúspěchu.

Výsledek: Transakce zůstává ve svém předchozím stavu; nespustí se žádné vedlejší účinky. (Autentičnost callbacku se řídí BR-PaymentGatewayCallbacks § Confirmation authentication — pouze sdílený secret, bez ochrany podpisem/proti replay útoku.)

### AF2 — Opakovaná nebo chronologicky nesprávně seřazená oznámení brány

1. Integration(PaymentGateway): Znovu odešle stavové oznámení, které systém již zpracoval, nebo odešle oznámení mimo chronologické pořadí.
2. System: Znovu uplatní mapování a tam, kde se výsledný stav liší od uloženého stavu transakce, transakci znovu uloží a znovu spustí sdílené vedlejší účinky z UC0006.4; tam, kde je stav nezměněný, se většina jednorázových vedlejších účinků (potvrzovací zpráva, promoce poukazu, aktivace trvalého daru) přeskočí, protože jsou chráněny příznakem „již provedeno", avšak přepočet celkových částek kampaně a zařazení do fronty pro index vyhledávání proběhnou znovu bez ohledu na to.

Výsledek: Transakce konverguje k poslednímu stavu reportovanému bránou; opakované přepočítávání celkových částek kampaně je známým vedlejším účinkem opakovaných oznámení, nikoli řízenou idempotentní no-op operací. Partial — jedná se o systémové chování odvozené z důkazů toku, nikoli o navrženou záruku idempotence.

### AF3 — Brána MAIB nedostupná během ověřování stavu

1. System: Pokusí se dotázat Integration(MAIB) na autoritativní stav a neobdrží použitelnou odpověď (timeout nebo chyba přenosu).
2. System: Zachází s výsledkem jako s PENDING, zaznamená jej na transakci a uloží ji.
3. System: Přesměruje zákazníka na stránku s výsledkem kampaně, která — protože za neúspěch je považován pouze stav CANCELLED — zobrazuje indikátor úspěchu, i když platba ještě není potvrzena jako PAID.

Výsledek: Transakce zůstává ve stavu PENDING až do pozdějšího potvrzeného callbacku/dotazu; zákazník může vidět zprávu o úspěchu dříve, než dojde ke skutečnému potvrzení. Partial — důkazy z toku tento výsledek explicitně dokumentují jako nesrovnalost viditelnou dárci.

### AF4 — Vedlejší účinky řízené automatickou událostí (neaktivní)

1. System: (Neprovedeno) Doménová událost signalizující změnu stavu transakce je definována, ale její vyvolání je v aktuální verzi vypnuté.

Výsledek: Žádný listener nereaguje na změny stavu transakce touto cestou přes událost; jakákoli současná kaskáda popsaná v UC0006.4 probíhá pouze prostřednictvím přímých kroků při ukládání, nikoli prostřednictvím odběru události. Hypothesis / neaktivní funkce — doloženo jako přítomné, ale vypnuté ve zdrojových dossier tocích, nespouští se za běhu.

## Postpodmínky

- Transakce (EN0009) nese stav potvrzený bránou (PENDING, PAID, CANCELLED, AUTHORIZED nebo REFUNDED) a, pokud je reportován, poplatek brány.
- Při prvním potvrzení PAID: dárce obdržel potvrzovací zprávu o platbě; vlastnící uživatel (User, EN0008) má roli podporovatele; jakýkoli navázaný poukaz (Voucher, EN0013) je povýšen na uhrazený/připravený k použití nebo nově vygenerován s dokumentem pro vyřízení; jakýkoli navázaný trvalý dar (RecurringTransaction, EN0010) je aktivní.
- Vybraná částka a procento naplnění cílové kampaně (EN0004) odrážejí všechny transakce ve stavu PAID vůči ní a kampaň (a její nadřazená žádost) je označena jako dokončená, pokud je plně naplněna.
- Pokud potvrzená částka přeplatila cílovou částku kampaně, existuje nová transakce zaznamenávající přebytek vůči transparentnímu/obecnému účtu platformy.
- Transakce je zařazena do fronty pro synchronizaci indexu vyhledávání.
- Pro Netopia a MAIB byl prohlížeči dárce zobrazen výsledek odrážející výsledek (MAIB: jakýkoli nezrušený výsledek, včetně stále čekajícího, je zobrazen jako úspěch).

## Trasovatelnost

Cílové SRV:
- ComGate-Adapter
- Netopia-Adapter
- MAIB-Adapter
- Payment-Processing
- Campaign-&-Story-Lifecycle
- Document-Generation-&-Fulfilment
- Identity-&-Access
- Transactional-Messaging-Orchestrator

Entity EN:
- EN0009 Transaction — záznam, jehož stav je potvrzován a ukládán; centrální bod všech peněžních vedlejších účinků v tomto UC
- EN0004 Campaign — cíl daru, jehož vybraná částka/dokončení se přepočítává při každé potvrzené transakci
- EN0013 Voucher — povýšen na uhrazený/připravený k použití nebo vygenerován, jakmile navázaná transakce dosáhne stavu PAID
- EN0010 RecurringTransaction — aktivován a (u Netopia) obdrží svůj token brány, jakmile navázaná transakce dosáhne stavu PAID
- EN0008 User — vlastník transakce; při dosažení PAID získává roli podporovatele a může obdržet zprávu o aktivaci

Integrační hranice:
- ComGate (CZ platební brána)
- Netopia/MobilPay (RO platební brána)
- MAIB (MD platební brána)

Řídící pravidla:
- BR-PaymentGatewayCallbacks — autentičnost callbacku a mapování stavů

Důkazy z toku:
- FLW0003 (ComGate payment status callback)
- FLW0004 (Netopia/MobilPay confirm + redirect)
- FLW0005 (MAIB payment status callback)

## Úroveň důkazů

Confirmed — podloženo mining dossiery toků FLW0003/FLW0004/FLW0005 (Confidence: Confirmed ve všech třech) a návrhy entit EN0009/EN0004/EN0013/EN0010/EN0008 pro slovník stavů, pole a vztahy; AF2 (chování při opakovaných oznámeních), AF3 (nedostupnost MAIB) a AF4 (neaktivní vyvolání události) jsou označeny jako Partial/Hypothesis podle vlastních sekcí Failure Modes v dossierech, nikoli tvrzeny jako navržené chování.
