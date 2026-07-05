---
doc_id: COMP0021
title: Input
layer: COMP
spec_type: component
modules: []
status: imported
references:
  - WIRE0002
  - WIRE0006
  - WIRE0007
  - WIRE0009
  - WIRE0010
  - WIRE0012
  - WIRE0013
  - WIRE0014
  - WIRE0015
  - WIRE0024
  - COMP0001
  - COMP0009
  - COMP0010
  - EN0004
  - EN0006
  - EN0008
  - DESIGN-component-index
  - DESIGN-tokens
---

# COMP0021 – Input

*(povýšeno z inline evidence; kanonická @patron/ui komponenta: Input)*

> **Poznámka k povýšení.** Tato komponenta zůstala v rekonstrukci **inline**. Každé textové/numerické
> pole pozorované na obrazovkách WIRE (`WIRE0002`, `WIRE0006`, `WIRE0007`, `WIRE0009`, `WIRE0010`,
> `WIRE0012`, `WIRE0013`, `WIRE0014`, `WIRE0015`, `WIRE0024` a další) bylo zaznamenáno jako holé
> `inline` pole — "obecný textový input", který se rekonstrukce vědomě rozhodla nepovyšovat na
> samostatný COMP, podle `_ar/evidence/design-system/components.md` §2 mapovacího řádku "Input":
> *"Obě strany vědomě zacházejí s holým polem jako s primitivem; kanonická knihovna přesto dodává
> stylizovaný atom `Input`. Nízkoprioritní sladění."* Zde je povýšena **jako kanonický cílový
> kontrakt** (`DESIGN-component-index.md` §1 řádek 2, `_ar/evidence/design-system/components.md` §1
> "Input"), podle instrukce, s current-state pozorováním rekonstruovaným níže jako jasně oddělená,
> neautoritativní sekce. Podle pravidla current-vs-target z projektové konstituce se tyto dvě věci
> nesmí zaměňovat: kanonický kontrakt níže popisuje atom **pro rebuild**; current-state sekce popisuje,
> co dnes skutečně vykreslují živá textová pole Patronu — což zůstává samostatně evidováno a na úrovni
> DOM/chování z velké části `Uncertain`.

---

## Design-system alignment (target — @patron/ui + @patron/tokens)

> **STATE: TARGET — `@patron/ui` `Input` (Atom).** Tato sekce je **autoritativní kanonický
> kontrakt**, vycházející z `DESIGN-component-index.md` §1 řádek 2 a
> `_ar/evidence/design-system/components.md` §1 "Input". Má stejnou úroveň autority jako
> `it-zadani` (budoucí/cílový designový podklad) — **není** current-state pravdou — a nesmí být
> zpětně promítána do sekce "Current-state (observed)" níže.

### Kanonická identita

- **Název:** `Input` (komponenta úrovně Atom, `packages/ui/src/components/Input/`).
- **Exportovaný typ props:** `InputProps`.
- **Storybook příběhy:** `Text`, `Číslo`, `Vypnuté`.
- **Účel:** holý textový/numerický atom formulářového pole. Named use cases v katalogu: vlastní
  částka příspěvku uvnitř `DonationBox` (`COMP0010`) dnes a budoucí donation modal
  (e-mail/souhlasy/platba — explicitně "Mimo scope" u `DonationBox`, podle
  `_ar/evidence/design-system/components.md` §1 "DonationBox"). Komponenta je **záměrně
  holá** — nevykresluje žádný `<label>` ani vlastní chybové stylování; spárování s viditelným
  labelem a chybovým textem je **odpovědností konzumenta**.

### Props / Inputs (kanonické)

| Název | Typ | Povinné | Výchozí | Popis |
|---|---|---|---|---|
| `type`, `value`, `placeholder`, `onChange`, `aria-label`, `inputMode`, `disabled`, … | nativní `InputHTMLAttributes<HTMLInputElement>` | ne (podle atributu) | nativní výchozí hodnoty | Komponenta předává celou nativní atributovou plochu `<input>`; nedodává žádnou vlastní custom prop mimo `className`. |
| `className` | `string` | ne | — | Stylový hook pro konzumenta (pouze kompozice — nenese hodnoty vlastněné tokeny podle §10 `DESIGN-tokens.md`). |

Exportovaný typ: `InputProps`. **Neexistuje prop `variant` ani `size`** — jedinou osou tvaru je
libovolný nativní `type`, který konzument nastaví (např. `text`, `number`, `email`).

### Varianty / stavy (kanonické)

- **Varianty:** žádné. Vykreslení rozlišuje pouze nativní atribut `type` (např. `text` vs.
  `number`); toto není modelováno jako osa `variant` na úrovni komponenty.
- **Velikosti:** žádné — jediná pevná velikost ovládacího prvku.
- **Stavy:**
  - `default` — okraj `color.border`, plocha `color.surface`.
  - `focus` — kroužek se řídí `color.accent`.
  - `disabled` — nativní atribut `disabled`; vizuál podle příběhu `Vypnuté`.
  - `error` — **komponenta jej sama nevykresluje.** Konzument musí signalizovat chybový stav pomocí
    `aria-invalid` a spárovat jej s vlastním viditelným chybovým textem; `Input` nenese žádné
    vestavěné chybové stylování ani slot pro zprávu.

### Sloty tokenů (kanonické)

`var(--font-body)`, `var(--radius-control)`, `var(--color-border)`, `var(--color-surface)`,
`var(--color-text)`, `var(--color-muted)`, `var(--color-accent)`.

Podle `DESIGN-tokens.md` §3.1/§6/§10: `--color-border` je výchozí obrys (`color.border`,
tenant-bound: CZ `#EEDDD5` / RO `#D6E7E6`); `--color-surface` je pozadí pole (`#FFFFFF` u obou
tenantů); `--color-text` / `--color-muted` stylují zadanou hodnotu vs. text placeholderu;
`--color-accent` je barva focus-kroužku (CZ `#6D4AFF` / RO `#FF7A2F`) — stejný slot, ze kterého čte
každý jiný fokusovatelný atom v knihovně, podle `DESIGN-tokens.md` §3.1 "focus ring nemá vlastní
slot"; `--radius-control` dává poli jeho rádius rohů (CZ `10px` / RO `16px`); `--font-body` nastavuje
písmo (`'Hanken Grotesk'`, sdílené oběma tenanty). Vše se čerpá přes `var(--…)` v přidruženém CSS
modulu komponenty — žádné literály hex/px (`DESIGN-tokens.md` §10).

### Přístupnost (kanonická)

- **ARIA role:** dědí nativní semantiku `<input>` — žádná custom role.
- **Labelování:** **komponenta nevykresluje žádný `<label>`.** Podle poznámek A11y v
  `DESIGN-component-index.md` §1 řádek 2 musí konzument spárovat `Input` s viditelným `<label>`
  a/nebo `aria-label`; jde o dokumentovaný požadavek kontraktu, nikoli o opomenutí.
- **Signalizace chyby:** `Input` **sám nevykresluje žádný chybový styl** — konzumující composite
  musí signalizovat chybový stav pomocí `aria-invalid` a dodat vlastní viditelný chybový text vedle
  pole.
- **Navigace klávesnicí:** nativní chování tab-stop a editace textu `<input>` (atom nepřidává žádné
  vlastní ošetření klávesnice).
- **Správa focusu:** focus-visible kroužek se řídí `color.accent`, konzistentně s každým jiným
  interaktivním atomem v knihovně (`Button`, `RailCta`, `ShareRow`).
- **Čtečka obrazovky:** ohlašuje podle toho, jaký nativní `type`/`aria-label`/přidružený `<label>`
  konzument dodá; samotný atom nepřidává žádné chování specifické pro čtečky obrazovky.

### Chování podle tenanta (CZ/RO)

- **Theme-neutral.** `Input` nemá žádnou prop pro volbu tenanta — jeho čtyři vizuální vlastnosti
  řízené tokeny (okraj, plocha, rádius, focus kroužek) se řeší čistě přes `data-theme="cz"|"ro"`,
  které remapuje sloty tokenů výše; neexistuje žádná vidlice kódu komponenty ani CZ/RO-specifická
  prop.
- Protože nevykresluje žádný vlastní label/text, nemá atom sám žádnou vlastní lokalizační plochu —
  jakýkoli lokalizovaný text placeholderu/labelu je zcela odpovědností konzumenta (např. prop
  `customInputLabel` u `DonationBox`).

### Kompozice (kanonická)

Listová komponenta — nic nesloučuje. Je sama komponována:

- v `DonationBox` (cílová design-system alignment u `COMP0010` — dosud bez rekonstruovaného
  current-state COMP) — pole vlastní ("Jiná") částky příspěvku.
- v budoucím donation modalu (e-mail/souhlasy/platba) — pojmenovaném jako explicitní hranice "Mimo
  scope" u `DonationBox`; v kanonické knihovně ještě není postaven jako composite.

```
Input (canonical, target)
  (leaf — no sub-components)
```

### Zdrojové odkazy

`DESIGN-component-index.md` §1 řádek 2 (indexová tabulka); úplný katalogový záznam
`_ar/evidence/design-system/components.md` §1 "Input — `components/Input/`" a mapovací řádek §2
"Input" (klasifikace `GAP→recon (by design both sides)`); hodnoty tokenů `DESIGN-tokens.md` §3.1
(`color.border`, `color.surface`, `color.text`, `color.muted`, `color.accent`), §6 (`radius.control`),
§10 (pojmenování CSS proměnných). Kanonická zdrojová cesta:
`/Users/o.suhajgmail.com/Developer/Argo22/bid-patron-deti/packages/ui/src/components/Input/`
(`Input.tsx`, `Input.stories.tsx`, `Input.module.css`, `Input.contract.md`, `index.ts`).

---

## Current-state (observed)

> Sekce níže dokumentuje **current-state UI Patronu, jak je pozorováno na screenshotech živého
> webu**. Jde o evidence-gated rekonstrukční obsah, záměrně oddělený od kanonického cílového
> kontraktu výše. Nic v této sekci nemá být čteno jako popis design systému pro rebuild.

### Účel

Holé jednořádkové textové/numerické formulářové pole, opakovaně pozorované téměř na každé
formulářové obrazovce v rekonstrukci, vždy zaznamenané jako `inline` (nikdy samostatně nepovýšené),
protože rekonstrukce považovala prosté textové pole za příliš obecný/všudypřítomný primitiv, aby si
zasloužilo vlastní COMP bez rozlišujícího vizuálního/behaviorálního kontraktu — rozhodnutí, které
kanonické mapování později potvrzuje jako "by design both sides" (`_ar/evidence/design-system/components.md`
§2). Reprezentativní pozorované výskyty:

1. **Pole částky v postranním panelu daru na detailu příběhu** (`WIRE0002`) — numerické pole "Chci
   darovat", přípona Kč, předvyplněno `50`; na téže stránce pozorovány **dvě instance nad sebou**
   (nevyřešená "Open Question" ve `WIRE0002` o možném duplicitním vykreslení postranního panelu,
   nikoli vlastní defekt této komponenty).
2. **Pole v donation modalu** (`WIRE0002`) — pole částky v hlavičce modalu (přípona Kč, předvyplněno
   `50`, editovatelné) + kontaktní pole (E-mail povinný, telefon s fixním prefixovým segmentem
   "+420", Jméno, Příjmení).
3. **Pole e-mailu pro passwordless přihlášení / žádost o aktivaci** (`WIRE0012`, `WIRE0024`) —
   jednořádkové pole, placeholder "E-mail", součást `COMP0009` Single Email-Entry Form.
4. **Kroky 1–4 wizardu žádosti** (`WIRE0007` jméno dítěte/rodné číslo/"jaké je vaše dítě",
   `WIRE0009` jméno žadatele/rodné číslo/adresa/město/PSČ/e-mail, `WIRE0010` jméno patrona/e-mail/
   telefon) — vícero jednořádkových textových polí na krok, několik s duálními inline nápovědními
   labely (např. "Rodné číslo dítěte (cizinec: číslo pojištěnce)").
5. **Kontaktní/consent brána** (`WIRE0006`) — pole e-mailu + pole telefonu s fixním needitovatelným
   prefixovým segmentem "+420" (pozorováno pouze CZ; chování prefixu pro RO/MD `Uncertain`, žádná
   evidence nezachycena).
6. **Aktivace účtu / nastavení hesla** (`WIRE0013`) — předvyplněné, read-only stylované pole
   e-mailu (šedé pozadí, žádný červený obrys) + pole hesla s přímo pozorovaným červeným obrysem
   validační chyby.
7. **Nastavení účtu / profil** (`WIRE0014`) — skupina polí jména (dva vedle sebe umístěné inputy) +
   skupina pole e-mailu, obě opatřené labelem (odklon od vzoru placeholder-jako-label vídaného jinde).
8. **Žádost o potvrzení o daru** (`WIRE0015`) — Jméno/Příjmení, adresa, rodné číslo bez lomítka a
   podmíněné pole "Fyzická osoba s IČ", vše jednořádková textová pole.

### Props / Inputs (jak pozorováno)

Není k dispozici žádná evidence DOM/props (pouze statické screenshoty). Rekonstruované fakty na
úrovni pole, po jednotlivých výskytech, nepotvrzené jako vlastní props sdílené komponenty:

| Název (rekonstruovaný) | Typ | Popis |
|---|---|---|
| `placeholder` | `string` | Dominantní pozorovaný vzor labelování: text placeholderu zastupuje jediný viditelný label pole (např. "E-mail", "Jméno", "Příjmení", "Telefon") — potvrzeno ve `WIRE0006`, `WIRE0009`, `WIRE0012`, `WIRE0024`. |
| `value` (předvyplněno) | `string`/`number` | Některá pole vykreslují předvyplněnou hodnotu (částka daru `50` ve `WIRE0002`; e-mailová adresa v read-only stylovaném poli `WIRE0013`). |
| fixní prefixový segment | n/a | Pole telefonu ve `WIRE0006`/`WIRE0010` vykreslují needitovatelný segment "+420" před editovatelnými číslicemi — vzor kompozitního pole bez evidovaného kanonického protějšku (kanonický atom `Input` nemá koncept prefixového segmentu). |
| explicitní `<label>` | n/a | Přítomen na některých pozdějších obrazovkách (`WIRE0014` "Vaše jméno a příjmení", "Váš e-mail") — nekonzistentní se vzorem placeholder-jako-label vídaným jinde, tj. current-state chování labelování **není jednotné** napříč produktem. |

### Varianty (jak pozorováno)

`Uncertain` — napříč výskyty nebyla potvrzena žádná odlišná osa varianty tvaru/velikosti; pozorované
vizuální rozdíly (pole na celou šířku vs. párovaná pole vedle sebe, kompozitní prefix+pole) se jeví
jako varianty na **úrovni layoutu** (vlastněné WIRE), nikoli na úrovni komponenty, ale toto nelze ze
statických screenshotů zcela rozlišit.

### Stavy

#### idle
Výchozí jednořádkové vykreslení, text placeholderu nebo labelu podle dostupnosti. Potvrzeno ve
všech citovaných výskytech WIRE (viz jednotlivé citace screenshotů ve vlastní tabulce Evidence
každého dokumentu WIRE).

#### hover
`Uncertain — nelze pozorovat ze statické evidence.`

#### focused
`Uncertain — nelze pozorovat ze statické evidence.`

#### disabled
Read-only stylovaná varianta pozorována jednou: předvyplněné pole e-mailu ve `WIRE0013` se
vykresluje se šedým pozadím a bez červeného obrysu, odlišně od aktivního/editovatelného pole hesla
vedle něj. Zda se jedná o skutečný HTML stav `disabled`, nebo o ošetření pouze pomocí
`readonly`/CSS, nelze ze samotného screenshotu potvrdit.

#### loading
`N/A` — žádné in-flight/loading vykreslení nebylo pozorováno ani není u holého textového pole
plausibilní.

#### error
Validační chybové stylování přímo pozorováno jednou: pole hesla ve `WIRE0013` se vykresluje s
**červeným obrysem** (v páru s neutrálním šedým stylováním předvyplněného e-mailového pole na témže
screenshotu). Několik dalších dokumentů WIRE (`WIRE0002`, `WIRE0006`) označuje "e-mail
povinný/formát" jako nevyřešenou validační Open Question bez nalezeného BR — current-state chování
chyb nad rámec jednoho potvrzeného červeného obrysu je z velké části `Uncertain`.

### Události

Ze screenshotů nelze potvrdit žádný konkrétní kontrakt událostí — zadávání textu a (v párování s CTA
pro odeslání) postup typu `onSubmit` je implikováno každým konzumujícím WIRE/UC (např. `UC0005`,
`UC0014`), nikoli vlastněno nebo samostatně evidováno samotným polem.

### Přístupnost (jak pozorováno)

Obvykle není přímo pozorovatelná ze screenshotů; zaznamenáno napříč jako `Uncertain` podle pravidel
COMP.

- **ARIA role:** `Uncertain` — žádná evidence DOM není k dispozici; předpokládá se nativní
  semantika `<input>`.
- **Navigace klávesnicí:** `Uncertain`.
- **Správa focusu:** `Uncertain`.
- **Čtečka obrazovky:** `Uncertain` — **vzor placeholder-jako-label** pozorovaný na několika
  výskytech (`WIRE0006`, `WIRE0009`, `WIRE0012`, `WIRE0024`) je opakující se, cross-screen otevřená
  otázka přístupnosti, již označená ve vlastní sekci Accessibility u `COMP0009` (žádný viditelný
  element `<label>` nepotvrzen) — zde neřešeno, přeneseno jako current-state pozorování, které je na
  úrovni DOM skutečně `Uncertain`, pouze `Probable` z viditelnosti textu placeholderu.

### Omezení použití (jak pozorováno)

- Použít když: zachycení jednoho řádku uživatelem zadaného textu/číselných dat, napříč
  storefrontovými donation flows (`WIRE0002`), wizardem žádosti (`WIRE0007`–`WIRE0011`),
  auth-adjacent obrazovkami pro vstup (`WIRE0012`, `WIRE0013`, `WIRE0024`) a obrazovkami účtu/
  daňového dokumentu (`WIRE0014`, `WIRE0015`).
- Nepoužívat když: `Uncertain` — žádné jiné current-state vyloučení nebylo pozorováno; pole se zdá
  být používáno téměř univerzálně kdekoli je potřeba krátký textový/numerický vstup.
- Kardinalita: vícero na obrazovku (pozorováno až ~7 polí na jediném kroku wizardu, např.
  `WIRE0009`).
- Umístění: uvnitř formulářových panelů/karet, postranních panelů (`WIRE0002` postranní panel daru)
  a modálních překryvů (`WIRE0002` donation modal).

### Závislosti (jak pozorováno)

- Ostatní COMP: komponováno uvnitř `COMP0009` Single Email-Entry Form (pole e-mailu ve `WIRE0012`/
  `WIRE0024`); jinak zaznamenáno `inline` uvnitř každého konzumujícího WIRE (`WIRE0002`, `WIRE0006`,
  `WIRE0007`, `WIRE0009`, `WIRE0010`, `WIRE0013`, `WIRE0014`, `WIRE0015`) — nepotvrzeno jako
  samostatně znovupoužitelná current-state komponenta před tímto povýšením.
- Datové entity: váže se, podle výskytu, na `EN0004` Campaign (částka daru), `EN0006`/`EN0008`
  Contact/User (pole e-mailu, telefonu, jména, adresy v modalu a krocích wizardu) — podle vlastní
  tabulky Data Bindings každého citujícího WIRE. Pole tyto hodnoty pouze *zachycuje*; samo neprovádí
  validační logiku (vlastněnou `UC` podle konzumujícího flow).
- ACL: nic evidováno.
- Externí knihovny: nic evidováno.

### Kompozice (jak pozorováno)

```
Input (current-state, as observed — inline, not independently confirmed reusable)
  (no confirmed sub-elements; rendered as internal markup within each consuming WIRE
   screen — WIRE0002, WIRE0006, WIRE0007, WIRE0009, WIRE0010, WIRE0012, WIRE0013,
   WIRE0014, WIRE0015, WIRE0024 — and within COMP0009 Single Email-Entry Form)
```

### Odchylka od kanonického cíle (zaznamenat, nikoli "opravovat")

- **Nekonzistence labelování vs. požadavek kanonického kontraktu.** Kontrakt kanonického atomu
  `Input` *požaduje*, aby konzument spároval komponentu s viditelným `<label>`/`aria-label` — ale
  current-state evidence ukazuje, že tento požadavek **dnes není konzistentně dodržován**: většina
  pozorovaných výskytů používá placeholder-jako-label (bez viditelného labelu), zatímco menšina
  (`WIRE0014`) explicitní label vykresluje. Jde o skutečnou current-state nekonzistenci, kterou zde
  nemáme "opravovat" směrem k cíli — je zaznamenána jako gap relevantní pro rebuild.
- **Vzor kompozitního prefixového segmentu chybí v kanonickém kontraktu.** Current-state telefonní
  pole (`WIRE0006`, `WIRE0010`) vykreslují fixní needitovatelný prefixový segment "+420" před
  inputem — kontrakt kanonického atomu `Input` žádný takový kompozitní/prefixový koncept nemá; cílová
  implementace telefonního pole by potřebovala buď samostatný composite, nebo prefixový wrapper na
  straně konzumenta — ani jedno v kanonické knihovně dosud neexistuje.
- **Žádný pozorovaný kontrakt chybového stylu vs. jedna konkrétní instance červeného obrysu.**
  Kanonický atom explicitně nevykresluje **žádný** vlastní chybový styl (`aria-invalid` je signálem
  konzumenta). Current state ukazuje **jedno** konkrétně pozorované vykreslení chyby červeným
  obrysem (pole hesla `WIRE0013`) — konzistentní s tím, že "chybový styl dodává konzument", ale
  evidence nestačí k potvrzení, zda je dnešní implementace na úrovni DOM ekvivalentní kanonickému
  kontraktu `aria-invalid`, nebo zda jde o zcela jiný mechanismus (`Uncertain`).
- **Žádný pozorovaný kontrakt přístupnosti.** Kanonický kontrakt předepisuje konkrétní
  odpovědnosti za labelování/`aria-invalid` uložené na konzumenta, přičemž samotný atom je přístupný
  přes nativní semantiku. Current-state přístupnost je jednotně `Uncertain` (žádná evidence
  DOM/záznamu), podle cross-cutting poznámky o sladění v `_ar/evidence/design-system/components.md`
  §2.
- **Žádná pozorovaná dimenze tenanta.** Current-state evidence je pouze CZ (jediný tenant);
  kanonický remapping tenanta (CZ/RO přes `data-theme`, všechny čtyři vizuální sloty tokenů
  přesměrované beze změny kódu) je pouze cílový, bez current-state RO evidence pro srovnání. Jediné
  dostupné CZ-specifické pozorování (fixní prefix "+420" ve `WIRE0006`) nemá potvrzený protějšek
  RO/MD.
- **Žádná osa `type`/`variant` potvrzená jako kontrakt na úrovni komponenty.** Current-state
  screenshoty ukazují různé účely polí (text, numerické s přípono, e-mail, telefon s prefixem), ale
  žádná evidence nepotvrzuje, že jsou implementovány jako jediná sdílená komponenta lišící se pouze
  nativním `type`, jak specifikuje kontrakt kanonického atomu — vs. několik nezávisle stylovaných
  current-state polí. Ponecháno jako `Uncertain`, netvrzeno žádným směrem.

### Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Holé textové/numerické pole přítomné na ≥2 obrazovkách | Confirmed | `WIRE0002`, `WIRE0006`, `WIRE0007`, `WIRE0009`, `WIRE0010`, `WIRE0012`, `WIRE0013`, `WIRE0014`, `WIRE0015`, `WIRE0024` — každý cituje vlastní screenshot(y), např. `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` |
| Vzor placeholder-jako-label (bez viditelného `<label>`) | Probable | popisy polí `WIRE0006`, `WIRE0009`, `WIRE0012`, `WIRE0024`; potvrzeno v sekci Accessibility u `COMP0009` |
| Přítomen explicitní `<label>` (protipříklad) | Confirmed | labely skupin polí "Vaše jméno a příjmení" / "Váš e-mail" ve `WIRE0014` |
| Fixní prefixový segment telefonu "+420" | Confirmed (CZ) / Uncertain (RO/MD) | `WIRE0006` Form panel — řádek pole Telefon; `WIRE0010` řádek pole telefonu patrona |
| Validační chybové stylování červeným obrysem | Confirmed | `WIRE0013` Main — řádek pole hesla (citovaný screenshot) |
| Read-only stylované předvyplněné pole e-mailu | Confirmed | `WIRE0013` Main — řádek pole e-mailu (citovaný screenshot) |
| Identita sdílené komponenty napříč výskyty (jedno znovupoužitelné pole vs. mnoho nezávislých polí) | Uncertain | `_ar/evidence/design-system/components.md` §2 mapovací řádek "Input" ("obě strany vědomě zacházejí s holým polem jako s primitivem"); žádná cross-WIRE DOM evidence není k dispozici |
| Přístupnost | Uncertain | žádná evidence DOM/záznamu k dispozici |
| Props/varianty/stavy nad rámec vizuálního zadávání textu | Uncertain | pouze statické screenshoty, žádná interaktivní/DOM evidence |
