---
doc_id: WIRE0002
title: Story Detail And Donation Modal
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S002
realizes_uc: [UC0005, UC0011, UC0009]
status: canonical
references:
  - UC0005
  - UC0011
  - UC0009
  - EN0004
  - EN0005
  - EN0006
  - EN0009
  - EN0010
  - EN0013
  - BR-PaymentAndMoneyIntegrity
  - BR-VoucherPolicy
  - BR-CampaignStoryLifecycle
  - BR-RecurringDonationPolicy
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0006
  - COMP0008
  - COMP0010
  - COMP0011
  - COMP0012
  - COMP0013
  - COMP0014
  - COMP0015
  - COMP0016
  - COMP0017
  - COMP0018
  - DESIGN-tokens
  - DESIGN-component-index
---

# WIRE0002 – Detail příběhu a modál daru

## Účel

Veřejná detailní stránka Příběhu (Story) pro jednotlivý Campaign (`EN0004`), kterou vidí
anonymní návštěvník nebo již přihlášený dárce. Prezentuje případ sbírky (dítě, kategorie,
komentář Patrona, cílová/zbývající částka) a je vstupní plochou pro tři záměry související
s darováním, realizované jinde v doménové vrstvě: provedení jednorázového nebo trvalého daru
(`UC0005`), zobrazení veřejného stavu životního cyklu Campaign jako vykresleného průběhu
(`UC0011` — tato obrazovka pouze *zobrazuje* odvozené hodnoty vybráno/procento, které počítá
`UC0011`/`BR-CampaignStoryLifecycle`; neprovádí žádný přechod životního cyklu) a spuštění
uplatnění poukazu ("Mám dobrošek", `UC0009`). Modál daru ("Chystáte se přispět") je sekundární
vrstva otevřená nad touto obrazovkou, která shromažďuje částku, kontakt a souhlasy před předáním
platební bráně (`S-EXT1`, mimo rozsah WIRE).

Aktér: anonymní návštěvník (Customer, dle `UC0005`) nebo přihlášený dárce. U základní stránky
nebyla zjištěna žádná bránu rolí (role gate).

Kontext vstupu: navigace z katalogu na Homepage (`S001`) nebo přímý/sdílený odkaz na Příběh
(`/pribeh/<slug>`); IA `Cross-Module Flows`, krok 1–2.

Jistota: Confirmed — obsah obrazovky i modál byly přímo zaznamenány (viz Evidence).

---

## Rozvržení zón

- **Header** — globální navigace webu (logo "patron dětí", "Jak to funguje", "Blog", "O nás",
  CTA "Požádat o pomoc", "Můj účet") — vlastní IA, zde nerekonstruováno.
- **Titulní pás** — název Příběhu ("Balík školních potřeb pro Sofinku").
- **Mediální zóna** — hero fotka Příběhu (dítě).
- **Karta komentáře Patrona** — štítek "PATRON PŘÍBĚHU", jméno/role Patrona (`EN0005`), avatar,
  přepínač/odkaz "Zobrazit komentář Patrona", text komentáře.
- **Text Příběhu** — dlouhý narativní text (nadpis + odstavce + odrážkový seznam důvěry:
  "100 % daru jde na pomoc dětem", "peníze neposíláme rodinám...", "všechny žádosti pečlivě
  posuzuje naše oddělení risku", "každou žádost potvrzuje Patron").
- **Postranní panel daru (sticky-right)** — v zachyceném snímku stránky se opakuje dvakrát
  (jednou vedle hero fotky, jednou níže vedle textu — viz Otevřená otázka níže):
  - kategorie štítek ("Rozvoj a vzdělání") s ikonou
  - "Přispět můžete na" + popis věcného plnění ("balík školních potřeb; dodává SEVT")
  - ilustrační ikona (batoh)
  - blok průběhu: "Chybí 1 600 Kč" + progress bar + "Zbývá měsíc" / "Cílová částka 1 600 Kč"
  - vstup jednorázové částky ("Chci darovat", Kč, předvyplněno `50`) + CTA "Přispět 🤝"
    (× 2 vrstvené instance zaznamenané — Otevřená otázka)
  - mikrotext "Na pomoc dětem putuje vždy 100 % z darované částky" pod každým CTA
  - blok trvalého daru: "Přeji si podporovat rozvoj a vzdělání pravidelně" + CTA "Chci podporovat
    rozvoj a vzdělání" (zelené)
  - blok poukazu: CTA "Mám dobrošek" (červené, ikona lístku) + odkaz "Chcete věnovat dobrošek?"
  - řádek sdílení: ikony Facebook / X / Instagram / LinkedIn / WhatsApp / Messenger
- **Banner důvěry (full-width)** — červený pás, "Na pomoc dětem putuje vždy 100 % částky, kterou
  darujete."
- **Panel souvisejících příběhů** — "Aktuálně čekají na vaši pomoc" + 3 karty (fotka, badge
  odpočtu "ZBÝVÁ MĚSÍC"/"ZBÝVÁ 16 DNÍ", páska "Chybí N Kč", jméno+přání, "Cílová částka N Kč",
  CTA "Podpořím <jméno>") + odkaz "Další příběhy".
- **Modál daru (overlay, při primární akci)** — zpětný odkaz "Zpět na příběh", nadpis "Chystáte se
  přispět" + pole částky (Kč), kontaktní pole (E-mail, +420 telefon, Jméno, Příjmení), dva
  zaškrtávací souhlasy, CTA "Přejít k platbě", nápovědný text "Po přesměrování na platební
  bránu...".
- **Footer** — globální patička webu — vlastní IA, zde nerekonstruováno.

```
+--------------------------------------------------------------+
| Header (IA)                                                    |
+--------------------------------------------------------------+
| Story title                                                    |
+---------------------------------+----------------------------+
| Media (hero photo)              | category tag                |
| Patron comment card             | "Přispět můžete na" + icon  |
|                                  | progress + "Chci darovat"   |
|                                  | + "Přispět" CTA              |
|                                  | recurring CTA                |
|                                  | "Mám dobrošek" CTA           |
|                                  | share row                    |
+---------------------------------+----------------------------+
| Story body text                 | (sidebar repeats — Open Q)  |
+---------------------------------+----------------------------+
| Trust banner (full-width)                                      |
+--------------------------------------------------------------+
| Related stories rail (3 cards)                                  |
+--------------------------------------------------------------+
| Footer (IA)                                                     |
+--------------------------------------------------------------+

Donation modal (overlay):
+----------------------------------------+
| < Zpět na příběh   Chystáte se přispět  [50 Kč] |
+----------------------------------------+
| E-mail (povinný)                        |
| +420 | Telefon                          |
| Jméno            | Příjmení              |
| [ ] Souhlasím s pravidly...              |
| [ ] Souhlasím se zpracováním...          |
|          [ Přejít k platbě ]             |
| helper: gateway method note              |
+----------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP agentem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označeny jako `inline` (buď nebyl prokázán reuse na ≥2
obrazovkách, nebo je reuse Uncertain — viz poznámky).

> **Poznámka k referencím COMP0010–COMP0018 níže.** Jde o **kanonická `@patron/ui` / TARGET**
> doc_id přiřazená v `DESIGN-component-index.md` (S002 je jediná obrazovka s kanonickým
> redesignem — viz `_ar/evidence/design-system/design-canon.md` §4/§7). Jejich citace zde
> zaznamenává, *které kanonické komponentě odpovídá zóna aktuálního stavu pro účely
> traceability*; **neznamená**, že zóna aktuálního stavu skutečně implementuje cílový kontrakt
> dané komponenty (props/varianty/stavy/tokeny). Vlastní sekce "Current-state (observed)" každé
> citované COMP nese skutečné rozdíly mezi aktuálním stavem a cílem — viz také nová sekce
> "Design-system alignment" níže pro souhrn kompozice/rozdílů na úrovni S002.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header (reuse v aktuálním stavu); také target `SiteHeader` dle `DESIGN-component-index.md` řádek 14 |
| Titulní pás | inline | h1 | název Příběhu; cílová kanonizace to kompozuje jako zjednodušený header — breadcrumb + full-width H1, bez pillů (viz tabulka rozdílů níže) |
| Mediální zóna | COMP0011 | fotka (bez galerie/karuselu) | fotka aktuálního stavu; cílová kanonizace = `StoryHero` (`DESIGN-component-index.md` řádek 9) — fotka + rohový `CategoryChip`, monogram na výplni jako fallback bez fotky (v aktuálním stavu nezaznamenáno) |
| Karta komentáře Patrona | COMP0012 | avatar + jméno + role + přepínač + text | váže `EN0005`; cílová kanonizace = `PatronCard` (řádek 10) — samostatný testimonial pilíř, komentář **je vždy viditelný** (bez přepínače) — viz tabulka rozdílů (aktuální stav má přepínač "Zobrazit komentář Patrona", cíl nikoliv) |
| Text Příběhu | inline | blok obohaceného textu | dlouhý narativní text + odrážkový seznam; cílová kanonizace to vykresluje jako `prose` (WYSIWYG) pod `PatronCard`, bez dedikované COMP |
| Kategorie štítek ("Rozvoj a vzdělání") | COMP0018 | ikona + label | fialový pill v breadcrumbu v aktuálním stavu; cílová kanonizace = `CategoryChip` (řádek 5) — jeden jednotný chip (ikona+barva), stejná oblast = stejná barva napříč chipem/podkladem karty/monogramem (viz tabulka rozdílů — aktuální stav používá dvě různá zpracování badge) |
| Blok průběhu | COMP0016 | label + progress bar + dvouřádková statistika (Zbývá / Cílová částka) | váže odvozená pole `EN0004` (viz Datové vazby); Uncertain, zda sdílí komponentu s vnitřními čísly průběhu `COMP0008` Story Card — nepotvrzeno jako identické, zde ponecháno inline pro tento cross-reference; cílová kanonizace `ProgressBar` (řádek 6) je kompozována uvnitř `DonationBox` |
| Text zbývajícího času ("Zbývá měsíc") | COMP0017 | klidný/naléhavý | aktuální stav to vykresluje jako běžný text blízko statistiky průběhu, nikoliv jako pill; cílová kanonizace = `TimeLeftPill` (řádek 6) — pill *uvnitř* boxu, naléhavý stav = plný alert-badge s pulsem (viz tabulka rozdílů) |
| Vstup částky | COMP0010 | číselné pole, přípona Kč, předvyplněno `50` | dvě vrstvené instance v evidenci (Otevřená otázka); cílová kanonizace = `DonationBox` (řádek 13, dokument `COMP0010_DonationBox.md`) — pevné čisté presety (500/1000/2000 Kč) + přepínač "Jiná" pro vlastní částku, nikoliv jediné předvyplněné pole (viz tabulka rozdílů) |
| Primární CTA daru ("Přispět 🤝") | COMP0001 | icon=🤝 | viz `COMP0001` Primary Button (reuse v aktuálním stavu); v cílové kanonizaci je toto CTA kompozovaným `Button` komponenty `DonationBox` (primary/block, ikona `give`) volajícím `onDonate(amount)` — kontrakt tam končí, modál je samostatný budoucí blok (viz tabulka rozdílů) |
| CTA trvalého daru ("Chci podporovat... pravidelně") | COMP0014 | secondary/zelené tlačítko | příznak záměru do `UC0005` (větev trvalého daru); samostatná obrazovka trvalého daru zde nezaznamenána; vizuální identita Uncertain vůči `COMP0001` (aktuální stav); cílová kanonizace = `RailCta` (řádek 11, výchozí varianta) — lehčí rail karta pod `DonationBox`, nikoliv tlačítko vedle něj (viz tabulka rozdílů) |
| CTA poukazu ("Mám dobrošek") | COMP0014 | secondary/červené tlačítko, ikona lístku | vstupní bod do `UC0009` — cílová obrazovka nezachycena (IA `S005`, Uncertain); cílová kanonizace = `RailCta` (řádek 11, varianta **promo**, pouze CZ, celá karta je odkaz na `/dobroseky`) — samotné uplatnění "Mám dobrošek" zůstává v kánonu uvnitř `DonationBox` (viz tabulka rozdílů) |
| Řádek sdílení | COMP0015 | řádek ikonových tlačítek | Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger — žádné sdílecí chování mimo přítomnost ikon nebylo zaznamenáno; cílová kanonizace = `ShareRow` (řádek 12) — kompaktní monochromatický řádek ikon, 7 platforem (přidává E-mail k 6 z aktuálního stavu), při hoveru přebírá barvu tenantu |
| Karta souvisejícího příběhu | COMP0008 | fotka + badge odpočtu + páska průběhu + jméno + cílová částka + CTA | opakuje vzor karty z katalogu na `S001`; vizuálně blízké `COMP0008` Story Card, ale vykresleno v layoutu postranního panelu "souvisejících" příběhů, nepotvrzeno jako identické (poznámka k aktuálnímu stavu zachována); cílová kanonizace kompozuje přesně `StoryCard` (řádek 8) ×3 pod "Další děti čekají na pomoc", s zástupným symbolem monogram na klidném povrchu (nikoliv mesh) bez fotky |
| Skořápka modálu daru | inline | overlay/dialog, header + zavřít/zpět | otevírá se primárním CTA; cílová kanonizace explicitně vyřazuje modál daru **mimo** kontrakt stránky `StoryDetail`/`DonationBox` ("Mimo scope" — budoucí blok); viz tabulka rozdílů |
| Pole částky v modálu | inline | číselné pole, přípona Kč, předvyplněno `50`, editovatelné v headeru modálu | váže částku daru; bez kanonického protějšku (modál je pro kánon mimo rozsah, viz výše) |
| Kontaktní pole v modálu | inline | E-mail (povinný), telefon (předpona +420), Jméno, Příjmení | váže `EN0006`/`EN0008` (viz Datové vazby); bez kanonického protějšku |
| Zaškrtávací souhlasy v modálu (×2) | COMP0006 | count-per-form=double | brána pro odeslání `UC0005` (Otevřená otázka — nenalezen žádný BR, viz Validační plochy); viz `COMP0006` Consent Checkbox; `DESIGN-component-index.md` §3 označuje tuto komponentu jako **bez kanonického protějšku** — jejím zamýšleným budoucím místem je odložený blok modálu daru |
| Primární CTA v modálu ("Přejít k platbě") | COMP0001 | — | odesílá `UC0005`, předává řízení `S-EXT1`; viz `COMP0001` Primary Button |
| Nápovědný text modálu | inline | statický mikrotext | popisuje navazující výběr brány; není obsah editovatelný v aplikaci, vlastní COPY |

---

## Design-system alignment (target — kánon S002)

> **Poznámka k disciplíně.** S002 (tato obrazovka) je **jediná** rekonstruovaná obrazovka
> s kanonickým redesignem — dle `_ar/evidence/design-system/design-canon.md` §4/§7 epik E0001
> (`Done`) rebuildu povýšil právě jednu kompozici stránky, "Detail příběhu" (`packages/ui/src/
> pages/StoryDetail/`), na kánon. Vše v této sekci je **TARGET stav** (`@patron/ui` +
> `@patron/tokens`), zdrojováno z `DESIGN-component-index.md` a `design-canon.md` §4. Tato sekce
> **nepopisuje, neopravuje ani nenahrazuje** rekonstrukci aktuálního stavu výše (Rozvržení zón /
> Interakce / Stavy / Datové vazby), která zůstává věrným záznamem živé stránky `patrondeti.cz`.
> Kde se obě verze liší, jsou zaznamenány obě — viz tabulka rozdílů v §2 — dle pravidla
> aktuální-vs-cílový stav z projektové konstituce.

### 1. Kanonická kompozice

Zdroj: `DESIGN-component-index.md`, řádek "StoryDetail (Page)"; `design-canon.md` §4.2.

```
SiteHeader (COMP0002)                          — brandmark, nav, login, "Požádat o pomoc"
← breadcrumb ("Všechny příběhy")
H1 — story title (full width, display type)
┌───────────────────────────────────┬───────────────────────┐
│ StoryHero (COMP0011)              │ DonationBox (COMP0010) │  right rail, sticky
│  photo + corner CategoryChip (COMP0018) │ RailCta (COMP0014, recurring)
│ lede (plain paragraph)            │ RailCta (COMP0014, promo — dobrošek, CZ-only)
│ PatronCard (COMP0012)             │ ShareRow (COMP0015)
│  testimonial + seal, comment always visible │
│ prose (WYSIWYG)                   │
└───────────────────────────────────┴───────────────────────┘
PledgeStrip (COMP0013)                         — 100% pledge + vendor, full-width divider
"Další děti čekají na pomoc" — 3× StoryCard (COMP0008)
SiteFooter (COMP0003)
[mobile sticky CTA bar — missing amount + "Přispět"]   (≤900px; hidden when funded)
```

Layout grid `minmax(0, 1.55fr) minmax(300px, 0.95fr)`; kontejner = `var(--layout-container)`
(1200px). Stavy obrazovky odrážejí `DonationBox` (`COMP0010`): **probíhá/live** (výchozí),
**naléhavé/urgent** (`TimeLeftPill`/`COMP0017` → plný alert-badge, jemný puls), **vybráno/funded**
(formulář nahrazen poděkováním; mobilní CTA lišta skryta). `PledgeStrip` (`COMP0013`) je přítomen
ve **všech** stavech — záruka nikdy nezmizí (kritérium přijetí, `design-canon.md` §4.4).

### 2. Rozdíly mezi aktuálním stavem a cílem (S002)

| Aspekt | Aktuální stav S002 (zaznamenáno, tento dokument) | Cílová kanonizace (`DESIGN-component-index.md` / `design-canon.md` §4.5) | Stav |
|---|---|---|---|
| Vstup pro darování | Inline modál daru (částka + kontakt + souhlasy) otevíraný kliknutím na "Přispět 🤝", dle Interakce #2–#3 | Kontrakt `DonationBox` (`COMP0010`) končí u `onDonate(amount)`; modál je označen jako **samostatný budoucí blok**, explicitně "Mimo scope" pro kanonickou stránku | Obě verze odkládají modál, ale z jiných důvodů — modál aktuálního stavu je již živý a zachycený, cílový modál ještě není postaven |
| Zadání částky daru | Jediné číselné pole ("Chci darovat"), předvyplněno `50` Kč, bez viditelných presetů; dvě vrstvené instance (WIRE0002-Q1) | Pevné **čisté** presety (500/1000/2000 Kč; RO 100/300/500 lei) + přepínač "Jiná" pro vlastní částku + rychlé doplnění do zbývající částky; "částka odpovídá kapacitě dárce, ne velikosti cíle" jako explicitní produktová pravda | Rozdíl — presety nejsou prokázány jako aktuálně živé |
| Kategorie štítek | Zaznamenána dvě zpracování: fialový pill v oblasti breadcrumbu + odlišný badge na kartách souvisejících příběhů | **Jeden jednotný `CategoryChip`** (`COMP0018`) — ikona + barva, stejná oblast = stejná barva napříč chipem / podkladem karty / monogramem | Rozdíl — aktuální stav používá nekonzistentní zpracování badge; cíl unifikuje |
| Slib 100 % / dodavatel | Přítomno jako full-width červený banner důvěry ("Na pomoc dětem putuje vždy 100 % částky, kterou darujete.") | Povýšeno na `PledgeStrip` (`COMP0013`) — výrazný full-width oddělovač před "Další děti", nese slib **+ dodavatele** (v 1. pádu, strojově doplnitelné); přítomen v každém stavu `DonationBox` | V cíli povýšeno/formalizováno — chování s uvedením dodavatele je cílový doplněk, nepotvrzený v textu aktuálního banneru |
| Patron | Karta "PATRON PŘÍBĚHU" s přepínačem/odkazem "Zobrazit komentář Patrona" (chování rozbalení Uncertain, WIRE0002-Q6) | `PatronCard` (`COMP0012`) — samostatný testimonial pilíř, větší avatar, **komentář vždy viditelný, bez přepínače** | Rozdíl — cíl přepínač zcela odstraňuje (invariant transparentnosti) |
| Naléhavost / zbývající čas | Běžný text blízko statistiky průběhu ("Zbývá měsíc"); žádné zaznamenané naléhavé/alert vizuální zpracování | `TimeLeftPill` (`COMP0017`) uvnitř boxu; naléhavý stav = plný alert-badge, vlastní token `color.urgent` (odpojený od brandu), jemný puls (vypnutý při reduced-motion) | Mezera — existence naléhavého vykreslení v aktuálním stavu je Uncertain, nikoliv potvrzeně nepřítomná |
| Poukaz (dobrošek) | CTA "Mám dobrošek" (červené, ikona lístku) vedle boxu; samostatný vstup "Koupím dobrošek" mapuje na `S005` | Uplatnění zůstává **uvnitř** `DonationBox`; samostatná **promo `RailCta`** (`COMP0014`, pouze CZ, celá karta odkazuje na `/dobroseky`) je umístěna pod boxem; RO **nemá** promo dobrošku (otevřená otázka) | Rozdíl — aktuální stav vykresluje poukaz jako samostatné červené CTA; cíl rozděluje uplatnění (v boxu) vs. promo (rail karta) |
| Trvalý dar | "Chci podporovat rozvoj a vzdělání pravidelně" (zelené tlačítko) vedle boxu | `RailCta` (`COMP0014`, výchozí varianta) — lehčí rail karta pod `DonationBox`, odkazující na sběrný účet kategorie daného příběhu (`kategorie=education`) | Rozdíl — aktuální stav je tlačítko na stejné úrovni; cíl ho snižuje na sekundární rail kartu |
| Header / navigace | Aktuální CZ navigace ("Jak to funguje", "Blog", "O nás") + login → účet, bez změny stylu breadcrumbu | Zjednodušený `SiteHeader` (cílový kontrakt `COMP0002`) — pouze breadcrumb + full-width H1; bez pillů v headeru | Rozdíl — liší se vizuální váha/kompozice; identita komponenty (COMP0002) je sdílená |
| Zástupný obrázek | V evidenci pozorovány pouze reálné fotky; případ chybějící fotky nezachycen | Zástupný symbol monogram na klidném povrchu (nikoliv mesh gradient) bez fotky, u obou `StoryHero` (`COMP0011`) i `StoryCard` (`COMP0008`) | Mezera — zpracování chybějící fotky v aktuálním stavu je Uncertain, neprokázáno ani jedním směrem |
| Multi-tenant (CZ/RO) | Žádná instance RO nezaznamenána ve snímcích aktuálního stavu; zdroj Patronus dle projektového kontextu pokrývá CZ/RO/MD, ale evidence tohoto WIRE je pouze CZ | Kánon provozuje oba tenanty z **jedné sady komponent** přes `data-theme="cz\|ro"` (`DESIGN-tokens.md` §11); RO = kotva KidsHero, turquoise/navy; **realita nasazení: pouze CZ běží živě, RO je demo theming ve Storybooku, nikoliv druhá nasazená instance** (`design-canon.md` §5) | Nejde o srovnání jedna ku jedné — cílové RO je demo, nikoliv živý fakt aktuálního stavu; neinterpretovat jako důkaz živého webu RO |
| Duplicitní postranní panel | Postranní panel (průběh/CTA/sdílení) se v zachyceném snímku celé stránky objevuje **dvakrát** (WIRE0002-Q1) — pravděpodobně artefakt šablony/layoutu | Jedna instance `DonationBox`, umístěná jednou ve sticky panelu — v kánonu neexistuje koncept duplicitního vykreslení | Rozdíl — jednoblokový model cíle může vysvětlit/vyřešit duplicitu aktuálního stavu, ale toto je `Hypothesis — Not evidenced in current sources`, nikoliv potvrzeno |

**Výchozí důvěra (dle `CLAUDE.md`):** pro aktuální chování má přednost vlastní rekonstrukce
tohoto WIRE (kód / snímky obrazovky) — výše uvedený kánon ji nepřepisuje. Pro to, co se má
postavit, je kánon cílem, na stejné úrovni autority jako `it-zadani`. Obě verze jsou zaznamenány
vedle sebe, nikdy sloučeny.

### 3. Není součástí kanonické stránky (explicitně mimo rozsah)

Dle `StoryDetail.contract.md` "Mimo scope" (`design-canon.md` §4.5): **modál** daru (e-mail/
souhlasy/mock platba), podrobný krokový vysvětlovač "donation chain" a dostupnost reálných dat
o počtu dárců jsou všechny označeny jako **budoucí** bloky, nikoliv součást dnešní kanonické
stránky. Modál aktuálního stavu popsaný v Interakcích #2–#3 a v Rozvržení zón tohoto WIRE
**nemá zatím kanonický protějšek** — mlčení kánonu k modálu nelze číst jako důkaz, že by modál
aktuálního stavu měl být odstraněn nebo zjednodušen; jednoduše ještě nebyl navržen.

---

## Interakce

1. **Vstup** — navigace z karty katalogu `S001` nebo přímého odkazu `/pribeh/<slug>` → stav:
   `default`.
2. **Primární akce — otevření modálu daru** — kliknutí na "Přispět 🤝" (kterákoli instance
   v postranním panelu) → otevře se modální overlay předvyplněný částkou zadanou ve spouštěcím
   poli "Chci darovat" (zaznamenaná výchozí hodnota `50` Kč přenesená do pole v headeru modálu);
   realizuje vstup do `UC0005`; dále: stav `default` modálu.
3. **Primární akce — odeslání daru** — vyplnění/potvrzení polí modálu, zaškrtnutí obou souhlasů,
   kliknutí na "Přejít k platbě" → realizuje `UC0005` (hlavní tok UC0005.1–UC0005.3); dále:
   přesměrování na `S-EXT1` (hostovaná brána Comgate, mimo rozsah WIRE) při úspěchu, nebo inline
   validační plocha při neúspěchu (viz Stavy → error, Validační plochy).
4. **Sekundární akce — záměr trvalého daru** — kliknutí na "Chci podporovat rozvoj a vzdělání" →
   Assumed otevření stejného nebo rovnocenného modálu daru s nastaveným příznakem trvalého daru
   (`UC0005.2`); specifická afordance modálu pro trvalý dar (např. přepínač) **není zaznamenána**
   na zachycených snímcích modálu — Uncertain (Otevřená otázka).
5. **Sekundární akce — vstup do uplatnění poukazu** — kliknutí na "Mám dobrošek" / "Chcete
   věnovat dobrošek?" → Assumed otevření plochy pro zadání kódu poukazu napájející `UC0009`;
   **cílová plocha nezachycena** na této obrazovce (IA `S005`/vstup poukazu, Uncertain) —
   Otevřená otázka.
6. **Sekundární akce — čtení komentáře Patrona** — kliknutí na "Zobrazit komentář Patrona" →
   Assumed chování rozbalení/scroll-to (štítek přepínače zaznamenán; rozbalený i sbalený stav
   nejsou zachyceny oba) — Uncertain.
7. **Sekundární akce — CTA podpory kategorie** — "Chci podporovat rozvoj a vzdělání" slouží
   zároveň jako vstup podpory na úrovni kategorie dle řádku účelu IA S002; stejný cíl jako CTA
   trvalého daru dle evidence (žádný samostatný tok pouze pro kategorii nezaznamenán) — Assumed.
8. **Sekundární akce — navigace na související příběh** — kliknutí na CTA souvisejícího příběhu
   ("Podpořím Románka"/"Petrušku"/"Miu") → navigace na vlastní instanci `S002` daného Příběhu
   (jiný `/pribeh/<slug>`); kliknutí na "Další příběhy" → Assumed návrat na katalog `S001`.
9. **Výstup — zrušení modálu** — kliknutí na "Zpět na příběh" → zavře modál, návrat do stavu
   `default` této obrazovky, žádná změna stavu `EN0009`.
10. **Výstup — úspěšné odeslání** — viz interakce 3; přesměrování mimo obrazovku na `S-EXT1` →
    `S-EXT2` → `S003` (dle IA Cross-Module Flow "Donation & payment flow").

---

## Stavy

### default
Detailní stránka Příběhu tak, jak byla zachycena: hero fotka, karta komentáře Patrona, text,
postranní panel s průběhem/CTA, banner důvěry, panel souvisejících příběhů. Confirmed —
`screencapture-...-13_25_48.png`.

### empty
Nezaznamenáno. Nebylo zachyceno žádné zpracování "Příběh odstraněn / plně vybrán / nenalezen".
Vzhledem k `UC0005` AF2 ("Campaign missing or already fully funded" odmítne dar, ale nepopisuje
vykreslení stránky Příběhu pro již plně vybraný nebo vyřazený Příběh), je zpracování prázdného/
uzavřeného stavu na úrovni stránky Uncertain — Otevřená otázka, zde nevymýšlené.

### loading
Nezaznamenáno. Nebyl zachycen žádný spinner/skeleton stav ani pro stránku, ani pro modál (např.
během odesílání požadavku o předání bráně při "Přejít k platbě" v `UC0005.3`). Assumed, že
existuje (síťový round-trip je nutný před přesměrováním na bránu), ale jeho vizuální zpracování
je Uncertain — Otevřená otázka.

### error
Nezaznamenáno jako vykreslený UI stav. `UC0005` AF1 (neplatná/nenumerická částka) a AF2 (Campaign
chybí nebo je plně vybrán) definují *výsledky* odmítnutí, ale žádný snímek nezobrazuje inline
chybovou zprávu, toast nebo stylování chyby na úrovni pole na této obrazovce nebo v jejím modálu.
Deklarováno dle disciplíny WIRE, nikoliv vymyšleno — Uncertain — Otevřená otázka (viz Validační
plochy).

---

## Validační plochy

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| Pole částky v modálu | `UC0005` AF1 (částka musí být numerická) — žádný BR toto pravidlo nevlastní | Uncertain — žádná chybová plocha nezaznamenána; uvedeno v Otevřených otázkách (žádné BR id k dispozici, nevymyšleno) |
| Pole částky v modálu vs. financování Campaign | `UC0005` AF2 / `BR-PaymentAndMoneyIntegrity` ("odmítnout dar odeslaný proti Campaign, jehož běžící vybraná celková částka již dosahuje nebo přesahuje jeho cílovou částku") | Uncertain — žádná chybová plocha na této obrazovce nezaznamenána |
| Pole "E-mail (povinný)" v modálu | Označeno jako povinné v textu ("povinný"); žádný BR upravující formát/povinnou validaci e-mailu na této obrazovce nenalezen | Uncertain — žádné BR id; otevřená otázka |
| Zaškrtávací souhlas 1 v modálu ("Souhlasím s pravidly poskytování pomoci") | Žádný BR podmiňující odeslání tímto zaškrtávacím polem nenalezen | Uncertain — žádné BR id; otevřená otázka |
| Zaškrtávací souhlas 2 v modálu ("Souhlasím se zpracováním osobních údajů") | Žádný BR podmiňující odeslání tímto zaškrtávacím polem nenalezen; `BR-DataProtectionAndErasure` upravuje GDPR výmaz/zpracování obecně, ale nespecifikuje tuto UI úroveň brány souhlasu | Uncertain — žádné BR id; otevřená otázka |

**validationsWithoutBR:** kontrola numerického formátu částky v modálu, kontrola povinnosti
e-mailu, oba zaškrtávací souhlasy — žádný z nich nemá řídící `BRxxxx` ve stávající vrstvě BR;
jde o viditelné afordance formuláře na snímku obrazovky, ale vynucující pravidlo (pokud nějaké
existuje nad rámec textu `UC0005`) není samostatně kodifikováno. Zaznamenáno jako Otevřené otázky
místo vymýšlení BR id.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Titulní pás | `EN0004` | — | veřejný název Campaign |
| Mediální zóna | `EN0004` | — | obrazový materiál Campaign (atribut povinného obrazového materiálu, dle `BR-CampaignStoryLifecycle`) |
| Kategorie štítek ("Rozvoj a vzdělání") | `EN0004` | — | atribut `gift_category` |
| Popis věcného plnění ("balík školních potřeb; dodává SEVT") | `EN0004` | — | volný text popisu případu; přesný vlastnící atribut nepotvrzen — Uncertain |
| Karta komentáře Patrona | `EN0005` | — | jméno/fotka Patrona (atributy `EN0005`); vlastnictví textu komentáře (Patron vs. narativ Žádosti) nepotvrzeno — Uncertain |
| Blok průběhu ("Chybí 1 600 Kč", progress bar, "Zbývá měsíc", "Cílová částka") | `EN0004` | — | odvozené `campaign_raised` / `campaign_percentual_raised` vs. `gift_price` (cíl) a `campaign_deadline`, dle `BR-CampaignStoryLifecycle`; tato obrazovka pouze vykresluje odvozené hodnoty, nepočítá je |
| Pole částky v modálu | `EN0009` | — | při odeslání se stává `Transaction.amount` (`UC0005.1`, krok 10) |
| E-mail / Jméno / Příjmení / telefon v modálu | `EN0006`, `EN0008` | — | řeší/vytváří dárcova `User` (`EN0008`) a navázaný `Contact` (`EN0006`) dle `UC0005.1` kroky 4–7 |
| Záměr CTA trvalého daru | `EN0010` | — | při požadavku na trvalý dar se vytvoří `RecurringTransaction` dle `UC0005.2` |
| Vstup "Mám dobrošek" | `EN0013` | — | napájí `UC0009` uplatnění poukazu; samotná plocha uplatnění je mimo zachycený rozsah této obrazovky |
| Karty souvisejících příběhů | `EN0004` | — | každá karta je jiná instance Campaign (vlastní pole průběhu/cíle) |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (ACL nebo BR ref) | Chování při skrytí |
|---|---|---|
| CTA trvalého daru ("...pravidelně") | Vrstva ACL ještě neexistuje; žádná bránu rolí nezaznamenána — v evidenci viditelné anonymním návštěvníkům | n/a — Confirmed vždy viditelné v zachycené evidenci |
| CTA poukazu / "Mám dobrošek" | Vrstva ACL ještě neexistuje; žádná bránu rolí nezaznamenána | n/a — Confirmed vždy viditelné v zachycené evidenci |
| Předvyplnění kontaktních polí modálu (E-mail/Jméno/Příjmení/telefon) | V evidenci zaznamenáno předvyplněné testovacími daty (`screencapture-...-13_26_21.png`), když prohlížeč/relace již obsahovala data pro automatické vyplnění; zda **přihlášený** dárce vidí tato pole předvyplněná ze svého záznamu `User`/`Contact` (vs. autofill prohlížeče) není z této evidence rozlišitelné — Uncertain, Otevřená otázka | pole by zřejmě byla prázdná pro prvně příchozího anonymního návštěvníka — Assumed, přímo nepozorováno |
| Duplicitní blok postranního panelu (průběh/CTA/sdílení, objevující se dvakrát v zachyceném snímku celé stránky) | Neřešeno podmínkou ACL/BR — pravděpodobně artefakt šablony/layoutu dvoukolonového reflow, nikoliv funkce podmíněná rolí či stavem | Uncertain — Otevřená otázka, nevymýšleno jako záměrné |

---

## Poznámky k přístupnosti

- **Pořadí tabulace:** Assumed sleduje vizuální pořadí (média → odkaz karty Patrona → text →
  vstup částky v postranním panelu → tlačítka CTA → ikony sdílení); nelze ověřit ze statických
  snímků obrazovky — Uncertain.
- **Focus při vstupu:** Nezaznamenáno; Assumed výchozí focus prohlížeče (vrchol dokumentu) při
  načtení stránky.
- **Focus při přechodu stavu (otevření modálu):** Nezaznamenáno, zda se focus přesune do modálu
  (např. na pole částky nebo na odkaz zavřít/zpět) při kliknutí na "Přispět" — Uncertain,
  Otevřená otázka; chování WCAG focus-trap dialogu nelze ze snímků obrazovky potvrdit.
- **Landmarky:** Ze snímků obrazovky neprokázáno (v tomto průchodu neproběhla inspekce DOM/ARIA);
  Uncertain.
- **Klávesové zkratky:** Žádné nezaznamenány; žádné zkratky specifické pro tuto obrazovku
  neprokázány.

---

## Otevřené otázky

| # | Otázka | Dopad | Stav |
|---|---|---|---|
| WIRE0002-Q1 | Proč se postranní panel daru (průběh + CTA + řádek sdílení) v zachyceném snímku celé stránky zdá opakovat dvakrát — artefakt dvoukolonového reflow, nebo dva skutečně odlišné bloky (např. sticky vs. statická kopie)? | Ovlivňuje duplicitu Rozvržení zón / Použité komponenty | open |
| WIRE0002-Q2 | Otevírá CTA "Chci podporovat rozvoj a vzdělání" (trvalý dar) stejný modál daru s příznakem trvalého daru, nebo odlišný modál/obrazovku? | Ovlivňuje Interakce #4, vazbu na `UC0005.2` | open |
| WIRE0002-Q3 | Na co naviguje "Mám dobrošek" / "Chcete věnovat dobrošek?" — existuje dedikovaná plocha pro uplatnění poukazu a je totožná s nezachycenou obrazovkou nákupu poukazu `S005`? | Ovlivňuje Interakce #5, vazbu vstupu do `UC0009` | open (cross-ref IA-Q10) |
| WIRE0002-Q4 | Existuje jakákoli inline validace pro neplatnou částku, chybějící e-mail, nezaškrtnuté souhlasy nebo plně vybranou Campaign — nebo se stávající implementace spoléhá výhradně na odmítnutí bránou/back-endem bez chybového stavu viditelného klientovi? | Ovlivňuje Stavy → error, Validační plochy | open |
| WIRE0002-Q5 | Existuje indikátor načítání mezi "Přejít k platbě" a přesměrováním na `S-EXT1`? | Ovlivňuje Stavy → loading | open |
| WIRE0002-Q6 | Rozbaluje "Zobrazit komentář Patrona" obsah, nebo odkazuje jinam? | Ovlivňuje Interakce #6 | open |

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Rozvržení celé stránky (titulek, média, karta Patrona, text, postranní panel, banner důvěry, panel souvisejících příběhů) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_25_48.png`; `ui-observed-areas.md` §2 |
| Modál daru — prázdná/výchozí kontaktní pole, částka `50` Kč, nezaškrtnuté souhlasy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_08.png` |
| Modál daru — vyplněná kontaktní pole (autofill/testovací data), zaškrtnuté souhlasy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png`; `ui-observed-areas.md` §2 |
| Vykreslení průběhu/cílové částky se váže na odvozená pole `EN0004`/`BR-CampaignStoryLifecycle` | Probable | `_ar/spec-draft/EN/EN0004_Campaign.md`; `_ar/spec-draft/BR/BR-CampaignStoryLifecycle.md` |
| Tok odeslání daru (`UC0005`) mapuje pole na `EN0009`/`EN0006`/`EN0008` | Confirmed | `_ar/spec-draft/UC/UC0005_MakeADonation.md` |
| Vstup poukazu mapuje na `UC0009`/`EN0013` | Probable | `_ar/spec-draft/UC/UC0009_RedeemValidateVoucher.md`; vstupní CTA zaznamenáno, ale cílová obrazovka nezachycena |
| Relevance `UC0011` (zobrazený průběh je počítán v UC0011, nikoliv obrazovkou) | Confirmed (jako nevlastnící reference) | `_ar/spec-draft/UC/UC0011_ManageCampaignStoryLifecycle.md` |
| Stavy empty/loading/error, správa focusu, duplicitní postranní panel, cílové plochy trvalého daru/poukazu | Uncertain | nezachyceno v žádném snímku obrazovky — viz Otevřené otázky |
</content>
