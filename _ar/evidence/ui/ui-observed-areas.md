# UI Observed Areas — durable FE-evidence record (Patronus)

> Recorded by **AR:ScreenshotCoverageAuditor** · 2026-07-04 · from screenshots in `_ar/prtsc/`
> captured 2026-07-04 against `patrondeti.cz` (CZ tenant), two Gmail-rendered transactional e-mails,
> and hosted payment-gateway / 3DS surfaces. This is the **UI-evidence source** downstream
> IA / WIRE / COMP / COPY passes consume. One section per distinct screen (scroll/interaction shots of
> the same `urlPath` merged). Every entry carries `Evidence =` filename(s).
>
> Evidence-first: verbatim text is quoted as observed (typos preserved, e.g. "Ziskat potvrzení",
> "Mate", "V jaké termínu"). Where a screen was filled with tester/placeholder data, field *values*
> are noise; field *presence/labels* are the evidence. Nothing here is domain logic inferred from
> layout alone — such inferences are flagged and deferred to code verification.

---

## 1. Homepage — story catalogue (`/`)

- **Audience:** anonymous visitor.
- **Visible concepts:** story cards (child photo, days-remaining countdown, title, target vs collected
  amount); help types "Zdravotní pomoc" / "Rozvoj a vzdělání"; collection-account / group story type
  ("SBÍRKOVÝ ÚČET", "Necháte výběr dítěte, kterému chcete pomoct na nás?"); monthly recurring presets;
  gift vouchers ("Dobrošeky"); Patron role explainer; partner/sponsor organisations; collection account
  number; cookie consent.
- **Actions / CTAs:** Nav — "Požádat o pomoc", "Můj účet", "Jak to funguje", "Blog", "O nás". Hero —
  "Daruj 90 Kč měsíčně", "Daruj 290 Kč měsíčně", "Daruj měsíčně podle sebe". Per-story — "Podpořím
  <jméno>", "Nechám to na vás" (collection account), "Další příběhy". Also "Koupím dobrošek", "Chci se
  stát Patronem", cookie "Přijímám / Odmítnout".
- **Controls:** four filter tabs — **Zbývající částka** (default active), **Samoživitelé**,
  **Filtrovat podle krajů**, **Brzy skončí**; "Filtrovat podle krajů" renders an **interactive CZ region
  map** ("Vyberte kraj na mapě") that replaces the card list until a region is picked; testimonials
  carousel prev/next arrows; donation-amount selector (90/290/vlastní).
- **Form fields:** none (browse view).
- **Tables:** none.
- **States:** default loaded (13_15_49 = Zbývající částka; 13_16_09 = Samoživitelé, different story set;
  13_16_21 = region map, empty/neutral before selection; 13_16_37 = full scroll capture). Cookie banner
  visible/undismissed on several.
- **Representative verbatim:** "DARUJME DĚTEM ŠANCI za jedno kafe měsíčně"; "323 dětí čeká na pomoc";
  "ZBÝVÁ MĚSÍC / ZBÝVÁ DEN / ZBÝVÁ 4 DNY"; "SBÍRKOVÝ ÚČET"; "Cílová částka" / "Vybráno"; "Poděkování od
  rodin"; "Dobrošeky pro lepší dětství"; "Kdo je to Patron příběhu? … Ten je pro dárce zárukou
  důvěryhodnosti. Patronem se může stát kdokoli, kdo zná dítě z příběhu – učitel, vedoucí kroužku nebo
  sociální pracovník."; "Číslo sbírkového účtu 57574646/0600"; "© 2026 Patron dětí."
- **Evidence =** screencapture-patrondeti-cz-2026-07-04-13_15_49.png,
  screencapture-patrondeti-cz-2026-07-04-13_16_09.png,
  screencapture-patrondeti-cz-2026-07-04-13_16_21.png,
  screencapture-patrondeti-cz-2026-07-04-13_16_37.png.

---

## 2. Story detail + donation modal (`/pribeh/balik-skolnich-potreb-pro-sofinku-4`)

- **Audience:** anonymous visitor / potential donor.
- **Visible concepts:** story of a child; story Patron; target amount; remaining amount; in-kind help
  (school supplies); category (Rozvoj a vzdělání); recurring/voucher support; social sharing; related
  stories; one-off donation form; GDPR consent; payment gateway choice.
- **Actions / CTAs:** "Přispět", "Zobrazit komentář Patrona", "Chci podporovat rozvoj a vzdělání",
  "Mám dobrošek" / "Chcete věnovat dobrošek?", share (Facebook/X/Instagram/LinkedIn/WhatsApp/Messenger),
  related "Podpořím Románka / Petrušku / Miu", "Další příběhy"; in modal — "Zpět na příběh",
  "Přejít k platbě".
- **Controls:** amount input (Kč, default 50 in modal); consent checkboxes in modal.
- **Form fields (donation modal "Chystáte se přispět"):** "Chci darovat (Kč)"; "E-mail" (required);
  "+420" (telefon); "Jméno"; "Příjmení"; checkbox "Souhlasím s pravidly poskytování pomoci projektu
  Patron."; checkbox "Souhlasím se zpracováním osobních údajů a informováním o projektu".
- **Tables:** none.
- **States:** donation modal open over the story detail; contact fields shown pre-filled (tester data).
- **Representative verbatim:** "Balík školních potřeb pro Sofinku"; "Chybí 1 600 Kč"; "Na pomoc dětem
  putuje vždy 100 % z darované částky."; "Chystáte se přispět"; "Po přesměrování na platební bránu si
  budete moci vybrat mezi online platbou (kartou) a expresním bankovním převodem"; "peníze neposíláme
  rodinám, ale hradíme přímo"; "každou žádost potvrzuje Patron – nezávislý ověřovatel".
- **Evidence =** screencapture-patrondeti-cz-pribeh-balik-skolnich-potreb-pro-sofinku-4-2026-07-04-13_26_21.png.

---

## 3. Application form — step 1 "Váš příběh" (`/zadost-formular`)

- **Audience:** applicant (parent / legal guardian).
- **Visible concepts:** 5-step wizard (Příběh · Dar · O Vás · Patron · Přílohy); one application per
  child; child identity; child health disadvantage; description of need; parallel collection at another
  foundation in last 6 months; child not of Czech nationality; application must be in Czech.
- **Actions / CTAs:** "Krok zpět", "Pokračovat"; nav "Požádat o pomoc", "Můj účet".
- **Controls:** stepper (step 1 active); checkbox "Je Vaše dítě zdravotně znevýhodněné?"; radio "Mate
  nebo měli jste sbírku u jiné nadace v posledních 6 měsících" (ANO/NE); radio "Žádám o pomoc pro dítě,
  které nemá českou národnost" (ANO/NE) — both radios default to NE.
- **Form fields:** story textarea "Řekněte nám více o sobě a o své rodině…" (0/500); child "Jméno";
  child "Příjmení"; "Rodné číslo dítěte" (cizinec: "číslo pojištěnce"); "Jaké je vaše dítě a co má
  rádo?"; "S čím se vaše dítě potýká a jakou potřebuje pomoc? / Má vaše dítě specifický zdravotní
  problém?" (0/500).
- **Tables:** none.
- **States:** empty with placeholders (13_18_33); a second pass (13_20_29) shows char counters near/at
  limit (500/500, 461/500) and both textareas filled with **Kafka "Metamorphosis" placeholder text**
  (QA dummy data — value is noise), identity fields with tester's own data.
- **Representative verbatim:** "Krok 1: Váš příběh"; "Pokud žádáte pro více dětí, vyplňte prosím pro
  každé z nich vlastní žádost. Žádost musí být vyplněna česky."; "Dovolte nám vaše dítě lépe poznat";
  "Pokud založíte v průběhu sbírky novou, duplicitní sbírku u jiného charitativního subjektu,
  informujte neprodleně Nadaci Sirius."
- **Evidence =** screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_18_33.png,
  screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_29.png.

---

## 4. Application form — step 2 "Dar, kterým vám pomůžeme" (`/zadost-formular`)

- **Audience:** applicant.
- **Visible concepts:** gift/in-kind selection via a **quick-choice list of 9 gift categories**;
  category-specific fields; vendor/school contact; total gift cost; supporting-document upload; FAQ.
- **Gift categories observed (9):** ŠVP / jazykový kurz / školní výlety; lyžařský kurz;
  kroužky / soustředění; **tábory** (pobytové, příměstské); školné a internát; notebook; automobil jako
  zdravotní pomůcka; pomůcky a služby pro zdravotně znevýhodněné děti; balík školních potřeb.
- **Actions / CTAs:** per row "Více informací" (expand) / "Zobrazit méně" (collapse) / "Vybrat" (select);
  "Krok zpět", "Pokračovat", "vyberte v počítači" (file picker).
- **Controls:** 9 expandable category rows; stepper (Příběh done / Dar active); drag-and-drop upload
  zone (0/3 files); FAQ accordion.
- **Form fields (generic default state):** "Název a adresa školy poskytující aktivity"; "Kontaktní
  osoba"; "Telefonní číslo na kontaktní osobu" (+420); "E-mail na kontaktní osobu"; "Jak dar dítěti
  konkrétně pomůže?" (0/500); attachment "Zde přiložte přihlášku na školní akci nebo informační leták"
  (max 3); "Celková částka na pořízení daru (Kč)".
- **Category-dependent relabelling (Tábory expanded):** org field becomes "Název a adresa organizátora
  tábora"; a camp-only field "V jaké termínu se tábor uskuteční" appears; attachment label becomes "Zde
  přiložte přihlášku na tábor".
- **Tables:** none.
- **States:** default before any category chosen (13_20_39); "Tábory" category expanded (13_20_57);
  0/500 char, 0/3 files.
- **Representative verbatim:** "Krok 2: Dar, kterým vám pomůžeme"; "Rychlá volba daru:"; "Tato informace
  může pomoci dárcům v rozhodování, zda přispějí či ne, buďte proto konkrétní…"; "TÁBORY – POBYTOVÉ,
  PŘÍMĚSTSKÉ … V žádosti je nutné uvést celkovou cenu a kontakt na poskytovatele služby."; "Často kladené
  otázky — Proč vyžadujeme po všech obdarovaných důkaz o tom, jak dar využívají?"
- **Evidence =** screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_39.png,
  screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_20_57.png.

---

## 5. Application form — step 3 "Údaje o vás" (`/zadost-formular`)

- **Audience:** applicant (parent / legal guardian).
- **Visible concepts:** applicant personal data; permanent residence; mailing address differs option;
  single-parent (samoživitel) status with definition; contact details; employment status with a
  cross-step attachment dependency; importance of keeping data current.
- **Actions / CTAs:** "Krok zpět", "Pokračovat".
- **Controls:** stepper (Příběh done / Dar done / O Vás active); checkbox "Zastihnete mě na jiné než
  trvalé adrese"; checkbox "Jsem samoživitel"; radio "Jste zaměstnán?" (ANO/NE) — defaults to NE.
- **Form fields:** "Jméno"; "Příjmení"; "Rodné číslo rodiče" (cizinec: číslo pojištěnce); "Ulice a
  číslo popisné"; "Město"; "PSČ"; "E-mail"; "Telefon" (+420); "Jste zaměstnán?".
- **Tables:** none.
- **States:** empty with placeholders (13_21_26); filled with tester data — Ondřej / Šuhaj / 881206/0290
  / Kaplická 446 / Velešín / 38232 / o.suhaj@gmail.com / +420 723667161, employment toggled to ANO
  (13_21_59); filled fields render with a light-blue background vs. white for untouched; a persistent
  red info banner about updating data.
- **Representative verbatim:** "Krok 3: Údaje o vás"; "Samoživitel = Zákonný zástupce dítěte, který vede
  samostatnou domácnost, ve které je jedinou dospělou osobou, žijící s nezaopatřenými dětmi"; "Jste
  zaměstnán? (pokud nejste zaměstnán, doložte evidenci na ÚP v kroku 5.)"; "V případě změny údajů nám
  nezapomeňte dát hned vědět."
- **Note:** steps 4 (Patron) and 5 (Přílohy) were **not captured** — only visible as stepper labels.
- **Evidence =** screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_21_26.png,
  screencapture-patrondeti-cz-zadost-formular-2026-07-04-13_21_59.png.

---

## 6. Application intake — "Údaje o žadateli" contact/consent step (`/zadost/zadatel`)

- **Audience:** applicant (parent / fundraiser).
- **Visible concepts:** application; applicant contact data; GDPR consent; marketing/project-info
  consent; required documents (child's birth certificate + applicant ID); FAQ. A "Zpět na výběr" link
  implies a **prior selection step** on this alternate entry path.
- **Actions / CTAs:** "Zpět na výběr", "Pokračovat"; footer links (O nás, Blog, Pravidla poskytování
  pomoci, Naše desatero, Splněné příběhy, Výroční zprávy, "Jak jsme pomáhali v době koronakrize"),
  "Chci přihlásit příběh", "Souhlas se zpracováním osobních údajů".
- **Controls:** phone +420 prefix selector; consent checkbox; FAQ accordion (two collapsed items).
- **Form fields:** "E-mail"; "Telefon" (+420); checkbox "Souhlasím se zpracováním osobních údajů a
  informováním o projektu".
- **Tables:** none.
- **States:** initial/empty; consent unchecked by default.
- **Representative verbatim:** "Začneme tím, že nám sdělíte váš telefon a e-mail"; "Pokud žádáte o dar
  pro své dítě, budete k vyplnění žádosti potřebovat jeho rodný list a svůj občanský průkaz."; "Souhlasy
  můžete upravit/zrušit zasláním e-mailu na souhlas@patrondeti.cz."; FAQ "Proč musí mít každé dítě svou
  vlastní žádost o dar?", "Proč musí mít každý příběh svého Patrona?"
- **Note / conflict:** this URL and first step differ from the `/zadost-formular` wizard (§3). Two
  distinct application-entry paths observed — relationship unresolved (see gap analysis §b/§c-6).
- **Evidence =** screencapture-patrondeti-cz-zadost-zadatel-2026-07-04-13_18_12.png.

---

## 7. Login — magic-link (`/prihlaseni`)

- **Audience:** applicant / donor / Patron (unauthenticated, has an account).
- **Visible concepts:** passwordless login via e-mailed link; account roles (žadatel, dárce, Patron);
  password fallback; activation cross-link; check-spam guidance.
- **Actions / CTAs:** "Přihlásit se"; "Přihlaste se pomocí svého hesla."; "Aktivujte si ho.".
- **Controls:** none beyond the field + button.
- **Form fields:** "E-mail".
- **Tables:** none.
- **States:** empty form (13_23_29); success/confirmation after submit (13_32_31).
- **Representative verbatim:** "Přihlaste se do účtu … pro žadatele, dárce a Patrony, kde najdete přehled
  o svých žádostech a darech."; "Zadejte svůj e-mail, a my vám místo hesla pošleme odkaz, kterým se
  přihlásíte."; (success) "Zkontrolujte svou e-mailovou schránku — Na váš e-mail jsme poslali odkaz…";
  "Pokud stále nedorazil, zkontrolujte složku spam, nebo nám napište na info@patrondeti.cz."
- **Evidence =** screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png,
  screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png.

---

## 8. Account activation — set password (`/aktivovat-ucet`)

- **Audience:** invited / newly-provisioned user.
- **Visible concepts:** account activation; e-mail identity (prefilled, read-only style); password
  creation; terms acceptance (rules + account-usage conditions); benefits gated behind activation.
- **Actions / CTAs:** "Aktivovat účet" (submit); links "pravidly poskytování pomoci", "podmínkami
  používání uživatelského účtu".
- **Controls:** checkbox "Prohlašuji, že jsem se seznámil/a s pravidly poskytování pomoci"; checkbox
  "Souhlasím s podmínkami používání uživatelského účtu".
- **Form fields:** e-mail (prefilled o.suhaj@gmail.com, read-only style); "Vytvořte si vlastní heslo".
- **Tables:** none.
- **States:** password field shown with a red outline — appears to be a required/validation highlight
  (no explicit error text); helper "Bez těchto informací se neobejdeme." — *Uncertain* whether error or
  required-state styling.
- **Representative verbatim:** "Aktivovat účet"; "Po aktivování svého uživatelského účtu budete
  přihlášení a budete moct využívat všech jeho výhod."; "Bez těchto informací se neobejdeme."
- **Evidence =** screencapture-patrondeti-cz-aktivovat-ucet-2026-07-04-13_33_10.png.

---

## 9. Activation entry — send activation link (`/overit-prihlaseni`)

- **Audience:** existing dárce / žadatel / Patron without an activated login.
- **Visible concepts:** dárce / žadatel / Patron roles; account activation; e-mail as identifier;
  activation link sent to the e-mail used when donating or applying.
- **Actions / CTAs:** "Poslat aktivační odkaz", "Zpět na přihlášení".
- **Controls:** none beyond field + buttons.
- **Form fields:** "email" (pre-filled o.suhaj@gmail.com).
- **Tables:** none.
- **States:** form ready / pre-filled, no validation shown.
- **Representative verbatim:** "Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet"; "Zde
  vyplňte svůj email, který jste použili při přispění na příběh nebo v žádosti o dar. Odešleme vám na
  něj aktivační odkaz."
- **Inference (deferred to code):** copy implies **accounts are provisioned from donation/application
  data**, then self-activated — not created by explicit registration. Not confirmable from UI alone.
- **Evidence =** screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png.

---

## 10. Activation-link-sent (`/poslat-aktivacni-email`)

- **Audience:** existing party awaiting activation link.
- **Visible concepts:** cookie consent; Nadace Sirius; veřejná sbírka; collection account; Comgate.
- **Actions / CTAs:** only nav + full site footer links + cookie "Další informace" captured.
- **Controls / Form fields / Tables:** none in frame.
- **States:** **only nav + cookie banner + footer captured** — the main confirmation body is out of
  frame. This screen's actual content is **not evidenced** by the capture; do not treat as content.
- **Representative verbatim:** (site-wide footer only) "Platby zprostředkovává: comgate"; "Číslo
  sbírkového účtu: 57574646/0600".
- **Evidence =** screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_23_37.png.

---

## 11. Account — Nastavení účtu (`/muj-ucet/nastaveni`)

- **Audience:** logged-in account holder (patron / donor).
- **Visible concepts:** user profile (name, e-mail, profile photo); footer CTA "Víte o dítěti, které
  potřebuje pomoci?".
- **Actions / CTAs:** "Uložit změny"; "vyberte v počítači" (file picker).
- **Controls:** drag-and-drop file-upload area (profile photo, 0/1).
- **Form fields:** "Jméno"; "Příjmení"; "E-mail"; "Změnit profilovou fotku" (file upload 0/1).
- **Tables:** none.
- **States:** empty (no values pre-filled); upload widget 0/1.
- **Representative verbatim:** "Nastavení účtu"; "Potřebujete něco změnit? Udělejte to tady."; upload
  copy (generic, likely reused) "Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte
  v počítači."; "Víte o dítěti, které potřebuje pomoci?".
- **Evidence note:** `po_prihlaseni_do_uctu_potvrzeni_o_darech2.png` is a **mis-named pixel-duplicate**
  of this screen (filename implies the donation-confirmation flow).
- **Evidence =** po_prihlaseni_do_uctu_nastaveni.png, po_prihlaseni_do_uctu_potvrzeni_o_darech2.png.

---

## 12. Account — Potvrzení o darech / tax-confirmation request (`/muj-ucet/potvrzeni-o-darech`)

- **Audience:** logged-in account holder (patron / donor).
- **Visible concepts:** donations; donation tax confirmation; fyzická vs. právnická osoba; rodné číslo;
  IČ; permanent-residence address; tax-base reduction; per-calendar-year donations; per-donation-once
  legal constraint.
- **Actions / CTAs:** "Ziskat potvrzení" (submit; typo for "Získat").
- **Controls:** tabs "Fyzická osoba" / "Právnická osoba"; checkbox "Chci vykázat všechny dary za rok
  2025".
- **Form fields:** "Jméno"; "Příjmení"; "Adresa trvalého bydliště (Ulice, číslo, Město, PSČ)"; "Rodné
  číslo bez lomítka (YYMMDDXXXX)"; "Fyzická osoba s IČ".
- **Tables:** none.
- **States:** initial/empty form (physical-person tab default); (scrolled) year checkbox + submit +
  legal disclaimer + cookie banner + footer.
- **Representative verbatim:** "Toto je stránka, na které vám vystavíme potvrzení o darech Patronu dětí.";
  "Základní údaje o vás"; "Pozor na překlepy :)"; "Chci vykázat všechny dary za rok 2025"; "Upozorňujeme,
  že pro účely snížení daňového základu můžete pro každý jednotlivý dar uplatnit toto potvrzení nebo
  potvrzení za kalendářní rok pouze jednou. Nelze uplatnit jeden dar obsažený ve dvou různých
  potvrzeních nebo pro dva různé subjekty."
- **Evidence =** po_prihlaseni_do_uctu.png, po_prihlaseni_do_uctu_potvrzeni_o_darech.png.

---

## 13. Thank-you / payment success + resume-application modal (`/dekujeme`)

- **Audience:** donor post-payment.
- **Visible concepts:** successful payment confirmation; in-progress ("rozpracovaná") application
  recovery; application deletion; social sharing; collection account; Comgate.
- **Actions / CTAs:** "Zpět na hlavní stránku"; share (Facebook/X/Instagram/LinkedIn/WhatsApp/Email/
  Messenger). Modal — "Návrat do žádosti", "Zůstat na stránce", "Smazat žádost", close (X).
- **Controls:** modal dialog with two primary choices + one destructive link.
- **Form fields / Tables:** none.
- **States:** success ("Platba proběhla úspěšně"); (separately) a modal about an unfinished, unrelated
  application overlaid on a dimmed background.
- **Representative verbatim:** "Platba proběhla úspěšně, děkujeme za pomoc!"; "Každý příspěvek pomáhá k
  lepšímu dětství. Děkujeme, že jste s námi."; "Prosíme, sdílejte a pomozte příběhu, kterému jste právě
  přispěli."; (modal) "Máte u nás rozpracovanou žádost. … Pro návrat do formuláře můžete použít tlačítka
  níže… Přejete si žádost o pomoc zcela zrušit? Smazat žádost."
- **Note:** the generic success page shows **no amount/story name**. The resume-application modal appears
  triggered by session state, independent of the just-completed donation.
- **Evidence =** screencapture-patrondeti-cz-dekujeme-2026-07-04-13_30_32.png,
  screencapture-patrondeti-cz-dekujeme-2026-07-04-13_31_51.png.

---

## 14. Blog — article listing (`/blog`)

- **Audience:** anonymous visitor.
- **Visible concepts:** blog articles (title, date, category tag, excerpt, thumbnail); thematic tags
  (#O čem se mluví, #Pomohli jsme, #Chcete vědět, #Rozhovory, #Pomoc pro děti s autismem, #Děti s
  Downovým syndromem); featured/hero article; campaign promotion.
- **Actions / CTAs:** "Číst více →"; article title links.
- **Controls:** category tag chips per article (grouping; interactivity not confirmed).
- **Form fields / Tables:** none.
- **States:** default loaded; long single page grouped into thematic sections.
- **Representative verbatim:** "Patron dětí, Nova pomáhá a Ondřej Sokol zvou do kampaně Darujme prázdniny";
  tag labels as above.
- **Evidence =** screencapture-patrondeti-cz-blog-2026-07-04-13_16_59.png.

---

## 15. Blog — article detail (`/blog/patron-deti-nova-pomaha-a-ondrej-sokol-zvou-do-kampane-darujme-prazdniny`)

- **Audience:** anonymous visitor.
- **Visible concepts:** article detail (title, date, tag, body, hero image); campaign matching (monthly
  recurring donations doubled by TV Nova up to 750 000 Kč); donation amount options (90/290/custom);
  **DMS SMS donation channel**; application verification reference ("oddělení risku"); related articles;
  social sharing.
- **Actions / CTAs:** "Zpět na všechny články"; "Sdílet"/"Tweetnout"/"LinkedIn"/"Zkopírovat odkaz";
  related article links; "Pomůžu".
- **Controls / Form fields / Tables:** none.
- **States:** default loaded.
- **Representative verbatim:** "19. 05. 2026 | #O čem se mluví"; "Letošní kampaň Darujme prázdniny se
  zaměřuje především na získání pravidelných dárců."; "televize Nova navýší až do celkové výše 750 000
  Kč"; "trvalou dárcovskou SMS na číslo 87 777: DMS TRV PATRONDETI 90 nebo 290"; "Před zveřejněním jsou
  navíc všechny žádosti pečlivě prověřeny v oddělení risku".
- **Domain note:** surfaces the internal term "oddělení risku" (relates C2/UC0003) and a **DMS SMS
  donation channel** not seen elsewhere in evidence.
- **Evidence =** screencapture-patrondeti-cz-blog-patron-deti-nova-pomaha-a-ondrej-sokol-zvou-do-kampane-darujme-prazdniny-2026-07-04-13_17_24.png.

---

## 16. O nás — about / team / documents (`/o-nas`)

- **Audience:** anonymous visitor.
- **Visible concepts:** Nadace Sirius; project team (roles: koordinátorka, výkonná/provozní ředitelka,
  fundraiser, HR, finance, IT); ethical code / Desatero; annual reports; public-collection control
  protocols; correspondence/billing address; veřejná sbírka.
- **Actions / CTAs:** "Stáhnout Desatero"; "Stáhnout" (each annual report 2018–2024); "Stáhnout" (each
  control protocol 2018–2024); "Sledujte nás na Facebooku"; write to info@patrondeti.cz.
- **Controls / Form fields:** none.
- **Tables:** none (document archives rendered as year tiles, not a data table).
- **States:** default (very tall page; layout inferred from a small render — hero + team grid + Desatero
  banner + two document-archive sections).
- **Representative verbatim:** "Patron dětí je charitativní projekt, jehož smyslem je pomáhat zdravotně a
  sociálně znevýhodněným dětem…"; "Korespondenční a fakturační adresa: Patron dětí, z.ú., U Prašné brány
  1079/3, 110 00 Praha 1, IČO: 06826911, neplátci DPH"; "Výroční zprávy"; "Protokoly o kontroly veřejné
  sbírky".
- **Provenance note:** entity name here "Patron dětí, z.ú." (IČO 06826911) differs from the rules PDF's
  "Nadace Sirius" (IČ 28418808); Patron dětí is a project of Nadace Sirius.
- **Evidence =** screencapture-patrondeti-cz-o-nas-2026-07-04-13_17_32.png.

---

## 17. Výsledky — how-it-works / trust / stats / completed stories (`/vysledky`)

- **Audience:** anonymous visitor.
- **Visible concepts:** application process (parent+Patron fill application → collection → purchase of
  help); Patron as verifier; risk vetting; 100 % of proceeds to help; in-kind help via providers;
  collection account; audited annual reports; oversight by Magistrát hl. m. Prahy; aggregate statistics;
  completed stories (SPLNĚNO, ZPĚTNÁ VAZBA badges).
- **Actions / CTAs:** "Detail příběhu" (per completed-story card); "Další příběhy".
- **Controls / Form fields:** none.
- **Tables:** none (stats as figure blocks; stories as cards).
- **States:** completed-story cards with "SPLNĚNO" and "ZPĚTNÁ VAZBA" badges.
- **Representative verbatim:** "Jak to funguje? — 1. Rodič a Patron vyplní žádost / 2. Společně hledáme
  dárce / 3. Na pořízení pomoci jde 100 % daru"; "Všechny žádosti prověřujeme"; "Kontroluje nás
  Magistrát hl. m. Prahy"; "232,7 mil. Kč"; "70 299 lidí"; "8 000 Kč"; "Společně jsme podpořili 32 977
  příběhů".
- **Note:** whether the aggregate figures are a computed read-model (EN0032/UC0017) or static content is
  **not determinable** from the screenshot.
- **Evidence =** screencapture-patrondeti-cz-vysledky-2026-07-04-13_16_50.png.

---

## 18. Transactional e-mail — donation thank-you (MSG layer)

- **Audience:** donor (one-off / new).
- **Sender / subject:** "Patron dětí" <peceodarce@patrondeti.cz> · "Děkujeme za váš dar!".
- **Visible concepts:** donation of a specific amount (50 Kč) credited to a named story; collection
  account 57574646/0600; user account activation; tax confirmation; one-off vs recurring contribution;
  social sharing.
- **Actions / CTAs:** "AKTIVOVAT UŽIVATELSKÝ ÚČET"; "zde" (set one-off/recurring); "uživatelském účtu"
  (link); share icons (FB/IG/Twitter/LinkedIn/WhatsApp/Messenger/Email).
- **Representative verbatim:** "Váš dar ve výši 50 Kč jsme právě do poslední koruny připsali k příběhu
  Balík školních potřeb pro Sofinku."; "Jednorázové či pravidelné příspěvky můžete nastavit zde nebo
  poslat na sbírkový účet 57574646/0600."; "Každý rok si odtud můžete stáhnout potvrzení o darech do
  daní."; "Ještě uživatelský účet nemáte? Aktivujte si ho."
- **Maps to:** MSG0019 (Donation Confirmation — Paid / Thank-You).
- **Evidence =** screencapture-mail-google-mail-u-1-2026-07-04-13_31_09.png.

---

## 19. Transactional e-mail — finish-your-account follow-up (MSG layer)

- **Audience:** donor without a completed account.
- **Sender / subject:** "Patron dětí" <info@patrondeti.cz> · "Dokončete svůj uživatelský účet 🎉".
- **Visible concepts:** incomplete account requiring completion; followed story; overview of
  contributions and amounts; statistics and feedback from the child; mobile + desktop availability;
  embedded **mobile account-UI mockup** (tabs "Pro vás" / "Všechny (67)", a story card with collection
  state "Přispěli jste 1 250 Kč", "ZBÝVÁ 10 DNÍ", "83 240 Kč / 101 591 Kč").
- **Actions / CTAs:** "Dokončit účet" (highlighted); "uživatelský účet" (link).
- **Representative verbatim:** "Abyste mohli sledovat příběh tohoto dítěte a zároveň měli pod jednou
  střechou všechny příběhy, na které jste přispěli, vytvořte si svůj uživatelský účet."; "Vše na jednom
  místě — Najdete tu příběhy, na které jste přispěl/a, částku, kterou jste daroval/a, potvrzení o
  darech, zpětné vazby."; "Můžete se stát i Patronem nebo žadatelem."
- **Maps to:** MSG0003 (closest) — but reads as a **drip/follow-up nudge**, possibly a distinct MSG not
  owned by activation (MSG0003) or thank-you (MSG0019). **Value:** the embedded mockup is the only
  glimpse of the logged-in **account dashboard** structure — no real dashboard screenshot exists.
- **Evidence =** screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png.

---

## 20. External — Comgate hosted gateway (method select + paid)

> Not a Patronus-built screen. Recorded so IA/WIRE do not reconstruct it as app UI. Patronus owns only
> the integration boundary (ES0001 ComGate) within UC0005/UC0006.

- **Audience:** donor completing a card/other payment.
- **Domain / branding:** `pay1gate.cz` with UI white-labelled "comgate"; merchant label "patrondeti.cz";
  amount 50 Kč; transaction token WMB6-07V8-QHCH (same token across both shots).
- **specify** — payment-method selection: QR platba; Platba kartou (Mastercard/Visa/Apple Pay/Google
  Pay); Bankovní převod; Platba jedním klikem v mobilu (Air Bank); Odložená platba (Twisto, PlatímPak);
  exits "Návrat do e-shopu", "Zrušit platbu"; language switcher (Čeština).
- **dispatcher** — paid/redirect: "Zaplacená platba"; "Předáváme informaci o stavu platby do
  patrondeti.cz"; 3-step stepper (card done / email active / home pending); "Detail platby".
- **Evidence =** screencapture-pay1gate-cz-specify-WMB6-07V8-QHCH-2026-07-04-13_26_29.png,
  screencapture-pay1gate-cz-dispatcher-WMB6-07V8-QHCH-2026-07-04-13_30_25.png.

---

## 21. External — Revolut ACS 3-D Secure challenge

> Not a Patronus-built screen. Issuer-side 3DS card authorisation during checkout.

- **Audience:** donor completing a card payment (3DS step).
- **Domain:** `/acs/revolut/challenges/browser` (Revolut ACS).
- **Visible concepts:** 3-D Secure authorisation; card payment; amount; merchant "Patron dětí"; Visa
  Secure; countdown timer (4:58).
- **Actions / CTAs:** "Cancel payment".
- **States:** waiting/pending authorisation (polling for app confirmation).
- **Representative verbatim:** "Check your Revolut app to authorise this payment"; "Patron dětí";
  "- CZK50.00"; "Today, 13:27".
- **Evidence =** screencapture-acs-revolut-challenges-browser-2026-07-04-13_27_28.png.

---

## 22. External — Rules PDF in browser viewer (document evidence, not app UI)

> The browser PDF viewer chrome is platform, not app UI; the **document content** is high-authority
> glossary/EN source.

- **Audience:** anonymous reader (public document).
- **Document:** `/files/Pravidla-poskytovani-pomoci-projektu-PATRON.pdf` (page 1 of 5 captured).
- **Domain value:** authoritative definitions — NADACE SIRIUS (IČ 28418808, registered public collection
  Sp. zn. S–MHMP/836092/2017); PATRON (GARANT) as guarantor of a child's story; ŽADATEL (person entitled
  to act for a child < 18, signs a Smlouva o poskytnutí daru with Nadace Sirius); DÁRCE (natural or legal
  person donating); ŽÁDOST (online form, applicant part + Patron part). Help area list cut off after
  "Zdravotní pomoc".
- **Representative verbatim:** "PATRON (GARANT) – je fyzická osoba, která je garantem příběhu dítěte…";
  "ŽÁDOST – je on-line formulář… Žádost se skládá z části vyplňované Žadatelem a z části vyplňované
  Patronem, který potvrzuje a garantuje pravdivost a oprávněnost příběhu Žadatele."
- **Evidence =** screencapture-patrondeti-cz-files-Pravidla-poskytovani-pomoci-projektu-PATRON-pdf-2026-07-04-13_40_46.png.
