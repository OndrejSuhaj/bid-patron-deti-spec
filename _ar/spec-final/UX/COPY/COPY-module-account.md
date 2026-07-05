---
doc_id: COPY-module-account
title: Account — Settings, Tax Confirmation, Dashboard & Role Zones
layer: COPY
spec_type: copy
scope: module-account
modules: []
language: cs
status: imported
references:
  - WIRE0014
  - WIRE0015
  - WIRE0020
  - WIRE0021
  - WIRE0022
  - WIRE0023
  - COMP0001
  - COMP0002
  - COMP0003
  - COMP0007
  - UC0024
  - UC0010
  - EN0006
  - EN0008
  - EN0014
  - EN0034
---

# COPY-module-account – Account — Settings, Tax Confirmation, Dashboard & Role Zones

## Účel

Tento dokument přepisuje uživatelsky viditelný text pozorovaný na autentizovaných plochách
sekce "Můj účet": nastavení účtu/profilu (`WIRE0014`, S011, `/muj-ucet/nastaveni`), CZ formulář
žádosti o potvrzení o darech vč. záložek Fyzická/Právnická osoba (`WIRE0015`, S012,
`/muj-ucet/potvrzeni-o-darech`), a skládaný dashboard + rolí podmíněné zóny
dárce/žadatele/patrona (`WIRE0020`–`WIRE0023`, S017–S020). Text je přepsán **verbatim** z
`_ar/prtsc/po_prihlaseni_do_uctu_nastaveni.png`, `_ar/prtsc/po_prihlaseni_do_uctu.png`,
`_ar/prtsc/po_prihlaseni_do_uctu_potvrzeni_o_darech.png`, a (pouze pro mockup dashboardu S017)
`_ar/prtsc/screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png`. Navazující obrazovky: S011,
S012, S017 (pouze hypotetický mockup), S018/S019/S020 (Evidence-Pending — text obrazovky
nebyl pozorován).
Tón/hlas: neformální 2. osoba jednotného čísla ("vy" forma použitá zdvořile — např. "Vaše jméno", "Potřebujete"),
v souladu se zbytkem veřejného webu.

Podle pravidel rozsahu COPY je sdílený mezi-obrazovkový chrom (globální hlavička/patička navigace,
souhlas s cookies) vlastněn dokumentem `COPY-shared-global` (pokud/až bude vytvořen) a **není** zde
znovu uváděn nad rámec promo-pásu unikátního pro variantu patičky S011, který je zaznamenán proto,
že je to jediné místo, kde byl tento přesný string pozorován.

---

## Popisky (Labels)

| Klíč | Text | Použití (WIRE/COMP ref) |
|---|---|---|
| `module-account.settings.heading` | `Nastavení účtu` | `WIRE0014` (titulek stránky) |
| `module-account.settings.name-group-label` | `Vaše jméno a příjmení` | `WIRE0014` (skupina polí jméno) |
| `module-account.settings.email-group-label` | `Váš e-mail` | `WIRE0014` (skupina polí e-mail) |
| `module-account.settings.photo-group-label` | `Změnit profilovou fotku` | `WIRE0014` / `COMP0007` (nahrání fotky) |
| `module-account.tax-confirmation.tab-individual` | `Fyzická osoba` | `WIRE0015` (ovládací prvek záložky, aktivní/výchozí) |
| `module-account.tax-confirmation.tab-organization` | `Právnická osoba` | `WIRE0015` (ovládací prvek záložky, neaktivní) |
| `module-account.tax-confirmation.basic-data-heading` | `Základní údaje o vás` | `WIRE0015` (skupina polí Jméno/Příjmení) |
| `module-account.tax-confirmation.address-label` | `Adresa trvalého bydliště` | `WIRE0015` (pole adresa) |
| `module-account.tax-confirmation.birth-number-label` | `Rodné číslo bez lomítka` | `WIRE0015` (pole rodné číslo) |
| `module-account.tax-confirmation.ic-label` | `Fyzická osoba s IČ` | `WIRE0015` (pole registračního čísla) |
| `module-account.dashboard-mockup.tab-for-you` | `Pro vás` | `WIRE0020` (lišta záložek, Hypothesis — pouze grafika mockupu, nezachycená obrazovka) |
| `module-account.dashboard-mockup.tab-all` | `Všechny ({count})` | `WIRE0020` (lišta záložek, pozorovaná hodnota "Všechny (67)"; Hypothesis — pouze grafika mockupu) |
| `module-account.dashboard-mockup.contribution-banner` | `Přispěli jste {amount}` | `WIRE0020` (banner překrytí story-karty, pozorovaná hodnota "Přispěli jste 1 250 Kč"; Hypothesis) |
| `module-account.dashboard-mockup.countdown-badge` | `ZBÝVÁ {n} DNÍ` | `WIRE0020` (odznak countdown story-karty, pozorovaná hodnota "ZBÝVÁ 10 DNÍ"; Hypothesis) |

Poznámka: klíče `module-account.dashboard-mockup.*` jsou přepsány z ilustrace vložené do
marketingového e-mailu, nikoli ze zachycené obrazovky aplikace — viz `WIRE0020` Purpose. Jsou zde
zaznamenány pro úplnost pozorovaných stringů, ale výslovně **nejsou** potvrzeným current-state UI
textem.

Žádný text popisku není pozorován pro S018 (`WIRE0021`, zóna dárce / "Moje zóna"), S019 (`WIRE0022`,
zóna žadatele), ani S020 (`WIRE0023`, zóna patrona) nad rámec hypotézy k titulku stránky uvedené
níže v sekci Nadpisy — pro žádnou ze tří obrazovek neexistuje screenshot, podle tabulky Evidence
v každém WIRE.

---

## Nadpisy (titulky stránek, nezachycené jako screenshoty)

| Klíč | Text | Použití | Jistota |
|---|---|---|---|
| `module-account.donor-zone.heading` | `Moje zóna` | `WIRE0021` (titulek stránky S018) | Probable — Confirmed jako config page-title string Drupal View (`views.view.supporter_zone.yml`, dle `EN0034`); jeho vizuální vykreslení jako nadpisu na obrazovce je Assumed, nezachyceno na screenshotu |

Pro S019 (`zona/zadatel`) ani S020 (`zona/patron`) není doložen žádný string titulku stránky —
ani `WIRE0022`, ani `WIRE0023` neuvádí potvrzený string titulku na úrovni configu (na rozdíl od
evidence `EN0034` u S018); zaznamenáno níže jako otevřená otázka, nikoli vymyšleno.

---

## Placeholdery

| Klíč | Text | Použití |
|---|---|---|
| `module-account.settings.first-name-placeholder` | `Jméno` | `WIRE0014` (pole jméno) |
| `module-account.settings.last-name-placeholder` | `Příjmení` | `WIRE0014` (pole jméno) |
| `module-account.settings.email-placeholder` | `E-mail` | `WIRE0014` (pole e-mail) |
| `module-account.tax-confirmation.first-name-placeholder` | `Jméno` | `WIRE0015` (záložka Fyzická osoba) |
| `module-account.tax-confirmation.last-name-placeholder` | `Příjmení` | `WIRE0015` (záložka Fyzická osoba) |
| `module-account.tax-confirmation.address-placeholder` | `Ulice, číslo, Město, PSČ` | `WIRE0015` (pole adresa) |
| `module-account.tax-confirmation.birth-number-placeholder` | `YYMMDDXXXX` | `WIRE0015` (pole rodné číslo) |
| `module-account.tax-confirmation.ic-placeholder` | `Pozor na překlepy :)` | `WIRE0015` (pole IČ) |

Pro sadu polí záložky "Právnická osoba" (organizace) není pozorován žádný text placeholderu — obsah
této záložky není zachycen na žádném z obou screenshotů (`WIRE0015` Open Questions #2).

---

## Nápovědné texty (Helper Texts)

| Klíč | Text | Použití |
|---|---|---|
| `module-account.settings.sub-heading` | `Potřebujete něco změnit? Udělejte to tady.` | `WIRE0014` (podtitulek stránky, pod "Nastavení účtu") |
| `module-account.settings.photo-upload-helper` | `Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v počítači.` | `WIRE0014` / `COMP0007` — část "vyberte v počítači" je inline call-to-action stylizovaná jako odkaz uvnitř této věty; znovu použitý obecný text upload widgetu pozorovaný i v kroku přílohy formuláře žádosti |
| `module-account.tax-confirmation.hero-heading` | `Děkujeme, že pomáháte dětem, které neměly v životě štěstí.` | `WIRE0015` (hero nadpis nad formulářem) |
| `module-account.tax-confirmation.hero-subcopy` | `Toto je stránka, na které vám vystavíme potvrzení o darech Patronu dětí.` | `WIRE0015` (hero podtext) |
| `module-account.tax-confirmation.year-checkbox-label` | `Chci vykázat všechny dary za rok 2025` | `WIRE0015` (ovládací prvek zaškrtávacího pole ve stylu radio-buttonu pro rozsah roku; hodnota roku "2025" je vykreslena inline, nikoli jako statický string — Confirmed jako šablona s dynamickým tokenem roku, `{year}`, na základě jediné pozorované hodnoty) |
| `module-account.tax-confirmation.legal-disclaimer` | `Upozorňujeme, že pro účely snížení daňového základu můžete pro každý jednotlivý dar uplatnit toto potvrzení nebo potvrzení za kalendářní rok pouze jednou. Nelze uplatnit jeden dar obsažený ve dvou různých potvrzeních nebo pro dva různé subjekty.` | `WIRE0015` (kurzívou psané upozornění s ikonou info pod tlačítkem pro odeslání) |

---

## Prázdné stavy (Empty States)

| Klíč | Text | Zobrazeno kdy | Jistota |
|---|---|---|---|
| `module-account.settings.empty-state` | `Not observed — Evidence Pending` | Pole "Jméno"/"Příjmení"/"E-mail" se v jediném zachyceném stavu vykreslují pouze s placeholder textem a bez viditelné hodnoty; `WIRE0014` to zaznamenává jako otevřenou otázku (skutečně poprvé prázdný profil vs. artefakt vykreslování vs. vždy pouze ukázkový placeholder), nikoli jako potvrzený text prázdného stavu | Uncertain |
| `module-account.donor-zone.empty-state` | `Not observed — Evidence Pending` | Uživatel s rolí `supporter` s nulovým počtem vyhovujících Kampaní v projekci `supporter_zone` — hraniční případ, který `WIRE0021` označuje jako nevyřešený; žádný text nezachycen | Uncertain |
| `module-account.applicant-zone.empty-state` | `Not observed — Evidence Pending` | Zda žadatel bez žádných Žádostí vidí na `zona/zadatel` vůbec nějakou zprávu o prázdném stavu, je nevyřešeno; `WIRE0022` zaznamenává celou obrazovku jako nezachycenou | Uncertain |
| `module-account.patron-zone.empty-state` | `Not observed — Evidence Pending` | Zda patron bez propojené Žádosti vidí na `zona/patron` nějakou zprávu o prázdném stavu, je nevyřešeno; `WIRE0023` zaznamenává celou obrazovku jako nezachycenou | Uncertain |

Pro žádnou z výše uvedených položek není text prázdného stavu vymyšlen; každá je zaznamenána jako
absence podle zásady evidence-first, nikoli jako odhadnutý string.

---

## Texty načítání (Loading Texts)

| Klíč | Text | Zobrazeno během | Jistota |
|---|---|---|---|
| `module-account.settings.loading` | `Not observed — Evidence Pending` | Prvotní načtení formuláře nebo uložení po odeslání na `/muj-ucet/nastaveni`; `WIRE0014` zaznamenává, že nebyl zachycen žádný loading/skeleton stav | Uncertain |
| `module-account.tax-confirmation.loading` | `Not observed — Evidence Pending` | Odeslání formuláře na `/muj-ucet/potvrzeni-o-darech`; `WIRE0015` zaznamenává, že nebyl zachycen žádný asynchronní indikátor | Uncertain |

Text stavu načítání není doložen ani pro S017–S020; `WIRE0020`–`WIRE0023` je zaznamenávají jako
`N/A — Evidence Pending`.

---

## Chybové / validační zprávy (Error / Validation Messages)

Každá zpráva odkazuje na pravidlo nebo invariant, který ji spouští. **Žádný dokument `BRxxxx` v
`_ar/spec-draft/BR/` nepokrývá validaci na úrovni polí pro žádnou obrazovku v tomto rozsahu** — toto
je zaznamenáno verbatim ze sekce Validation Surfaces každého WIRE jako mezera v evidenci, nikoli
doplněno vymyšleným textem.

| Klíč | Text | Spouštěč |
|---|---|---|
| `module-account.settings.first-name.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen — `WIRE0014` zaznamenává, že žádný dokument BR/EN nespecifikuje pravidlo formátu jména pro tuto obrazovku; Open Question |
| `module-account.settings.last-name.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen — stejná mezera jako u jména |
| `module-account.settings.email.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen — podle `UC0024` AF2 e-mail není akceptovaným polem v kontraktu úpravy profilu; zda UI zobrazuje jakoukoli klientskou validaci před no-op odeslání není doloženo |
| `module-account.settings.photo-upload.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen — počítadlo "0 / 1" implikuje limit jednoho souboru, ale žádný `BRxxxx` nedokumentuje omezení počtu/typu/velikosti souborů |
| `module-account.tax-confirmation.first-name.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen — krok `UC0010` "Validate the type-specific identifying fields" potvrzuje, že validace probíhá, ale žádné BR nespecifikuje obsah pravidla ani jeho zobrazení na obrazovce |
| `module-account.tax-confirmation.last-name.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen — stejná mezera jako u jména |
| `module-account.tax-confirmation.birth-number.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen — formát placeholderu "YYMMDDXXXX" implikuje očekávání, ale žádné BR neupravuje pravidlo kontrolní číslice/formátu |
| `module-account.tax-confirmation.address.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen |
| `module-account.tax-confirmation.ic.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen |
| `module-account.tax-confirmation.organization-tab.validation-error` | `Not observed — no validation copy captured` | žádný nenalezen — krok `UC0010` "organization: name and registration number"; samotná sada polí záložky "Právnická osoba" není zachycena |
| `module-account.tax-confirmation.zero-total.error` | `Not observed — no on-screen surface captured` | `BR-DonationConfirmationAndTax` (server-side pravidlo přerušení: vystavení potvrzení je přerušeno, když je vypočtený roční součet nulový, dle `UC0010` AF1) — BR/UC upravují přerušení narativně; zda/jak je toto zobrazeno uživateli na S012 je Uncertain, žádný text nepozorován |

`validationsWithoutTrigger`: žádný z výše uvedených řádků nemá řešitelný `BRxxxx`/`ENxxxx` nad rámec
jedné výjimky (`zero-total.error` → `BR-DonationConfirmationAndTax`, ačkoli i jeho zobrazení na
obrazovce zůstává nepotvrzené). Všechna pravidla validace formátu polí jméno/adresa/rodné
číslo/IČ/foto na úrovni pole jsou otevřené otázky bez vlastnícího BR — označeno k dořešení na
vrstvě BR, nikoli zde vymyšleno.

---

## CTA (výzvy k akci)

Každé CTA odkazuje na use case, který realizuje.

| Klíč | Text | Akce |
|---|---|---|
| `module-account.settings.save-cta` | `Uložit změny` | `UC0024` (UC0024.2 — úprava vlastního profilu: jméno, fotka) |
| `module-account.settings.photo-picker-link` | `vyberte v počítači` | `UC0024` (UC0024.2 — dílčí akce nahrání fotky; inline CTA stylizovaná jako odkaz uvnitř věty nápovědy k nahrání, otevírá výběr souboru) |
| `module-account.tax-confirmation.submit-cta` | `Ziskat potvrzení` | `UC0010` (UC0010.1–UC0010.2 — validace, dohledání Uživatele, výpočet celkové částky, persistence potvrzení, vykreslení PDF, odeslání e-mailu); verbatim překlep za "Získat" — pozorováno přesně tak, jak je vykresleno, neopraveno |

Pro S017 (mockup dashboardu — grafika mockupu nezobrazuje žádné viditelné CTA tlačítko v rámci
oříznutého zobrazení story-karty; vlastní CTA e-mailu "Dokončit účet" patří k obklopujícímu
chromu marketingového e-mailu/vrstvě MSG, nikoli k této obrazovce dashboardu) není pozorován žádný
text CTA, ani pro S018/S019/S020 (pro žádnou ze tří neexistuje záznam; `WIRE0021`/`WIRE0022`/`WIRE0023`
zaznamenávají jejich primární/sekundární akce jako Uncertain nebo Not evidenced).

---

## Konvence microcopy (Microcopy Conventions)

- Tón: neformálně-zdvořilý, přímé oslovení ("Vaše", "Potřebujete", "vám vystavíme").
- Osoba: 2. osoba jednotného čísla / zdvořilostní forma ("vy" register, např. "Váš e-mail", "Chci vykázat").
- Velká písmena: sentence case v rámci všech pozorovaných popisků a nadpisů (např. "Nastavení účtu",
  "Adresa trvalého bydliště"); i text tlačítek je v sentence case ("Uložit změny", "Ziskat potvrzení").
- Interpunkce: celé věty v nápovědném/upozorňujícím textu končí tečkou; popisky polí a text CTA
  tlačítek nemají koncové interpunkční znaménko.
- Pozorovaný překlep zachován verbatim: "Ziskat potvrzení" (chybějící diakritika u "Získat") — podle
  zásady evidence-first je přepsán přesně tak, jak je vykreslen, bez tichého opravení.

---

## Otevřené otázky (Open Questions)

1. Pro S018 (`zona/darce`, nad rámec config page-title z `EN0034`), S019 (`zona/zadatel`), ani S020
   (`zona/patron`) neexistuje screenshot — pro tyto tři obrazovky nelze přepsat žádné popisky polí,
   nadpisy (kromě S018 Probable "Moje zóna"), nápovědný text, text prázdného/načítacího/chybového
   stavu ani text CTA. Doporučuje se cílené znovu-zachycení, než bude možné dokončit inventuru
   copy pro tento rozsah u S018–S020.
2. Zda je hodnota roku u `module-account.tax-confirmation.year-checkbox-label` živý dynamický token
   (aktuální/předchozí kalendářní rok) nebo statický string zafixovaný na "2025" v pozorovaném
   sestavení, je Uncertain — zaznamenáno jako hypotéza tokenu `{year}`, nepotvrzeno vůči zdroji.
3. Sada polí záložky "Právnická osoba" (organizace), včetně jejích popisků a placeholderů, není
   zachycena na žádném ze screenshotů S012 — nelze pro ni přepsat žádný text (viz `WIRE0015` Open
   Question #2).
4. Zda stringy záložek "Pro vás" / "Všechny (N)" a text story-karty v mockupu dashboardu S017
   (`module-account.dashboard-mockup.*`) vůbec odrážejí nějakou reálně vytvořenou obrazovku, je
   nevyřešeno — převzato ze statusu Hypothesis-only dokumentu `WIRE0020`; nepovažovat za potvrzený
   current-state text.

---

## Evidence

| Oblast klíčů | Jistota | Evidence |
|---|---|---|
| S011 popisky, placeholdery, nápovědný text, CTA ("Nastavení účtu", "Vaše jméno a příjmení", "Váš e-mail", "Změnit profilovou fotku", nápověda k nahrání, "Uložit změny") | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu_nastaveni.png`; `_ar/evidence/ui/ui-observed-areas.md` §11 |
| S012 hero text, záložky, popisky/placeholdery polí, zaškrtávací pole roku, CTA odeslání, právní upozornění | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu.png`; `_ar/prtsc/po_prihlaseni_do_uctu_potvrzeni_o_darech.png`; `_ar/evidence/ui/ui-observed-areas.md` §12 |
| S012 sada polí záložky "Právnická osoba" | Evidence Pending — nezachyceno | `ui-observed-areas.md` §12 (ovládací prvek záložky pozorován, obsah nikoli) |
| S017 text mockupu dashboardu (záložky, banner, badge) | Confirmed (jako zobrazeno v grafice marketingového e-mailu); Hypothesis (jako text reálné obrazovky) | `_ar/prtsc/screencapture-mail-google-mail-u-1-2026-07-04-13_32_45.png` |
| S018 titulek stránky "Moje zóna" | Probable | `_ar/spec-draft/EN/EN0034_DonorAccountView.md` (config page-title `views.view.supporter_zone.yml`) |
| S018 text pole/řádku, S019, S020 (veškerý text) | Evidence Pending — nezachyceno | Žádný záznam v `ui-observed-areas.md`; žádný název souboru screenshotu v `_ar/prtsc/` neodpovídá žádné z těchto tří cest |
| Validační/chybový text (všechna pole, všechny obrazovky) | Uncertain — žádné BR nevlastní obsah validace na úrovni pole | `_ar/spec-draft/WIRE/WIRE0014_AccountSettingsProfile.md` Validation Surfaces; `_ar/spec-draft/WIRE/WIRE0015_TaxConfirmationRequest.md` Validation Surfaces |
| Mapování CTA na UC (`Uložit změny`→UC0024, `Ziskat potvrzení`→UC0010) | Confirmed | `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md`; `_ar/spec-draft/UC/UC0010_IssueDonationConfirmation.md` |
