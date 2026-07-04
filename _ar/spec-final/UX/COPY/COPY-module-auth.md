---
doc_id: COPY-module-auth
title: Auth Module Copy — Login Magic Link & Account Activation
canonical_layer: COPY
spec_type: copy
scope: module-auth
modules: []
language: cs
status: canonical
references:
  - WIRE0012
  - WIRE0013
  - WIRE0024
  - WIRE0025
  - COMP0001
  - COMP0006
  - COMP0009
  - UC0014
  - BR-AccessControlAndRoles
  - BR-PartyIdentityAndDeduplication
---

# COPY-module-auth – Textový obsah modulu Auth (přihlášení magic-linkem a aktivace účtu)

## Účel

Textová plocha pro čtyři bezheslové autentizační obrazovky: přihlášení pomocí magic-linku a jeho
stav po odeslání potvrzení (S009 / `WIRE0012`), aktivace účtu s nastavením hesla a odsouhlasením
podmínek (S010 / `WIRE0013`), vstupní bod pro vyžádání aktivačního odkazu (S021 / `WIRE0024`) a
cílová stránka po odeslání aktivačního odkazu (S022 / `WIRE0025`). Využívají ji `COMP0009` (jednotný
formulář pro zadání e-mailu, purpose=login a purpose=activation-request), `COMP0001` (primární
tlačítko) a `COMP0006` (souhlasový checkbox), jak jsou umístěny na těchto čtyřech obrazovkách. Tón je
přímý, ve druhé osobě neformální (vykání), věty malými písmeny (sentence case), krátká imperativní CTA.
Text je přepsán **verbatim** z pozorovaného UI (`_ar/prtsc/**`) a z `_ar/evidence/ui/ui-observed-areas.md`
§7–§10; nic zde není parafrázováno ani vymyšleno.

---

## Popisky (Labels)

| Klíč | Text | Použití (odkaz WIRE/COMP) |
|---|---|---|
| `module-auth.login.heading` | `Přihlaste se do účtu` | `WIRE0012` (výchozí stav) / `COMP0009` |
| `module-auth.login.body` | `pro žadatele, dárce a Patrony, kde najdete přehled o svých žádostech a darech. Zadejte svůj e-mail, a my vám místo hesla pošleme odkaz, kterým se přihlásíte.` | `WIRE0012` (výchozí stav) / `COMP0009` |
| `module-auth.login-confirmation.heading` | `Zkontrolujte svou e-mailovou schránku` | `WIRE0012` (potvrzovací stav) / `COMP0009` |
| `module-auth.login-confirmation.body` | `Na váš e-mail jsme poslali odkaz, pomocí kterého se přihlásíte i bez hesla.` | `WIRE0012` (potvrzovací stav) / `COMP0009` |
| `module-auth.activate-account.heading` | `Aktivovat účet` | `WIRE0013` (výchozí stav) |
| `module-auth.activate-account.body` | `Po aktivování svého uživatelského účtu budete přihlášení a budete moct využívat všech jeho výhod.` | `WIRE0013` (výchozí stav) |
| `module-auth.activation-entry.heading` | `Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet` | `WIRE0024` (výchozí stav) / `COMP0009`; **Confirmed** přímo screenshotem v tomto průchodu — viz poznámka u Evidence níže (upgraduje vlastní hodnocení *Probable* u `WIRE0024`, aniž by ho zde přepisovala) |
| `module-auth.activation-entry.body` | `Zde vyplňte svůj email, který jste použili při přispění na příběh nebo v žádosti o dar. Odešleme vám na něj aktivační odkaz.` | `WIRE0024` (výchozí stav) / `COMP0009`; **Confirmed** — viz poznámka u Evidence |

---

## Nápovědné texty (Helper Texts)

| Klíč | Text | Použití |
|---|---|---|
| `module-auth.login-confirmation.resend-hint` | `Pokud stále nedorazil, zkontrolujte složku spam, nebo nám napište na info@patrondeti.cz.` | `WIRE0012` (potvrzovací stav); obsahuje odkaz `mailto:info@patrondeti.cz` |
| `module-auth.activate-account.missing-info-helper` | `Bez těchto informací se neobejdeme.` | `WIRE0013`; červený nápovědný text pod dvojicí polí e-mail/heslo. **Jistota role:** Uncertain — nerozlišeno, zda jde o konvenci povinného pole, nebo již vyvolanou chybu validace (viz `WIRE0013` OQ-WIRE0013-1); zde uvedeno pouze jako pozorovaný text, bez tvrzení o žádné z variant. |

---

## Prázdné stavy (Empty States)

`N/A — nevztahuje se žádný samostatný prázdný stav.` Všechny čtyři obrazovky jsou jednotné pevné
formuláře nebo potvrzovací panel, nikoli výpisy; na žádné z nich neexistuje stav typu „žádné položky"
(`WIRE0012`, `WIRE0013`, `WIRE0024` States→empty; `WIRE0025` States→empty).

---

## Načítací texty (Loading Texts)

`Evidence Pending — nezachyceno` na žádné ze čtyř obrazovek. Na žádném screenshotu S009, S010, S021
ani S022 nebyl pozorován text spinneru/deaktivovaného tlačítka/probíhající akce
(`WIRE0012`/`WIRE0013`/`WIRE0024` States→loading). **Open Question** — zde nedomýšleno.

---

## Chybové / validační zprávy (Error / Validation Messages)

| Klíč | Text | Spouštěč (Trigger) |
|---|---|---|
| `module-auth.login.email.validation-error` | *(nepozorováno)* | **Open Question** — nebyl nalezen BR/EN upravující zpětnou vazbu k povinnosti/formátu e-mailu na S009; `WIRE0012` Validation Surfaces označuje toto jako nevyřešené (`BR-AccessControlAndRoles` upravuje flood-control/expiraci tokenu, nikoli validaci na úrovni formuláře). Text se zde nedomýšlí. |
| `module-auth.activate-account.password.validation-error` | *(nepozorováno — viz `module-auth.activate-account.missing-info-helper` výše, role Uncertain)* | **Open Question** — žádný BR nespecifikuje formát/sílu hesla pro S010; `BR-PartyIdentityAndDeduplication` pouze požaduje, aby nově vytvořený User byl založen bez použitelného hesla až do aktivace, nikoli formátové pravidlo (`WIRE0013` validationsWithoutBR). |
| `module-auth.activate-account.terms-checkbox.validation-error` | *(nepozorováno)* | **Open Question** — žádný BR nevyžaduje zaškrtnutí kteréhokoli aktivačního checkboxu před odesláním; nedoloženo (`WIRE0013` validationsWithoutBR). |
| `module-auth.activation-entry.email.validation-error` | *(nepozorováno)* | **Open Question** — žádný BR neupravuje zpětnou vazbu k povinnosti/formátu e-mailu na S021, ani zda je neshodující se e-mail zpracován odlišně (bezpečnost proti enumeraci); `WIRE0024` Validation Surfaces / validationsWithoutBR. |
| `module-auth.activation-link-sent.error` | *(nepozorováno)* | **Open Question** — pro S022 nebyla doložena žádná chybová plocha; `WIRE0025` States→error uvádí, že UC0014 AF4/AF5 popisují přidružené chybové cesty pouze na úrovni UC, bez potvrzeného zobrazení na obrazovce zde. |

---

## CTA

| Klíč | Text | Akce |
|---|---|---|
| `module-auth.login.submit-cta` | `Přihlásit se` | `UC0014` (větev UC0014.1 magic-link — odeslání žádosti o odkaz); `COMP0001` uvnitř `COMP0009` |
| `module-auth.login.password-fallback-cta` | `Přihlaste se pomocí svého hesla.` | Naviguje na variantu přihlášení heslem v rámci `UC0014`; cílová obrazovka není samostatně zachycena — **Open Question** (nedoloženo screen-id, dle `WIRE0012` interaction 3) |
| `module-auth.login.activate-account-cta` | `Aktivujte si ho.` | Naviguje na S021 (předstupeň vystavení aktivačního odkazu v rámci `UC0014`); `WIRE0012` interaction 4 |
| `module-auth.login-confirmation.password-fallback-cta` | `Přihlaste se pomocí svého hesla.` | Stejný cíl/akce jako `module-auth.login.password-fallback-cta`, zobrazeno v potvrzovacím stavu; `UC0014` |
| `module-auth.login-confirmation.contact-support-cta` | `napište na info@patrondeti.cz` | Odkaz `mailto:`, nikoli akce `UC0014` — otevírá e-mailového klienta Customera; vloženo uvnitř nápovědného textu resend-hint; bez vlastnícího UC (kontakt na podporu, nikoli doménový use case) |
| `module-auth.activate-account.rules-link-cta` | `pravidly poskytování pomoci` | Otevírá dokument s pravidly (`S-EXT4` dle `_ar/spec-draft/IA-screen-map.md`); neodesílá formulář; nepřiřazeno k žádnému kroku `UC0014` (akce zobrazení dokumentu) |
| `module-auth.activate-account.terms-link-cta` | `podmínkami používání uživatelského účtu` | Otevírá obsah podmínek používání účtu; cílová obrazovka nezachycena — **Open Question** (`WIRE0013` interaction 4) |
| `module-auth.activate-account.submit-cta` | `Aktivovat účet` | `UC0014` (aktivační přechod, „Registered (blocked or password-less) → Active"); `COMP0001` |
| `module-auth.activation-entry.submit-cta` | `Poslat aktivační odkaz` | `UC0014` (předstupeň vystavení aktivačního odkazu, přidružený k UC0014.1/UC0014.3 — sám o sobě není číslovaným krokem toku UC0014, dle `WIRE0024` Purpose); `COMP0001` uvnitř `COMP0009` |
| `module-auth.activation-entry.back-to-login-cta` | `Zpět na přihlášení` | Naviguje na S009 (`/prihlaseni`); navigace přidružená k `UC0014`, sama o sobě není krokem UC0014; `WIRE0024` interaction 3 |

---

## Popisky souhlasového checkboxu (instance COMP0006 na S010)

| Klíč | Text | Spouštěč/Akce |
|---|---|---|
| `module-auth.activate-account.consent-rules.label` | `Prohlašuji, že jsem se seznámil/a s pravidly poskytování pomoci.` | instance 1 `COMP0006` na `WIRE0013`; zda je zaškrtnutí povinné před odesláním, není podloženo žádným BR — **Open Question** (`WIRE0013` validationsWithoutBR; `COMP0006` Open Questions) |
| `module-auth.activate-account.consent-terms.label` | `Souhlasím s podmínkami používání uživatelského účtu.` | instance 2 `COMP0006` na `WIRE0013`; stejná otevřená otázka ohledně povinnosti checkboxu jako výše |

Poznámka: vložené hypertextové odkazy uvnitř těchto dvou popisků ("pravidly poskytování pomoci" /
"podmínkami používání uživatelského účtu") odpovídají stejným řádkům CTA textu uvedeným výše
(`module-auth.activate-account.rules-link-cta`, `module-auth.activate-account.terms-link-cta`); nejsou
duplikovány jako samostatný text popisku podle kompozice komponenty (prop label v `COMP0006` odkaz vkládá).

---

## Konvence mikrotextů (Microcopy Conventions)

- Tón: přímý, přátelský, hybrid neformálního a formálního stylu v souladu se zbytkem veřejného webu
  (imperativní CTA, tvary slovesa ve 2. osobě množného čísla „vy" — „Zadejte", „Zkontrolujte", „Vyplňte").
- Osoba: 2. osoba množného čísla (vykání), např. „Zadejte svůj e-mail…", „Zkontrolujte svou
  e-mailovou schránku".
- Velká písmena: v celém rozsahu sentence case (nadpisy, CTA, nápovědný text); title case nebyl
  pozorován.
- Interpunkce: tečka na konci vět v body/helper textu a u kompletních vět v sekundárních odkazech
  („Aktivujte si ho.", „Přihlaste se pomocí svého hesla."); CTA na tlačítkách nemají koncovou
  interpunkci („Přihlásit se", „Aktivovat účet", „Poslat aktivační odkaz").
- Vzor placeholder-jako-label: placeholder pole „E-mail" na S009/S021 zároveň slouží jako jediný
  viditelný popisek pole (samostatný text `<label>` nebyl pozorován) — označeno jako otevřená otázka
  přístupnosti v `WIRE0012`/`WIRE0024`/`COMP0009`, nikoli jako defekt COPY.

---

## Otevřené otázky (Open Questions)

- **OQ-COPY-auth-1:** Na žádné ze čtyř obrazovek (S009, S010, S021, S022) nebyl pozorován
  validační/chybový text pro formát e-mailu, formát hesla, povinný checkbox nebo případ
  expirovaného/neplatného tokenu. Žádný BR ani EN tyto spouštěče neupravuje dle sekcí
  `validationsWithoutBR` v `WIRE0012`/`WIRE0013`/`WIRE0024`/`WIRE0025` — zaznamenáno, nikoli
  domýšleno.
- **OQ-COPY-auth-2:** Skutečný text potvrzení „odkaz odeslán" na S022 není doložen. Oba zachycené
  screenshoty pro `/poslat-aktivacni-email`
  (`screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_23_37.png` a
  `…-13_31_22.png`) zobrazují identický aktivační formulář S021
  („Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet" / „Poslat aktivační odkaz" /
  „Zpět na přihlášení"), nikoli samostatnou potvrzovací zprávu — potvrzeno nezávisle v tomto průchodu
  COPY přímou pixelovou kontrolou obou souborů, ve shodě s vlastním zjištěním `WIRE0025` (převzato
  z `UI-gap-open-questions.md` OQ-03). Žádné klíče potvrzovacího textu
  `module-auth.activation-link-sent.*` se zde nezavádí; platí pouze společné chrome a (identický,
  již zaklíčovaný) text formuláře S021 — dokud nebude S022 znovu zachyceno.
- **OQ-COPY-auth-3:** `WIRE0024` hodnotí vlastní obsah těla formuláře (nadpis, text, CTA) jako
  *Probable*, protože jeho citovaný screenshot byl nahlášen jako obsahující pouze chrome. Přímá
  kontrola `screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` v tomto průchodu
  COPY ukazuje celé tělo formuláře (nadpis, úvodní text, předvyplněné pole „email", obě CTA) jasně
  v záběru — to je zde zaznamenáno jako rozpor vůči hodnocení jistoty u `WIRE0024`, nikoli tiše
  vyřešeno upgradem dokumentu WIRE (mimo rozsah zápisu tohoto dokumentu). Řádky popisků
  `module-auth.activation-entry.*` výše jsou označeny jako Confirmed na základě tohoto přímého
  pozorování screenshotu; rozpor v jistotě na úrovni WIRE zůstává otevřený k vyřešení vlastníkem WIRE.
- **OQ-COPY-auth-4:** `MSG0003` (e-mail o aktivaci účtu) rámuje aktivaci jako tok s magic-linkem, kde
  se heslo nikdy nezobrazuje ani nevyžaduje, zatímco S010 (`WIRE0013`) zobrazuje explicitní pole pro
  vytvoření hesla. Jde o konflikt zaznamenaný u `WIRE0013` (OQ-WIRE0013-2); COPY jej neřeší a
  nedomýšlí text ke sladění obou zdrojů — placeholder textu pole hesla ("Vytvořte si vlastní heslo")
  je přepsán tak, jak byl pozorován, bez ohledu na tento konflikt.

---

## Evidence

| Klíčová oblast | Jistota | Evidence |
|---|---|---|
| Nadpis/text/CTA/sekundární odkazy výchozího stavu přihlášení (S009) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`; `ui-observed-areas.md` §7 |
| Nadpis/text/nápověda/CTA potvrzovacího stavu přihlášení (S009) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png`; `ui-observed-areas.md` §7 |
| Nadpis/text/pole/checkboxy/CTA aktivace účtu (S010) | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-aktivovat-ucet-2026-07-04-13_33_10.png`; `ui-observed-areas.md` §8 |
| Role textu „Bez těchto informací se neobejdeme." (povinné pole vs. chyba) | Confirmed text / Uncertain semantics | stejný screenshot; `ui-observed-areas.md` §8; `WIRE0013` OQ-WIRE0013-1 |
| Nadpis/text/pole/CTA vstupu pro aktivaci (S021) | Confirmed (přímá kontrola screenshotu, tento průchod) | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`; `ui-observed-areas.md` §9 — viz OQ-COPY-auth-3 ohledně rozporu vůči vlastnímu hodnocení *Probable* u `WIRE0024` |
| Skutečný obsah těla obrazovky po odeslání aktivačního odkazu (S022) | Uncertain / evidence-blocked | `_ar/prtsc/screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_23_37.png`, `…-13_31_22.png` (obě zobrazují formulář S021, nikoli samostatné potvrzení); `ui-observed-areas.md` §10; `WIRE0025`; viz OQ-COPY-auth-2 |
| Validační/chybový text (všechny čtyři obrazovky) | Evidence Pending | žádný screenshot nezobrazuje žádnou vyvolanou validační/chybovou zprávu; viz Otevřené otázky |
| Návaznost CTA→UC0014 | Confirmed | `_ar/spec-draft/UC/UC0014_AuthenticateManageAccess.md`; sekce Interactions v `WIRE0012`/`WIRE0013`/`WIRE0024` |
