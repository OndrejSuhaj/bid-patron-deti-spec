---
doc_id: UC0004
title: Manage Contract & Signature
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0004 — Správa smlouvy a podpisu

## Header

| Field | Value |
|---|---|
| UC ID | UC0004 |
| Name | Manage Contract & Signature |
| Bounded Context | C6 |
| Primary Actor(s) | Admin, Customer, System |
| Trigger Type | UI |

## Aktéři a odpovědnosti

- **Admin** (koordinátor / pracovník back-office): iniciuje generování smlouvy (EN0011) k žádosti (EN0001), zkontroluje ji a předá ji k manažerskému schválení.
- **Admin** (v roli manažera/kontrolora): zkontroluje vygenerovanou smlouvu a připojí razítko manažerského podpisu před předáním fundraiserovi.
- **Customer** (fundraiser/žadatel): provede závěrečný krok elektronického podpisu smlouvy v samoobslužné zóně, přičemž svou identitu potvrdí shodou vypsaného jména.
- **System**: vyrenderuje dokument smlouvy do PDF, provede dosazení proměnných (token substitution) ze šablony smlouvy (EN0012), posouvá stav žádosti v souladu s postupem podepisování, vytváří/ruší podpisovou relaci fundraisera a spouští odchozí notifikace.

## Záměr

Vygenerovat právně závazný dokument smlouvy k žádosti na základě opakovaně použitelné šablony, provést ji interní manažerskou kontrolou/podpisem a získat elektronický podpis fundraisera — přičemž se při každém kroku posouvá stav žádosti a jsou informovány odpovědné strany.

## Předpoklady

- Žádost (EN0001) má přiřazeného fundraisera, profil žádosti (EN0002) s vyplněným profilem fundraisera, zvolený typ smlouvy a (pokud se neuplatní specifické pravidlo dané země pro vynechání přiřazení patrona) přiřazeného patrona a koordinátora. Chybějící přiřazení dítěte je varováním, nikoli blokující podmínkou.
- Pro zvolený typ smlouvy existuje šablona smlouvy (EN0012).
- Admin disponuje oprávněními k vytvoření smlouvy, k jejímu odeslání manažerovi a k jejímu odeslání fundraiserovi (pro každý krok samostatné oprávnění).
- Pro krok podpisu ze strany Customer: žádost je ve stavu, který umožňuje podpis fundraiserem, a jednající Customer je fundraiserem evidovaným u dané žádosti.
- Evidence: FLW0008 (Confirmed).

## Hlavní tok

### UC0004.1 — Vytvoření smlouvy a vyrenderování PDF

1. Admin: Otevře záložku Smlouva na žádosti (EN0001) a zvolí typ smlouvy, který se má vygenerovat.
2. System: Ověří předpoklady pro vytvoření (vyplněný profil fundraisera, zvolený typ smlouvy, přiřazený patron/koordinátor dle pravidla dané země) a upozorní, pokud dosud není přiřazeno dítě, aniž by to vytvoření blokovalo.
3. System: Vytvoří novou smlouvu (EN0011), přiřadí jí čitelné číslo smlouvy dle pravidel dané země a sekvenční počítadlo v rámci roku.
4. System: Načte odpovídající šablonu smlouvy (EN0012) pro zvolený typ smlouvy a dosadí do těla šablony údaje ze žádosti/profilu žádosti (fundraiser, patron, dítě, detaily daru), čímž vznikne obsah dokumentu smlouvy.
5. System: Vyrenderuje obsah dokumentu smlouvy do souboru PDF a připojí jej ke smlouvě.
6. System: Propojí vytvořenou smlouvu s referencí na smlouvu u žádosti (nebo, u určitých typů smlouvy, s referencí na dodatek/přílohu).
7. System: Pokud je typem smlouvy nájemní smlouva, dodatečně vygeneruje související dokument nájemní smlouvy a předem na něj aplikuje manažerský podpis.

Evidence: FLW0008 (Confirmed).

### UC0004.2 — Manažerská kontrola a podpis

1. Admin: Spustí akci „odeslat smlouvu manažerovi" ze záložky Smlouva na žádosti.
2. System: Odešle notifikaci nakonfigurovanému příjemci pro kontrolu smlouvy s odkazem na kontrolu a předání smlouvy a zaznamená položku do logu aktivit na žádosti.
3. System: Posune stav žádosti tak, aby odrážel, že smlouva je v manažerské kontrole.
4. Admin: Po dokončení manažerské kontroly spustí akci „odeslat smlouvu fundraiserovi".
5. System: Pokud je pro daného tenanta zapnutý elektronický podpis, vloží do obsahu dokumentu smlouvy obrázek manažerova podpisu a aktuální datum a znovu jej vyrenderuje; zaznamená položku do logu aktivit.
6. System: Posune stav žádosti tak, aby indikoval, že smlouva čeká na podpis fundraisera.
7. System: (Legacy cesta, pokud elektronický podpis není zapnutý) Namísto vložení manažerova podpisu odešle vyrenderované PDF smlouvy fundraiserovi formou notifikace a poté posune stav žádosti do stavu čekání na podpis fundraisera.

Evidence: FLW0008 (Confirmed).

### UC0004.3 — Elektronický podpis fundraisera

1. System: Při vstupu žádosti do stavu „čeká na podpis fundraisera", a pokud je zapnutý elektronický podpis, deaktivuje veškeré předchozí podpisové relace fundraisera, vytvoří smlouvu typu akceptačního protokolu a otevře novou podpisovou relaci nesoucí obsah a PDF smlouvy pro prohlížení v rámci zóny.
2. Customer: Otevře obrazovku podpisu smlouvy v samoobslužné zóně a zkontroluje obsah smlouvy.
3. Customer: Vypíše své celé jméno pro potvrzení identity a odešle podpis.
4. System: Ověří, že vypsané jméno odpovídá celému jménu fundraisera evidovanému v systému.
5. System: Posune stav žádosti do stavu podepsáno a zaznamená údaje elektronického podpisu na smlouvě.
6. System: Vygeneruje potvrzovací PDF podpisu (obsahující ověřovací kód/QR kód) pro podepsanou smlouvu.
7. System: Zobrazí fundraiserovi potvrzení podpisu a vrátí jej na přehled jeho žádostí.

Evidence: FLW0008 (Confirmed).

## Alternativní toky

### AF1 — Legacy (neelektronické) předání k podpisu

1. System: Při vypnutém elektronickém podpisu pro daného tenanta vynechá vložení manažerova razítka v zóně i sestavení podpisové relace.
2. System: Odešle vyrenderované PDF smlouvy fundraiserovi formou notifikace, mimo samoobslužnou zónu.
3. System: Posune stav žádosti do stavu čekání na podpis fundraisera, bez relace pro kontrolu v zóně.

Outcome: Fundraiser obdrží smlouvu pouze formou notifikace; dílčí tok relace podpisu v zóně (UC0004.3 krok 1) se pro tuto žádost nespouští.

### AF2 — Chybějící příjemce notifikace

1. System: Pokusí se odeslat notifikaci o manažerské kontrole, ale zjistí, že příjemce pro kontrolu nebo vyrenderované PDF nejsou dostupné.
2. System: Vynechá odeslání notifikace, přičemž stav žádosti přesto posune do kroku manažerské kontroly.

Outcome: Žádost vykazuje smlouvu jako v manažerské kontrole, aniž by byla odeslána jakákoli notifikace — tichá mezera vyžadující ruční kontrolu.

### AF3 — Neshoda jména při podpisu

1. Customer: Odešle podpisový formulář s vypsaným jménem, které neodpovídá celému jménu fundraisera evidovanému v systému.
2. System: Odmítne odeslání a ponechá žádost ve stavu čekání na podpis.

Outcome: Podpis není zaznamenán; Customer musí odeslání zopakovat se správným jménem.

### AF4 — Země bez vytváření smlouvy v zóně

1. Admin: Pokusí se otevřít obrazovku vytvoření smlouvy u žádosti v tenantovi/zemi, kde vytváření smlouvy v zóně není nabízeno.
2. System: Pro danou zemi neprezentuje formulář pro vytvoření smlouvy.

Outcome: Vytvoření smlouvy pro tohoto tenanta probíhá mimo tuto UI cestu (evidence nepotvrzuje alternativní postup). Partial evidence — vyloučení dle země je potvrzeno, alternativní cesta nebyla vytěžena.

## Postconditions

- Existuje smlouva (EN0011), propojená se žádostí (EN0001), nesoucí vyrenderované PDF, číslo smlouvy a (jakmile je plně podepsána) záznam elektronického podpisu a potvrzovací PDF podpisu.
- Stav žádosti odráží nejdále dosažený krok podepisování: vytvořena smlouva → v manažerské kontrole → čeká na podpis fundraisera → podepsáno.
- Ke každému přechodu jsou na žádosti zaznamenány položky logu aktivit a historie stavů.
- U digitálně podepsaných smluv existují jako podpůrné záznamy smlouva typu akceptačního protokolu a podpisová relace fundraisera.
- Notifikace byly odeslány manažerovi (a na legacy cestě i fundraiserovi) tam, kde byl k dispozici platný příjemce a dokument.

## Traceability

Target SRVs:
- Document-Generation-&-Fulfilment
- Application-Status-Orchestrator
- Transactional-Messaging-Orchestrator

EN entities:
- EN0011 Contract — vygenerovaný, podepsaný dokument, který je jádrem tohoto UC
- EN0012 ContractTemplate — zdrojová šablona vyrenderovaná do obsahu smlouvy
- EN0001 Application — agregát, jehož stav je posouván při každém milníku smlouvy/podpisu
- EN0002 ApplicationProfile — zdroj údajů o fundraiserovi/patronovi/daru dosazovaných do smlouvy

Integration boundaries:
- Žádné (renderování dokumentu a odesílání notifikací jsou interní odpovědnosti systému; podle aktuální evidence v tomto UC není volán žádný externí systém).

Flow Evidence:
- FLW0008 (Contract create → manager check → fundraiser sign)

## Evidence Level

Confirmed — grounded ve flow dossieru FLW0008 (Confirmed confidence), který se přímo mapuje na SRV0011 (Document-Generation-&-Fulfilment), přechody stavů Application-Status-Orchestrator a notifikace Transactional-Messaging-Orchestrator; entity EN0011 (Contract), EN0012 (ContractTemplate), EN0001 (Application) a EN0002 (ApplicationProfile) potvrzují popsaná pole a životní cyklus. AF4 (vyloučení dle země) je doloženo pouze pro samotné vyloučení, nikoli pro alternativní cestu, a v rámci jinak Confirmed UC je označeno jako Partial.
