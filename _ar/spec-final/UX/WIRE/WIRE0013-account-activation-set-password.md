---
doc_id: WIRE0013
title: Account Activation Set Password
canonical_layer: WIRE
spec_type: wireframe
modules: []
screen_id: S010
realizes_uc: [UC0014]
status: canonical
references:
  - UC0014
  - EN0008
  - BR-PartyIdentityAndDeduplication
  - MSG0003
  - IA-patronus (S010)
---

# WIRE0013 – Aktivace účtu, nastavení hesla

## Účel

S010 je cílová obrazovka aktivačního odkazu zaslaného e-mailem pozvanému/nově vytvořenému Uživateli
(`EN0008`, stavy "Registered — blocked, password-less" nebo "Registered — active, password-less") —
dosažitelná z aktivačního e-mailu (`MSG0003`) podle aktivačního flow v
`_ar/spec-draft/IA/IA-patronus.md` §5. Jejím úkolem je umožnit dané osobě nastavit heslo a odsouhlasit
dvě zaškrtávací pole se souhlasy/podmínkami, aby platforma mohla převést jeho záznam Uživatele do
stavu "Active" a spustit autentizovanou session; realizuje `UC0014` (aktivační dílčí flow
UC0014.1/UC0014.3 — "Registered (blocked or password-less) → Active",
`_ar/spec-draft/EN/EN0008_User.md` State Transitions). Aktér: pozvaný/nově vytvořený Customer
(žadatel, patron nebo přispěvatel), ještě neautentizovaný.

**Route:** `/aktivovat-ucet` (Confirmed — `_ar/spec-draft/IA/IA-patronus.md` §3.4, §4).

**Otevřená otázka přenesená z evidence:** `MSG0003` popisuje aktivační odkaz jako magic-link flow,
který nikdy nezobrazuje ani nevyžaduje heslo ("without ever being shown or asked to enter a
password"). Tento screenshot ukazuje explicitní pole pro vytvoření hesla na aktivační obrazovce, což
je s tímto rámováním v rozporu. Podle cross-layer discipline se toto zaznamenává, nikoli tiše
řeší — viz tabulka Evidence a Open Question níže.

---

## Zóny layoutu

- Header — globální navigace webu: logo "patron dětí", "Jak to funguje", "Blog", "O nás", CTA
  "Požádat o pomoc", "Můj účet" (ikona + odkaz) — Confirmed, odpovídá celoplošnému chrome patternu
  (`_ar/evidence/ui/ui-observed-areas.md` §1).
- Hlavní obsah — centrovaný jednosloupcový aktivační panel:
  - ikona (glyf dvou postav)
  - nadpis "Aktivovat účet"
  - úvodní text: "Po aktivování svého uživatelského účtu budete přihlášení a budete moct využívat
    všech jeho výhod."
  - světle šedá karta obsahující: pole e-mail + pole heslo (vedle sebe), inline zprávu "Bez
    těchto informací se neobejdeme.", dvě zaškrtávací pole, tlačítko pro odeslání "Aktivovat účet"
- Sidebar — nezaznamenáno.
- Footer — globální patička webu: cookie-consent banner, brand blok, sloupce odkazů ("Patron dětí",
  "Kontakt"), lišta platebního poskytovatele / sbírkového účtu, právní odkazy — Confirmed, odpovídá
  celoplošnému chrome patternu (`_ar/evidence/ui/ui-observed-areas.md` §1).

```
+--------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | Požádat  |
|              o pomoc (CTA) | Můj účet                  |
+--------------------------------------------------------+
|                     [icon]                              |
|                 Aktivovat účet                          |
|   Po aktivování svého uživatelského účtu budete ...      |
|  +----------------------------------------------------+ |
|  | [ e-mail (read-only style) ] [ password (red border)]| |
|  |         Bez těchto informací se neobejdeme.          | |
|  |  [ ] Prohlašuji, že jsem se seznámil/a s pravidly...  | |
|  |  [ ] Souhlasím s podmínkami používání uživ. účtu.     | |
|  |            [ Aktivovat účet ]                         | |
|  +----------------------------------------------------+ |
+--------------------------------------------------------+
| Cookie banner: "Tyto stránky používají k poskytování..." |
+--------------------------------------------------------+
| Footer: brand | Patron dětí links | Kontakt              |
| Platby zprostředkovává: comgate | Číslo sbírkového účtu   |
+--------------------------------------------------------+
```

---

## Použité komponenty

Opakující se prvky povýšené na COMP agentem **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označeny jako `inline` (nedoloženo opakované použití na ≥2
obrazovkách).

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | Confirmed — stejný pattern jako na ostatních veřejných obrazovkách; viz `COMP0002` Global Site Header |
| Main — ikona | inline | glyf dvou postav, dekorativní | Confirmed (screenshot) |
| Main — nadpis + úvodní text | inline | titulek stránky + jednořádkový popis | Confirmed (screenshot); přesný text je v gesci COPY, zde citován pouze pro identifikaci zóny |
| Main — aktivační karta | inline | světle šedý panel-container | Confirmed (screenshot) |
| Main — pole e-mail | inline | textové pole, předvyplněné, stylované jako read-only (šedé pozadí, bez červeného obrysu) | Confirmed (screenshot); zobrazená hodnota `o.suhaj@gmail.com` — testovací/evidenční data, nikoli UI popisek |
| Main — pole heslo | inline | textové pole, placeholder "Vytvořte si vlastní heslo", červený obrys | Confirmed (screenshot) |
| Main — inline zpráva | inline | červený pomocný/status text pod dvojicí polí | Confirmed text, Uncertain sémantika (viz States) |
| Main — zaškrtávací pole 1 + zaškrtávací pole 2 | COMP0006 | count-per-form=double | "pravidly poskytování pomoci" / "podmínkami používání uživatelského účtu"; viz `COMP0006` Consent Checkbox |
| Main — tlačítko pro odeslání | COMP0001 | — | "Aktivovat účet"; viz `COMP0001` Primary Button |
| Footer | COMP0003 | — | globální patička webu + cookie banner (`COMP0004`); Confirmed — stejný pattern jako na ostatních veřejných obrazovkách; viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — Customer klikne na aktivační odkaz v e-mailu o aktivaci účtu (`MSG0003`) →
   dostane se na `/aktivovat-ucet` → stav: `default`. Zda odkaz nese token, který se musí ověřit
   před vykreslením formuláře (vs. až po odeslání), je Uncertain — z statického screenshotu to nelze
   pozorovat; viz Open Question.
2. **Primární akce — aktivace účtu** — Customer vyplní heslo, zaškrtne obě zaškrtávací pole, klikne
   na "Aktivovat účet" → odešle formulář; realizuje `UC0014` (aktivační přechod,
   `_ar/spec-draft/EN/EN0008_User.md` "Registered (blocked or password-less) → Active"); dále:
   autentizovaná session podle UC0014, poté navigace do zóny účtu (S011/S018 podle
   `_ar/spec-draft/IA/IA-patronus.md` §5 "activation flow", krok 5). Přesná následující obrazovka po
   úspěchu je Assumed (z IA flow), nikoli samostatně zaznamenaná pro S010.
3. **Sekundární akce — přečtení pravidel** — klik na odkaz "pravidly poskytování pomoci" → otevře
   dokument s pravidly (externí/dokumentová plocha, `S-EXT4` podle `_ar/spec-draft/IA-screen-map.md`);
   neodesílá formulář.
4. **Sekundární akce — přečtení podmínek užívání účtu** — klik na odkaz "podmínkami používání
   uživatelského účtu" → otevře obsah podmínek; cílová obrazovka nezaznamenána (Uncertain — pro
   destinaci tohoto odkazu není doložen žádný samostatný screen-id).
5. **Výstup** — na této obrazovce není doložena žádná akce zrušit/zpět (jedinou další možností
   odchodu je globální navigace v headeru). Zda lze nedokončenou aktivaci později dokončit pomocí
   téhož odkazu, je Uncertain.

---

## Stavy

### default
Formulář jako na screenshotu: e-mail předvyplněný a stylovaný jako read-only, pole heslo prázdné s
červeným obrysem, obě zaškrtávací pole nezaškrtnutá, tlačítko pro odeslání aktivní (nezaznamenáno
chování disabled-until-valid). Confirmed — screenshot.

### empty
`N/A — not applicable`. Jde o jediný fixní formulář, nikoli o pohled typu list/collection; neexistuje
zde stav "žádné položky" k vykreslení.

### loading
`Evidence Pending — not captured`. Ve statickém záznamu není vidět žádný indikátor načítání. Zda
odeslání "Aktivovat účet" zobrazuje spinner/deaktivované tlačítko po dobu vyřizování aktivačního
požadavku, je Uncertain — není doloženo ani v jednom směru; nepředpokládat, že takový stav neexistuje.

### error
`Evidence Pending — not captured` pro skutečný chybový stav (např. expirovaný/neplatný token,
zamítnuté heslo, nezaškrtnutá zaškrtávací pole). Screenshot zobrazuje pole heslo s **červeným
obrysem** a zprávu "Bez těchto informací se neobejdeme." pod dvojicí polí, ale k žádnému z polí není
připojen explicitní inline chybový text, a neexistuje screenshot zobrazující tento panel po
neúspěšném pokusu o odeslání. Ze samostatného statického záznamu jsou možné dva výklady:
- (a) jde o **výchozí stylovou konvenci povinného pole**, zobrazenou i před jakýmkoli pokusem o
  odeslání (tj. vždy vykreslenou takto, dokud není heslo vyplněno), nebo
- (b) jde o **již vyvolanou validační chybu** (např. předchozí neúspěšné odeslání, nebo expirovaný
  aktivační token vyvolávající obecnou zprávu "chybí nám informace").
Klasifikováno jako **Uncertain** — zaznamenáno jako Open Question, neřešeno domněnkou
(`_ar/evidence/ui/ui-observed-areas.md` §8 označuje stejnou nejednoznačnost nezávisle).

---

## Validační plochy

| Pole/Zóna | Trigger (BR-id) | Plocha |
|---|---|---|
| Pole heslo | žádné neidentifikováno — žádné BR v `_ar/spec-draft/BR/` nespecifikuje pravidlo síly/formátu hesla | inline (červený obrys pole + zpráva "Bez těchto informací se neobejdeme." pod dvojicí polí) |
| Zaškrtávací pole — potvrzení pravidel | žádné neidentifikováno — žádné BR nevyžaduje zaškrtnutí tohoto pole před odesláním | inline (samotné zaškrtávací pole; nezaznamenán samostatný chybový text) |
| Zaškrtávací pole — souhlas s podmínkami užívání účtu | žádné neidentifikováno — žádné BR nevyžaduje zaškrtnutí tohoto pole před odesláním | inline (samotné zaškrtávací pole; nezaznamenán samostatný chybový text) |

**validationsWithoutBR:**
- Validace povinnosti/formátu pole heslo — `BR-PartyIdentityAndDeduplication` pouze uvádí, že nově
  vytvořený Uživatel "SHALL be created without a usable password until a separate activation step
  is completed" (aktivace musí nastavit *nějaké* heslo), ale nespecifikuje žádné pravidlo
  formátu/síly; skutečné omezení minimální délky/složitosti vynucované touto obrazovkou, pokud
  existuje, není z UI samotného doloženo. Otevřená otázka.
- Povinnost obou zaškrtávacích polí s podmínkami před odesláním je pravděpodobná z propojení
  zaškrtávacího pole/popisku a odkazovaných právních dokumentů, ale žádné BR toto omezení neuvádí a
  žádný screenshot nezobrazuje odmítnutí odeslání s nezaškrtnutým polem. Otevřená otázka.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Pole e-mail (předvyplněné, styl read-only) | `EN0008` | — | Zobrazuje existující e-mail/identifikátor Uživatele (nebo Kontaktu, `EN0006`, podle vazby linked-Contact na `EN0008`); pole je na screenshotu stylováno jako read-only, což odpovídá tomu, že e-mail je v tomto kroku pevná identita, nikoli editovatelná uživatelem. |
| Pole heslo | `EN0008` | — | Zapisuje přihlašovací údaj, který převádí Uživatele ze stavu bez hesla do stavu "Active" (`_ar/spec-draft/EN/EN0008_User.md` State Transitions, trigger UC0014). |
| Zaškrtávací pole (pravidla / podmínky užívání účtu) | — | — | Není doložena žádná entita EN/záznam souhlasu, která by tato zaškrtávací pole podkládala; zda je souhlas kdekoli persistován (např. časové razítko souhlasu na `EN0008`/`EN0006`), je Uncertain — v přečtené vrstvě EN nepotvrzeno. |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nedoloženo — v této rekonstrukci neexistuje vrstva ACL (`_ar/spec-draft/IA/IA-patronus.md` §9) | Obrazovka je určena pro neautentizovaného Customera s platným aktivačním odkazem; zda již autentizovaná session přesměruje mimo `/aktivovat-ucet`, je Uncertain, nezaznamenáno. |
| Odkaz "Můj účet" v headeru | nedoloženo | Přítomen bez ohledu na stav před aktivací v zaznamenaném snímku (odkazuje na přihlášení/účet podle globálního navigačního patternu); na této konkrétní obrazovce nezaznamenán žádný rozdíl podle rolí. |

---

## Poznámky k přístupnosti

Evidence Pending nad rámec toho, co lze prokázat statickým screenshotem. Zaznamenáno jako otevřená
otázka; nevymýšlet.

- **Pořadí tabulátoru:** Uncertain — vizuálně pole e-mail, poté pole heslo, poté dvě zaškrtávací
  pole, poté tlačítko pro odeslání, v souladu s pořadím čtení; nepotvrzeno interakcí.
- **Focus při vstupu:** Uncertain — nezaznamenán autofocus na poli heslo.
- **Focus při přechodu stavu:** Uncertain — nezaznamenán žádný chybový/loading stav, který by
  potvrdil správu focusu.
- **Landmarks:** Uncertain — nepotvrzeno pouze na základě vizuálního záznamu.
- **Klávesové zkratky:** nezaznamenány žádné.
- **Riziko signálu pouze barvou:** červený obrys pole heslo je jediný zaznamenaný vizuální
  rozlišovací prvek jeho (Uncertain) povinného/chybového stavu; zda je doprovázen ekvivalentním
  nebarevným signálem (ikona, text), není vyřešeno tím, že text "Bez těchto informací se
  neobejdeme." je umístěn pod dvojicí polí, nikoli přímo asociován s daným polem — označeno jako
  otevřená otázka přístupnosti, nikoli tvrzeno jako vada bez potvrzení skutečného markupu.

---

## Otevřené otázky

- **OQ-WIRE0013-1 (nejednoznačnost stavu):** Je pole heslo s červeným obrysem + zpráva "Bez těchto
  informací se neobejdeme." výchozí konvencí povinného pole, nebo již vyvolanou validační chybou?
  Ovlivňuje, zda je stav `error` na této obrazovce odlišný od `default`. Viz States → error.
- **OQ-WIRE0013-2 (konflikt heslo vs. magic-link):** `MSG0003` rámuje aktivaci účtu jako magic-link
  flow, kde není heslo nikdy zobrazeno/vyžadováno, ale S010 zobrazuje explicitní pole pro vytvoření
  hesla. Obojí je doloženo (text MSG0003 vs. tento screenshot) a zde se to nesjednocuje — zaznamenáno
  jako konflikt podle cross-layer discipline, neřešeno tichým preferováním jednoho zdroje.
- **OQ-WIRE0013-3 (validační pravidla):** Žádné BR nespecifikuje formát/síly hesla ani povinnost
  zaškrtávacích polí před odesláním na této obrazovce; viz `validationsWithoutBR` výše.
- **OQ-WIRE0013-4 (cílová obrazovka po úspěchu):** Přesná následující obrazovka po úspěšné aktivaci je
  Assumed z narativu flow na úrovni IA (`_ar/spec-draft/IA/IA-patronus.md` §5), samostatně
  nezaznamenaná při odchodu z S010.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Obrazovka existuje na `/aktivovat-ucet`, realizuje `UC0014` | Confirmed | `_ar/spec-draft/IA-screen-map.md` řádek S010; `_ar/spec-draft/IA/IA-patronus.md` §3.4, §4, §5 |
| Zóny layoutu, chrome headeru/footeru, obsah aktivační karty | Confirmed | `screencapture-patrondeti-cz-aktivovat-ucet-2026-07-04-13_33_10.png`; `_ar/evidence/ui/ui-observed-areas.md` §8 |
| Pole e-mail předvyplněné + styl read-only | Confirmed | stejný screenshot |
| Pole heslo s červeným obrysem | Confirmed (vizuálně) / Uncertain (sémantika: povinné vs. chyba) | stejný screenshot; `_ar/evidence/ui/ui-observed-areas.md` §8 uvádí stejnou nejednoznačnost |
| Dvě zaškrtávací pole (pravidla / podmínky užívání účtu) a jejich odkazované dokumenty | Confirmed | stejný screenshot |
| CTA pro odeslání "Aktivovat účet" | Confirmed | stejný screenshot |
| Aktivace převádí `EN0008` "Registered (blocked/password-less) → Active" | Confirmed | `_ar/spec-draft/EN/EN0008_User.md` State Transitions; `UC0014` |
| Validační pravidlo formátu hesla / povinnosti zaškrtávacích polí | Uncertain — žádné BR nenalezeno | `_ar/spec-draft/BR/BR-PartyIdentityAndDeduplication.md` (pokrývá pouze provisioning bez hesla, nikoli formát) |
| Stavy empty / loading / error nad rámec jediného zaznamenaného default | Evidence Pending — nezaznamenáno | pro tuto obrazovku nejsou k dispozici další screenshoty |
| Konflikt: aktivace pouze pomocí magic-link (MSG0003) vs. zaznamenané pole heslo (S010) | Confirmed conflict, nevyřešeno | `_ar/spec-draft/MSG/MSG0003_AccountActivation.md` Purpose; tento screenshot |
