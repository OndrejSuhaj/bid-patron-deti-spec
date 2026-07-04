---
doc_id: WIRE0014
title: Account Settings Profile
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S011
realizes_uc: [UC0024]
status: canonical
references:
  - UC0024
  - EN0006
  - EN0008
  - IA-patronus
---

# WIRE0014 – Nastavení profilu účtu

## Účel

Obrazovka nastavení účtu pro přihlášené uživatele na adrese `/muj-ucet/nastaveni` ("Nastavení účtu"),
kde přihlášená strana (dárce/podporovatel, patron nebo fundraiser — jakýkoli přihlášený uživatel,
`EN0008`) zobrazuje a upravuje své jméno a profilovou fotku. Realizuje dílčí toky UC0024 —
UC0024.1 (zobrazení vlastního profilu) a UC0024.2 (úprava vlastního profilu: jméno, fotka) — úplný
kontrakt aktéra/systému viz příslušný UC; tento dokument popisuje pouze povrch obrazovky. Kontext
vstupu: navigace přihlášeného uživatele přes odkaz zóny účtu "Můj účet" (viz `IA-patronus.md` §3.6,
§5 přihlašovací/návratové toky). **Confirmed** — `_ar/prtsc/po_prihlaseni_do_uctu_nastaveni.png`.

Poznámka: obrazovka rovněž zobrazuje pole "E-mail", ale podle `UC0024` AF2 je toto pole **current-state
gap** — žádný pozorovaný kontrakt aktualizace profilu nepřijímá změnu e-mailu z této obrazovky. Tento
WIRE dokumentuje pole tak, jak je vykreslené; jeho nefunkční zápisová cesta je zjištění UC0024 a
neopakuje se zde nad rámec poznámky v části Validation Surfaces níže.

---

## Zóny rozvržení

**Confirmed** — `po_prihlaseni_do_uctu_nastaveni.png`.

- **Header (globální navigace)** — logo "patron dětí"; hlavní navigační odkazy "Jak to funguje",
  "Blog", "O nás"; CTA tlačítko "Požádat o pomoc"; odkaz na menu účtu přihlášeného uživatele "Můj
  účet" (ikona postavy).
- **Zóna titulku stránky** — nadpis "Nastavení účtu"; podtitulek "Potřebujete něco změnit? Udělejte
  to tady."
- **Hlavní obsah — panel formuláře profilu** (jedna světle šedá karta, zarovnaná vlevo, bez viditelného
  postranního panelu):
  - Skupina polí jméno — popisek "Vaše jméno a příjmení"; dva textové vstupy vedle sebe, placeholdery
    "Jméno" / "Příjmení".
  - Skupina pole e-mail — popisek "Váš e-mail"; jeden textový vstup, placeholder "E-mail".
  - Skupina pole profilové fotky — popisek "Změnit profilovou fotku"; zóna pro drag-and-drop upload s
    ikonou nahrávání, text "Sem přetáhněte soubory, které chcete do žádosti nahrát nebo je vyberte v
    počítači." ("vyberte v počítači" stylované jako odkaz) a indikátor počtu souborů "0 / 1".
  - Primární akční tlačítko "Uložit změny" pod formulářem.
- **Patička s promo pásem** — cross-sell banner "Víte o dítěti, které potřebuje pomoci?" (není součástí
  formuláře nastavení; sdílený chrome patičky webu podle `IA-patronus.md` §2).

Na této obrazovce není přítomen žádný postranní panel (jednosloupcové rozvržení formuláře).

```
+--------------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | [Požádat o     |
|         pomoc] | Můj účet                                    |
+--------------------------------------------------------------+
| Nastavení účtu                                                |
| Potřebujete něco změnit? Udělejte to tady.                    |
+--------------------------------------------------------------+
| Main content (card):                                          |
|   Vaše jméno a příjmení                                        |
|   [ Jméno ]        [ Příjmení ]                                |
|                                                                 |
|   Váš e-mail                                                    |
|   [ E-mail                                    ]                |
|                                                                 |
|   Změnit profilovou fotku                                      |
|   +------------------------------------------------+          |
|   |  ⬆  Sem přetáhněte soubory ... vyberte v        |          |
|   |     počítači.                          0 / 1     |          |
|   +------------------------------------------------+          |
|                                                                 |
|   [ Uložit změny ]                                             |
+--------------------------------------------------------------+
| Footer promo band: "Víte o dítěti, které potřebuje pomoci?"    |
+--------------------------------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP nástrojem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označené `inline` (nebyla prokázána opakovaná použitelnost na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/vlastnosti | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=authenticated-account | Sdílený chrome napříč obrazovkami pro přihlášené uživatele (`IA-patronus.md`); viz `COMP0002` Global Site Header |
| Titulek stránky | inline | H1 + podtext | "Nastavení účtu" / "Potřebujete něco změnit? Udělejte to tady." |
| Hlavní obsah — skupina polí jméno | inline | dvojice textových vstupů ve dvou sloupcích, s popiskem | "Jméno" / "Příjmení" |
| Hlavní obsah — skupina pole e-mail | inline | jeden textový vstup, s popiskem | "E-mail" — viz Validation Surfaces ohledně nefunkční zápisové cesty |
| Hlavní obsah — upload fotky | COMP0007 | maxCount=1, currentCount=0, exampleThumbnails=no | Nyní potvrzeno jako stejný znovupoužitelný vzor dropzone, jaký je pozorován v kroku přílohy formuláře žádosti; viz `COMP0007` File Upload Dropzone |
| Hlavní obsah — odeslání | COMP0001 | — | "Uložit změny"; viz `COMP0001` Primary Button |
| Footer | COMP0003 | promo=with-promo-band | "Víte o dítěti, které potřebuje pomoci?" — viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — navigace přihlášeného uživatele na `/muj-ucet/nastaveni` přes odkaz menu účtu "Můj
   účet" (route potvrzena v `IA-patronus.md` §4) → stav: `default`. **Confirmed** (route + vstupní
   odkaz), **Assumed** (zda se pole zobrazí předvyplněná aktuálními hodnotami profilu volajícího —
   zachycený screenshot ukazuje všechna pole pouze s placeholder textem, nikoli s vyplněnými hodnotami;
   `UC0024.1` krok 4 uvádí "zobrazí se vykreslený formulář profilu (předvyplnitelný)", ale nepotvrzuje
   předvyplněné vs. prázdné vykreslení s placeholderem u tohoto konkrétního zachycení — viz
   States/empty níže).
2. **Primární akce — Uložit změny** — Customer klikne na "Uložit změny" → odešle změněné pole/pole
   jména a/nebo nově přiložený odkaz na soubor profilové fotky; realizuje `UC0024` (UC0024.2) →
   následuje: stejná obrazovka, stav `default` odrážející uložené hodnoty (nebyla pozorována žádná
   samostatná potvrzovací obrazovka ani toast — **Uncertain**, nezachyceno).
3. **Sekundární akce — Upload fotky** — Customer přetáhne soubor do dropzone nebo klikne na "vyberte v
   počítači" → otevře výběr souboru / přijme drop; při úspěchu se očekává, že se počítadlo "0 / 1"
   aktualizuje na "1 / 1" (**Assumed** — vizuální stav po uploadu nezachycen).
4. **Odchod** — Customer opustí obrazovku přes navigaci v headeru (např. zpět na "Můj účet" nebo
   jakýkoli odkaz globální navigace) → opustí obrazovku bez pozorovaného ochranného mechanismu proti
   ztrátě neuložených změn (**Uncertain** — neprokázáno ani jedním směrem).

---

## Stavy

### default
Formulář vykresluje skupiny polí "Vaše jméno a příjmení" (Jméno/Příjmení), "Váš e-mail" a "Změnit
profilovou fotku" (0/1) a tlačítko "Uložit změny", jak je zachyceno. **Confirmed** —
`po_prihlaseni_do_uctu_nastaveni.png`.

### empty
Všechna tři textová pole (Jméno, Příjmení, E-mail) zobrazují v zachycení pouze šedý placeholder text
bez viditelné vyplněné hodnoty — jde o jediný zachycený stav a je **Uncertain**, zda představuje
(a) skutečně poprvé prázdný profil, (b) placeholdery vykreslené jako vizuální mock/nikdy nevyplněný
ukázkový obsah, nebo (c) artefakt vykreslení, kdy se skutečné hodnoty v okamžiku zachycení nenačetly.
Podle `UC0024.1` čtecí model profilu vrací vlastní jméno/příjmení/e-mail volajícího, takže by se u
přihlášené strany s existujícími hodnotami očekávalo jejich předvyplnění; to není dostupnými důkazy
potvrzeno. Označeno jako otevřená otázka níže, nikoli tvrzeno jedním či druhým směrem.

### loading
Nezachyceno. `N/A — Evidence Pending`: nebyl pozorován žádný stav načítání/skeleton ani pro počáteční
načtení formuláře, ani pro požadavek uložení po odeslání.

### error
Nezachyceno. `N/A — Evidence Pending`: v dostupných screenshotech nebyl pozorován žádný stav chyby na
úrovni pole ani formuláře (např. neúspěšné uložení, neplatný vstup, odmítnutí uploadu).

---

## Validation Surfaces

V `_ar/spec-draft/BR/` neexistuje žádný dokument BR, který by pokrýval validaci polí této obrazovky
na úrovni jednotlivých vstupů (jméno, e-mail, fotka). Následující validačně relevantní chování je
zaznamenáno jako **otevřené otázky bez BR**, nikoli vymyšleno:

| Pole/zóna | Trigger (BR-id) | Projev |
|---|---|---|
| Jméno / Příjmení | žádné nenalezeno | Uncertain — není prokázáno žádné klientské ani serverové validační pravidlo pro pole jména; `UC0024.2` uvádí, že nerozpoznaná/chybějící pole jsou jednoduše ponechána nezměněná (AF1), ale nepopisuje formátovou validaci |
| E-mail | žádné nenalezeno | Uncertain — podle `UC0024` AF2 pole e-mail **není přijímaným polem v kontraktu aktualizace profilu v žádné pozorované verzi API**; zda UI provádí klientskou validaci formátu e-mailu před no-op odeslením, pole tiše zahazuje, nebo je pole čistě read-only/kosmetické, není prokázáno |
| Změnit profilovou fotku (limit 0/1) | žádné nenalezeno | Probable — počítadlo "0 / 1" implikuje limit jednoho souboru vynucený widgetem, což je v souladu se stejným znovupoužitým textem obecného upload-widgetu pozorovaným i v kroku přílohy formuláře žádosti; žádný BR nedokumentuje omezení počtu souborů, typu souboru ani velikosti pro tento uploader |

`validationsWithoutBR`: formátová validace Jméno/Příjmení; chování pole E-mail (editovatelné vs.
kosmetické, podle UC0024 AF2); limity počtu/typu/velikosti souborů profilové fotky. Žádné z těchto
zatím nemá odpovídající `BRxxxx` v `_ar/spec-draft/BR/` — označit pro následné zpracování na vrstvě
BR nebo potvrdit jako current-state gapy mimo rozsah.

---

## Data Bindings

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Vaše jméno a příjmení | `EN0006` (Contact) | none | Pole `first_name` / `last_name` na Contact napojeném na User volajícího, podle `UC0024.2` kroku 3 |
| Váš e-mail | `EN0006` (Contact) | none | Zobrazované pole; podle `UC0024` AF2 **není** zápisovým polem v kontraktu aktualizace profilu — vazba pouze pro zobrazení je Probable, nikoli Confirmed jako živá čtecí vazba na konkrétní atribut e-mailu Contact/User |
| Změnit profilovou fotku | `EN0008` (User) | none | Pole `user_image` na User, podle `UC0024.2` kroku 4 (při uploadu se generují tři odvozené obrazové styly: `324x326`, `324x326@2`, `324x326@3`) |

V zachycení této obrazovky nejsou viditelné žádné souhrnné údaje profilu (celková výše darů, počet
kampaní, odznaky — podle `UC0024.1` kroku 3); ty patří k dashboardovému povrchu, jehož spojení s
tímto formulářem nastavení není potvrzeno (viz `UC0024` Evidence Pending, IA-Q2/IA-Q3). Zde není
navázáno.

---

## Conditional Visibility

| Komponenta/zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | Vyžaduje přihlášenou relaci (pozorovaná role: jakákoli přihlášená strana — dárce/podporovatel, patron nebo fundraiser; pro tuto konkrétní obrazovku není prokázáno žádné granulárnější omezení role, na rozdíl od rolí omezených sesterských obrazovek `zona/*` S018–S020) | V této rekonstrukci neexistuje žádná vrstva ACL (podle `IA-patronus.md` §9); chování při nepřihlášeném přístupu (přesměrování na přihlášení vs. 403) není prokázáno — **Uncertain** |
| Odkaz "Můj účet" v headeru | Stejná podmínka přihlášené relace | Není prokázáno, zda je skrytý samotný odkaz, nebo zda přístup omezuje cílová obrazovka — **Uncertain** |

---

## Accessibility Notes

Neprokázáno ze statického screenshotu; následující jsou `Assumed` očekávání dobré praxe, nikoli
potvrzená pozorování:

- **Pořadí tabulátoru:** Assumed zleva doprava, shora dolů — Jméno → Příjmení → E-mail → ovládací
  prvek uploadu / odkaz "vyberte v počítači" → tlačítko "Uložit změny". Nepotvrzeno.
- **Focus při vstupu:** Uncertain — není prokázáno, zda focus při navigaci padne na první pole nebo
  na nadpis stránky.
- **Focus při přechodu stavu:** Uncertain — nebyl zachycen žádný stav po odeslání, takže chování
  focusu při uložení (úspěch či chyba) není prokázáno.
- **Landmarks:** Uncertain — sémantická struktura (např. `<form>`, `<main>`, hierarchie nadpisů) není
  ze samotného vizuálního screenshotu určitelná.
- **Klávesové zkratky:** Žádné nebyly pozorovány ani očekávány nad rámec standardního tabování mezi
  poli formuláře a aktivace odkazu file-pickeru v zóně drag-and-drop uploadu.

---

## Evidence

| Oblast tvrzení | Jistota | Důkaz |
|---|---|---|
| Zóny rozvržení, popisky polí, text tlačítka | Confirmed | `_ar/prtsc/po_prihlaseni_do_uctu_nastaveni.png` |
| Duplicitní rozvržení (chybně pojmenovaný soubor) | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §11 poznamenává, že `po_prihlaseni_do_uctu_potvrzeni_o_darech2.png` je pixelová duplicita stejné obrazovky |
| Realizace UC (UC0024.1 zobrazení, UC0024.2 úprava) | Confirmed | `_ar/spec-draft/UC/UC0024_ManageDonorAccount.md` |
| Nefunkční zápisová cesta pole E-mail | Confirmed (jako fakt kódu); Uncertain (viditelný důsledek na front-endu) | `UC0024` AF2 |
| Prázdný vs. předvyplněný stav pole | Uncertain | Screenshot ukazuje pouze placeholder text; neexistuje druhé zachycení s vyplněnými hodnotami |
| Stavy loading / error | Evidence Pending — nezachyceno | Pro žádný z těchto stavů neexistuje screenshotový důkaz |
| Data bindings (EN0006, EN0008) | Probable | Odvozeno z mapování polí v `UC0024.2`, nebylo nezávisle ověřeno oproti DOM/API payloadu této obrazovky |
| Validační pravidla | Uncertain — bez BR | Žádný dokument `BRxxxx` nepokrývá validaci jména/e-mailu/fotky pro tuto obrazovku |
| Rozsah omezení role | Uncertain | Neexistuje vrstva ACL; širší přístup pouze pro přihlášené uživatele odvozen ze skupiny zóny účtu v IA (`IA-patronus.md` §3.6, §7) |
