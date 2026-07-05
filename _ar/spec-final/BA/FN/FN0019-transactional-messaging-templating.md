---
doc_id: FN0019
title: Transactional Messaging & Templating
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0012
  - UC0002
  - UC0004
  - UC0006
  - UC0010
  - UC0011
  - UC0015
  - EN0022
  - EN0001
---

# FN0019 – Transakční zasílání zpráv a šablonování

## Účel

Doručit jednu šablonovanou transakční zprávu příjemci jménem libovolného volajícího business
kontextu — přičemž se vyřeší specifická šablona pro danou zemi, aplikuje se prostředí-závislá
brána pro odeslání, zpráva se předá odchozímu přenosu a pokus o odeslání je vždy archivován bez
ohledu na výsledek přenosu.

## Odpovědnosti

- Normalizovat a validovat vstupní údaje příjemce a vyřešit název šablony podle mapy šablon pro
  jednotlivé země, přičemž se odeslání zastaví se zalogovanou chybou, pokud je název šablony
  neznámý.
- Sestavit hodnoty tokenů/zástupných symbolů z dodaných argumentů zprávy a vytvořit záznam
  EmailArchive (EN0022) pro každého příjemce — zachycující předmět, vyřešené adresy „komu"/„od",
  vykreslené tělo zprávy, název šablony, serializované argumenty a propojenou Žádost (EN0001) a
  Kampaň — bez ohledu na to, zda je zpráva skutečně odeslána.
- Aplikovat prostředí-závislou bránu pro odeslání (odesílat pouze v produkci, nebo příjemcům na
  interním seznamu povolených adres) a předat vyřešenou zprávu, tokeny a případné přílohy
  odchozímu přenosu.
- Odkazovat na volitelnou kontrolu platnosti e-mailové domény na úrovni skládání zprávy (viz
  Omezení — nepotvrzená role při odesílání).

## Související případy užití

UC0012 – Odeslání transakční zprávy

UC0002 – Orchestrace změny stavu žádosti

UC0004 – Správa smlouvy a podpisu

UC0006 – Potvrzení platby

UC0010 – Vystavení potvrzení o daru

UC0011 – Správa životního cyklu kampaně/příběhu

UC0015 – Anonymizace osobních údajů

## Související entity

EN0022 – EmailArchive

EN0001 – Žádost

## Integrace

Mautic — skutečný odchozí přenos pro každou šablonovanou transakční zprávu (uvedený v ARCH0002
Context Interaction Map jako externí cíl transakčního odeslání; zároveň cíl CRM synchronizace
popsaný v FN0015). Přestože je volající capability pojmenována „SmartMailing", neexistuje žádný
přímý SMTP přenos — všechna odeslání jsou předávána do Mautic.

WhoisXML — uvedený v ARCH0002 (Context Interaction Map) jako externí cíl validace e-mailové domény
na úrovni skládání orchestrátoru zasílání zpráv; role v toku odesílání není potvrzena (viz
Omezení).

## Omezení

- Fronta pro rozesílání je mrtvá (zařazování do fronty je v aktuální konfiguraci vypnuto), takže
  každé odeslání probíhá synchronně v rámci požadavku/uložení volajícího — pomalé nebo selhávající
  volání přenosu může zablokovat nebo přerušit obklopující operaci ukládání.
- Archiv po vytvoření nikdy nezaznamenává výsledky doručeno vs. potlačeno vs. selhalo: pole stavu
  odeslání na EmailArchive (EN0022) existují, ale nikdy se do nich nezapisuje, takže potlačené
  odeslání (mimo produkci, mimo seznam povolených adres) je nerozlišitelné od skutečně doručeného.
- Přestože je capability pojmenována „SmartMailing", neexistuje žádný přímý SMTP přenos — jediným
  přenosem je Mautic, oslovovaný synchronně pro každého příjemce.
- Aspekt validace platnosti domény přes WhoisXML je uveden na úrovni integrační krajiny, ale
  v prozkoumaných důkazech toku nemá doložený krok odeslání, spouštěč ani výsledek — jeho role
  v této capability je `Hypothesis — Not evidenced in current sources.`
- Nevyřešitelný název šablony přeruší odeslání ještě před archivací: pro tento pokus není vytvořen
  žádný záznam EmailArchive (EN0022), pouze záznam v logu.
