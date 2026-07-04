---
doc_id: EN0024
title: Blog
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0004  # Campaign — Blog CTA may link to a Campaign
  - EN0008  # User — Blog author
---

# EN0024 — Blog

## Účel

Blog je redakční obsahová entita používaná pro marketingovou/obsahovou publikaci. Reprezentuje
blogový příspěvek s titulkem, úvodním textem, hlavním obsahem, obrázky a konfigurovatelnou výzvou
k akci (CTA), která může čtenáře nasměrovat na Kampaň (Campaign). V jednu chvíli může být jako
zvýrazněný ("hero") příspěvek označen právě jeden blogový příspěvek. Blog je odlišný od základního
obsahového bundlu platformy, který sdílí název "blog"; tento bundle se v redakční praxi nepoužívá a
není součástí domény této entity.

---

## Životní cyklus

- Publikováno
- Nepublikováno

Blogový příspěvek má rovněž nezávislý příznak "hero": v jednu chvíli je aktuálním hero příspěvkem
nejvýše jeden Blog. Jde o výběr jedné položky, nikoli o stav životního cyklu jednotlivého
příspěvku — viz Invarianty.

Hypothesis — Not evidenced in current sources: žádný flow dossier nesleduje redakční životní cyklus
Blogu nad rámec vytvoření/publikace a výběru hero příspěvku. Zda Blog podporuje stav "koncept před
publikací", plánovanou publikaci nebo archivační stavy nad rámec příznaku publikováno/nepublikováno,
není potvrzeno.

---

## Přechody stavů

Nepublikováno → Publikováno
trigger: Hypothesis — Not evidenced in current sources. Žádný use case v aktuální rekonstrukci
nemodeluje autorskou tvorbu/publikaci Blogu jako krokový flow; mechanismus plánované publikace je
zmíněn ve flow evidenci (FL057), ale pro tuto entitu není potvrzen jako autoritativní. Viz otevřená
otázka níže.

(není hero) → hero
trigger: Hypothesis — Not evidenced in current sources; výběr blogového příspěvku jako hero je
odvozen pouze z chování entity (viz Invarianty), nikoli z modelovaného use case.

---

## Atributy

### Systémem spravované atributy

- slug (řetězec; generováno systémem; odvozeno z titulku v okamžiku vytvoření; jedinečnost není
  zaručena — viz Invarianty)
- created (datetime; spravováno systémem)
- changed (datetime; spravováno systémem)
- status (boolean; publikováno / nepublikováno)

### Uživatelem zadávané atributy

- name (řetězec, max 75; povinné; titulek příspěvku; používá se jako zobrazovaný název entity)
- perex (dlouhý text; volitelné; úvodní/teaser text)
- body (dlouhý text; volitelné; hlavní obsah)
- image (obrázek; volitelné; jeden; povinný odkaz na médium/soubor)
- gallery (obrázek; volitelné; více; odkazy na média/soubory)
- category (reference; volitelné; více; odkazuje na klasifikační term kategorie blogu)
- is_hero_post (boolean; volitelné; označuje tento příspěvek jako aktuální zvýrazněný příspěvek —
  viz Invarianty)
- cta_type (výčet; volitelné; hodnoty: tlačítko / karty / výzva k akci na žádost)
- cta_title (řetězec, max 200; volitelné)
- cta_button_text (řetězec, max 200; volitelné)
- cta_button_link (řetězec, max 200; volitelné)
- cta_campaign (reference na EN0004 – Kampaň; volitelné; cílová kampaň CTA)
- cta_filter (výčet; volitelné; hodnoty: končí brzy / nejnižší procentuální podpora / filtrovat podle
  regionu / filtrovat podle kategorie — řídí výběr obsahu CTA typu "karty")
- cta_filter_region (reference; volitelné; term regionu použitý, když cta_filter vybírá podle regionu)
- cta_filter_category (reference; volitelné; více; termy kategorie použité, když cta_filter vybírá
  podle kategorie)
- user_id (reference na EN0008 – Uživatel; volitelné; autor příspěvku)

---

## Invarianty

- V jednu chvíli je aktuálním hero příspěvkem nejvýše jeden Blog. Status: Implemented (pozorováno
  procedurální vynucení; nepodloženo žádným deklarovaným omezením jedinečnosti — viz Otevřené otázky).
- Očekává se, že slug blogového příspěvku je jedinečný, avšak na úrovni dat není deklarováno žádné
  omezení jedinečnosti. Status: Uncertain — viz Otevřené otázky.
- Blog aktuálně neomezuje žádný BR dokument; tyto invarianty jsou lokální pro entitu do doby, než
  budou pokryty BR dokumentací.

---

## Vztahy

- EN0008 – Uživatel (autor blogového příspěvku)
- EN0004 – Kampaň (volitelný cíl CTA)
- Atributy kategorie, filtru regionu a filtru kategorie Blogu odkazují na taxonomické/klasifikační
  termy, které nejsou v aktuální rekonstrukci samostatně modelovány jako AR entity.

---

## Otevřené otázky

1. Jedinečnost slugu není podložena deklarovaným omezením — je prevence kolize zaručena současným
   chováním, nebo jde o latentní defekt?
2. Vynucení jediného hero příspěvku je procedurální, nikoli podložené omezením, a podle dostupné
   evidence se uplatňuje bez jakéhokoli tenant/country scopingu — je jeden globální hero příspěvek
   napříč CZ/RO/MD zamýšleným současným chováním, nebo by měl být scoped podle země (viz
   `BR-MultiTenantCountryScoping` pro obecnou multi-tenant politiku, která Blog explicitně nepokrývá)?
3. Atribut `cta_filter_category` údajně spoléhá na pevnou, hardcodovanou sadu hodnot kategorií místo
   dynamické reference — je tato křehká vazba autoritativním současným chováním?
4. Vztah/překryv se základním obsahovým bundlem platformy "blog": jsou oba aktivně redakčně
   používány, nebo je jeden z nich legacy? V současných zdrojích nevyřešeno.
5. Žádný use case v aktuální rekonstrukci nemodeluje vytvoření, publikaci nebo výběr hero příspěvku
   Blogu jako flow — je to proto, že Blog je spravován mimo hlavní workflow Žádost/Příběh/Lead
   (obyčejná úprava obsahu), nebo proto, že evidence prostě chybí?
