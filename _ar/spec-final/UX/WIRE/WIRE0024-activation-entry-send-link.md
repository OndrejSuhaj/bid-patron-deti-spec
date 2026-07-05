---
doc_id: WIRE0024
title: Activation Entry Send Link
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S021
realizes_uc: [UC0014]
status: imported
references:
  - UC0014
  - EN0008
  - BR-AccessControlAndRoles
  - MSG0003
  - IA-patronus (S009, S010, S021, S022)
---

# WIRE0024 – Vstupní obrazovka aktivace – odeslání odkazu

## Účel

S021 (`/overit-prihlaseni`) je vstupní bod pro osobu, která už má v platformě implicitní záznam
strany — dárce, žadatel nebo Patron, jehož Contact/User (`EN0006`/`EN0008`) byl vytvořen na základě
předchozího daru nebo žádosti, ale která ještě nikdy neaktivovala přihlášení — a slouží k vyžádání
aktivačního odkazu na účet e-mailem. Customer zadá e-mailovou adresu, kterou použil při darování nebo
podávání žádosti, a systém na ni odešle aktivační odkaz. Tato obrazovka realizuje `UC0014` (předstupeň
vydání aktivačního odkazu, přidružený k UC0014.1/UC0014.3; sám o sobě není číslovaným krokem toku
UC0014 — viz Evidence). Aktér: Customer (neautentizovaný, má existující, ale neaktivovaný záznam
strany). Kontext vstupu: odkaz "Aktivujte si ho." na S009 (`/prihlaseni`), nebo přímá návštěva
`/overit-prihlaseni` (`_ar/spec-draft/IA/IA-patronus.md` §4, vstupní řádek `/overit-prihlaseni`).

*Poznámka k evidenci:* IA Screen Map (`_ar/spec-draft/IA-screen-map.md`, řádek S021) hodnotí tuto
obrazovku jako **Confirmed** a `_ar/evidence/ui/ui-observed-areas.md` §9 popisuje jako obsah této
obrazovky formulář (předvyplněné pole e-mailu, dvě CTA, vysvětlující text). Jediný screenshot citovaný
jako evidence tohoto oddílu — `screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`
— však při přímé kontrole pro tento WIRE průchod zobrazuje **pouze globální header, banner souhlasu s
cookies a globální footer**; tělo formuláře je mimo záběr, stejný vzorec záznamu, jaký je zdokumentován
jako otevřená mezera u sesterské obrazovky S022 (`_ar/spec-draft/UI-gap-open-questions.md` OQ-03).
Tento WIRE rekonstruuje obsah formuláře z textu `ui-observed-areas.md` §9 (posuzováno jako *Probable*,
nikoli samostatně *Confirmed* samotným obrázkem) a zaznamenává rozpor jako otevřenou otázku, aniž by
tiše povyšoval nebo snižoval hodnocení jednoho ze zdrojů.

---

## Rozvržení zón (Layout Zones)

- Header — globální navigace webu: logo "patron dětí", "Jak to funguje", "Blog", "O nás", CTA
  "Požádat o pomoc", "Můj účet" — stejný vzorec chrome, jaký je pozorován v celém webu
  (`_ar/evidence/ui/ui-observed-areas.md` §1). *Confirmed* (screenshot).
- Hlavní obsah — centrovaný jednosloupcový panel (vzorec odvozen ze sesterských obrazovek S009/S010;
  na tomto screenshotu není samostatně viditelný): nadpis/úvodní text, vstupní pole pro e-mail,
  primární CTA a sekundární odkaz. *Probable* — rekonstruováno pouze z textu `ui-observed-areas.md`
  §9.
- Sidebar — nepozorováno.
- Footer — globální footer webu (mission text, klastry navigačních odkazů, badge platebních
  poskytovatelů, číslo sbírkového účtu, právní odkazy, cookie banner) — stejný vzorec chrome, jaký je
  pozorován v celém webu. *Confirmed* (screenshot).

```
+--------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | Požádat  |
|        o pomoc (CTA) | Můj účet                         |
+--------------------------------------------------------+
| [cookie consent banner]                                 |
+--------------------------------------------------------+
|                                                          |
|   Heading: "Už jsem dárcem, žadatelem nebo Patronem      |
|   a chci aktivovat účet"                    (Probable)  |
|   Body: "Zde vyplňte svůj email, který jste použili      |
|   při přispění na příběh nebo v žádosti o dar. Odešleme  |
|   vám na něj aktivační odkaz."              (Probable)   |
|                                                          |
|   +--------------------------------------------------+ |
|   |  [ email input — pre-filled example value ]        | |
|   |  [ Poslat aktivační odkaz ]  (button)              | |
|   |  Zpět na přihlášení (link)                         | |
|   +--------------------------------------------------+ | (Probable — blok
|                                                          |  formuláře není
+--------------------------------------------------------+  vidět na citovaném
| Footer: mission blurb | nav clusters | contact | badges |  screenshotu)
+--------------------------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP agentem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`),
omezené na řádky, jejichž vlastní přítomnost na této obrazovce je *Confirmed* screenshotem; níže
uvedené řádky těla formuláře zůstávají `inline` na úrovni jistoty *Probable* (evidence pouze z textu —
viz Účel/Evidence). Zóny Main + Form společně koncepčně tvoří instanci `COMP0009` Single Email-Entry
Form (purpose=activation-request), přičemž dědí strop jistoty Probable této COMP pro tuto obrazovku.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | Sdílené chrome; navigační cíle vlastní IA. *Confirmed* (screenshot). Viz `COMP0002` Global Site Header. |
| Cookie consent banner | COMP0004 | — | Sdílené chrome v celém webu, nikoli specifické pro obrazovku. *Confirmed* (screenshot). Viz `COMP0004` Cookie Consent Banner. |
| Main — nadpis | inline | text nadpisu, "Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet" | Pouze minimální popisek — plný text vlastní vrstva COPY. Součást `COMP0009` (purpose=activation-request). *Probable* — `ui-observed-areas.md` §9 verbatim; není vidět v citovaném záběru screenshotu. |
| Main — text těla | inline | vysvětlující odstavec, "Zde vyplňte svůj email, který jste použili při přispění na příběh nebo v žádosti o dar. Odešleme vám na něj aktivační odkaz." | Pouze minimální výňatek — plný text vlastní vrstva COPY. Součást `COMP0009`. *Probable* — stejná výhrada jako výše. |
| Form — pole e-mailu | inline | jedno textové pole s popiskem "email", dle zdrojové poznámky pozorováno předvyplněné ukázkovou adresou | Vizuální styl popisku nepotvrzen (pouze vzorec dle textu §9). Součást `COMP0009`. *Probable* — není vidět v citovaném záběru screenshotu. |
| Form — primární CTA | inline | primární tlačítko, "Poslat aktivační odkaz" | Styl červeného/primárního tlačítka odpovídající stylu CTA v celém webu (dle sesterských obrazovek S009/S010); podobá se `COMP0001` Primary Button, ale nebylo povýšeno na úrovni řádku, protože vlastní přítomnost řádku na obrazovce je pouze *Probable*, nikoli Confirmed. |
| Form — sekundární odkaz | inline | textový odkaz, "Zpět na přihlášení" (→ S009) | Součást `COMP0009`. *Probable* — není vidět v citovaném záběru screenshotu. |
| Footer | COMP0003 | — | Sdílené chrome. *Confirmed* (screenshot). Viz `COMP0003` Global Site Footer. |

---

## Interakce

1. **Vstup** — Customer klikne na "Aktivujte si ho." na S009 (`/prihlaseni`), nebo přejde přímo na
   `/overit-prihlaseni` → stav: `default`. (`_ar/spec-draft/WIRE/WIRE0012_LoginMagicLink.md`
   interakce 4; `_ar/spec-draft/IA/IA-patronus.md` §4, vstupní řádek `/overit-prihlaseni`.)
   *Confirmed* (křížová reference IA/WIRE0012).
2. **Primární akce — vyžádání aktivačního odkazu** — Customer zadá e-mailovou adresu do pole "email"
   a klikne na "Poslat aktivační odkaz" → spustí odeslání aktivačního odkazu přidružené k `UC0014`
   (viz poznámka k evidenci v Účelu) → očekávaná následující obrazovka: S022
   (`/poslat-aktivacni-email`, potvrzení odeslání odkazu), dle `_ar/spec-draft/IA/IA-patronus.md` §5
   "Account activation / provisioning flow". *Probable* — cíl přechodu je dokumentován v IA, ale ani
   chování S021 po odeslání, ani skutečný obsah S022 nejsou přímo evidovány (S022 samotné je otevřená
   mezera, OQ-03).
3. **Sekundární akce — zpět na přihlášení** — kliknutí na "Zpět na přihlášení" → přechod na S009
   (`/prihlaseni`). *Probable* — odvozeno z reprezentativního verbatim seznamu CTA v §9; přesný cílový
   screen odvozen z názvu, nikoli samostatně potvrzen zachyceným odkazem/href.
4. **Odchod** — Customer odejde přes navigaci v headeru/footeru (každá je navigační cíl vlastněný IA,
   zde neopakováno). *Confirmed* (screenshot, pouze chrome).

---

## Stavy

### default
Formulář pro zadání e-mailu: pole "email" předvyplněné ukázkovou adresou dle `ui-observed-areas.md`
§9 ("pre-filled o.suhaj@gmail.com" v podkladové poznámce k zachycení evidence), tlačítko "Poslat
aktivační odkaz", sekundární odkaz "Zpět na přihlášení". Žádná validační zpráva nedokumentována.
*Probable* — obsah tohoto stavu není vidět v záběru screenshotu, který byl pro tento WIRE průchod
skutečně kontrolován; viz poznámka k evidenci v Účelu.

### empty
`N/A — no distinct empty-state applies`. Jde o formulář s jediným polem, nikoli o výpis; neexistuje
tedy stav "žádné položky" k zobrazení.

### loading
`Evidence Pending — not captured`. Pro tuto obrazovku není dokumentován žádný stav probíhajícího
načítání/spinneru. Zda tlačítko zobrazí spinner, deaktivuje se, nebo je přechod na S022 okamžitý, je
Uncertain.

### error
`Evidence Pending — not captured`. Žádný zdroj (screenshot ani `ui-observed-areas.md`) nedokumentuje
validační nebo odesílací chybu na této obrazovce (např. neplatný formát e-mailu, neznámý e-mail bez
odpovídajícího záznamu strany). Zaznamenáno jako otevřená otázka, nikoli tvrzeno; viz Validation
Surfaces níže.

---

## Validation Surfaces

| Pole/Zóna | Spouštěč (BR-id) | Projev |
|---|---|---|
| Pole "email" — validace povinnosti/formátu | *(none identified)* | Evidence Pending — `ui-observed-areas.md` §9 explicitně uvádí "form ready / pre-filled, no validation shown"; zda probíhá kontrola formátu na straně klienta nebo zamítnutí na straně serveru, je Uncertain. |
| Odeslání s e-mailem, který neodpovídá žádnému existujícímu Contact/User | *(none identified)* | Evidence Pending — nedokumentováno v žádném zdroji; Uncertain, zda systém odhalí existenci účtu (bezpečnostně relevantní chování), nebo vždy zobrazí obecné potvrzení "odkaz odeslán" bez ohledu na shodu. |

**validationsWithoutBR:**
- Zda pole "email" vynucuje pravidlo povinnosti/formátu před odeslením, není pozorováno. Nebylo
  nalezeno žádné BR upravující klientsky viditelnou validační odezvu na tomto konkrétním formuláři —
  `BR-AccessControlAndRoles` se týká flood-control politiky a expirace magic-link tokenu, nikoli
  validace vstupů na úrovni formuláře na obrazovce žádosti o aktivaci. **Otevřená otázka.**
- Zda jsou opakované žádosti o aktivační odkaz pro stejný e-mail omezovány (throttling), je Uncertain.
  Poznámka `BR-AccessControlAndRoles` k flood-control v současném stavu je omezena na ochranu proti
  brute-force útokům při přihlašování, nikoli na omezení frekvence žádostí o aktivační odkaz — žádné
  BR tuto oblast nepokrývá. **Otevřená otázka.**
- Zda se odpověď liší (nebo je záměrně identická, z důvodu bezpečnosti proti enumeraci) mezi
  odpovídajícím a neodpovídajícím e-mailem, není pokryto žádným BR nalezeným v tomto rekonstrukčním
  průchodu. **Otevřená otázka.**

---

## Data Bindings

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Odeslání formuláře → odeslání aktivačního odkazu | `EN0008` | — | Odeslání e-mailu má dle očekávání vyhledat odpovídajícího `EN0008` User (atribut přihlašovacího e-mailu) nebo jeho propojený `EN0006` Contact a spustit odeslání aktivačního e-mailu (`MSG0003`, dle řádku "Transactional-email surfaces" v `_ar/spec-draft/IA-screen-map.md`). Na této obrazovce se nezobrazují žádná data zpět. *Probable* — mechanika vyhledání/odeslání není přímo evidována modelovanými toky UC0014 (viz Evidence). |

---

## Conditional Visibility

| Komponenta/Zóna | Podmínka (ACL nebo ref. BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nic evidováno | Nebylo nalezeno žádné omezení dle role — S021 je záměrně neautentizovaný vstupní bod (`_ar/spec-draft/IA/IA-patronus.md` §4: dosažitelná z S009 "Aktivujte si ho." nebo přímou návštěvou, bez nutnosti autentizace). Vrstva ACL v této rekonstrukci neexistuje. Zda je již přihlášený Customer navštěvující `/overit-prihlaseni` přímo přesměrován jinam, je Uncertain — nepozorováno; **Otevřená otázka.** |

---

## Accessibility Notes

Evidence Pending — záběr screenshotu skutečně dostupný pro tuto obrazovku zobrazuje pouze chrome
(header, cookie banner, footer), takže nelze zkontrolovat DOM strukturu, role ARIA ani chování
klávesnice pro samotný formulář. Následující body jsou Uncertain a nejsou vymyšlené:

- **Pořadí tabulátoru:** Uncertain — dle pořadí v textu §9 pravděpodobně pole e-mailu → tlačítko
  odeslat → odkaz "Zpět na přihlášení", ale nepotvrzeno žádným záznamem.
- **Focus při vstupu:** Uncertain — zda pole e-mailu získává autofocus, nebo si zachovává předvyplněnou
  ukázkovou hodnotu, kterou musí uživatel vymazat, nelze pozorovat.
- **Focus při přechodu stavu:** Uncertain — zda se focus přesouvá při přechodu na S022, není
  evidováno.
- **Landmarky:** Uncertain — žádná evidence DOM/ARIA není k dispozici.
- **Klávesové zkratky:** nic evidováno.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Globální chrome header/footer/cookie-banner přítomný na této obrazovce | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png` (přímo zkontrolováno: zobrazuje pouze nav, cookie banner, footer) |
| Obrazovka realizuje UC0014 (předstupeň vydání aktivačního odkazu) | Confirmed | `_ar/spec-draft/UC/UC0014_AuthenticateManageAccess.md`; `_ar/spec-draft/IA-screen-map.md` řádek S021 |
| Obsah formuláře: nadpis, text těla, pole "email" (předvyplněné), CTA "Poslat aktivační odkaz" / "Zpět na přihlášení" | Probable | `_ar/evidence/ui/ui-observed-areas.md` §9 (textový popis); **není samostatně vidět** v souboru screenshotu citovaném jako evidence tohoto oddílu — viz poznámka k evidenci v Účelu a Otevřené otázky |
| Cíl přechodu po odeslání je S022 | Probable | `_ar/spec-draft/IA/IA-patronus.md` §5 "Account activation / provisioning flow" krok 2→3 |
| Stav loading, stav error, validační odezva pole formuláře | Evidence Pending / Uncertain | Nezachyceno v žádném zdroji; nebylo nalezeno žádné BR upravující zobrazení validace na úrovni formuláře — označeno jako Otevřená otázka výše |
| Odeslaný aktivační e-mail je MSG0003 | Probable | `_ar/spec-draft/IA-screen-map.md` řádek "Transactional-email surfaces" |

---

## Open Questions

- **OQ-WIRE0024-1** — Screenshot citovaný v `_ar/evidence/ui/ui-observed-areas.md` §9
  (`screencapture-patrondeti-cz-overit-prihlaseni-2026-07-04-13_33_25.png`) při přímé kontrole
  zobrazuje pouze globální header, banner souhlasu s cookies a footer — stejný vzorec
  chrome-only/tělo-mimo-záběr, jaký je již zaznamenán u sesterské obrazovky S022 (OQ-03 v
  `_ar/spec-draft/UI-gap-open-questions.md`). Obsah formuláře v tomto WIRE je rekonstruován pouze z
  textu §9, a je proto *Probable*, nikoli *Confirmed*, navzdory tomu, že IA Screen Map hodnotí S021
  jako "Confirmed". **Potřebné řešení:** znovu zachytit `/overit-prihlaseni` se formulářem v záběru,
  nebo potvrdit původní zdroj evidence textu §9 (může jít o jiný, neindexovaný záznam nebo přímé
  čtení zdroje/šablony). Doporučuje se sladit hodnocení "Confirmed" IA Screen Map pro S021 s tímto
  zjištěním.
- **OQ-WIRE0024-2** — Stavy loading a error jsou zcela neevidované (viz sekce Stavy výše).
- **OQ-WIRE0024-3** — Žádné BR neupravuje validaci na úrovni formuláře, omezení opakovaných žádostí
  (throttling), ani chování z hlediska bezpečnosti proti enumeraci na této obrazovce (viz
  validationsWithoutBR výše).
