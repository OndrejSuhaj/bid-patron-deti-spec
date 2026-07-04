---
doc_id: UC0021
title: Recommend Campaigns (DORMANT)
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0021 — Doporučování kampaní (DORMANT)

## Header

| Field | Value |
|---|---|
| UC ID | UC0021 |
| Name | Recommend Campaigns (DORMANT) |
| Bounded Context | C3 |
| Primary Actor(s) | System |
| Trigger Type | Event (disabled) |

## Actors & Responsibilities

- **System** — detekoval by uhrazenou Transakci (EN0009), natrénoval by prediktivní model pro jednotlivého Uživatele a seřadil by Kampaně (EN0004) pro daného Uživatele; dnes nic z toho neprovádí, protože funkce je vyřazená z provozu (dormant).
- **Scheduler** — periodicky by na pozadí znovu spouštěl scoring/trénování; periodický spouštěč je vypnutý, takže tento aktér tento use case ve skutečnosti nikdy nespustí.

## Intent

(Domnělý záměr, dnes neaktivní.) Automaticky se učit dárcovský vzorec chování každého Uživatele (EN0008) z jeho uhrazených Transakcí (EN0009) a doporučovat personalizovaný, seřazený seznam Kampaní (EN0004), které daný uživatel pravděpodobně podpoří, uložený u jeho Účtu (EN0007), s cílem zvýšit budoucí konverzi darů.

## Preconditions

- **Dormantní podmínka (blokující, aktuální stav):** funkce doporučování je vypnutá od začátku do konce — příslušný modul není nainstalován, scoringová/klasifikační služba není nakonfigurována, podpůrná knihovna strojového učení chybí, vyhledávání sady funkcí kampaně (feature-set) je vypnuté a úložné pole pro výsledky neexistuje. Žádná z podmínek uvedených níže nemůže být v současnosti splněna, protože use case nemůže být spuštěn.
- (Domnělé, v případě reaktivace) Transakce (EN0009) dosáhne stavu PAID a má identifikovatelného vlastnícího Uživatele (EN0008).
- (Domnělé, v případě reaktivace) Uživatel (EN0008) má přiřazený Účet (EN0007) schopný uchovávat natrénovaný model a seřazená doporučení.

## Main Flow

> **Evidence status: Hypothesis / dormant.** Níže popsané kroky popisují kontrakt, který BY se vykonal, kdyby byla každá vypnutá součást reaktivována. Podle aktuálního zdrojového kódu tento tok neběží: spouštěcí událost není nikdy vyvolána, příslušný modul není zapnutý a požadované úložiště neexistuje. Žádný krok v této sekci neodráží živé, aktuální chování systému.

### UC0021.1 — Spuštění a trénování (spustilo by se, aktuálně dormant)
1. System: Transakce (EN0009) se uloží a běžně by vyvolala notifikaci „transakce aktualizována" — tato notifikace se v současnosti nikdy skutečně nevyvolá (mrtvá cesta kódu).
2. System: pokud by byla notifikace vyvolána a stav Transakce (EN0009) je PAID s identifikovatelným vlastnícím Uživatelem (EN0008), System by pro daného Uživatele zařadil trénovací úlohu do fronty.
3. System: trénovací úloha by načetla Uživatele (EN0008) a spočítala jeho uhrazené (PAID) Transakce (EN0009), aby určila velikost trénovacího vzorku.
4. System: trénovací úloha by sestavila množinu pozitivních příkladů (kampaně, které Uživatel skutečně podpořil) a větší množinu negativních příkladů (kampaně, které nepodpořil), čerpaných z historie Uživatele (EN0008), Žádosti a dat Kampaně (EN0004).
5. System: trénovací úloha by tyto příklady předala klasifikační službě za účelem vytvoření prediktivního modelu.
6. System: trénovací úloha by uložila natrénovaný model do záznamu Uživatele (EN0008) a poté by pro téhož Uživatele zařadila do fronty scoringovou úlohu.

### UC0021.2 — Scoring a ukládání doporučení (spustilo by se, aktuálně dormant)
1. System: scoringová úloha by načetla Uživatele (EN0008) a získala množinu kandidátských Kampaní (EN0004) způsobilých k doporučení — toto vyhledávání kandidátů v současnosti vždy vrací prázdný výsledek, protože je podkladová logika vypnutá.
2. System: scoringová úloha by aplikovala natrénovaný model Uživatele (EN0008) na kandidátské Kampaně (EN0004) a předpověděla by preferenční skóre pro každou z nich.
3. System: scoringová úloha by seřadila obodované Kampaně (EN0004) podle predikované preference, od nejvyšší.
4. System: scoringová úloha by přepsala záznam seřazených doporučení Uživatele (EN0008) nebo Účtu (EN0007) seřazeným seznamem Kampaní (EN0004) a jejich skóre — tento zápis v současnosti nemá kam persistovat, protože úložné pole pro doporučení neexistuje.

## Alternative Flows

### AF1 — Manuální/administrativní opětovné spuštění (spustilo by se, aktuálně dormant)
1. Admin: by vyvolal administrativní příkaz k přetrénování modelu pro všechny Uživatele (EN0008) najednou, obcházející spouštěč vázaný na jednotlivou Transakci.
2. Admin: by vyvolal samostatný administrativní příkaz k opětovnému obodování všech Uživatelů (EN0008) vůči aktuálním Kampaním (EN0004).

Outcome: (domnělý) stejný koncový stav jako u UC0021.1/.2, spuštěný na vyžádání místo per-Transaction spouštěče; v současnosti nedostupné ze stejných důvodů jako hlavní tok — modul, který by tyto příkazy zpřístupnil, není nainstalován.

### AF2 — Plánované opětovné obodování (spustilo by se, aktuálně dormant)
1. Scheduler: by periodicky znovu spouštěl scoring pro všechny Uživatele (EN0008), aby doporučení zůstávala aktuální s objevujícími se novými Kampaněmi (EN0004).

Outcome: (domnělý) periodicky obnovovaná doporučení; v současnosti nikdy neproběhne — plánovaný spouštěč pro tuto činnost je vypnutý.

## Postconditions

- **Current state (actual):** v tomto use case nedochází k žádným změnám stavu. Žádný model se netrénuje, žádné doporučení se neukládá, žádná položka fronty se nevytváří.
- (Domnělé, v případě reaktivace) Záznam Uživatele (EN0008) by obsahoval serializovaný natrénovaný model.
- (Domnělé, v případě reaktivace) Záznam Uživatele (EN0008) nebo Účtu (EN0007) by obsahoval seřazený seznam doporučených Kampaní (EN0004) s přiřazenými preferenčními skóre.

## Traceability

Target SRVs:
- CampaignRecommendation-Processor (Transitional)

EN entities:
- EN0009 Transaction — domnělý spouštěč (změna stavu na PAID)
- EN0008 User — subjekt trénování a (domnělý) držitel natrénovaného modelu
- EN0007 Account — (domnělý) držitel uloženého seřazeného seznamu doporučení
- EN0004 Campaign — entita, která je řazena/doporučována

Integration boundaries:
- Žádné (žádný externí systém není zapojen ani v případě reaktivace — klasifikační krok probíhá in-process, nejde o síťovou integraci).

Flow Evidence:
- FLW0030 (dormant — potvrzená (Confirmed) neaktivita na základě více nezávislých zjištění; zde popsané chování je pouze domnělý „would-fire" kontrakt)

## Evidence Level

Hypothesis — neaktivita (dormancy) spouštěče, modulu, služby, knihovny a úložiště je Confirmed podle FLW0030 a SRV0006/CampaignRecommendation-Processor (označeno jako Transitional/dead cron v SRV-target-list.md); popsané chování krok za krokem je pouze rekonstruovaný „would-fire" kontrakt, opřený o EN0009/EN0008/EN0007/EN0004, a nejde o pozorovatelné aktuální (current-state) chování.
