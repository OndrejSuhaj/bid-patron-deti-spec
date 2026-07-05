---
doc_id: UC0007
title: Process Recurring Donation
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0007 — Zpracování trvalého daru

## Header

| Field | Value |
|---|---|
| UC ID | UC0007 |
| Name | Process Recurring Donation |
| Bounded Context | C4 |
| Primary Actor(s) | Scheduler, Integration(ComGate), Integration(Netopia) |
| Trigger Type | Cron |

## Aktéři a odpovědnosti

- **Scheduler** — spouští úlohu opakovaného strhávání plateb pro jednotlivé platební brány v denním cyklu, s omezením tak, aby se úloha pro danou bránu spustila nejvýše jednou denně.
- **Integration(ComGate)** — platební brána pro CZ; strhává platbu podle uložené reference pro opakované platby a vrací potvrzení o zpracování platby.
- **Integration(Netopia)** — platební brána pro RO; strhává platbu podle uloženého tokenu brány a vrací synchronní výsledek zpracování platby.
- **System** — vybírá splatné plány trvalých darů, vytváří dceřinou transakci (EN0009) pro každou platbu, zaznamenává výsledek, posouvá plán a spouští navazující vedlejší efekty (notifikace, přepočet příběhu, indexace).

## Záměr

Automaticky strhávat platby dárcům, kteří mají aktivní plán trvalého daru (EN0010), v jejich plánovaný den, přičemž se pro každou úspěšnou nebo pokusnou platbu vytváří nová transakce (EN0009), aby trvalá podpora pokračovala bez nutnosti manuální akce dárce.

## Předpoklady

- Existuje RecurringTransaction (EN0010) ve stavu aktivní, navázaná na výchozí transakci (EN0009), která dříve dosáhla stavu PAID.
- Den v měsíci naplánovaný v RecurringTransaction odpovídá aktuálnímu datu spuštění (dny nad 28 se přesouvají na den 1), plán není zrušený a od poslední úspěšné platby uplynulo alespoň 28 dní (nebo dosud nebyla stržena žádná platba).
- Pro cestu přes CZ bránu: výchozí transakce obsahuje referenci pro opakované platby použitelnou u dané brány a běh probíhá na produkční instanci CZ.
- Pro cestu přes RO bránu: RecurringTransaction obsahuje neexpirovaný token brány a běh probíhá na instanci RO; pokud byla poslední zrušená opakovaná platba daného dárce velmi nedávná (v rámci krátkého ochranného období), je tento dárce při běhu s přesunem dne přeskočen.
- Pro platební bránu MD není potvrzena žádná aktuální cesta cronu; opakované strhávání plateb přes tuto bránu není doloženo (viz Úroveň důkazů).

## Hlavní tok

### UC0007.1 — Výběr splatných plánů (podle brány)

1. Scheduler: spustit úlohu opakovaného strhávání plateb pro CZ po uplynutí denního okna omezení.
2. Scheduler: spustit úlohu opakovaného strhávání plateb pro RO po uplynutí jejího vlastního denního okna omezení.
3. System: vybrat všechny RecurringTransaction (EN0010) splatné k dnešnímu dni (shoda dne v měsíci, není zrušeno, ≥28 dní od poslední platby).
4. System: pro každou splatnou RecurringTransaction načíst výchozí transakci (EN0009) a detaily plánu.
5. System: pokud chybí potřebná data pro strhávání platby (např. chybějící reference pro opakované platby u CZ, nebo chybějící/expirovaný token u RO), plán přeskočit a pokračovat dalším.

### UC0007.2 — Provedení platby a vytvoření dceřiné transakce

1. System: vytvořit novou dceřinou transakci (EN0009) přebírající částku daru, dárce a příběh (EN0004) z výchozí transakce, označenou jako trvalý dar a zpočátku ve stavu čekající.
2. Integration(ComGate): u CZ plánu strhnout platbu dárci pomocí uložené reference pro opakované platby z výchozí transakce.
3. Integration(Netopia): u RO plánu strhnout platbu dárci pomocí tokenu brány uloženého v RecurringTransaction.
4. System: označit novou transakci jako uhrazenou, pokud volání brány proběhne bez chyby, nebo jako zrušenou, pokud volání brány selže nebo vrátí chybu.
5. System: zaznamenat referenci platby vrácenou bránou do nové transakce.
6. System: posunout časové razítko poslední platby v RecurringTransaction na aktuální čas pouze v případě, že volání brány neselhalo.

### UC0007.3 — Vedlejší efekty po platbě (při úspěšné platbě)

1. System: odeslat dárci děkovnou notifikaci za opakovanou platbu.
2. System: reaktivovat účet dárce s notifikací o aktivaci, pokud byl účet dárce dříve zablokovaný.
3. System: přepočítat vybranou částku cílového příběhu (EN0004) tak, aby zahrnovala novou transakci.
4. System: rozdělit novou transakci na dvě části — financovanou část a přeplatek směrovaný na transparentní/obecný účet — pokud by vybraná částka příběhu překročila jeho cílovou částku.
5. System: odeslat interní provozní notifikaci o úspěšné opakované platbě CZ (pouze v produkčním prostředí).
6. System: zařadit novou transakci do fronty pro aktualizaci vyhledávacího indexu.

## Alternativní toky

### AF1 — Platba přes bránu selže nebo je zamítnuta

1. Integration(ComGate): nahlásit selhání, nebo pokus o platbu přes ComGate vyvolá chybu.
2. Integration(Netopia): nahlásit chybový kód platby v odpovědi brány.
3. System: označit novou dceřinou transakci jako zrušenou.
4. System: neposouvat časové razítko poslední platby v RecurringTransaction, takže plán zůstává splatný a bude opakován při některém z dalších naplánovaných běhů.
5. System: odeslat dárci notifikaci o zrušení platby (pouze cesta RO/Netopia; na cestě CZ/ComGate není obdobná notifikace doložena).

Výsledek: Není zaznamenána žádná úspěšná platba; plán trvalého daru zůstává otevřený pro opakování; dárce je informován pouze na cestě RO.

### AF2 — První běh úlohy plánovače pro danou bránu

1. Scheduler: spustit úlohu opakovaného strhávání plateb pro bránu, pro kterou dosud nebyl zaznamenán žádný předchozí běh.
2. System: zaznamenat aktuální čas běhu jako výchozí bod pro budoucí omezování frekvence.

Výsledek: Při tomto běhu nejsou provedeny žádné platby; strhávání plateb začíná od dalšího naplánovaného okna.

### AF3 — Platba optimisticky označena jako uhrazená před potvrzením bránou (cesta CZ/ComGate)

1. Integration(ComGate): přijmout požadavek na platbu bez okamžité chyby.
2. System: označit novou dceřinou transakci jako uhrazenou pouze na základě absence chyby, bez čekání na asynchronní potvrzení výsledku platby ze strany brány.

Výsledek: Transakce je předběžně uhrazena; konečné potvrzení výsledku platby závisí na samostatné asynchronní notifikaci brány zpracovávané mimo tento use case. Jde o zaznamenané riziko integrity peněz, nikoli o záměrné obchodní pravidlo.

## Postconditions

- Pro každou splatnou RecurringTransaction zpracovanou v daném běhu existuje jedna nová transakce (EN0009), ve stavu uhrazená nebo zrušená.
- Časové razítko poslední platby v RecurringTransaction (EN0010) je posunuto pouze u běhů, kde volání brány neselhalo; neúspěšné běhy ponechávají plán splatný i při dalším naplánovaném běhu.
- Vybraná částka cílového příběhu (EN0004) odráží jakoukoli nově uhrazenou transakci, včetně případného rozdělení přeplatku.
- Tento use case nezpůsobuje zrušení ani deaktivaci žádné RecurringTransaction pouze na základě neúspěšného pokusu o platbu.

## Traceability

Target SRVs:
- RecurringPayment-Processor
- Payment-Processing
- ComGate-Adapter
- Netopia-Adapter
- MAIB-Adapter

EN entities:
- EN0010 RecurringTransaction — plán trvalého daru vybraný, zpoplatněný a posunutý tímto use case
- EN0009 Transaction — výchozí platba (zdroj reference pro strhávání) a nová dceřiná transakce vytvořená při každé platbě
- EN0004 Campaign — cíl daru, jehož vybraná částka je přepočítána po úspěšné platbě

Integration boundaries:
- Integration(ComGate) — provedení opakované platby CZ
- Integration(Netopia) — provedení opakované platby RO
- MAIB (MD) — uvedeno jako cílová hranice adaptéru v rozsahu, ale pro tuto bránu není doložena žádná aktuální integrace s recurring cronem (viz Úroveň důkazů)

Flow Evidence:
- FLW0007 (recurring donation charge cron — cesty CZ/ComGate a RO/Netopia)

## Úroveň důkazů

Confirmed pro cesty cronu ComGate (CZ) a Netopia (RO), pro pojistku výběru splatných plánů, chování s optimistickým stavem PAID a neposouváním plánu při neúspěšné platbě a pro vedlejší efekty po platbě, vše dle FLW0007 a v souladu s životními cykly EN0010/EN0009/EN0004; Partial/Hypothesis pro cestu adaptéru MAIB (MD), který se objevuje v cílovém seznamu SRV, ale nemá potvrzený recurring-cron tok ve FLW0007 ("MD has no recurring cron in this flow").
