---
doc_id: COPY-synthesis-report
title: COPY Synthesis Report — AR:COPYSynthesizer
canonical_layer: COPY
spec_type: report
scope: all
modules: []
language: cs
status: draft
date: 2026-07-04
references:
  - COPY-shared-global
  - COPY-module-story-donation
  - COPY-module-application
  - COPY-module-auth
  - COPY-module-account
  - COPY-key-index
---

# COPY Synthesis Report — AR:COPYSynthesizer

**Datum: 2026-07-04**

## 1. Použitá pravidla a šablona

Synthesis proběhla podle normativních zdrojů definovaných v
`tooling/orchestration/90-optional-bonus/ux-reconstruction/agents/COPYSynthesizer.md`:

- **Pravidla:** `tooling/docs/rules-COPY.md` — text se transkribuje **verbatim** z pozorovaného UI,
  bez parafráze či vymýšlení; klíče ve formátu `<scope>.<screen-or-component>.<role>`; každá
  validační zpráva odkazuje na vlastnící `BRxxxx`/`ENxxxx`; každé CTA odkazuje na realizované
  `UCxxxx`; nejistý/neimplikovaný text je označen `Assumed`/`Uncertain`, nikoli vydáván za potvrzenou
  kopii; terminologie normalizována dle `_ar/repo-map/glossary.md`.
- **Šablona:** `tooling/templates/template-COPY.md` — struktura Purpose → Labels → Helper Texts →
  Empty States → Loading Texts → Error/Validation Messages → CTAs → Microcopy Conventions →
  Evidence; povinný frontmatter (`doc_id`, `scope`, `modules: []`, `language`, `references`).
- **Cross-layer disciplína:** `tooling/docs/cross-layer-discipline.md` — COPY neobsahuje inline
  atributy entit (EN), obsah business pravidel (BR), logiku obrazovky (WIRE) ani kontrakty komponent
  (COMP); pouze odkazy na `doc_id`.
- Všech pět scope-souborů dodržuje tuto šablonu beze změny struktury; žádné odchylky od šablony
  nebyly zjištěny.

---

## 2. Scopy a počty klíčů

| Scope | Soubor | Klíčů (self-report) | CTA bez UC | Validace bez triggeru | Uncertain/Hypothesis |
|---|---|---:|---:|---:|---:|
| `shared-global` | `_ar/spec-draft/COPY/COPY-shared-global.md` | 38 | 14 | 0 | 4 |
| `module-story-donation` | `_ar/spec-draft/COPY/COPY-module-story-donation.md` | 85 | 10 | 5 | 2 |
| `module-application` | `_ar/spec-draft/COPY/COPY-module-application.md` | 147 | 8 | 6 | 5 |
| `module-auth` | `_ar/spec-draft/COPY/COPY-module-auth.md` | 23 | 2 | 5 | 4 |
| `module-account` | `_ar/spec-draft/COPY/COPY-module-account.md` | 49 | 0 | 10 | 15 |
| **Celkem** | **5 souborů** | **342** | **34** | **26** | **30** |

Poznámka k rekonciliaci: konsolidovaný `COPY-key-index.md` restatuje řádky s reálným `key` (i18n
identifikátorem) a zároveň — pro úplnost — několik neklíčovaných "not observed" placeholder-řádků
(validační/empty/loading mezery bez vlastnícího BR/EN, evidované jako otevřené otázky, ne jako
klíče). Proto se počet řádků v `COPY-key-index.md` mírně liší od výše uvedeného `keyCount`
self-reportu jednotlivých scope-agentů — self-report `keyCount` počítá jen skutečné i18n klíče,
`COPY-key-index.md` přidává i mezery samotné pro dohledatelnost. Žádný klíč nebyl vynalezen ani
duplicitně vytvořen.

Celkem bylo přečteno a indexováno **5 scope-souborů** ve `_ar/spec-draft/COPY/` — pokrývají všechny
scope, které byly této synthesis dodány jako vstup (shared chrome + 4 modulové scope: story/donation,
application, auth, account). Žádný další COPY scope nebyl v této dávce zpracován (např. RISK/FINANCE/
AFFIL back-office plochy nemají UI evidenci ve `_ar/prtsc/**`, a proto zde nemají COPY scope).

---

## 3. Zdroje UI evidence

Primární evidence, na kterou se všech pět dokumentů odkazuje:

- **Screenshoty:** `_ar/prtsc/**` — zejména
  `screencapture-patrondeti-cz-2026-07-04-13_15_49.png` a navazující homepage crops (hero, story
  cards, voucher band), `screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-*.png`
  (detail příběhu + donation modal), `screencapture-patrondeti-cz-dekujeme-*.png` (thank-you +
  resume-draft modal), `screencapture-patrondeti-cz-zadost-zadatel-*.png` a
  `screencapture-patrondeti-cz-zadost-formular-*.png` (kontakt/consent gate + 5-krokový wizard),
  `screencapture-patrondeti-cz-prihlaseni-*.png`,
  `screencapture-patrondeti-cz-aktivovat-ucet-*.png`,
  `screencapture-patrondeti-cz-overit-prihlaseni-*.png`,
  `screencapture-patrondeti-cz-poslat-aktivacni-email-*.png` (auth), a
  `po_prihlaseni_do_uctu*.png` (account settings, tax confirmation, post-login header) plus
  `screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png` (marketingový e-mail mockup,
  Hypothesis-only pro S017 dashboard).
- **`_ar/evidence/ui/ui-observed-areas.md`** §1–§16 — transkribovaný text napříč všemi obrazovkami,
  cross-checkovaný proti přímé inspekci screenshotů v této synthesis.
- **`_ar/spec-draft/WIRE/`** — WIRE0001–WIRE0025 jako primární zdroj vazby text→obrazovka a
  Validation Surfaces / Open Questions sekce.
- **`_ar/spec-draft/COMP/`** — COMP0001 (Primary Button), COMP0002 (Header), COMP0003 (Footer),
  COMP0004 (Cookie Consent), COMP0005 (Wizard Stepper), COMP0006 (Consent Checkbox), COMP0007
  (Upload Dropzone), COMP0008 (Story Card), COMP0009 (Single Email-Entry Form) — pro sdílený text
  opakující se napříč obrazovkami.
- **`_ar/spec-draft/UC/`, `_ar/spec-draft/BR/`, `_ar/spec-draft/EN/`** — pro vazbu CTA→UC a
  validace→BR/EN, kde taková vazba existuje.

---

## 4. Validační zprávy bez BR/EN triggeru (otevřené otázky)

Souhrn napříč scope (26 řádků v self-reportu, viz `COPY-key-index.md` pro plný seznam):

- **shared-global (0):** chrome neobsahuje formulářová pole, žádné validace nevznikají; jediná
  příbuzná mezera je vlastnictví cookie-consent akce (viz §5/§6).
- **module-story-donation (5):** donation modal — částka (neplatná/nenumerická), plně vybraná
  Campaign (fully-funded), povinnost e-mailu, a oba consent checkboxy (souhlas s pravidly / GDPR) —
  žádné z nich nemá vlastnící `BRxxxx`; `BR-DataProtectionAndErasure` pokrývá GDPR zpracování obecně,
  ale ne UI-level gate tohoto checkboxu.
- **module-application (6, s výjimkou 1 potvrzené):** kontakt gate (e-mail/telefon formát,
  consent-checkbox); step 1 (0/500 čítače, povinnost jména dítěte, formát rodného čísla, povinnost
  radio-buttonů); step 2 (0/500 čítač, 0/3 čítač příloh, minimální cena — `EN0002` zmiňuje floor, ale
  ne kde se vynucuje —, povinnost výběru kategorie); step 3 (všechna osobní data); step 4 (jméno/
  příjmení/vztah/e-mail Patrona — mimo jediný pozorovaný `module-application.step4.telefon-mismatch-error`,
  který má potvrzený text, ale žádný vlastnící BR/EN); step 5 (povinnost tří uploadů, referral
  dropdown, tři consent checkboxy).
- **module-auth (5):** e-mail formát/povinnost na S009 a S021, formát hesla a povinnost
  terms-checkboxu na S010, chybějící error-surface na S022 vůbec.
- **module-account (10):** jméno/příjmení/e-mail/foto na S011; jméno/příjmení/rodné číslo/adresa/IČ/
  "Právnická osoba" tab na S012; jediná výjimka s částečnou vazbou je
  `module-account.tax-confirmation.zero-total.error` → `BR-DonationConfirmationAndTax` (server-side
  abort pravidlo existuje, ale jeho on-screen surfacing není potvrzen).

Ve všech případech nebyl vynalezen žádný text ani ID pravidla — mezera je zaznamenána jako Open
Question s odkazem na příslušnou WIRE Validation Surfaces sekci.

---

## 5. CTA bez vlastnícího UC (otevřené otázky)

Souhrn napříč scope (34 řádků, viz `COPY-key-index.md`):

- **shared-global (14):** statická obsahová navigace bez dedikovaného UC — "Jak to funguje", "Blog",
  "O nás" (nav i footer), "Pravidla poskytování pomoci", "Naše desatero", "Splněné příběhy",
  "Výroční zprávy", "Jak jsme pomáhali v době koronakrize", "Souhlas se zpracováním osobních údajů",
  a všechny cookie-banner akce (Přijímám/Odmítnout/Další informace/Více zde./Přizpůsobit/Přijmout
  vše) — žádné BR/UC nevlastní mechanismus cookie-consentu.
- **module-story-donation (10):** hero preset CTA (3× "Daruj … měsíčně"), kategorie-pilulky (Zdravotní
  pomoc, Rozvoj a vzdělání), "Další příběhy" (2×, homepage i detail), "Chci se stát Patronem",
  recurring/voucher/comment-toggle CTA na detailu příběhu (`Assumed` cíle, ne `Confirmed`).
- **module-application (8):** krokové "Pokračovat"/"← Krok zpět" na jednotlivých krocích (kromě
  vstupního a finálního submitu, které mají `UC0001`), exit-modal "Zpět do žádosti" a "Smazat žádost".
- **module-auth (2):** "Přihlaste se pomocí svého hesla." (cílová obrazovka nezachycena) a
  "podmínkami používání uživatelského účtu" (cílový obsah nezachycen).
- **module-account (0):** všechna CTA v tomto scope mají vlastnící UC (`UC0024` nebo `UC0010`).

Žádné UC ID nebylo vynalezeno; kde odkaz chybí, je zaznamenána otevřená otázka s odkazem na
příslušnou WIRE Interactions sekci.

---

## 6. Texty označené Assumed/Uncertain/Hypothesis

- **shared-global:** vztah single-action / dual-action cookie banneru (jedna parametrizovaná
  komponenta vs. dva nezávislé mechanismy) — Uncertain; cílové obrazovky 5 footer odkazů — Partial/
  Uncertain (`IA-patronus.md` IA-Q8).
- **module-story-donation:** downstream cíl hero preset a kategorie-pilulek CTA — Uncertain; recurring/
  voucher/comment-toggle CTA na S002 — Assumed (otevírají modal/flow, cíl nepotvrzen); veškerý obsah
  S005 (voucher purchase) mimo vstupní CTA — Evidence Pending, žádný screenshot neexistuje.
- **module-application:** card copy S006 (role-choice landing) — zcela Evidence Pending, žádný klíč
  nebyl vytvořen; kompletní seznam možností pro dropdowny "vztah k Patronovi" a "referral zdroj" —
  Uncertain, jen jedna hodnota u každého pozorována; vztah mezi dvěma capture na `/zadost/zadatel` —
  nevyřešená WIRE-layer nejasnost.
- **module-auth:** "Bez těchto informací se neobejdeme." — Uncertain, zda jde o standardní
  required-field konvenci nebo již vyvolanou chybu; S022 (`activation-link-sent`) — Uncertain/
  evidence-blocked, oba capture ukazují identický formulář S021, ne vlastní potvrzení; `WIRE0024`
  vlastní *Probable* rating rozporován přímou inspekcí v této COPY vrstvě (zaznamenáno jako
  discrepancy, ne tiše opraveno).
- **module-account:** S017 dashboard-mockup celý blok (`tab-for-you`, `tab-all`, `contribution-banner`,
  `countdown-badge`) — **Hypothesis**, pochází z marketingového e-mailového obrázku, ne z reálné
  zachycené obrazovky; S018 nadpis "Moje zóna" — **Probable** (Drupal View config page-title,
  `EN0034`, vizuální rendering nepotvrzen); S019 a S020 — kompletně Evidence Pending, žádný capture
  neexistuje pro žádnou z těchto dvou obrazovek; dynamický `{year}` token v
  `tax-confirmation.year-checkbox-label` — Uncertain, jen jedna hodnota (2025) pozorována.

Celkem 30 položek self-reportovaných jako `uncertain` napříč scope (viz tabulka §2); žádná z nich
nebyla v této synthesis převedena na potvrzený text bez nové přímé evidence.

---

## 7. Doporučený další krok

1. **Spustit RefIntegrityValidator** (pokud ještě neproběhl po posledním COPY běhu) nad
   `_ar/spec-draft/COPY/**`, aby se ověřilo, že všechny odkazy na `WIRExxxx`/`COMPxxxx`/`UCxxxx`/
   `BRxxxx`/`ENxxxx` existují a jsou konzistentní s `_ar/spec-draft/<LAYER>/_REGISTRY.md`.
2. **Re-run SpecFinalGenerator** pro publikaci UX vrstvy — přenést `_ar/spec-draft/COPY/**` (plus
   `COPY-key-index.md`) do `_ar/spec-final/UX/COPY/` s `_REGISTRY.md`, jako drop-in i18n zdroj pro
   `bid-patron-deti` rebuild, podle `tooling/docs/rules-spec-final.md`.
2a. Před nebo souběžně s tím doporučeno cílené domanipulování evidence pro otevřené mezery s
   nejvyšším dopadem na rebuild: S006 (role-choice landing — chybí úplně), S019/S020 (applicant/
   patron zóny — chybí úplně), "Právnická osoba" tab na S012, a S022 (activation-link-sent) skutečný
   potvrzovací text — bez těchto capture nelze pro odpovídající scope dokončit i18n pokrytí.
3. **BR-layer follow-up** na otevřené validační mezery zaznamenané v §4 — zejména step-level
   required/format pravidla v `module-application` (steps 1–5) a `module-account` (S011/S012), kde
   UI evidence formulářové pole ukazuje, ale žádný BR/EN dokument validaci nevlastní; toto je mimo
   scope COPYSynthesizeru, ale blokuje budoucí doplnění sloupce Trigger v `COPY-key-index.md`.
4. **Cookie-consent mechanismus** (shared-global OQ-COPY-shared-global-1/2) — přiřadit vlastnící BR/UC
   nebo explicitně potvrdit, že jde o čistě klientskou (mimo-doménovou) funkcionalitu, aby CTA řádky
   v `shared-global` mohly být uzavřeny.

---

## Shrnutí

Tato synthesis nekonsolidovala nové UI evidence ani nevytvářela nové COPY scope soubory — pouze
přečetla pět existujících `_ar/spec-draft/COPY/COPY-*.md` souborů (shared-global,
module-story-donation, module-application, module-auth, module-account) a sestavila z nich dva
povinné podpůrné výstupy: konsolidovaný `_ar/spec-draft/COPY-key-index.md` (jednotná tabulka
Key/Text/Usage/Trigger/Certainty přes všech 342 řádků) a tento `_ar/spec-draft/COPY-synthesis-report.md`.
Žádný nový text nebyl vymyšlen; všechny otevřené otázky ze zdrojových dokumentů byly zachovány a
agregovány, ne tiše vyřešeny.
