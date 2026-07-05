---
doc_id: UC0008
title: Reconcile Bank Transactions
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0008 — Párování bankovních transakcí

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0008 |
| Název | Párování bankovních transakcí |
| Bounded Context | C5 |
| Primární aktér(ři) | Scheduler, System, Integration(Moneta), Integration(Bank), Integration(ComGate) |
| Typ spouštěče | Cron/CLI |

## Aktéři a odpovědnosti

- **Scheduler** — spouští pravidelné (denní cron) nebo ad-hoc (CLI) běhy párování; vynucuje ochrany běhu pro jednotlivé zdroje (např. maximálně jednou denně) a omezení podle prostředí/země.
- **Integration(Moneta)** — česká banka transparentního účtu, vystavující API pro informace o účtu (AISP), které systém dotazuje na nové příchozí platby.
- **Integration(Bank)** — česká banka běžného účtu, jejíž e-maily s platebním oznámením ("avízo") jsou čteny prostřednictvím integrace poštovní schránky (IMAP).
- **Integration(ComGate)** — česká platební brána, vystavující API pro seznam převodů/detail převodu, které se používá k potvrzení, které platby přes bránu se skutečně vypořádaly na bankovní účet.
- **System** — parsuje data z každého zdroje, páruje je s existujícími transakcemi (EN0009), vytváří nové transakce pro dosud nezaznamenané bankovní platby, označuje spárované transakce jako vypořádané bankou, přepočítává dotčenou kampaň (EN0004) a spouští navazující notifikace/indexaci.

Informované strany (nejsou aktivními účastníky tohoto případu užití):
- **Support** — pouze CZ, dostává provozní upozornění na příchozí platby (chatová notifikace) pro přehled o průběhu párování (vedlejší kanál, není součástí samotné logiky párování).

## Záměr

Udržovat záznamy transakcí (EN0009) platformy v souladu se skutečným vypořádáním bankou/bránou: importovat bankovní platby, které nebyly zahájeny přes online platební proces, a označit platby zahájené přes bránu jako potvrzeně vypořádané na bankovní účet, aby součty kampaní a potvrzení dárcům odpovídaly skutečně přijatým penězům.

## Předpoklady

- Relevantní přihlašovací údaje integrací jsou nakonfigurovány (token bankovního API, přihlašovací údaje ke schránce, secret/merchant id brány) pro instanci CZ; zdroje párování jsou specifické pro CZ a neběží pro RO/MD.
- Pro zdroj Moneta AISP: denní import dnes ještě neproběhl (ochrana idempotence) a bankovní API je dostupné.
- Pro zdroj bankovního e-mailu: prostředí je produkční a tenant je CZ; oznamovací schránka je dostupná.
- Pro zdroj synchronizace převodů ComGate: jsou k dispozici platné přihlašovací údaje brány; existující transakce nesou identifikátor transakce brány potřebný pro párování.

## Hlavní tok

### UC0008.1 — Denní import Moneta AISP
1. Scheduler: spustí denní úlohu párování s bankou jednou denně, chráněnou proti opakovanému spuštění téhož dne.
2. Integration(Moneta): dohledá jediný nakonfigurovaný bankovní účet platformy.
3. Integration(Moneta): vrátí příchozí platební transakce z předchozího dne pro daný účet, stránkovaně.
4. System: pro každou vrácenou platbu ověří, zda již existuje transakce (EN0009) se stejnou bankovní referencí; pokud ano, přeskočí ji.
5. System: odmítne a zaznamená každou platbu, která není v očekávané měně, čímž zastaví zpracování zbytku dávky daného dne.
6. System: z dat platby extrahuje variabilní symbol a zdrojový účet plátce.
7. System: pokusí se identifikovat platícího dárce spárováním zdrojového účtu plátce s předchozí transakcí ze stejného účtu, a pokud jej najde, přenese přiřazeného vlastníka.
8. System: vytvoří novou transakci (EN0009) označenou jako uhrazenou, přiřazenou ke kampani transparentního účtu platformy (EN0004), s bankovním datem, bankovní referencí a (pokud byl identifikován) vlastníkem.
9. System: přepočítá vybranou částku a procento kampaně transparentního účtu (EN0004) dotčené novou transakcí.
10. System: odešle poděkovací notifikaci za platbu identifikovanému vlastníkovi, pokud byl spárován a má platný kontaktní e-mail.
11. System: odešle provozní upozornění na platbu (pouze CZ, produkce).
12. System: zařadí novou transakci (a přepočítanou kampaň) do fronty pro aktualizaci vyhledávacího indexu.
13. System: zaznamená dokončení denního importu (počet zaznamenaných transakcí).

### UC0008.2 — Import bankovního oznámení e-mailem (avízo)
1. Scheduler: spustí úlohu párování bankovních e-mailů cronem, omezenou na produkci/CZ.
2. Integration(Bank): připojí se ke schránce s platebními oznámeními a vybere nepřečtené zprávy od odesílatele oznámení banky.
3. System: zohlední pouze nepřečtené zprávy, jejichž předmět odpovídá očekávanému předmětu bankovního platebního oznámení; neodpovídající nepřečtené zprávy ponechá beze změny.
4. System: z těla zprávy parsuje platební údaje oznámení (datum, částku, variabilní symbol, název a číslo protiúčtu, odesílající banku, volitelný e-mailový identifikátor dárce, popis).
5. System: normalizuje parsované oznámení do interního formátu řádku bankovního výpisu platformy a označí jej identifikátorem zprávy jako klíčem idempotence importu.
6. System: předá normalizovaný řádek bankovního výpisu stejné logice párování, jaká se používá pro ručně nahrané bankovní výpisy.
7. System: určí, zda protiúčet řádku identifikuje transakci jako vypořádací převod ComGate, nebo jako nový dar mezi bankami.
8. System: ve větvi vypořádání ComGate dohledá existující transakci/transakce podle shody variabilního symbolu; pokud je najde, aktualizuje jejich bankovní datum a označí je jako vypořádané bankou; pokud žádnou nenajde, ponechá zprávu nepřečtenou pro opakovaný pokus a zaznamená neúspěch.
9. System: ve větvi nového daru se pokusí identifikovat platícího dárce podle předchozí transakce na stejném zdrojovém účtu, případně podle e-mailového identifikátoru z oznámení.
10. System: ve větvi nového daru vytvoří novou transakci (EN0009) označenou jako uhrazenou a jako dar, přiřazenou ke kampani transparentního účtu (EN0004), s bankovním datem, variabilním symbolem a klíčem idempotence zprávy; při duplicitním klíči idempotence vytvoření přeskočí a místo toho zaznamená duplicitu.
11. System: ve větvi nového daru vyhodnotí, zda nová transakce představuje opakující se měsíční vzor, a případně ji odpovídajícím způsobem označí.
12. System: přepočítá vybranou částku dotčené kampaně (EN0004); pokud přepočítaný součet přesáhne cíl, oddělí dílčí transakci do kampaně transparentního účtu.
13. System: odešle poděkovací notifikaci za platbu identifikovanému vlastníkovi, je-li to relevantní.
14. System: odešle provozní upozornění na platbu do kanálu příchozích plateb (pouze CZ, produkce).
15. System: zaznamená auditní záznam (EN0029, BankTransactionMail) zachycující předmět, odesílatele a údaje o přijetí zpracované zprávy.
16. System: označí zpracovanou zprávu jako přečtenou, s výjimkou případu, kdy šlo o nespárovaného kandidáta na vypořádání ComGate ponechaného pro opakovaný pokus.

### UC0008.3 — Synchronizace vypořádání ze seznamu převodů ComGate
1. Scheduler: vyvolá úlohu synchronizace vypořádání ComGate na vyžádání nebo podle plánovaného běhu, pro zadaný počet předchozích dnů.
2. Integration(ComGate): pro každý den v požadovaném okně vrátí seznam převodů vypořádaných na bankovní účet daný den.
3. Integration(ComGate): pro každý uvedený převod vrátí detailní řádky převodu.
4. System: ponechá pouze detailní řádky typu platba a extrahuje variabilní symbol převodu a identifikátor transakce brány.
5. System: dohledá existující transakci/transakce podle shody identifikátoru transakce brány a nastaví jejich variabilní symbol a příznak vypořádání bankou; pevný limit omezuje, kolik odpovídajících řádků lze v jednom běhu aktualizovat.
6. System: pro každý zpracovaný převod nahlásí, zda byla aktualizována odpovídající transakce; pokud shoda nebyla nalezena, zaznamená chybu a krátce pozastaví zpracování.

## Alternativní toky

### AF1 — Selhání importu Moneta přeruší dávku
1. Integration(Moneta): volání pro vyhledání účtu nebo načtení transakcí selže (chyba sítě/autentizace).
2. System: zaznamená chybu a ukončí denní import bez importu dalších transakcí v daném běhu.

Výsledek: dnešní slot importu je přesto považován za vyčerpaný; protože zdroj vždy dotazuje „včerejšek“, chybějící den se automaticky nezopakuje v pozdějším běhu — tichá mezera v importu (Partial evidence: zaznamenaný způsob selhání, nikoli opravené chování).

### AF2 — Platba v cizí měně zastaví zbytek dávky
1. Integration(Moneta): vrátí platbu v jiné měně, než je očekávaná.
2. System: platbu odmítne a vyvolá chybu, čímž se přeruší zpracování zbývajících plateb v dané denní dávce.

Výsledek: transakce následující po odmítnuté v téže dávce nejsou v tomto běhu importovány (Confirmed failure mode).

### AF3 — Parsování bankovního e-mailu selže při odchylce šablony
1. Integration(Bank): doručí oznámení, jehož formát již neodpovídá očekávané struktuře.
2. System: z těla zprávy extrahuje prázdná/částečná pole.
3. System: přesto vytvoří transakci (nebo auditní záznam) z neúplných dat, místo aby je odmítl.

Výsledek: transakce nebo auditní záznam mohou být vytvořeny s chybějícími platebními údaji (Confirmed fragile-parsing risk).

### AF4 — Shoda vypořádání ComGate nenalezena
1. System: žádná existující transakce neodpovídá variabilnímu symbolu vypořádání ComGate.
2. Integration(Bank): odpovídající oznamovací zpráva zůstane ve schránce nepřečtená pro opakovaný pokus v pozdějším běhu.

Výsledek: vypořádání není v tomto běhu spárováno; automaticky se opakuje pouze prostřednictvím dalšího průchodu nepřečtenými zprávami zdroje bankovních e-mailů, nikoli prostřednictvím zdroje synchronizace převodů ComGate.

### AF5 — Rozdělené vypořádání překročí limit párování na jeden běh
1. System: jeden identifikátor transakce brány odpovídá více transakcím, než kolik povoluje limit aktualizací na jeden běh (např. platba rozdělená mezi mnoho řádků transakcí).
2. System: aktualizuje pouze do výše limitu; zbývající odpovídající transakce nejsou v tomto běhu označeny jako vypořádané bankou.

Výsledek: částečné párování — některé transakce vázané na rozdělené vypořádání zůstávají neoznačené až do následujícího běhu (Confirmed data-loss/idempotence risk).

## Postconditions

- Nové transakce (EN0009) existují pro dosud nezaznamenané bankovní platby a dary mezi bankami, označené jako uhrazené a přiřazené ke kampani transparentního účtu (EN0004).
- Dříve vytvořené transakce odpovídající potvrzeným vypořádáním ComGate jsou označeny jako vypořádané bankou (nastaveno bankovní datum, zapnutý příznak vypořádání) beze změny historie jejich platebního stavu.
- Dotčená kampaň/kampaně (EN0004) mají přepočítané součty vybrané částky tak, aby odrážely nově importované nebo spárované transakce.
- Ke každému zpracovanému bankovnímu oznamovacímu e-mailu, ať už úspěšně či nikoli, existuje jeden auditní záznam (EN0029, BankTransactionMail).
- Nově vytvořené nebo aktualizované transakce a kampaně jsou zařazeny do fronty pro aktualizaci vyhledávacího indexu.
- Poděkovací notifikace dárcům a provozní upozornění na platby byly odeslány tam, kde je to relevantní.

## Traceability

Cílové SRV:
- Bank-Reconciliation
- Moneta-AISP-Adapter
- BankMail-IMAP-Adapter
- ComGate-TransferSync-Adapter
- Reconciliation-Processor

Entity EN:
- EN0009 Transaction — záznam vytvořený (nová bankovní platba/dar) nebo aktualizovaný (shoda vypořádání bankou) v každém dílčím toku
- EN0029 BankTransactionMail — auditní stopa zpracovaných bankovních oznamovacích e-mailů (UC0008.2)
- EN0030 ComgateBankReconciliation — související záznam ručního účetního vypořádání; není zapisován automatizovaným dílčím tokem synchronizace (UC0008.3), uveden pouze pro kontext/vymezení hranice
- EN0004 Campaign — kampaň transparentního účtu (a jakákoli kampaň, na kterou míří transakce spárovaného dárce), jejíž vybraná částka je vedlejším efektem přepočítána

Hranice integrací:
- Integration(Moneta) — API pro informace o účtu (AISP), denní import plateb (UC0008.1)
- Integration(Bank) — schránka platebních oznámení (IMAP), import e-mailů avízo (UC0008.2)
- Integration(ComGate) — API vypořádání seznamu převodů/detailu převodu (UC0008.3)

Flow Evidence:
- FLW0011 (denní import transakcí Moneta AISP)
- FLW0012 (import bankovního oznamovacího e-mailu přes IMAP)
- FLW0013 (synchronizace párování ze seznamu převodů ComGate)

## Evidence Level

Confirmed — všechny tři dílčí toky jsou Flow-evidenced (FLW0011, FLW0012, FLW0013) spouštěče cron/CLI s konkrétními vedlejšími efekty na transakce (EN0009) namapované na cílové SRV Bank-Reconciliation, Moneta-AISP-Adapter, BankMail-IMAP-Adapter a ComGate-TransferSync-Adapter; automatické plánování dílčího toku synchronizace převodů ComGate (UC0008.3) je zaznamenaný konflikt rozsahu ve FLW0013 — jeho ruční/CLI spouštění je Confirmed, jakékoli plánování cronem je Hypothesis — a je odpovídajícím způsobem označeno, nikoli tvrzeno jako fakt.
