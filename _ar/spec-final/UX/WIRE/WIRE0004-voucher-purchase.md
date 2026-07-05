---
doc_id: WIRE0004
title: Voucher Purchase
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S005
realizes_uc: [UC0009]
status: imported
references:
  - UC0009
  - EN0013
  - EN0009
  - EN0004
  - BR-VoucherPolicy
---

# WIRE0004 – Nákup poukazu

> **WIRE s čekající evidencí.** Snímek obrazovky S005 neexistuje ani v `_ar/prtsc/**`, ani v
> `_ar/evidence/ui/ui-observed-areas.md`. Zaznamenány byly pouze **vstupní body** na tuto obrazovku
> (popisky CTA na S001/S002), nikoli samotná nákupní obrazovka. Tento dokument zaznamenává to, co
> podporuje evidence IA/UC/EN/BR, a vše ostatní označuje jako `Uncertain` / `Evidence Pending`. Viz
> IA-Q10 (`_ar/spec-draft/IA/IA-patronus.md` §8) pro sledovanou mezeru.

---

## Účel

S005 má být **obrazovkou nákupu / checkoutu poukazu (Dobrošku)**: návštěvník zvolí hodnotu/nominál
Dobrošku a koupí jej jako předplacený dárkový kód daru (`EN0013` Voucher), který si příjemce
následně uplatní vůči Kampani (`EN0004`) dle svého výběru. Vstup je přes CTA "Koupím dobrošek"
zaznamenané na homepage (S001) — viz `ui-observed-areas.md` §1 — a v tabulce vstupních bodů IA
(`_ar/spec-draft/IA/IA-patronus.md` §4, řádek "Koupím dobrošek").

**Výhrada k mapování na UC (Uncertain — otevřená otázka, žádné BR toto mapování neupravuje):**
jediný kandidátní UC dodaný pro S005 je `UC0009` (Uplatnění / validace poukazu). Při čtení `UC0009`
(`_ar/spec-draft/UC/UC0009_RedeemValidateVoucher.md`) a jeho evidence toku `FLW0018`
(`_ar/evidence/flow/FLW0018_voucher-apply-validate.md`) je zřejmé, že `UC0009` je výhradně operace
**validace/uplatnění** spouštěná přes API (`POST /api/2.2/voucher/validate`,
`POST /api/2.2/voucher/apply`), používaná z kontextu darovacího modálního okna na S002 ("Mám
dobrošek" / "Chcete věnovat dobrošek?" — `ui-observed-areas.md` §2), nikoli nákupní/checkout flow.
Strana **nákupu** poukazu (`VoucherTransactionService::createVoucher` / `VoucherCartService`, dle
FLW0018 §D) je samostatná, nezaznamenaná backendová cesta, k níž v `_ar/spec-draft/UC/` v době
tohoto průchodu neexistuje vlastní dokument UC. Tento WIRE se řídí kandidátním mapováním ze zadání
(`realizes_uc: [UC0009]`, `certainty: Uncertain` dle řádku S005 v `IA-screen-map.md`), ale
upozorňuje na tento nesoulad, místo aby bez dalšího tvrdil, že S005 realizuje uplatnění/validaci:
**Conflict — requires clarification** (kandidátní UC pravděpodobně popisuje nesprávnou polovinu
životního cyklu poukazu pro tuto obrazovku; UC pro stranu nákupu v aktuální sadě UC chybí).

**Aktér:** anonymní návštěvník (kupující), analogicky k patternu anonymního dárce na S001/S002;
požadavek na autentizaci není evidován ani pro nákup, ani pro uplatnění/validaci (`BR-VoucherPolicy`
"Aktuální rizika jedinečnosti a souběhu" — validace/uplatnění jsou potvrzeně bez autentizace;
autentizace na straně nákupu je Uncertain, není evidována ani jedním směrem).

**Kontext vstupu:** CTA "Koupím dobrošek" na S001 (homepage) a případně S002 (detail příběhu) — viz
tabulka vstupních bodů IA. Pro samotnou S005 není evidována žádná route/URL.

---

## Zóny rozvržení

Uncertain — Evidence Pending. Neexistuje snímek obrazovky ani DOM capture pro S005. Níže uvedené
zóny jsou **předpokládané analogicky** s příbuzným patternem darovacího modálního okna
zaznamenaného na S002 (`ui-observed-areas.md` §2: modal "Chystáte se přispět" — vstup částky,
e-mail, souhlasové checkboxy, "Přejít k platbě") a s uživatelsky zadávanými atributy entity Voucher
(`EN0013` "User-provided attributes"). Nic z tohoto rozvržení není Confirmed.

- Header — Assumed: sdílená hlavička/navigace webu (dle patternu S001/S002). **Uncertain.**
- Hlavní obsah — Assumed: výběr nominálu/hodnoty plus formulář údajů o příjemci, dle atributů
  `EN0013` `price`, `recipient_name`, `recipient_email`, `user_phone`, `recipient_message`,
  `delivery_type` (e-mail/tisk). **Uncertain — nezaznamenáno.**
- Krok platby — Assumed: předání externí platební bráně Comgate (S-EXT1/S-EXT2 dle
  `IA-patronus.md` §3.7), analogicky k patternu darovací modal → brána na S002/UC0005/UC0006.
  **Uncertain — pro cestu nákupu poukazu konkrétně nezaznamenáno.**
- Footer — Assumed: sdílené footer webu. **Uncertain.**

Náčrt rozvržení v ASCII zde není uveden — vymýšlení prostorového uspořádání bez evidence by
porušovalo evidenční disciplínu WIRE (`rules-WIRE.md` "Observed UI wins... do not fabricate").

---

## Použité komponenty

Evidence Pending — pro S005 neexistuje žádná evidence na úrovni komponent. Vrstva COMP v tomto
průchodu navíc ještě neexistuje, takže by jakýkoli rekonstruovaný prvek byl označen jako `inline`.
Žádné prvky zde nejsou uvedeny, protože žádný nemá status Confirmed nebo Probable; uvádět
předpokládaná (Assumed) pole formuláře jako komponenty by nadhodnocovalo jistotu.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| — | — | — | Evidence Pending — neexistuje záznam S005; viz poznámka v části Účel. |

---

## Interakce

Uncertain — Evidence Pending, rekonstruováno pouze z CTA vstupního bodu a tvaru entity Voucher;
sekvence interakcí na úrovni obrazovky není zaznamenána.

1. **Vstup** — kliknutí na "Koupím dobrošek" na S001 (Confirmed popisek CTA existuje —
   `ui-observed-areas.md` §1) → stav: `default` (Uncertain — cílová obrazovka/route nezaznamenána).
2. **Primární akce** — Assumed: výběr hodnoty/nominálu Dobrošku a odeslání údajů o příjemci
   → vytvoří Voucher (`EN0013`) navázaný na nákupní Transakci (`EN0009`) ve stavu nezaplaceno,
   poté pokračuje k platbě. **Uncertain** — žádný dokument UC v aktuální sadě UC tento nákupní krok
   nepokrývá; odvozeno pouze z atributů `EN0013` a poznámky k přechodu "Unpaid → Paid" v části
   State Transitions entity `EN0013` (spouštěno `UC0006` Potvrzení platby, nikoli `UC0009`).
3. **Sekundární akce** — žádná nezaznamenána.
4. **Výstup** — Assumed: přesměrování na externí platební bránu (Comgate, S-EXT1) po odeslání,
   s návratem na obrazovku poděkování/potvrzení dle výsledku platby, analogicky k patternu
   callbacku brány u `UC0006`. **Uncertain — pro tuto obrazovku nezaznamenáno.**

---

## Stavy

### default
Uncertain — Evidence Pending. Neexistuje záznam obrazovky v jejím běžném použitelném stavu.

### empty
N/A — Evidence Pending: žádná evidence nenaznačuje, že by tato obrazovka měla stav prázdného
seznamu (předpokládá se, že jde o jednoúčelový nákupní formulář, nikoli o zobrazení
seznamu/kolekce), ale jde o odvození, nikoli o zaznamenaný fakt.

### loading
Uncertain — Evidence Pending. Žádná evidence indikátoru asynchronního načítání pro tuto obrazovku.

### error
Uncertain — Evidence Pending. Žádná evidence zobrazení chyby validace nebo neúspěchu platby
konkrétně na této obrazovce. (Pro srovnání: `FLW0018` dokumentuje, že *samostatné* API pro
validaci/uplatnění vždy vrací HTTP 200 s `{status:failed|invalid}` v těle odpovědi — to je ale API
strany uplatnění, nikoli tato nákupní obrazovka; přenášet tento chybový kontrakt na S005 by
znamenalo porušení oddělení vrstev a zde se to nedělá.)

---

## Validační plochy

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| Hodnota/nominál poukazu | žádný — nenalezeno BR | Uncertain — validationsWithoutBR |
| E-mail příjemce (pokud se sbírá při nákupu) | žádný — nenalezeno BR | Uncertain — validationsWithoutBR |
| Typ doručení (e-mail/tisk) | žádný — nenalezeno BR | Uncertain — validationsWithoutBR |

Žádný dokument BR neupravuje validaci polí v okamžiku nákupu pro Voucher; `BR-VoucherPolicy`
upravuje pouze životní cyklus po zaplacení/uplatnění (Non-Goals: "nedefinuje persistované atributy
Voucheru, typy polí ani tvar úložiště"). Toto je **otevřená otázka** — je pouze vlajkována,
nikoli fabrikována jako nové BR.

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Hlavní obsah (Assumed formulář) | `EN0013` | — | Uživatelsky zadávané atributy Voucheru: `price`, `recipient_name`, `recipient_email`, `user_phone`, `recipient_message`, `delivery_type`. Nejisté, které z nich se sbírají v okamžiku nákupu na této obrazovce vs. jinde. |
| Předání k platbě | `EN0009` | — | Nákupní Transakce vytvořená ve stavu nezaplaceno (dle atributu "transaction" entity `EN0013` a State Transitions). Uncertain — na této obrazovce nezaznamenáno. |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (odkaz na ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | neevidováno — nenalezena žádná role gate | Uncertain — v tomto průchodu neexistuje vrstva ACL; nákup se jeví jako otevřený anonymním návštěvníkům analogicky k S001/S002, ale jde o Assumed, nikoli Confirmed konkrétně pro S005. |

---

## Poznámky k přístupnosti

Evidence Pending — neexistuje snímek obrazovky ani DOM capture, z něhož by bylo možné odvodit
pořadí tabulace, chování fokusu, landmarky nebo klávesové zkratky pro S005. Nefabrikováno.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Existence obrazovky / vstupní CTA | Confirmed | `_ar/evidence/ui/ui-observed-areas.md` §1 (CTA "Koupím dobrošek" na homepage), §2 ("Mám dobrošek" / "Chcete věnovat dobrošek?" na detailu příběhu — pozn.: jde o vstup na straně *uplatnění*, nikoli nákupu) |
| Samotná nákupní obrazovka nezaznamenána | Confirmed (absence) | `_ar/spec-draft/IA/IA-patronus.md` §3.5, §8 IA-Q10; `_ar/spec-draft/IA-screen-map.md` řádek S005 |
| Zóny rozvržení, komponenty, interakce, stavy, přístupnost | Uncertain / Evidence Pending | Neexistuje snímek obrazovky; rekonstruováno pouze analogicky s darovacím modálním oknem na S002 a tvarem atributů `EN0013` — neuváděno jako zaznamenaný fakt |
| UC0009 jako realizující UC pro nákupní obrazovku | Uncertain — Conflict, requires clarification | `_ar/spec-draft/UC/UC0009_RedeemValidateVoucher.md` (pouze validace/uplatnění, spouštěno přes API); `_ar/evidence/flow/FLW0018_voucher-apply-validate.md` (totéž); v `_ar/spec-draft/UC/` v době tohoto průchodu neexistuje UC pro stranu nákupu |
| Tvar polí Voucheru (nominál, příjemce, typ doručení) | Confirmed (tvar entity) / Uncertain (mapování na obrazovku) | `_ar/spec-draft/EN/EN0013_Voucher.md` "User-provided attributes" |
| Validační pravidla pro pole v okamžiku nákupu | Uncertain — nenalezeno BR | `_ar/spec-draft/BR/BR-VoucherPolicy.md` (Non-Goals explicitně vylučuje validaci na úrovni polí) |
