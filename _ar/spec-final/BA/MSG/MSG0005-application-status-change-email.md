---
doc_id: MSG0005
title: Application Status-Change Email
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0026
  - EN0004
  - EN0022
  - ES0006
---

# MSG0005 – E-mail o změně stavu žádosti

## Účel

Informovat e-mailem Žadatele (Žadatel/fundraiser) a/nebo Patrona vždy, když je Žádost (Application),
EN0001, uložena do stavu, jehož nakonfigurovaná reakce má pro danou roli zapnutý e-mailový kanál. Jde
o jednotný, stavem a rolí parametrizovaný transakční e-mail, který stojí za většinou řádků
Notifikační matice (`intake/test-scenarios/test-scenarios.md`, list "Notification Matrix"): jeden
obecný kontrakt zprávy, instanciovaný odlišně podle kombinace stav × role, namísto samostatné zprávy
pro každý stav.

---

## Spouštěč

UC0002 (Orchestrace změny stavu žádosti) — konkrétně navazující rozeslání reakcí (fan-out)
(UC0002.2): při každém uložení Žádosti (EN0001) do nového stavu Systém vyhledá odpovídající
konfiguraci ApplicationReaction (EN0026) pro daný stav a roli, a — pokud má tato reakce zapnutý
příznak e-mailu — odešle tento stavově řízený e-mail.

Tento MSG pokrývá každý stav uvedený v Notifikační matici, jehož sloupec Email má hodnotu `YES` pro
roli Žadatele a/nebo Patrona a který **nemá** vlastní dedikovaný MSG dokument pro záměr s vyšší
významností (podání žádosti, scoringové rozhodnutí, smlouva, potvrzení daru/plnění atd. — viz
příslušné konkrétní MSG). Poté, co byly stavy s vyšší významností vyčleněny do dedikovaných MSG,
**zbytková** množina skutečně náležející tomuto souhrnnému mechanismu — stavy, které si NEnárokuje
jako spouštěč žádný dedikovaný MSG (dle Notifikační matice) — je: `canceled_application`,
`canceled_lead`, `duplicate`, `feedback_received`, `gift_confirmation_approved`, `refiled`,
`waiting_for_protocol`. Přesná množina stavů je řízena konfigurací (ApplicationReaction, EN0026) a
může přesahovat tento evidovaný zbytkový seznam; tento MSG je záměrně ponechán obecný, namísto
rozpadu na jeden dokument na stav.

Stavy dříve zahrnuté do tohoto souhrnného mechanismu, které nyní nesou odlišný záměr s vysokou
významností, byly **nahrazeny a odsud odstraněny** a náleží svým dedikovaným MSG: `to_check` /
`waiting_for_patron` / `waiting_for_fundraiser` (MSG0001); `reminder_*` / `waiting_reminder_*`
(MSG0007); `returned_new_patron*` (MSG0008); `waiting` (MSG0009); `out_of_scope` (MSG0010);
`scoring_ko` (MSG0011); `in_progress` (MSG0012); `completed` (MSG0014); `campaign_uncompleted`
(MSG0015); `canceled_campaign` (MSG0016); `canceled_timeout` / `canceled_fundraiser` (MSG0017);
`canceled_by_user` (MSG0018); `waiting_signature*` / `contract_signed` (MSG0027);
`waiting_feedback_reminder_*` (MSG0029). Kontrakt zprávy pro každý z nich viz příslušné doc_id.

Evidence Level: Confirmed pro existenci a tvar mechanismu podmíněného stavem/rolí (UC0002, EN0026,
Notifikační matice křížově ověřeny); Partial pro úplný výčet stavů, které mají v současnosti zapnutý
příznak e-mailu, jelikož jde o živá konfigurační data, nikoli pevný kód — výše uvedený seznam je
doložen Notifikační maticí, ale konstrukčně není vyčerpávající.

---

## Příjemci

Podle kombinace stav × role nakonfigurované na odpovídající ApplicationReaction (EN0026):

- **Žadatel (Žadatel/fundraiser)** — e-mail přes ES0006 (Mautic), tam kde Notifikační matice pro daný
  stav ve sloupci Žadatel označuje Email = YES.
- **Patron** — e-mail přes ES0006 (Mautic), tam kde Notifikační matice pro daný stav ve sloupci Patron
  označuje Email = YES.

Daný stav může mít e-mail zapnutý jen pro jednu roli, pro obě role, nebo pro žádnou (v takovém
případě se spustí pouze notifikace v zóně/aplikaci — mimo rozsah tohoto MSG). Adresa příjemce se
odvozuje z účtu User/Contact příjemce nebo z e-mailu profilu žádosti uloženého na Žádosti (EN0001).
CZ je evidovaný primární trh; varianty RO/MD nejsou pro tuto zprávu samostatně doloženy nad rámec
již dokumentovaného rozlišení šablon podle země na úrovni schopnosti (FN0019) — žádné obsahové
odlišnosti specifické pro RO/MD zde nejsou tvrzeny.

---

## Obsah zprávy

Zpráva je datově řízená podle kombinace stav × role reakce (ApplicationReaction, EN0026), nikoli
nesená jedním pevným tělem. Koncepčně každá instance této zprávy nese:

- Stavovou/předmětovou zprávu identifikující nový stav případu Žadatele nebo Patrona (např. "Žádost
  zpracováváme", "Duplikát", "Zrušená žádost", "Schváleno", "Potvrzené převzetí daru", "Vyplňte
  žádost", "Nahrajte smlouvu" — přesný doslovný text je konfigurační data podle stavu/role, zde není
  tvrzen jako pevný obsah šablony).
- Identifikaci předmětné Žádosti (EN0001) a případně přidruženého dítěte/Příběhu (Kampaň, EN0004), aby
  příjemce rozpoznal, kterého případu se zpráva týká.
- Odkaz směřující příjemce zpět do jeho zóny (zóna Žadatele / zóna Patrona), kde vidí plný detail a
  případnou požadovanou další akci, v souladu s párovou notifikací v zóně, která zprávu pro stejný
  stav/roli často doprovází.

V tomto kanonickém dokumentu není tvrzen žádný pevný text předmětu, markup těla ani struktura
šablony — konkrétní znění je instanční data podle ApplicationReaction (EN0026) a je mimo rozsah
vrstvy MSG (viz omezení v rules-MSG.md).

Každé odeslání této zprávy je archivováno jako záznam EmailArchive (EN0022) bez ohledu na to, zda je
odeslání skutečně přenesené; archiv nedokáže rozlišit doručené odeslání od odeslání potlačeného
prostředím (send-gate) (viz FN0019 Constraints) — jde o známé omezení evidence, nikoli o součást
zamýšleného kontraktu zprávy.

---

## Poznámky

- Jde o skupinový/souhrnný stavový e-mail: záměrně nerozpadnutý do samostatného MSG pro každý řádek
  stavu z Notifikační matice (~117 řádků se sbíhá do konfigurace role×stav na jediném mechanismu
  zprávy). Stavy posouzené jako nesoucí odlišný záměr s vysokou významností jsou vyčleněny do
  vlastních MSG dokumentů (podání/přijetí žádosti, scoringové rozhodnutí, smlouva/podpis, potvrzení
  daru/plnění, GDPR atd.) a byly z tohoto souhrnného mechanismu **nahrazeny a odstraněny** — viz
  MSG0001, MSG0007, MSG0008, MSG0009, MSG0010, MSG0011, MSG0012, MSG0014, MSG0015, MSG0016, MSG0017,
  MSG0018, MSG0027, MSG0029 (dle sekce Spouštěč). Tento MSG vlastní pouze zbytkovou množinu
  (`canceled_application`, `canceled_lead`, `duplicate`, `feedback_received`,
  `gift_confirmation_approved`, `refiled`, `waiting_for_protocol`).
- Odeslání probíhá synchronně v rámci požadavku na uložení Žádosti (EN0001) (fan-out UC0002); selhání
  pozdější reakce ve stejném průchodu fan-outu zpětně neruší e-mail již odeslaný dříve v pořadí (viz
  UC0002 AF2).
- Evidence Level pro celkový mechanismus: Confirmed. Evidence Level pro úplný výčet stavů a pro
  jakoukoli obsahovou odlišnost RO/MD: Partial — závisí na konfiguraci a není plně viditelné z
  citovaných zdrojů.
