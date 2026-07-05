---
doc_id: EN0001
title: Application
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - BR-ApplicationStatusGovernance
  - BR-ScoringAndRiskGating
  - BR-PartyIdentityAndDeduplication
  - BR-ContractAndESignature
  - BR-CampaignStoryLifecycle
  - EN0002 (ApplicationProfile)
  - EN0003 (ApplicationSession)
  - EN0004 (Campaign)
  - EN0006 (Contact)
  - EN0008 (User)
  - EN0011 (Contract)
  - EN0016 (Blacklist)
  - EN0017 (ScoringRecord)
  - EN0018 (Organisation)
  - EN0025 (ApplicationLog)
  - EN0026 (ApplicationReaction)
  - EN0027 (ApplicationAction)
---

# EN0001 — Žádost

## Účel

Žádost (Application) je hlavní agregační kořen (aggregate root) doménového modelu Patronus — uzel,
který propojuje žadatele (fundraisera), patrona, dítě, koordinátora, posouzení rizika, smlouvu a
výsledný Příběh (Campaign). „Lead" není samostatná entita: jde o ranou fázi příjmu/koordinace téhož
záznamu žádosti, takže jedno pole stavu pokrývá jak lead-eru, tak application-eru daného případu. Stav
žádosti řídí veškeré navazující procesní oblasti (příjem žádosti, riziko, dary, obsah) a je udržován
v souladu se stavem navázaného Příběhu (EN0004).

---

## Životní cyklus

Potvrzené hodnoty stavu (nejsou vyčerpávající; úplný, zemi-specifický slovník je kanonicky definován
v modelu stavů a zde se neopakuje): `new` · `to_check` · `scoring` · `scoring_ok` ·
`application_processing` · `waiting` · `suspended` · `contract` · `waiting_signature` ·
`contract_signed` · `waiting_for_feetback` · `returned_new_patron` · `active` ·
`campaign_uncompleted` · `complete` / `completed` · `duplicate`.

Výčet stavů je rozsáhlý (~66 popisků) a zemi-specifický (CZ/RO/MD); kanonický slovník viz model
stavů (`intake/statuses/`). Které záruky ohledně legality přechodu, vedlejších efektů, idempotence a
automatických přechodů jsou — a nejsou — v aktuálním stavu na tomto životním cyklu vynucovány, viz
BR-ApplicationStatusGovernance.

---

## Přechody stavů

- (vytvoření) → `new`
  spouštěč: UC0001 (Podání žádosti — self-registrace a založení administrátorem)

- libovolný → cílový stav
  spouštěč: UC0002 (Orchestrace změny stavu žádosti — změna stavu řízená administrátorem, UC0002.1)

- libovolný → `to_check`
  spouštěč: UC0002 (krok fan-outu stavu, který přepočítává rizikové skóre) / UC0003 (Posouzení
  rizika žadatele — automatická sub-flow low-risk scoringu, UC0003.2)

- `scoring` → `scoring_ok`
  spouštěč: UC0003 (Posouzení rizika žadatele — manuální schválení scoringu, UC0003.1); podmínku
  schvalovací brány viz BR-ScoringAndRiskGating

- způsobilý mezistav → `scoring_ok`
  spouštěč: UC0003 (Posouzení rizika žadatele — přepsání low-risk koordinátorem, AF3); kvalifikační
  prahovou podmínku viz BR-ScoringAndRiskGating

- libovolný → `waiting_signature`
  spouštěč: UC0002 (fan-out stavu vstupující do stavu čekání na podpis) / UC0004 (Správa smlouvy a
  podpisu)

- `waiting_signature` → `contract_signed`
  spouštěč: UC0004 (Správa smlouvy a podpisu — žadatel dokončí elektronický podpis)

- libovolný → `waiting_for_feetback` *(sic: takto je popisek stavu uveden ve zdroji)*
  spouštěč: UC0002 (fan-out stavu vstupující do stavu čekání na zpětnou vazbu)

- libovolný → `returned_new_patron`
  spouštěč: UC0002 (Orchestrace změny stavu žádosti, AF3 — vrácení k novému patronovi); profil
  patrona a scoringová data jsou v rámci tohoto přechodu vymazána

- (kandidát/předchozí) → `active`
  spouštěč: UC0011 (Správa životního cyklu Příběhu/kampaně — administrátor publikuje navázaný
  Příběh, UC0011.1)

- `active` → `complete` / `completed`
  spouštěč: UC0011 (Správa životního cyklu Příběhu/kampaně — dokončení financování Příběhu se
  promítá do žádosti); přesný popisek zdrojového stavu není potvrzen — **Partial**

- `active` → `campaign_uncompleted`
  spouštěč: UC0011 (Správa životního cyklu Příběhu/kampaně — plánovaná kontrola vypršení termínu,
  UC0011.2)

- (libovolný, duplicitní lead) → `duplicate`
  spouštěč: UC0016 (Správa záznamů stran — sloučení leadů, UC0016.4); profil a odkazy na strany na
  duplicitě jsou v rámci tohoto přechodu vymazány; viz BR-PartyIdentityAndDeduplication

**Otevřená poznámka k legalitě přechodů:** zda je daný stav koncový, nebo znovu-vstupitelný, není
v tomto systému aktuálně definováno — viz BR-ApplicationStatusGovernance (legalita přechodů
většinou není vynucována).

---

## Atributy

### Systémem spravované atributy

- status (řetězec; povinné; aktuální pozice žádosti ve workflow; viz Životní cyklus; řízeno
  BR-ApplicationStatusGovernance)
- status_note (řetězec; volitelné; poznámka zaznamenaná při změně stavu)
- lead_role (řetězec; volitelné; role při příjmu — patron / fundraiser / organisation_worker)
- lead_source (řetězec; volitelné; původ leadu — např. web, manuálně, telefon, doporučení)
- activity / activity_note (řetězec; volitelné; zaznamenaná aktivita koordinátora — např. hovor,
  e-mail, sms)
- flag (seznam řetězců; volitelné, více hodnot; runtime situační příznaky, např. příznak pandemické
  pomoci)
- contract_type (řetězec; volitelné; volí, jaký druh smlouvy se uplatní — např. věcný dar, služby,
  převod, nájem, dodatek)
- scoring / pole výsledku scoringu (strukturované; volitelné; aktuální snímek scoringu — viz EN0017
  ScoringRecord a BR-ScoringAndRiskGating)
- low-risk skóre (číslo; volitelné, odvozené; přepočítané rizikové skóre; nedostupné, pokud chybí
  potřebná data o aktérovi/profilu; viz BR-ScoringAndRiskGating)
- scoring_coord_note / pole rozhodnutí scoringu (řetězec; volitelné; poznámky koordinátora ke
  scoringu a rozhodnutí)
- fundraiser (odkaz na EN0008 User; volitelné; žadatel)
- patron (odkaz na EN0008 User; volitelné; patron)
- coordinator (odkaz na EN0008 User; volitelné; přiřazený koordinátor)
- scoring reviewer (odkaz na EN0008 User; volitelné; kdo provedl scoring)
- child (odkaz na EN0006 Contact; volitelné)
- lead contact (odkaz na EN0006 Contact; volitelné; strana asociovaná s leadem)
- fundraiser profile / patron profile (odkaz na EN0002 ApplicationProfile; volitelné; kardinalita
  řízena BR-ApplicationStatusGovernance)
- employer (odkaz na EN0018 Organisation; volitelné; zaměstnavatel patrona)
- campaign (odkaz na EN0004 Campaign; volitelné; výsledný veřejný Příběh)
- category (odkaz na klasifikaci kategorie; volitelné; oblast pomoci)
- contract / delivery note / acceptance protocol / appendix (odkaz na EN0011 Contract; volitelné,
  appendix více hodnot)
- attachments / attachments audit (odkaz na soubor; volitelné, více hodnot)

### Uživatelem zadávané atributy

- status_note (řetězec; volitelné; „poznámka ke změně stavu" — zadaná jednajícím uživatelem; viz
  také Systémem spravované atributy, neboť toto pole je zároveň zadávané uživatelem i metadaty
  změny stavu)
- category (viz Systémem spravované atributy; volí žadatel/koordinátor)
- contract_type (viz Systémem spravované atributy; volí se při přípravě smlouvy)
- scoringová pole zadávaná na scoringovém formuláři (detail entity scoringu viz EN0017
  ScoringRecord; pole zachycená na žádosti jsou uložený snímek)

---

## Invarianty

- Pole stavu žádosti je jediným zdrojem pravdy o pozici případu napříč lead-erou a application-erou
  workflow; viz BR-ApplicationStatusGovernance.
- Kardinalita profilu fundraisera/patrona na žádosti je řízena BR-ApplicationStatusGovernance
  (kardinalita profilu).
- Legalita přechodu (jaký stav může následovat po jakém) není v aktuálním stavu spolehlivě
  vynucována; viz BR-ApplicationStatusGovernance.
- Změna stavu není garantovaně idempotentní a její navazující reakce nejsou garantovaně atomické;
  viz BR-ApplicationStatusGovernance.
- Žádost a její navázaný Příběh (EN0004) jsou udržovány ve vzájemně konzistentní kombinaci stavu a
  kategorie daru, přičemž desynchronizace je hlášena pouze jako provozní upozornění, nikoli
  automaticky opravena; viz BR-ApplicationStatusGovernance a BR-CampaignStoryLifecycle.
- Low-risk skóre je odvozená hodnota přepočítávaná při vstupu žádosti do posouzení rizika, vycházející
  z profilových dat, která ne vždy odpovídají straně, jíž jsou přiřazena; viz BR-ScoringAndRiskGating.
- Schválení scoringu do stavu `scoring_ok` je podmíněno aktuálním stavem žádosti a odeslaným
  verdiktem; viz BR-ScoringAndRiskGating.
- Odkazy na strany ze žádosti na Contact (EN0006) nejsou vynucovány z hlediska referenční integrity;
  viz BR-PartyIdentityAndDeduplication.
- Sloučení kontaktu i sloučení leadů shodně mění nadřazenost nebo přepisují odkazy na
  strany/profily držené žádostí, bez transakční záruky; viz BR-PartyIdentityAndDeduplication.
- Postup podpisu smlouvy řídí stav žádosti (příprava smlouvy, čekání na podpis, podepsáno); viz
  BR-ContractAndESignature.

---

## Vztahy

- EN0002 — ApplicationProfile (profily fundraisera a patrona)
- EN0003 — ApplicationSession (přístupové/rozhraní relace vázané na tuto žádost)
- EN0004 — Campaign (výsledný veřejný Příběh)
- EN0006 — Contact (dítě, lead contact a — prostřednictvím User — záznamy stran
  fundraisera/patrona)
- EN0008 — User (fundraiser, patron, koordinátor, scoring reviewer)
- EN0011 — Contract (smlouva, dodací list, protokol o převzetí, přílohy)
- EN0016 — Blacklist (položky rizikové klasifikace vytvořené proti této žádosti)
- EN0017 — ScoringRecord (výsledek scoringu)
- EN0018 — Organisation (zaměstnavatel patrona)
- EN0025 — ApplicationLog (auditní stopa historie stavů / aktivit)
- EN0026 — ApplicationReaction (konfigurace reakce řízené stavem)
- EN0027 — ApplicationAction (konfigurace automatického přechodu stavu)

---

## Otevřené otázky

- Které stavy jsou koncové a které znovu-vstupitelné, když není vynucována žádná ochrana legality
  přechodu (viz BR-ApplicationStatusGovernance)?
- Zdroj pravdy (Partial — vyřešeno se zbytkovým rizikem): vlastní pole stavu žádosti je de facto
  doménovým zdrojem pravdy — workflow i odvození stavu jej čtou a změna stavu jej zapisuje. Paralelní
  moderation state dodávaný frameworkem je udržován v souladu cestou změny stavu, nikoli jediným
  vlastnícím mechanismem, takže se obě hodnoty mohou rozejít, pokud je moderation state změněn mimo
  tuto cestu. Zbytkovou otevřenou položkou je riziko rozjetí, nikoli otázka zdroje pravdy.
- Jaký je přesný popisek zdrojového stavu pro `complete` versus `completed` u dokončení řízeného
  Příběhem (viz Přechody stavů, `active → complete/completed`)?
