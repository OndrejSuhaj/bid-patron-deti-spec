---
doc_id: FN0020
title: Reporting Read-Model & CSV Export
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0017
  - EN0001
  - EN0002
  - EN0004
  - EN0006
  - EN0009
  - EN0011
  - EN0031
  - EN0032
---

# FN0020 – Reportovací read-model a CSV export

## Účel

Poskytnout administrátorům konsolidované, stažitelné CSV extrakty dat o darech, žádostech, smlouvách,
scoringu a kampaních pro finanční/riziková/kampaňová reportování — automaticky obnovované jednou denně
nebo generované na vyžádání — plus hodnoty read-model dashboardu, aniž by se měnil jakýkoli doménový
záznam. Sdružuje plánovanou exportní dávku, cestu exportu na vyžádání a read-model reportovacího
dashboardu do jedné reportovací capability, odlišné od transakčních/doménu-zapisujících capabilities,
které produkují podkladové záznamy.

---

## Odpovědnosti

Capability je odpovědná za:

- Spouštění denní dávky, která sestaví až šestnáct standardních reportovacích CSV souborů (platby,
  podporovatelé, dárkové poukazy, účetnictví, leady, kampaně, patroni, fundraiseři, úhrady darů,
  smlouvy, scoring/riziko, blacklist, souhrny za regiony), přičemž pro každý kalendářní den se
  ukládá do cache jeden soubor na typ exportu a soubor předchozího dne pro daný typ se zahazuje.
- Obsluhu exportních požadavků na vyžádání po kontrole oprávnění dle kategorie (obecné reportování,
  leady, nebo účetnictví), s opětovným použitím souboru uloženého v cache ze stejného dne, pokud již
  existuje, nebo sestavením nového, pokud neexistuje — včetně dvou typů exportu, které existují
  pouze jako požadavky na vyžádání a nikdy nejsou produkovány plánovanou dávkou.
- Zúžení sestavených řádků exportů souvisejících s platbami na jedinou kampaň (EN0004), pokud
  administrátor zadá volitelný filtr kampaně.
- Obsluhu reportovacích dashboardů z časových snímků read-modelu (CostsSnapshot EN0031, ReportSnapshot
  EN0032) filtrovaných na požadované časové rozmezí, nezávisle na CSV exportních souborech.
- Čtení zdrojových záznamů pouze pro čtení napříč rozsahem reportování — žádný záznam Application
  (EN0001), ApplicationProfile (EN0002), Contact (EN0006), Transaction (EN0009), Campaign (EN0004)
  ani Contract (EN0011) není touto capability vytvořen, aktualizován ani převeden do jiného stavu.
- Zaznamenávání záznamu do logu o úspěchu nebo selhání pro každý export vyprodukovaný v rámci plánované
  dávky, přičemž při selhání jednotlivého exportu pokračuje se zbývajícími exporty v dávce.
- Zobrazení chybového výsledku administrátorovi, namísto souboru, pokud při požadavku na vyžádání
  selže načtení záznamů nebo sestavení souboru.

---

## Související use case

UC0017 – Export reportovacích dat (CSV)

---

## Související entity

EN0009 – Transaction
EN0001 – Application
EN0002 – ApplicationProfile
EN0006 – Contact
EN0004 – Campaign
EN0011 – Contract
EN0031 – CostsSnapshot
EN0032 – ReportSnapshot

---

## Integrace

Žádné. Jedinou hranicí je lokální souborový systém sloužící jako exportní/úložný sink pro perzistenci
a opětovné poskytování CSV souborů pro znovupoužití v rámci stejného dne, pojmenovaný podle
integrační mapy C5 (Finance & Reconciliation) v ARCH0002_ContextInteractionMap; pro tuto hranici
zatím neexistuje žádný artefakt vrstvy ES a není zapojen žádný externí systém.

---

## Omezení

- Exportovaný obsah CSV nese syrové osobní údaje (identifikační čísla, jména, adresy, e-maily,
  telefonní čísla, čísla smluv); kromě kontroly oprávnění provedené v okamžiku požadavku není na
  samotný exportovaný soubor uplatněna žádná další ochrana a podkladové dočasné exportní soubory
  nejsou nikdy uklízeny, čímž se v čase hromadí na hostiteli úložiště.
- Na žádný export není uplatněno žádné rozlišení tenanta/země (CZ/RO/MD) — všechny standardní
  exporty jsou napříč tenanty globální.
- Granularita oprávnění je vzhledem k citlivosti hrubá: některé exporty obsahující identifikační
  čísla a verdikty rizika/scoringu jsou chráněny pouze obecným oprávněním pro reportování, nikoli
  vyhrazeným oprávněním pro citlivá data.
- Za kalendářní den proběhne nejvýše jedna plánovaná exportní dávka; selhané nebo přeskočené okno
  dávky se neopakuje dříve než v okně následujícího dne.
- Podtok reportovacího dashboardu / read-modelu (přístup k read-modelu přes CostsSnapshot EN0031 /
  ReportSnapshot EN0032) je nyní zmapován (FLW0031, dříve flow-index FL034): controllery
  `/admin/reports/*` jsou pouze pro čtení (SELECT-and-render, cache stránky vypnuta), takže se
  žádná reportovací hodnota nikde nematerializuje — každý přístup na dashboard znovu dotazuje data
  při požadavku na stránku. FLW0031 také opravuje otisk entit: `snapshot_entity` (ReportSnapshot
  EN0032) je nezávislá CRUD entita bez volajícího reportu; hodnoty měsíčních nákladů pocházejí z
  `costs_entity` (CostsSnapshot EN0031).
- Účetní report zpřístupňuje `application_attachments_audit-archive/*` (obecní/auditní přílohy,
  potenciálně obsahující osobní údaje) jako anonymně stažitelné veřejné URL; permission-gated je
  pouze stránka se seznamem (FLW0031). Peněžní hodnoty obsahují napevno zadané magické konstanty
  (zůstatek transparentního účtu a viditelné upozornění "artificially added") a v modulu reportů
  se nikde neprovádí výpočet DPH (FLW0031).
