---
doc_id: WIRE0012
title: Login Magic Link
layer: WIRE
spec_type: wireframe
modules: []
screen_id: S009
realizes_uc: [UC0014]
status: imported
references:
  - UC0014
  - EN0008
  - BR-AccessControlAndRoles
  - MSG0004
  - IA-patronus (S009, S010, S021)
---

# WIRE0012 – Přihlášení pomocí magic linku

## Účel

S009 (`/prihlaseni`) je bezheslový vstupní bod pro přihlášení pro neautentizovanou stranu, která již
má uživatelský účet (`EN0008`) — žadatel, dárce nebo patron. Customer zadá svůj e-mail a systém odešle
přihlašovací e-mail s magic linkem (`MSG0004`); tato obrazovka realizuje `UC0014` (konkrétně
přihlašovací dílčí tok, magic-link větev UC0014.1 a jeho předchozí krok vyžádání linku). Aktér:
Customer (neautentizovaný, má existující účet). Kontext vstupu: kliknutí na "Můj účet" v globální
navigaci v neautentizovaném stavu (`_ar/spec-draft/IA/IA-patronus.md` §4, vstup `/prihlaseni`).

Obrazovka má dva pozorované stavy vykreslované jako výměna celoobrazovkového obsahu v rámci stejného
layoutu: formulář pro zadání e-mailu (výchozí) a potvrzení "zkontrolujte si schránku" po odeslání.
Oba jsou přímo doloženy screenshotem.

---

## Layoutové zóny

- Header — globální navigace webu: logo "patron dětí", "Jak to funguje", "Blog", "O nás", CTA
  "Požádat o pomoc", "Můj účet" — stejný vzor chrome pozorovaný napříč celým webem
  (`_ar/evidence/ui/ui-observed-areas.md` §1). *Confirmed* (oba screenshoty).
- Hlavní obsah — centrovaný jednosloupcový panel:
  - Ikona (glyf dvou postav ve výchozím stavu / zaškrtnutí v kolečku ve stavu potvrzení)
  - Nadpis
  - Úvodní/textový obsah (jeden až dva krátké odstavce)
  - Světle šedá karta obsahující formulář (výchozí stav) nebo sekundární odkazy (stav potvrzení)
- Sidebar — nepozorováno.
- Footer — globální patička webu (motto/misie, shluky navigačních odkazů, badge platebních
  poskytovatelů, číslo sbírkového účtu, právní odkazy, cookie banner) — stejný vzor chrome pozorovaný
  napříč celým webem. *Confirmed* (oba screenshoty).

```
+--------------------------------------------------------+
| Header: logo | Jak to funguje | Blog | O nás | Požádat  |
|        o pomoc (CTA) | Můj účet                         |
+--------------------------------------------------------+
|                                                          |
|                     [icon]                               |
|                    Heading                                |
|                  Body copy (1-2 lines)                    |
|                                                            |
|   +--------------------------------------------------+   |
|   |     [ E-mail input ]         (default state)      |   |
|   |     [ Přihlásit se ]  (button)                     |   |
|   |     Už máte účet i heslo? Přihlaste se pomocí ...  |   |
|   |     Ještě účet nemáte? Aktivujte si ho.            |   |
|   +--------------------------------------------------+   |
|                                                          |
+--------------------------------------------------------+
| Footer: mission blurb | nav clusters | contact | badges |
+--------------------------------------------------------+
```

---

## Použité komponenty

Opakující se elementy povýšené na COMP pomocí **AR:COMPSynthesizer** (viz `COMP-inventory-map.md`);
všechny ostatní záznamy zůstávají označené jako `inline`. Zóny Main + Form-card společně tvoří
instanci `COMP0009` Single Email-Entry Form (purpose=login) — ponechány jako samostatné řádky níže
(nesloučeny), aby byla zachována původní granularita zón této WIRE; `COMP0009` je vlastnící smlouva
pro jejich kombinované props/stavy/eventy.

| Zóna | COMP-id | Varianta/Props | Poznámky |
|---|---|---|---|
| Header | COMP0002 | context=public | viz `COMP0002` Global Site Header |
| Main — stavová ikona | inline | glyf dvou postav (výchozí) / zaškrtnutí v kolečku (potvrzení) | Čistě dekorativní indikátor stavu; bez interakce. Součást `COMP0009` (purpose=login). *Confirmed* (oba screenshoty). |
| Main — nadpis | inline | H1, "Přihlaste se do účtu" (výchozí) / "Zkontrolujte svou e-mailovou schránku" (potvrzení) | Pouze minimální popisek — plný text vlastní vrstva COPY. Součást `COMP0009`. *Confirmed.* |
| Main — textový obsah | inline | úvodní text v rozsahu 1–2 odstavců | Pouze minimální výňatek — plný text vlastní vrstva COPY. Součást `COMP0009`. *Confirmed.* |
| Form card — pole e-mail | inline | jednořádkové textové pole, placeholder "E-mail" | Nad polem nezobrazen žádný label; placeholder zároveň slouží jako label. Součást `COMP0009`. *Confirmed* (screenshot 13_23_29). |
| Form card — tlačítko odeslat | COMP0001 | — | "Přihlásit se"; viz `COMP0001` Primary Button (komponováno v rámci `COMP0009`). |
| Form card — sekundární odkazy (výchozí stav) | inline | dva textové odkazy: "Přihlaste se pomocí svého hesla." (→ přihlášení heslem) a "Aktivujte si ho." (→ S021 `/overit-prihlaseni`) | Odkazy na sekundární akce uvnitř ztlumené karty, pod primárním CTA. Součást `COMP0009`. *Confirmed* (13_23_29). |
| Form card — sekundární odkazy (stav potvrzení) | inline | dva textové odkazy: "Přihlaste se pomocí svého hesla." (→ přihlášení heslem) a v textu "zkontrolujte složku spam, nebo nám napište na info@patrondeti.cz" (mailto) | Součást `COMP0009`. *Confirmed* (13_32_31). |
| Footer | COMP0003 | — | viz `COMP0003` Global Site Footer |

---

## Interakce

1. **Vstup** — Customer klikne na "Můj účet" v globální navigaci v neautentizovaném stavu → přesměrování
   na `/prihlaseni` → stav: `default`. (`_ar/spec-draft/IA/IA-patronus.md` §4, řádek vstupu
   `/prihlaseni`.) *Confirmed* (křížová reference na IA; samotný mechanismus vstupu není v této dvojici
   screenshotů znovu zachycen).
2. **Primární akce — odeslání e-mailu** — Customer zadá e-mail do pole "E-mail" a klikne na "Přihlásit
   se" → spustí `UC0014` (větev vydání magic linku; odešle `MSG0004`) → obrazovka přejde ze stavu
   `default` do stavu potvrzení (13_32_31), stále na `/prihlaseni`. Mezi oběma záznamy nedochází k
   žádné viditelné celoobrazovkové navigaci; stejná route vykresluje obsah po odeslání. *Confirmed*
   (oba screenshoty ukazují stejné header/footer chrome, mění se pouze blok hlavního obsahu).
3. **Sekundární akce — přihlášení heslem** — kliknutí na "Přihlaste se pomocí svého hesla." (přítomné
   v obou stavech) → přesměrování na variantu `UC0014` s přihlášením heslem; cílová obrazovka nebyla
   samostatně zachycena (IA neuvádí samostatné screen-id pro přihlášení heslem — Open Question).
4. **Sekundární akce — aktivace účtu** — kliknutí na "Aktivujte si ho." (pouze výchozí stav) →
   přesměrování na S021 `/overit-prihlaseni` (vstup aktivace — odeslání aktivačního linku).
   *Confirmed* (`_ar/spec-draft/IA-screen-map.md` řádek S021; text odkazu viditelný na 13_23_29).
5. **Sekundární akce — kontakt na podporu** — kliknutí na "napište na info@patrondeti.cz" (pouze stav
   potvrzení) → otevře e-mailového klienta (odkaz `mailto:`), v textu uvnitř nápovědy "zkontrolujte
   spam". *Confirmed* (13_32_31).
6. **Výstup** — Customer opustí obrazovku přes navigaci v header/footer (každá je cíl navigace ve
   vlastnictví IA, zde neopakovaný), nebo otevřením e-mailu s magic linkem (`MSG0004`) v jiném
   kontextu, což jej autentizuje a přesměruje do zóny účtu (S011 / S018) dle
   `_ar/spec-draft/IA/IA-patronus.md` §5 "Login flow". *Confirmed* (křížová reference na IA).

---

## Stavy

### default
Formulář pro zadání e-mailu: prázdné pole "E-mail" (placeholder text, bez předvyplnění), tlačítko
"Přihlásit se", dva sekundární odkazy ("Přihlaste se pomocí svého hesla." / "Aktivujte si ho.").
Žádná validační zpráva viditelná. *Confirmed* —
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png`.

### empty
`N/A — no distinct empty-state applies`. Jde o jednopolní vstupní formulář, nikoli výpis; neexistuje
zde stav "žádné položky" k vykreslení.

### loading
`Evidence Pending — not captured`. Mezi odesláním e-mailu a zobrazením obrazovky potvrzení nebyl
zachycen žádný průběžný/spinner stav. Zda tlačítko zobrazuje spinner, deaktivuje se, nebo je přechod
okamžitý, je Uncertain — nepozorováno na žádném ze screenshotů.

### error
`Evidence Pending — not captured`. Žádný screenshot nezobrazuje validační nebo odeslávací chybu na
této obrazovce (např. chybný formát e-mailu, neznámý e-mail, rate-limited požadavek). Zaznamenáno
jako otevřená otázka, nikoli jako tvrzení; související BR-podložené i nepodložené spouštěče viz
Plochy validace níže.

### confirmation (po odeslání — stav navíc nad rámec šablonových default/empty/loading/error)
Panel "Zkontrolujte svou e-mailovou schránku": ikona zaškrtnutí, nadpis a text potvrzení, záložní
odkaz na přihlášení heslem a řádek s nápovědou "zkontrolujte spam / napište nám" (s odkazem
`mailto:`). Samotný formulář pro zadání e-mailu se již nezobrazuje. *Confirmed* —
`_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png`. Tento stav je navíc oproti
čtyřem povinným stavům šablony; je zaznamenán, protože jde o dominantní pozorované chování obrazovky
po odeslání a je pro přihlašovací flow zásadní.

---

## Plochy validace

| Pole/Zóna | Spouštěč (BR-id) | Plocha |
|---|---|---|
| Pole "E-mail" — validace povinnosti/formátu | *(neidentifikováno)* | Evidence Pending — na žádném ze záznamů nebyla pozorována validační zpráva; zda dochází ke klientské kontrole formátu (např. `type="email"` prohlížečová validace) nebo k serverovému zamítnutí, je Uncertain. |
| Expirace tokenu magic linku (spotřebováno na jiné obrazovce při otevření e-mailového linku, ne na S009 samotné) | `BR-AccessControlAndRoles` (90denní platnost; zamítnutí UC0014 AF4 "expired or invalid") | Nejde o plochu na S009 — případné zamítnutí by se vykreslilo na obrazovce, která zpracovává kliknutí na link, což je mimo evidenci této obrazovky. Uvedeno zde pouze pro dohledatelnost. |

**validationsWithoutBR:**
- Zda pole "E-mail" před odeslením vynucuje pravidlo povinnosti/formátu a co se stane při odeslání s
  neznámým e-mailem (bez odpovídajícího uživatele) nebo blokovaným účtem (`UC0014` AF1/AF2), není na
  této obrazovce pozorováno. Nebyla nalezena žádná BR, která by konkrétně upravovala klientsky
  viditelnou validační zpětnou vazbu na samotném přihlašovacím formuláři —
  `BR-AccessControlAndRoles` se týká flood-control a politiky expirace tokenu, nikoli validace vstupu
  na úrovni formuláře. **Open Question.**
- Zda je opětovné odeslání formuláře, zatímco předchozí magic link je stále platný/čekající,
  blokováno, omezeno (throttled), nebo tiše umožněno, je Uncertain — souvisí s poznámkou
  `BR-AccessControlAndRoles` o současném stavu, že flood-control je napříč přihlašovacími plochami
  vynucován nekonzistentně, tato poznámka je ale omezena na pokusy o přihlášení heslem, nikoli na
  flood-control odesílání e-mailu na tomto konkrétním formuláři. **Open Question.**

---

## Datové vazby

| Zóna | EN-id | QUERY-id | Poznámky |
|---|---|---|---|
| Odeslání formuláře → vydání magic linku | `EN0008` | — | Odeslání e-mailu spouští větev magic linku `UC0014` proti odpovídajícímu záznamu uživatele `EN0008` (atribut login email); na této obrazovce se nezobrazují žádná data mimo statický text potvrzení. Žádné QUERY-id nedoloženo — obrazovka nečte/nezobrazuje uživatelská data. |
| Stav potvrzení | — | — | Žádný obsah vázaný na entitu; panel potvrzení je statický text, nikoli vykreslení uložených dat. |

---

## Podmíněná viditelnost

| Komponenta/Zóna | Podmínka (ref. ACL nebo BR) | Chování při skrytí |
|---|---|---|
| Celá obrazovka | nedoloženo | Nezjištěno žádné omezení podle role — S009 je záměrně neautentizovaný vstupní bod (`_ar/spec-draft/IA/IA-patronus.md` §4: dosažitelný z "Můj účet" *v neautentizovaném stavu*). Vrstva ACL v této rekonstrukci neexistuje. Zda je již autentizovaný Customer navštěvující přímo `/prihlaseni` přesměrován jinam, je Uncertain — nepozorováno; **Open Question.** |
| Odkaz "Aktivujte si ho." | nedoloženo | Podle screenshotu vždy viditelný ve výchozím stavu; nepozorována žádná podmínka, která by jej skrývala. |

---

## Poznámky k přístupnosti

Evidence Pending — žádný ze screenshotů neumožňuje kontrolu struktury DOM, ARIA rolí nebo klávesového
ovládání; následující body jsou Uncertain a nejsou domýšlené:

- **Pořadí tabulátoru:** Uncertain — vizuálně by pořadí bylo pole e-mail → tlačítko odeslat →
  sekundární odkazy, ale ze statických screenshotů to nelze potvrdit.
- **Focus při vstupu:** Uncertain — zda pole e-mail při načtení stránky získává autofocus, není ze
  statického záznamu možné pozorovat.
- **Focus při přechodu stavu:** Uncertain — zda se po odeslání přesune focus na nadpis potvrzení
  (relevantní pro oznámení změny stavu čtečkou obrazovky), není doloženo.
- **Landmarky:** Uncertain — nejsou k dispozici žádné DOM/ARIA důkazy.
- **Klávesové zkratky:** nedoloženo.

---

## Evidence

| Oblast tvrzení | Jistota | Evidence |
|---|---|---|
| Výchozí stav (zadání e-mailu) — ikona, nadpis, textový obsah, pole formuláře, tlačítko odeslat, sekundární odkazy | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_23_29.png` |
| Stav potvrzení ("zkontrolujte schránku") — ikona, nadpis, textový obsah, záložní odkazy, mailto | Confirmed | `_ar/prtsc/screencapture-patrondeti-cz-prihlaseni-2026-07-04-13_32_31.png` |
| Globální chrome header/footer přítomný na této obrazovce | Confirmed | oba výše uvedené screenshoty; vzor křížově ověřen proti `_ar/evidence/ui/ui-observed-areas.md` §1 |
| Obrazovka realizuje UC0014 (magic-link přihlašovací větev) | Confirmed | `_ar/spec-draft/UC/UC0014_AuthenticateManageAccess.md` UC0014.1; `_ar/spec-draft/IA-screen-map.md` řádek S009 |
| Odkaz "Aktivujte si ho." vede na S021 | Confirmed | `_ar/spec-draft/IA-screen-map.md` řádky S009/S021; `_ar/spec-draft/IA/IA-patronus.md` §3.4 |
| E-mail s magic linkem je MSG0004 | Probable | `_ar/spec-draft/IA-screen-map.md` řádek "Transactional-email surfaces"; obsah e-mailu nebyl samostatně zachycen |
| Stav loading, stav error, zpětná vazba validace pole formuláře | Evidence Pending / Uncertain | Nezachyceno na žádném screenshotu; nebyla nalezena BR upravující zobrazení validace na úrovni formuláře — označeno výše jako Open Question |
| Politika expirace tokenu magic linku (90denní okno, zamítnutí AF4) | Confirmed (jako fakt BR/UC, nikoli vykreslený stav S009) | `_ar/spec-draft/BR/BR-AccessControlAndRoles.md`; `_ar/spec-draft/UC/UC0014_AuthenticateManageAccess.md` AF4 |
