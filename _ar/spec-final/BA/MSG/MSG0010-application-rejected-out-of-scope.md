---
doc_id: MSG0010
title: Application Rejected — Out of Scope
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0022
  - EN0026
  - ES0006
---

# MSG0010 – Zamítnutí žádosti — Out of Scope

## Účel

Informovat Žadatele (Žadatel/fundraiser) i Patrona o tom, že Koordinátor zamítl Žádost (EN0001),
protože nesplňuje podmínky způsobilosti projektu — případ je uzavřen jako „out of scope", nikoli
kvůli rizikovému rozhodnutí, problému s daty nebo nečinnosti stran. Jde o samostatnou zprávu
milníku zamítnutí: stav `out_of_scope` je vyčleněn z obecného e-mailu o změně stavu (MSG0005) do
této dedikované, více zvýrazněné smluvní specifikace, protože manuální zamítnutí způsobilosti
koordinátorem je bodem rozhodnutí učiněného člověkem v životním cyklu Žádosti (EN0001), doloženým
vlastním akceptačním scénářem (SC-4C). Mechanicky stále běží po stejném rozcestníku reakcí podle
stavu/role (EN0026) jako MSG0005/MSG0006 — vyčlenění je otázkou zvýraznění a vlastnictví
dokumentace, nikoli samostatné doručovací cesty.

---

## Spouštěč

UC0002 (Orchestrovat změnu stavu žádosti) — konkrétně navazující rozcestník reakcí (UC0002.2):
Koordinátor manuálně zamítne Žádost (EN0001) v administraci poté, co zjistí, že nesplňuje podmínky
způsobilosti projektu (např. dítě je mimo podporovaný věkový rozsah); Žádost se uloží do stavu
`out_of_scope` a Systém vyhledá odpovídající konfiguraci ApplicationReaction (EN0026) pro daný
stav a roli a odešle tuto zprávu na každém kanálu, který je pro ni povolen.

Doloženo přímo scénářem SC-4C („Zamítnutí žádosti – Out of Scope"), kroky 1–6: Koordinátor
posoudí Žádost vůči podmínkám způsobilosti projektu (krok 1), zjistí, že je nesplňuje, a
zdokumentuje konkrétní důvod zamítnutí v poznámkách k případu (krok 2), manuálně ji zamítne v
administraci (krok 3), Systém změní stav na `out_of_scope` (krok 4) a poté odešle e-mail o zamítnutí
Žadateli spolu s doprovodnou notifikací (krok 5) a notifikaci o zamítnutí Patronovi (krok 6).

---

## Příjemci

- **Žadatel / Žadatel** — e-mail (kanál: ES0006, Mautic) + notifikace v zóně v Zóně žadatele, obě
  označené Email = YES a Notifikace v účtu uživatele = YES pro `out_of_scope`/Žadatel v Notification
  Matrix.
- **Patron** — e-mail (kanál: ES0006, Mautic) + notifikace v zóně v Zóně patrona, obě označené
  Email = YES a Notifikace v účtu uživatele = YES pro `out_of_scope`/Patron v Notification Matrix.

Obě strany dostávají pro tento stav oba kanály — na rozdíl od mnoha jiných zpráv řízených stavem,
kde daná role dostane jen jeden kanál nebo žádný. Kroky 7–8 scénáře SC-4C dále potvrzují, že stejný
stav „Out of Scope" je viditelný pro každou stranu uvnitř její vlastní zóny při dalším přihlášení,
v souladu s notifikací v zóně. CZ je doložený primární trh; žádná specifická RO/MD varianta obsahu
ani kanálu není pro tuto zprávu doložena nad rámec rozlišení šablony podle země, které je již
zdokumentováno na úrovni schopnosti (FN0019).

---

## Obsah zprávy

- Tvrzení, že Žádost (EN0001) nelze podpořit a byla uzavřena, protože nespadá do rozsahu/podmínek
  způsobilosti projektu — formulováno podle role/zóny dle rozlišení „Status message" v
  ApplicationReaction (EN0026) a Notification Matrix pro `out_of_scope` (zaznamenáno tam jako
  dvoudílná stavová fráze; přesné znění je konfigurační/stavová data a v tomto dokumentu není
  tvrzeno jako pevný text šablony — viz omezení v rules-MSG.md).
- Konkrétní důvod zamítnutí, pokud jej Koordinátor zdokumentoval v poznámkách k případu v okamžiku
  rozhodnutí (SC-4C krok 2) — obsahově jde o data vytvořená k případu a připojená k Žádosti
  (EN0001), nikoli pevný text šablony; tento dokument netvrdí, zda je samotný text důvodu zobrazen
  přímo v těle zprávy, nebo je uchováván pouze interně na záznamu případu, což je z citovaného
  důkazu **Uncertain**.
- Zdvořilé zakončení naznačující, že případ je uzavřen a od žádné ze stran se neočekává další
  akce — což tuto zprávu odlišuje od stavových notifikací, které nesou pokyn vyžadující akci.
- Identifikace předmětné Žádosti (EN0001), implicitně vymezená vlastním pohledem strany v její
  zóně (Zóna žadatele / Zóna patrona) pro variantu v zóně a rozlišením příjemce na záznamu
  Žádosti/Kontaktu pro e-mailovou variantu.
- Každé odeslání e-mailu této zprávy je archivováno jako záznam EmailArchive (EN0022) podle
  standardního mechanismu odeslání/archivace, bez ohledu na to, zda bylo odeslání skutečně
  přeneseno (viz MSG0005 / FN0019 Omezení k limitaci brány odeslání/archivace).

Z této smluvní specifikace je vyloučeno: přesné řetězce předmětu/těla e-mailu, HTML/vizuální
prezentace a konfigurace poskytovatele pošty/doručování — viz MSG0005 (E-mail o změně stavu
žádosti) a MSG0006 (Notifikace o změně stavu v zóně) pro sdílený mechanismus odeslání, na kterém
tato zpráva jede.

---

## Poznámky / Nejistoty

- Tento dokument vlastní manuální zamítnutí způsobilosti koordinátorem (`out_of_scope`) jako
  vlastní pojmenovanou zprávu, vyčleněnou z obecného e-mailu o změně stavu (MSG0005) a jeho
  protějšku v zóně (MSG0006), a odlišnou od dalších záměrů zamítnutí/uzavření v životním cyklu
  případu, které se spouští za jiných stavů (např. zamítnutí na základě rizikového rozhodnutí,
  nebo zrušení kvůli nečinnosti žadatele/koordinátora) — ty jsou samostatnými rodinami zpráv a zde
  se neopakují. `out_of_scope` je proto zdokumentováno zde, nikoli jako jeden ze souhrnných
  seskupených řádků MSG0005. Mechanicky je tato zpráva stále odesílána prostřednictvím stejného
  rozcestníku ApplicationReaction (EN0026) řízeného stavem/rolí jako MSG0005/MSG0006; tato zpráva
  (MSG) nezavádí samostatný mechanismus doručení.
- Notification Matrix zaznamenává stavovou zprávu pro `out_of_scope` jako dvoudílnou frázi
  („Zrušená žádost; Nemůžeme vám pomoci" pro Žadatele i Patrona) a označuje řádek příznakem
  `CHECK_PARSE` — která z obou frází (nebo obě, v sekvenci) je výsledná jednotlivá stavová zpráva,
  je **Uncertain** a je ponecháno na důkazech modelu stavů / ApplicationReaction (EN0026), nikoli
  tvrzeno zde.
- Zda je důvod zamítnutí vytvořený k případu (SC-4C krok 2) zahrnut přímo v těle zprávy, nebo jde
  o čistě interní poznámku k případu nezpřístupněnou Žadateli/Patronovi, je **Uncertain** — není
  vyřešeno citovaným důkazem; ponecháno obecně namísto vymýšlení.
- Úroveň důkazu: Confirmed pro spouštěč, tvar příjemců oba kanály/obě role a existenci důvodu
  zamítnutí zdokumentovaného k případu (SC-4C, Notification Matrix). Partial/Uncertain pro přesné
  výsledné znění stavové zprávy a pro to, zda je text důvodu zamítnutí zobrazen stranám, nebo
  zůstává interní.
