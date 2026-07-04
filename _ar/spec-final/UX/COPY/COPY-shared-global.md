---
doc_id: COPY-shared-global
title: Shared Global Chrome Copy — Header, Footer, Cookie Consent
canonical_layer: COPY
spec_type: copy
scope: shared-global
modules: []
language: cs
status: canonical
references:
  - WIRE0001
  - WIRE0002
  - WIRE0003
  - WIRE0005
  - WIRE0006
  - WIRE0007
  - WIRE0008
  - WIRE0009
  - WIRE0010
  - WIRE0011
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0019
  - WIRE0021
  - WIRE0023
  - WIRE0024
  - WIRE0025
  - COMP0002
  - COMP0003
  - COMP0004
  - UC0023
  - UC0001
  - UC0014
---

# COPY-shared-global – Sdílené texty globálního chrome (hlavička, patička, cookie souhlas)

## Účel

Textový povrch pro sdílené prvky ("chrome"), které se opakují téměř na každé obrazovce Patronus:
globální horní navigace (`COMP0002`), globální patička webu (`COMP0003`) a banner cookie souhlasu
v obou pozorovaných variantách (`COMP0004`). Tyto prvky jsou popsány identicky ve ≥19 z 22
zdokumentovaných WIRE dokumentů (`_ar/spec-draft/WIRE-synthesis-report.md` §6). Obsah specifický pro
konkrétní obrazovku (hero texty, popisky formulářů, CTA pro danou obrazovku, validační zprávy) je
mimo rozsah tohoto dokumentu a patří do příslušného dokumentu `module-*` COPY. Text je přepsán
**verbatim** z `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (hlavička, patička,
dual-action cookie banner) a `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`
(single-action cookie banner), zkříženě ověřeno oproti `_ar/evidence/ui/ui-observed-areas.md` §1, §6,
§16 a `COMP0002`/`COMP0003`/`COMP0004`.

Hlavička se vykresluje identicky bez ohledu na stav přihlášení pozorovaný v podkladech: záznam
`_ar/prtsc/po_prihlaseni_do_uctu.png` (po přihlášení) zobrazuje stejné logo, navigační odkazy a
popisek "Můj účet" jako záznam anonymní domovské stránky — liší se pouze cílová destinace odkazu
(vlastněno IA vrstvou, není předmětem COPY; `COMP0002` prop `isAuthenticated`). V samotné hlavičce
nebyla pozorována samostatná navigační položka "Přihlásit se"; "Přihlásit se" je submit CTA
přihlašovacího formuláře na S009 a je vlastněno dokumentem `COPY-module-auth`
(`module-auth.login.submit-cta`), nikoli tímto dokumentem.

---

## Popisky (Labels)

| Klíč | Text | Použití (odkaz WIRE/COMP) |
|---|---|---|
| `shared-global.header.logo` | `patron dětí` | `COMP0002`; logo/odkaz na domovskou stránku, všechny obrazovky |
| `shared-global.header.tagline` | `společně za lepší dětství` | `COMP0002`; malý červený podtitulek pod logem |
| `shared-global.footer.brand-heading` | `patron dětí` | `COMP0003` brandový blok |
| `shared-global.footer.brand-blurb` | `Patron dětí je charitativní projekt, který pomáhá zdravotně a sociálně znevýhodněným dětem a jejich rodinám z celé České republiky.` | `COMP0003` brandový blok |
| `shared-global.footer.social-label` | `Sledujte nás na` | `COMP0003` brandový blok, vedle odkazu s ikonou Facebooku |
| `shared-global.footer.sirius-attribution` | `Patron dětí je projektem Nadace Sirius` | `COMP0003` brandový blok; "Nadace Sirius" je odkaz |
| `shared-global.footer.collection-registration` | `Zaregistrovaná veřejná sbírka: Sp. zn. S-MHMP/836092/2017` | `COMP0003` brandový blok |
| `shared-global.footer.column-heading.patron-deti` | `Patron dětí` | `COMP0003`; nadpis prvního sloupce odkazů |
| `shared-global.footer.column-heading.kontakt` | `Kontakt` | `COMP0003`; nadpis druhého sloupce odkazů |
| `shared-global.footer.contact-email-label` | `E-mail` | `COMP0003` sloupec Kontakt |
| `shared-global.footer.contact-email-value` | `info@patrondeti.cz` | `COMP0003` sloupec Kontakt; odkaz `mailto:` |
| `shared-global.footer.payments-label` | `Platby zprostředkovává:` | `COMP0003`; předchází řádku odznaků Comgate/Mastercard/Visa |
| `shared-global.footer.collection-account-label` | `Číslo sbírkového účtu: 57574646/0600` | `COMP0003` |
| `shared-global.footer.copyright` | `© 2026 Patron dětí. Všechna práva vyhrazena.` | `COMP0003` spodní lišta |

---

## Nápovědné texty (Helper Texts)

`(none)` — patička a hlavička nenesou žádnou samostatnou roli nápovědného textu nad rámec výše
uvedených popisků/odkazů a níže uvedených CTA; žádný další vysvětlující text uvnitř těchto prvků
nebyl pozorován.

---

## Prázdné stavy (Empty States)

`N/A` — hlavička, patička a cookie banner jsou statické prvky chrome, nikoli výpisy dat; stav
"prázdno" se na ně nevztahuje (sekce States v `COMP0002`/`COMP0003`/`COMP0004` toto shodně označují
jako `N/A`).

---

## Načítací texty (Loading Texts)

`N/A` — žádnou asynchronní operaci nevlastní samotná hlavička, patička ani cookie banner
(`COMP0002`/`COMP0003`/`COMP0004` States→loading, vše `N/A`).

---

## Chybové / validační zprávy

`N/A` — globální chrome neobsahuje žádná pole formulářů a nespouští žádnou validaci. Žádné
`BRxxxx`/`ENxxxx` neřídí obsah hlavičky/patičky/cookie banneru; tato sekce je záměrně prázdná podle
`cross-layer-discipline.md` §5 (pravidlo skip-empty-sections se vztahuje na čistě placeholderový
obsah, ale Otevřené otázky níže zaznamenávají související mezeru: žádné BR neřídí samotnou akci
cookie souhlasu).

---

## CTA

Každé CTA odkazuje na use case, který realizuje. Navigační cíle chrome prvků (navigační odkazy,
odkazy v patičce) jsou vlastněny vrstvou IA podle `cross-layer-discipline.md`; kde žádný dokument
`UCxxxx` nevlastní cílové chování, je to zaznamenáno jako Otevřená otázka, nikoli vymyšleno.

| Klíč | Text | Akce |
|---|---|---|
| `shared-global.nav.how-it-works` | `Jak to funguje` | Naviguje na obsahovou obrazovku "Jak to funguje" (`S019`/`WIRE0019` podle IA); žádný vyhrazený UC — statická obsahová navigace. **Otevřená otázka** — žádné `UCxxxx` nevlastní tento navigační cíl. |
| `shared-global.nav.blog` | `Blog` | Naviguje na obrazovku výpisu blogu; žádný vyhrazený UC — statická obsahová navigace. **Otevřená otázka** — žádné `UCxxxx` nevlastní tento navigační cíl. |
| `shared-global.nav.o-nas` | `O nás` | Naviguje na obsahovou obrazovku "O nás"; žádný vyhrazený UC — statická obsahová navigace. **Otevřená otázka** — žádné `UCxxxx` nevlastní tento navigační cíl. |
| `shared-global.nav.pozadat-o-pomoc-cta` | `Požádat o pomoc` | `UC0001` (Podání žádosti) — vstupuje na landing s volbou role (S006), který zahajuje intake žádosti |
| `shared-global.nav.muj-ucet-cta` | `Můj účet` | `UC0014` (Autentizace a správa přístupu) — směruje na přihlášení (S009), pokud uživatel není přihlášen, nebo do sekce účtu, pokud je přihlášen; popisek je identický v obou stavech přihlášení (`COMP0002` prop `isAuthenticated`, zde nerestatováno) |
| `shared-global.footer.link.o-nas` | `O nás` | Stejná destinace jako `shared-global.nav.o-nas`; sloupec patičky "Patron dětí". **Otevřená otázka** — žádné `UCxxxx` nevlastní tento navigační cíl. |
| `shared-global.footer.link.blog` | `Blog` | Stejná destinace jako `shared-global.nav.blog`; sloupec patičky "Patron dětí". **Otevřená otázka** — žádné `UCxxxx` nevlastní tento navigační cíl. |
| `shared-global.footer.link.pravidla` | `Pravidla poskytování pomoci` | Otevírá PDF s pravidly (`S-EXT4` podle `_ar/spec-draft/IA-screen-map.md`); žádné `UCxxxx` — zobrazení dokumentu. **Otevřená otázka** podle `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.desatero` | `Naše desatero` | Obsahová obrazovka; žádné `UCxxxx` nevlastní tento cíl. **Otevřená otázka** podle `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.splnene-pribehy` | `Splněné příběhy` | Naviguje na S016 (výpis splněných příběhů); žádné `UCxxxx` nevlastní tento cíl — prohlížení obsahu, nikoli `UC0023`. **Otevřená otázka** podle `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.vyrocni-zpravy` | `Výroční zprávy` | Obsahová obrazovka (vykresluje se na S015 podle `IA-patronus.md` IA-Q8); žádné `UCxxxx` nevlastní tento cíl. **Otevřená otázka**. |
| `shared-global.footer.link.koronakrize` | `Jak jsme pomáhali v době koronakrize` | Obsahová obrazovka; žádné `UCxxxx` nevlastní tento cíl. **Otevřená otázka** podle `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.gdpr-consent` | `Souhlas se zpracováním osobních údajů` | Cíl nevyřešen — žádné `UCxxxx`, žádná potvrzená cílová obrazovka. **Otevřená otázka** podle `IA-patronus.md` IA-Q8. |
| `shared-global.footer.link.chci-prihlasit-pribeh` | `Chci přihlásit příběh` | `UC0001` (Podání žádosti) — vstupní bod v patičce ekvivalentní ke stejnému landingu s volbou role (S006) jako CTA "Požádat o pomoc" v hlavičce (`IA-patronus.md` §2) |
| `shared-global.cookie-banner.accept-cta` | `Přijímám` | Žádný vlastnící UC — akce persistence souhlasu na straně klienta, mechanismus není podložen důkazy (`COMP0004` `onAccept`). **Otevřená otázka** — žádné BR neřídí cookie souhlas. |
| `shared-global.cookie-banner.reject-cta` | `Odmítnout` | Žádný vlastnící UC — pouze dual-action varianta (`COMP0004` `onReject`); žádný potvrzený rozdíl v chování oproti přijetí nebyl pozorován. **Otevřená otázka** — žádné BR neřídí cookie souhlas. |
| `shared-global.cookie-banner.more-info-cta` | `Další informace` | Cíl nepotvrzen v podkladech, pravděpodobně stránka s cookie zásadami (nezachycena); single-action varianta. **Otevřená otázka.** |
| `shared-global.cookie-banner.modal-more-info-cta` | `Více zde.` | Stejný nevyřešený cíl jako `shared-global.cookie-banner.more-info-cta`, zobrazeno inline v textu těla dual-action privacy modalu. **Otevřená otázka.** |
| `shared-global.cookie-banner.customize-cta` | `Přizpůsobit` | Dual-action privacy modal; otevírá panel předvoleb cookies, který samotný nebyl zachycen (žádný další screenshot). **Otevřená otázka.** |
| `shared-global.cookie-banner.modal-reject-cta` | `Odmítnout` | Sekundární tlačítko dual-action privacy modalu; stejný text klíče jako `shared-global.cookie-banner.reject-cta`, samostatná instance uvnitř karty modalu. **Otevřená otázka.** |
| `shared-global.cookie-banner.modal-accept-all-cta` | `Přijmout vše` | Primární tlačítko dual-action privacy modalu. **Otevřená otázka** — žádné BR neřídí cookie souhlas. |

---

## Banner cookie souhlasu — textové varianty (COMP0004)

Byly přímo pozorovány dvě vizuálně odlišné varianty (`COMP0004` Varianty: `single-action` /
`dual-action`, označeno `Uncertain`, zda jde o jednu parametrizovanou komponentu nebo dva nezávislé
mechanismy — zde neřešeno, pouze restatováno jako pozorovaný text pro každou variantu).

### varianta dual-action (plovoucí karta vlevo dole, pozorováno na záznamu výchozí záložky domovské stránky)

| Klíč | Text | Použití |
|---|---|---|
| `shared-global.cookie-banner.dual.modal-heading` | `Záleží nám na vašem soukromí` | `WIRE0001` (S001, dual-action karta) |
| `shared-global.cookie-banner.dual.modal-body` | `Pomocí cookies vylepšujeme příjemnost prohlížení, nabízíme na míru přizpůsobené reklamy či obsah a analyzujeme návštěvnost stránky. Kliknutím na „Přijmout vše" vyjadřujete souhlas s tím, jak cookies používáme.` | `WIRE0001` (S001, dual-action karta); obsahuje inline odkaz `Více zde.` |

### varianta single-action (tmavý pruh na celou šířku dole, pozorováno na více dalších obrazovkách)

| Klíč | Text | Použití |
|---|---|---|
| `shared-global.cookie-banner.single.body` | `🍪 Tyto stránky používají k poskytování služeb soubory cookie. Používáním tohoto webu s tím souhlasíte. Další informace.` | Potvrzeno na `WIRE0006`, `WIRE0007`, `WIRE0013`, `WIRE0024`, a přímo znovu ověřeno na `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` v tomto průchodu; úvodní glyf emoji cookie je součástí pozorovaného vykreslení |

---

## Konvence mikrotextů (Microcopy)

- Tón: neutrální až vřelý, přímý; popisky nav/footer/CTA používají krátká podstatná jmenná spojení
  nebo rozkazovací tvary sloves ("Požádat o pomoc", "Přijímám", "Odmítnout"); žádný odlišný hlas
  persony nad rámec zbytku veřejného webu.
- Osoba: 2. osoba množného čísla implikovaná v textu cookie souhlasu ("Používáním tohoto webu s tím
  souhlasíte", "vyjadřujete souhlas"); popisky nav/footer jsou neosobní jmenná spojení.
- Velká písmena: v celém textu sentence case; navigační položky jsou krátká spojení pokračující
  malými písmeny po úvodním velkém písmenu ("Jak to funguje", "O nás"); nadpisy sloupců patičky jsou
  titulkovitá jedno/dvouslovná spojení ("Patron dětí", "Kontakt").
- Interpunkce: právní/copyright řádky patičky končí tečkou; navigační odkazy a většina popisků
  tlačítek CTA nenesou koncovou interpunkci; tělo single-action cookie banneru je souvislý text
  celých vět zakončených tečkami, přičemž koncový odkaz "Další informace" je v pozorovaném
  vykreslení sám následován samostatnou tečkou.
- Formátování měny/čísel (číslo sbírkového účtu v patičce, registrační reference) je přepsáno
  verbatim a nepovažuje se za formátovací logiku vlastněnou COPY vrstvou.

---

## Otevřené otázky

- **OQ-COPY-shared-global-1:** Žádný dokument `BRxxxx` ani `UCxxxx` neřídí akce přijmout/odmítnout/
  přizpůsobit v banneru cookie souhlasu ani jejich mechanismus persistence (`COMP0004` Otevřené
  otázky; mezera podle `cross-layer-discipline.md`). Zaznamenáno jako otevřená otázka u každého
  řádku CTA cookie banneru výše, nikoli vymyšleno.
- **OQ-COPY-shared-global-2:** Zda jsou vykreslení `single-action` a `dual-action` cookie banneru
  stejnou parametrizovanou komponentou nebo dvěma nezávisle vybudovanými mechanismy, zůstává
  nevyřešeno (`COMP0004` Otevřené otázky) — obě textové varianty jsou zde přepsány bez tvrzení, které
  obrazovky dostávají kterou variantu nad rámec přímého pozorování.
- **OQ-COPY-shared-global-3:** Cíle odkazů v patičce pro "Pravidla poskytování pomoci" (částečně
  vyřešeno jako PDF), "Naše desatero", "Výroční zprávy", "Jak jsme pomáhali v době koronakrize" a
  "Souhlas se zpracováním osobních údajů" jsou podloženy pouze částečně (`IA-patronus.md` IA-Q8);
  žádné `UCxxxx` není pro tyto cíle tvrzeno nad rámec výše uvedeného.
- **OQ-COPY-shared-global-4:** Položky primární navigace "Jak to funguje", "Blog" a "O nás" nemají
  identifikované vlastnící `UCxxxx` — jde o statickou obsahovou navigaci, mimo číslovanou sadu use
  case rekonstruovanou pro Patronus. Nepovažuje se za mezeru vyžadující vymyšlený text, pouze
  zaznamenáno.

---

## Podklady (Evidence)

| Oblast | Jistota | Podklad |
|---|---|---|
| Logo hlavičky, slogan, navigační odkazy, CTA "Požádat o pomoc", odkaz "Můj účet" (anonymní) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png`; `_ar/evidence/ui/ui-observed-areas.md` §1; `COMP0002` |
| Identické vykreslení hlavičky po autentizaci | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu.png` (přímá inspekce, tento průchod) |
| Textace brandu v patičce, popisek sociálních sítí, atribuce Sirius, registrace sbírky, sloupce odkazů, kontaktní e-mail, platební odznaky, číslo sbírkového účtu, copyright | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (přímá inspekce výřezu, tento průchod); `_ar/evidence/ui/ui-observed-areas.md` §1; `COMP0003` |
| Cookie banner — varianta dual-action (nadpis/tělo modalu, Přizpůsobit/Odmítnout/Přijmout vše) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-2026-07-04-13_15_49.png` (přímá inspekce výřezu, tento průchod); `COMP0004` |
| Cookie banner — varianta single-action (plný text těla) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` (přímá inspekce, tento průchod); `_ar/evidence/ui/ui-observed-areas.md` §6, §16; `COMP0004` |
| Vlastnictví cílů odkazů v patičce (mapování UC/obsahová obrazovka) | Partial / Uncertain | `_ar/spec-draft/IA/IA-patronus.md` IA-Q8; viz Otevřené otázky |
| Vlastnictví akce cookie souhlasu (BR/UC) | Uncertain — nenalezen žádný vlastnící dokument | `COMP0004` Otevřené otázky; viz Otevřené otázky |
