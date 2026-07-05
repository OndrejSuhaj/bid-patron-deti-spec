---
doc_id: UC0001
title: Submit Application (Žádost)
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0001 — Podání žádosti (Žádost)

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0001 |
| Název | Podání žádosti (Žádost) |
| Bounded Context | C1 |
| Primární aktér(ři) | Customer, Admin |
| Typ spouštění | UI/API |

## Aktéři a odpovědnosti

- **Customer** — anonymní návštěvník (potenciální dárce žádosti/fundraiser nebo patron), který zahajuje samoregistraci a po identifikaci se stává žadatelem na nové žádosti (EN0001).
- **Admin** — pracovník backoffice, který na základě již existující žádosti (EN0001) a jejího profilu žádosti (EN0002) vytváří nebo propojuje záznamy uživatele (EN0008) / kontaktu (EN0006) pro fundraisera, patrona nebo dítě.
- **System** — validuje odeslaná data, dohledává referenční data (např. vyhledávání měst), vytváří/propojuje záznamy User, Contact, Application a ApplicationSession (EN0003) a odesílá aktivační notifikaci.
- **Integration(Email Validation Service)** — ověřuje, že odeslaná e-mailová adresa patří k platné, existující e-mailové doméně, než registrace pokračuje.
- **Integration(Transactional Messaging Service)** — odesílá aktivační e-mail (magic-link) nově zaregistrovanému Customerovi.

## Záměr

Umožnit potenciálnímu fundraiserovi nebo patronovi provést samoregistraci a založit žádost (Žádost), nebo umožnit Adminovi formalizovat identitu fundraisera/patrona/dítěte na existující žádosti — v obou případech je výsledkem propojený User/Contact a žádost připravená k vyplnění.

## Předpoklady

- Návštěvník je anonymní (sub-flow samoregistrace) — již ověřený (authenticated) Customer je směrován přímo do žádosti bez opakovaného zachycení identity.
- Pro sub-flow iniciovaný Adminem již existuje žádost (EN0001) a její přidružený profil žádosti (EN0002), který nese data specifická pro roli (fundraiser/patron/dítě) určená k povýšení na User/Contact.
- Referenční data (např. hodnoty města/geolokace) jsou k dispozici pro vyhledání nebo vytvoření na vyžádání.

## Hlavní tok

### UC0001.1 — Samoregistrace Customera (fundraiser nebo patron)

1. Customer: otevře vstupní bod registrace a zvolí roli fundraiser nebo patron.
2. System: zobrazí minimalistický registrační formulář (e-mail, telefon a zaškrtávací políčka souhlasů/regulatorních požadavků specifických pro danou zemi).
3. Customer: odešle e-mail, telefon a požadované souhlasy.
4. System: validuje formát e-mailu a požadované souhlasy.
5. Integration(Email Validation Service): potvrdí, že e-mailová doména je platná a dosažitelná.
6. System: ověří, zda pro odeslaný e-mail již existuje User (EN0008).
7. System: pokud žádný existující User nebyl nalezen, vytvoří nový User (EN0008) se zvolenou rolí a propojeným Contact (EN0006).
8. System: vytvoří novou žádost (EN0001) v jejím počátečním stavu, přičemž zaznamená roli leadu, zdroj leadu a Contact (EN0006) leadu.
9. System: vytvoří dva záznamy ApplicationSession (EN0003) pro novou žádost — jeden pro roli patrona a jeden pro roli fundraisera — každý s přístupovým rozhraním odpovídajícím tomu, zda je daná role registrující se Customer, nebo pozvaný protějšek.
10. System: zaznamená počáteční stav žádosti (EN0001) do historie stavů.
11. Integration(Transactional Messaging Service): odešle Customerovi aktivační e-mail (magic-link), který nového Customera navede k pokračování ve vyplňování žádosti, nebo existujícího Customera do jeho účtu.
12. System: zobrazí Customerovi potvrzovací/výslednou stránku.

### UC0001.2 — Admin povyšuje data profilu žádosti na User/Contact

1. Admin: otevře akci „vytvořit uživatele" na existující žádosti (EN0001) pro danou roli (fundraiser, patron nebo dítě).
2. System: načte žádost (EN0001) a její profil žádosti (EN0002) pro požadovanou roli.
3. System: ověří, že žádost, profil žádosti i role jsou přítomné a že role odpovídá jedné z podporovaných hodnot; v opačném případě je akce zamítnuta bez jakékoli změny.
4. System: načte osobní data specifická pro danou roli (jméno, kontaktní údaje, adresu a — v případě dítěte — identifikátor narození) z profilu žádosti (EN0002).
5. System: ověří, zda již existuje User (EN0008) (fundraiser/patron), nebo Contact (EN0006) (dítě, dohledané podle identifikátoru narození).
6. System: pokud žádný neexistuje, vytvoří pro danou roli nový Contact (EN0006) na základě dat z profilu.
7. System: dohledá odeslanou hodnotu města proti referenčním datům a vytvoří nový referenční záznam, pokud daná hodnota ještě není známa (vyhledání v Reference-Data).
8. System: pro větev fundraiser/patron vytvoří, pokud nebyl nalezen žádný existující User, nový User (EN0008) s požadovanou rolí a propojeným Contact (EN0006).
9. System: propojí výsledný User (EN0008) (fundraiser/patron), nebo Contact (EN0006) (dítě) zpět na žádost (EN0001).
10. Admin: je vrácen na detailní zobrazení žádosti (EN0001).

## Alternativní toky

### AF1 — Vracející se Customer dokončí registraci, přestože je již ověřený

1. Customer: otevře vstupní bod registrace, přestože je již ověřený (authenticated).
2. System: rozpozná, že Customer je již ověřený, a vytvoří žádost (EN0001) přímo pro roli tohoto Customera, přičemž kroky zachycení identity jsou přeskočeny.

Výsledek: Pro již známého Customera je vytvořena žádost (EN0001), aniž by byl vytvořen nový User/Contact.

### AF2 — Opětovné odeslání samoregistrace se stejným e-mailem

1. Customer: odešle formulář samoregistrace s e-mailem, který je již přiřazen k existujícímu User (EN0008).
2. System: místo vytvoření nového User doplní požadovanou roli a/nebo chybějící Contact (EN0006) k existujícímu User (EN0008).
3. System: pro toto odeslání nevytváří novou žádost (EN0001).
4. Integration(Transactional Messaging Service): znovu odešle Customerovi aktivační/účtový e-mail.

Výsledek: Není vytvořena duplicitní žádost (EN0001); existující User (EN0008) je podle potřeby doplněn o roli/Contact a notifikace je odeslána při každém odeslání formuláře.

### AF3 — Selhání validace domény e-mailu

1. Integration(Email Validation Service): oznámí, že doménu odeslaného e-mailu nelze ověřit, nebo že kontrola selhala.
2. System: v registraci nepokračuje.

Výsledek: Registrace je zablokována. Evidence Level: Partial — dokumentace uvádí, že tato závislost může zablokovat legitimní registraci a není potvrzeno, že dochází k odpovídající degradaci chování (graceful degradation).

### AF4 — Akce Admina selže v polovině (sub-flow iniciovaný Adminem)

1. System: během sub-flow iniciovaného Adminem selže při vytváření nebo validaci User (EN0008) (např. porušení validace).
2. System: nepropojí částečně vytvořený Contact (EN0006) zpět na žádost (EN0001).

Výsledek: Contact (EN0006) může existovat, aniž by byl propojen na žádost (EN0001) nebo na User (EN0008) — stav osiřelého záznamu. Evidence Level: Partial — v dokumentaci zaznamenáno jako riziko integrity dat, nikoli jako navržený kompenzační tok.

## Následné podmínky (postconditions)

- Existuje User (EN0008) s rolí fundraiser nebo patron, propojený s Contact (EN0006) (sub-flow samoregistrace), nebo je znovu použit, pokud již existoval.
- U zcela nového samoregistrujícího se Customera existuje žádost (EN0001) v počátečním stavu se dvěma záznamy ApplicationSession (EN0003) (patron a fundraiser) a jedním záznamem v historii stavů.
- V sub-flow iniciovaném Adminem má žádost (EN0001) nastavenou referenci na fundraisera/patrona (User, EN0008), nebo na dítě (Contact, EN0006); mohl být vytvořen nový referenční záznam (město).
- V sub-flow samoregistrace byla Customerovi odeslána aktivační notifikace.

## Trasovatelnost (Traceability)

Cílové SRV:
- Application-Lifecycle
- Identity-&-Access
- Reference-Data

EN entity:
- EN0001 Application — žádost (Žádost) vytvořená nebo aktualizovaná tímto UC.
- EN0002 ApplicationProfile — zdroj dat specifických pro roli, který čte sub-flow iniciovaný Adminem (UC0001.2).
- EN0003 ApplicationSession — záznamy řízení přístupu/rozhraní vytvořené pro novou žádost v sub-flow samoregistrace.
- EN0006 Contact — záznam subjektu vytvořený/propojený pro fundraisera, patrona nebo dítě.
- EN0008 User — účet vytvořený/propojený pro fundraisera nebo patrona.

Integrační hranice:
- Email Validation Service (kontrola domény/mail-exchange během samoregistrace)
- Transactional Messaging Service (aktivační e-mail / magic-link)

Evidence toku (Flow Evidence):
- FLW0010 (Samoregistrace fundraisera/patrona)
- FLW0026 (Vytvoření uživatele ze žádosti — iniciováno Adminem)

## Evidence Level

Confirmed — podloženo FLW0010 a FLW0026 (obě dokumentace s důvěryhodností Confirmed) a entitami EN0001/EN0002/EN0003/EN0006/EN0008, s dílčím (Partial) evidence uvedeným inline pro chybový scénář validace e-mailu (AF3) a riziko částečného zápisu při akci iniciované Adminem (AF4); trasováno na Application-Lifecycle, Identity-&-Access a Reference-Data dle UC-candidates.md a UC-srv-traceability.md.
