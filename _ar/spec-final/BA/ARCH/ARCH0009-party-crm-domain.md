---
doc_id: ARCH0009
title: Party / CRM Domain
canonical_layer: ARCH
spec_type: architecture
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - EN0006
  - EN0007
  - EN0008
  - EN0018
  - EN0023
  - UC0016
  - FN0014
  - FN0022
  - BR-PartyIdentityAndDeduplication
---

# ARCH0009 – Doména Party / CRM

> Navigační dokument domény pro ohraničený kontext **C7 Party / CRM** (ARCH0001 §4).
> Pouze navigační vrstva — odkazuje na hlubší artefakty pomocí `doc_id`, neopakuje jejich obsah. Current-state.

## Účel

Vysvětluje architektonický pohled na **univerzální úložiště party**: Uživatele (User) — prvotřídního
aktéra rozlišovaného rolí — a přetížený záznam Kontaktu (Contact), který drží osobní/institucionální
detaily pro každý druh party (dítě, fundraiser, patron, škola, zaměstnavatel, lead), plus organizace
a poznámky. Jde o identitní a vztahový substrát, na který odkazuje téměř každá jiná doména.

---

## Přehled systému

C7 vlastní agregát Party (User + Contact + poznámky) a registr organizací/zaměstnavatelů. Jeho
definujícím architektonickým rysem je, že jediné **přetížené úložiště Kontaktu** reprezentuje všechny
druhy party rozlišené pouze diskriminátorem role, s měkkými referencemi a bez jedinečnosti identity
— to je hlavní příčina destruktivních manuálních procesů dedup/sloučení
([ARCH0001](../ARCH0001_ApplicationOverview.md) §2, §8 Riziko 2/3;
[EN0006](../EN/EN0006_Contact.md), [EN0008](../EN/EN0008_User.md)). Kontakt je **sdílený mutabilní
stav**: jeho životní cyklus leží v C7, ale je čten z C1 a jeho riziková klasifikace je zapisována C2
(ARCH0002 §(c)). Sloučení jsou destruktivní a netransakční (tvrdé smazání ztrácejícího Kontaktu a
jeho vlastnícího Uživatele). Kontext dále drží dormantní satelit Account (subsystém doporučení, C3).

---

## Strukturální komponenty

- **Party-&-Contact-Management** (doménová služba) — registr party plus všechny tři dílčí toky
  sloučení (dedup kontaktů, sloučení leadů, dedup organizací). Capability:
  [FN0014](../FN/FN0014_PartyContactManagement.md).
- **Rezidentní agregáty** — AG7 Party (kořen User [EN0008](../EN/EN0008_User.md); členové Contact
  [EN0006](../EN/EN0006_Contact.md), Account [EN0007](../EN/EN0007_Account.md) *dormantní*, UserNote
  [EN0023](../EN/EN0023_UserNote.md)); AG8 Organisation (kořen
  [EN0018](../EN/EN0018_Organisation.md), vazby pracovníků odkazují na Uživatele referencí).
- **Synchronizace vyhledávacího indexu organizací** — denní push indexu organizací je záležitostí C10;
  C7 je zdrojem dat ([FN0022](../FN/FN0022_SearchIndexing.md)).

Identita, autentizace, GDPR výmaz a příkazy řízení přístupu nad Uživatelem jsou pokryty sesterskou
doménou **C9 Identity & Access** ([ARCH0011](ARCH0011_IdentityAndAccess.md)), která sdílí tento
agregát (ARCH0001 §4).

---

## Interakční model

Dle [ARCH0002](../ARCH0002_ContextInteractionMap.md) §(a)/(c):

- Provisioning probíhá **synchronně** z **C1** při odeslání žádosti a z **C4** pro anonymní dárce
  (vytvoření User+Contact; ARCH0002 §(a)).
- Riziková klasifikace Kontaktu je zapisována **do** C7 schválením scoringu **C2** (klíčováno syrovým
  e-mailem, bez LIMIT — ARCH0002 §(c)); role podporovatele je udělena **do** C7 kaskádou první platby
  (first-PAID) **C4**.
- Dedup/sloučení ([UC0016](../UC/UC0016_MaintainPartyRecords.md)) přepojuje reference a tvrdě maže
  duplicity napříč C1 (sloučení leadů) a C7 (kontakt/organizace), netransakčně (ARCH0002 §(c)).
- Uložení party a organizace zařazují do fronty aktualizace indexu **C10 Search**; index organizací
  je plně přegenerován denním re-pushem (ARCH0002 §(b)).
- Upsert kontaktu do CRM Mautic a GDPR výmaz zajišťují **C8** / **C9**; tato doména jim dodává data
  o party.

---

## Provázání (Cross-links)

- **relatedEN:** EN0006, EN0007, EN0008, EN0018, EN0023
- **relatedUC:** UC0016 (přispívá do UC0001, UC0014, UC0015)
- **relatedFN:** FN0014 (synchronizace indexu organizací přes FN0022)
- **relatedES:** (žádné přímo — organizace → externí vyhledávací index přes C10; CRM sync přes C8)
- **relatedMSG:** (zde žádné vlastněné — zprávy party/auth MSG0003/MSG0004 jsou navigovány z C9)
- **relatedBR:** BR-PartyIdentityAndDeduplication
  ([../BR/BR-PartyIdentityAndDeduplication.md](../BR/BR-PartyIdentityAndDeduplication.md))
