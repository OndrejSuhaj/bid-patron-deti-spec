---
doc_id: WIRE0025
title: Activation Link Sent
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S022
realizes_uc: [UC0014]
status: imported
references:
  - UC0014
  - EN0008
  - EN0006
  - BR-AccessControlAndRoles
---

# WIRE0025 – Odeslání aktivačního odkazu

## Účel

`/poslat-aktivacni-email` je plocha namapovaná v IA, na kterou se Customer dostane po odeslání
formuláře žádosti o aktivaci na S021 (`/overit-prihlaseni`), jako součást bezheslové cesty
aktivace / samoobslužného přihlášení v rámci `UC0014` (Authenticate & Manage Access — větev vystavení
magic-link odkazu). Podle IA Screen Map je jejím zamýšleným účelem **potvrzení "odkaz odeslán"**:
potvrzení, že aktivační odkaz byl zaslán e-mailem na adresu, kterou Customer zadal. **Tento účel je
deklarován vrstvou IA, nikoli potvrzen obsahem obrazovky** — viz Evidence a Otevřená otázka níže.

Aktér: neautentizovaná existující strana (dárce / žadatel / Patron dle textu na S021), která právě
požádala o aktivační odkaz.

## Otevřená otázka — obsah obrazovky nedoložen

Oba dostupné snímky pro route `/poslat-aktivacni-email` zobrazují **pouze chrome webu (hlavičkovou
navigaci, cookie lištu, celé footer)** kolem těla, které je pixel-pro-pixel **formulářem S021**
("Už jsem dárcem, žadatelem nebo Patronem a chci aktivovat účet" — pole e-mail + tlačítko "Poslat
aktivační odkaz" + odkaz "Zpět na přihlášení"), nikoli samostatnou potvrzující zprávou "odkaz
odeslán". To odpovídá existujícímu nálezu IA (`IA-patronus.md` §8 IA-Q9; `UI-gap-open-questions.md`
OQ-03): "tělo potvrzení je mimo záběr — nepovažovat za obsahovou evidenci." **Klasifikace:
Uncertain / evidence-blocked.** Níže není bez tohoto upozornění tvrzeno žádné rozvržení, text ani
komponenta specifická pro potvrzení. Tato skutečnost nebrání existenci dokumentu WIRE, protože
`screen_id` (`S022`) a `realizes_uc` (`UC0014`) jsou stanoveny vrstvou IA; pouze *vlastní* obsah těla
obrazovky čeká na nové zachycení nebo na evidenci ze zdroje/šablony.

---

## Zóny rozvržení

Potvrzené zóny (společný globální chrome, identický na obou snímcích S022 a konzistentní s ostatními
obrazovkami Patronus, např. S021):

- **Header** — globální navigace webu: logo "patron dětí", "Jak to funguje", "Blog", "O nás",
  "Požádat o pomoc" (primární CTA), "Můj účet" (vstup do účtu, neautentizovaný stav). — *Confirmed*
- **Main content** — **nedoloženo pro skutečný potvrzující stav této obrazovky**; oba snímky
  zobrazují tělo žádacího formuláře S021 místo potvrzení "odkaz odeslán". — *Uncertain*
- **Cookie-consent banner** — dole fixovaný pruh: ikona cookie + "Tyto stránky používají k poskytování
  služeb soubory cookie. Používáním tohoto webu s tím souhlasíte." + odkaz "Další informace". —
  *Confirmed (celowebové, nikoli specifické pro obrazovku)*
- **Footer** — brandový blok "patron dětí" + text mise + odkaz na Facebook + "Nadace Sirius" +
  číslo veřejné sbírky; sloupec odkazů "Patron dětí" (O nás / Blog / Pravidla poskytování
  pomoci / Naše desatero / Splněné příběhy / Výroční zprávy / Jak jsme pomáhali v době koronakrize);
  sloupec "Kontakt" (e-mail info@patrondeti.cz); pruh platebních poskytovatelů (Comgate, Mastercard,
  Visa) + "Číslo sbírkového účtu: 57574646/0600"; spodní lišta (odkaz na GDPR souhlas, "Chci přihlásit
  příběh", copyright). — *Confirmed (celowebové, nikoli specifické pro obrazovku)*

```
+--------------------------------------------------+
| Header (global nav)                               |
+--------------------------------------------------+
| Main content — NOT EVIDENCED for this screen      |
| (captures show S021 form instead; see Open        |
| Question above)                                   |
+--------------------------------------------------+
| Cookie-consent banner (global)                    |
+--------------------------------------------------+
| Footer (global)                                   |
+--------------------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP nástrojem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`),
omezené na řádky chrome, jejichž vlastní přítomnost na této obrazovce je *Confirmed* screenshotem.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | Confirmed present; nejde o komponentu specifickou pro obrazovku. Viz `COMP0002` Global Site Header. |
| Main content | inline | — | **Uncertain** — pro skutečné tělo potvrzení nebyla potvrzena žádná komponenta; nic se netvrdí. Bylo zjištěno, že oba screenshoty této obrazovky zobrazují místo toho obsah formuláře `WIRE0024` (viz `COMP0009` Open Questions) — nepovýšeno do vyřešení. |
| Cookie banner | COMP0004 | — | Confirmed present; celowebové, nikoli specifické pro obrazovku. Viz `COMP0004` Cookie Consent Banner. |
| Footer | COMP0003 | — | Confirmed present; celowebové, nikoli specifické pro obrazovku. Viz `COMP0003` Global Site Footer. |

---

## Interakce

1. **Vstup** — Customer odešle formulář žádosti o aktivaci na S021 (`/overit-prihlaseni`) →
   přesměrování/vykreslení na `/poslat-aktivacni-email` → stav: `default` (zamýšlené: potvrzující
   zpráva). *Vstupní route potvrzena mapováním URL/IA; výsledný vykreslený stav je Uncertain
   (viz Otevřená otázka).*
2. **Primární akce** — žádná potvrzena. Pokud je obrazovka čistým potvrzením (dle jejího IA-deklarovaného
   účelu), nemusí mít žádnou primární akci nad rámec potvrzení — **Uncertain, nedoloženo**.
3. **Sekundární akce** — žádná potvrzena v zachyceném chrome specifickém pro hlavní obsah této
   obrazovky.
4. **Výstup** — globální navigace ("Můj účet", "Požádat o pomoc", logo) zůstává k dispozici jako
   úniková cesta, v souladu s potvrzenou přítomností header; žádný ovládací prvek specifický pro tuto
   obrazovku pro výstup není doložen.

Realizuje `UC0014` (dílčí tok magic-link/žádost o aktivaci) na úrovni IA-mapování; žádný krok UC
nelze zde přiřadit ke konkrétnímu ovládacímu prvku na obrazovce, protože obsah nesoucí ovládací prvky
není doložen.

---

## Stavy

### default
**Uncertain — nedoloženo.** IA deklaruje účel této obrazovky jako potvrzení odeslání aktivačního
odkazu, ale žádný snímek toto tělo potvrzení nezobrazuje; oba dostupné screenshoty místo toho
vykreslují formulář S021. Nepovažovat za obsahovou evidenci (viz Otevřená otázka).

### empty
`N/A — no confirmed content to have an empty variant of; not evidenced.`

### loading
`N/A — not evidenced; no async indicator observed in either capture.`

### error
`N/A — not evidenced; no error-display evidence for this screen (e.g. invalid-email / send-failure
messaging is not visible in the captured chrome). Note: UC0014 AF4/AF5 describe adjacent
token/registration failure paths at the UC level, but no on-screen error surface for this specific
screen is confirmed.`

---

## Validační plochy

Na této obrazovce nic potvrzeno. Validace formátu e-mailu / povinného pole implikovaná
*předcházejícím* formulářem S021 je mimo rozsah tohoto WIRE (patří k vlastnímu wireframu S021, nikoli
S022). Žádná validační plocha specifická pro tělo potvrzení S022 není doložena.

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| — | — | pro tuto obrazovku nic doloženo |

**validationsWithoutBR:** nic nevzneseno — pro tuto obrazovku není tvrzena žádná validační plocha,
takže není co nechat bez referencí na BR.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Main content (intended) | `EN0008` | — | *Assumed* — pokud zamýšlené potvrzení zobrazuje nebo odkazuje na odeslanou e-mailovou adresu, tato hodnota by pocházela z vyhledání User (`EN0008`) / Contact (`EN0006`) provedeného krokem vystavení magic-link odkazu v `UC0014`; na obrazovce nepotvrzeno, protože obsah není doložen. |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Odkaz "Můj účet" v header | stav header neautentizovaný-vs-autentizovaný (`BR-AccessControlAndRoles`) | Confirmed: zobrazeno jako "Můj účet" pro neautentizovaného Customera na této obrazovce, v souladu s ostatními obrazovkami před přihlášením (S009, S021); vrstva ACL ještě není naplněna, takže neexistuje žádné `ACLxxxx` id k citaci. |
| Main content (tělo potvrzení) | n/a | **Uncertain** — pro nedoložený obsah nelze tvrdit žádnou logiku podmíněné viditelnosti. |

---

## Poznámky k přístupnosti

- **Pořadí tabulace:** Nedoloženo pro obsah specifický pro obrazovku; pořadí tabulace globálního
  header/footer je konzistentní s ostatními obrazovkami Patronus (logo → navigační odkazy → "Požádat
  o pomoc" → "Můj účet").
- **Fokus při vstupu:** Uncertain — nedoloženo.
- **Fokus při přechodu stavu:** Uncertain — nedoloženo (žádný přechod stavu nebyl zaznamenán).
- **Landmarks:** Header/footer používají standardní celowebovou strukturu landmarks (potvrzeno
  konzistentním chrome napříč zachycenými obrazovkami); role landmark hlavního obsahu specificky pro
  tuto obrazovku je Uncertain.
- **Klávesové zkratky:** Žádné zaznamenány; žádné se pro obrazovku typu potvrzení neočekávají.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Chrome header / cookie banner / footer | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_23_37.png`, `_ar/prtsc/screencapture-patrondeti-cz-poslat-aktivacni-email-2026-07-04-13_31_22.png` |
| Main content = potvrzení "odkaz odeslán" (IA-deklarovaný účel) | Uncertain | `_ar/evidence/ui/ui-observed-areas.md` §10; `_ar/spec-draft/IA/IA-patronus.md` §8 IA-Q9; `_ar/spec-draft/UI-gap-open-questions.md` OQ-03; `_ar/spec-draft/IA-screen-map.md` row S022 (certainty: Uncertain) |
| Obrazovka realizuje `UC0014` | Probable | `_ar/spec-draft/IA-screen-map.md` row S022; `_ar/spec-draft/IA/IA-patronus.md` line 258 |
| Zachycené tělo je ve skutečnosti formulář S021, nikoli samostatné potvrzení | Confirmed (visual, this pass) | oba screenshoty výše — obsah těla, placeholder pole ("E-mail" / předvyplněné "o.suhaj@gmail.com"), nadpis a CTA jsou identické se zachyceným formulářem S021 |

**Otevřená otázka přenesená dále (tímto WIRE nevyřešena):** IA-Q9 / OQ-03 — znovu zachytit skutečné
vykreslení potvrzení po odeslání na `/poslat-aktivacni-email`, nebo prozkoumat šablonu/controller
route ve zdrojovém kódu, aby se určil skutečný obsah potvrzení, než tento WIRE může posunout svou
zónu main content dál od stavu Evidence-Pending.
