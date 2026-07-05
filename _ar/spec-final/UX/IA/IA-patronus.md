---
doc_id: IA-patronus
title: Information Architecture — Patronus (Patron dětí)
layer: IA
spec_type: information-architecture
scope: program
modules: []
status: imported
owners: [ux-lead, architect]
language: cs
references:
  # referenced canonical doc_ids (each verified to resolve in _ar/spec-draft/ at authoring time):
  - UC0001  # Submit Application (self-registration + 5-step wizard)
  - UC0005  # Make a Donation
  - UC0006  # Confirm Payment (Gateway Callback)
  - UC0007  # Process Recurring Donation
  - UC0009  # Redeem / Validate Voucher
  - UC0010  # Issue Donation Confirmation (Tax)
  - UC0011  # Manage Campaign / Story Lifecycle
  - UC0014  # Authenticate & Manage Access
  - UC0023  # Browse & Filter Story Catalogue
  - UC0024  # Manage Donor Account (Self-Service)
  - UC0025  # Resume or Discard Draft Application
  - EN0001  # Application (Žádost)
  - EN0003  # ApplicationSession
  - EN0004  # Campaign (Story / Příběh)
  - EN0005  # Patron
  - EN0006  # Contact
  - EN0007  # Account
  - EN0008  # User
  - EN0009  # Transaction (Donation / Dar)
  - EN0010  # RecurringTransaction
  - EN0013  # Voucher (Dobrošek)
  - EN0014  # DonationConfirmation (CZ tax certificate)
  - EN0024  # Blog
  - EN0032  # ReportSnapshot
  - EN0033  # GiftCategory
  - EN0034  # DonorAccountView (donor zone read-model)
  - ES0001  # ComGate payment gateway (external boundary; see ES layer)
  - ARCH0001 # Application Overview (program architecture)
---

# IA — Patronus (Patron dětí)

## 1. Zdroje / Autorita

Tato IA je rekonstruována z pozorovaného veřejného + přihlášeného front-endu dárce/žadatele na
`patrondeti.cz` (tenant CZ) a z rekonstruovaných BA vrstev. Primární UI evidence:

- `_ar/coverage/ui-screen-index.md`, `_ar/coverage/ui-gap-analysis.md`
- `_ar/evidence/ui/ui-observed-areas.md` (trvalá per-screen pozorovaná evidence — primární zdroj)
- `_ar/prtsc/**` (screenshoty, prohlédnuté pro potvrzení navigace/hierarchie)
- kódem ověřená řešení v `_ar/evidence/gap-closure-evidence.md`
  (přistávací stránka volby role → `/zadost/zadatel` + `/zadost/patron`; karta SBÍRKOVÝ ÚČET =
  transparentní kampaň `isGeneral()`, nikoli typ příběhu)
- otevřené IA-relevantní položky v `_ar/spec-draft/UI-gap-open-questions.md`
- referencované kanonické dokumenty (viz `references:`)

Pouze orientační (ne autoritativní): pozorované UI je důkazem záměru; rekonstruovaný kanonický
obsah (`_ar/spec-draft/{UC,EN,ARCH,ES}/`) má při rozporu přednost. Tam, kde je obrazovka nebo route
viditelná, ale její účel nebo řízení přístupu podle role není potvrzeno, je to zaznamenáno v §8
Otevřené IA otázky — nikoli tvrzeno jako existující funkce.

**Poznámka k rozsahu evidence (přenesená z auditu pokrytí):** zachycený povrch je pouze anonymní +
veřejný front-end dárce/žadatele. **Žádná obrazovka administračního back-office (`/admin/**`) nebyla
zachycena**, takže rozsáhlá administrativní navigace za rekonstruovanými admin-side UC (UC0002
řízení stavů, UC0003 riziko, UC0004 smlouvy, UC0008 párování plateb, UC0016 sloučení stran, UC0017
export) je mimo evidenční sadu této IA. Její absence zde **není** důkazem, že v systému chybí; tato
IA dokumentuje pouze pozorovaný veřejný / samoobslužný navigační povrch.

**Poznámka k tenantu:** všechny screenshoty pochází z **tenantu CZ** (`patrondeti.cz`). Navigace
RO/MD se předpokládá rovnocenná dle multi-tenant modelu CZ/RO/MD, ale **není doložena** (viz §8,
IA-Q6).

---

## 2. Navigace nejvyšší úrovně

Pozorovaná primární navigace (doslovné CZ popisky, dle `_ar/evidence/ui/ui-observed-areas.md` §1 a
záznamu domovské stránky). Všechny položky veřejné navigace jsou dostupné anonymně, není-li
uvedeno jinak.

- **patron dětí** (logo) — návrat na domovskou stránku / katalog příběhů (S001) (`UC0023`).
- **Jak to funguje** — stránka jak-to-funguje / důvěryhodnost / agregované statistiky / splněné
  příběhy (S016) (`UC0011`; zdroj agregovaných čísel nevyřešen — viz §8 IA-Q7).
- **Blog** — výpis redakčních článků (S013) (žádné vlastnící UC; obsah — `EN0024`).
- **O nás** — o nás / tým / dokumenty / výroční zprávy (S015) (statické/institucionální; žádné UC).
- **Požádat o pomoc** (CTA tlačítko) — vstup do intake žádosti na přistávací stránce volby role
  (S006) (`UC0001`). Patička obsahuje ekvivalentní odkaz "Chci přihlásit příběh".
- **Můj účet** — vstup do přihlášené zóny účtu; při neautentizovaném stavu směruje na přihlášení
  (S009) (`UC0014`), při autentizovaném do oblasti účtu (S018–S020 / S011–S012) (`UC0024`).

Trvalý chrome přítomný téměř na každé obrazovce (není navigačním cílem): **banner souhlasu s
cookies** ("Přijímám / Odmítnout / Další informace") a **patička webu** (číslo sbírkového účtu
57574646/0600, "Platby zprostředkovává: comgate" → `ES0001`, a shluk odkazů v patičce níže).

Shluk odkazů v patičce (pozorováno, `_ar/evidence/ui/ui-observed-areas.md` §6, §16 a záznam
domovské stránky): O nás (S015), Blog (S013), **Pravidla poskytování pomoci** (PDF pravidel —
externí dokument, S-EXT4), **Naše desatero** (stažení Desatera — na S015), **Splněné příběhy**
(splněné příběhy → S016), **Výroční zprávy** (výroční zprávy — na S015), "Jak jsme pomáhali v době
koronakrize" (redakční obsah), "Souhlas se zpracováním osobních údajů", "Chci přihlásit příběh"
(→ S006). Přesné routy za několika odkazy v patičce nejsou jednotlivě doloženy (viz §8 IA-Q8).

**Menu účtu / přihlášená zóna "Můj účet".** Evidence potvrzuje tři samoobslužné zóny účtu podle
role a dvě podstránky "Můj účet" (viz §3.6). Evidence **nepotvrzuje** jediný složený widget menu
účtu ani jednotnou dashboard stránku, která by je propojovala (viz §8 IA-Q2, IA-Q3):

- Nastavení účtu — "Nastavení účtu" (S011) (`UC0024`).
- Potvrzení o daru pro daňové účely — "Potvrzení o darech" (S012) (`UC0010`).
- Zóna dárce — "Moje zóna" / historie darů podle podpořeného příběhu (S018) (`UC0024`,
  read-model `EN0034`).
- Zóna žadatele (fundraiser) (S019) a zóna patrona (S020) (`UC0024`-přidružené; řízeno rolí,
  viz §8 IA-Q4).

---

## 3. Mapa obrazovek

Stabilní `S###` id obrazovek (přidělena jednou, napříč běhy stabilní). Každá obrazovka nese
jednořádkový účel a tam, kde reprezentuje klíčovou entitu, i `ENxxxx`. Plná evidence + míra jistoty
pro každou obrazovku žije v `_ar/spec-draft/IA-screen-map.md`; tato sekce je navigační seskupení.

### 3.1 Veřejný web (anonymní)

- **S001** Domovská stránka — katalog příběhů s filtrovacími záložkami — hlavní vstupní stránka pro
  akvizici dárců; procházení/filtrování aktivních příběhů (`EN0004`), hero přednastavení trvalého
  daru (`EN0010`), blok voucherů (`EN0013`).
- **S013** Blog — výpis článků (`EN0024`).
- **S014** Blog — detail článku (`EN0024`).
- **S015** O nás — o nás / tým / Desatero / výroční zprávy / kontrolní protokoly
  (statické/institucionální).
- **S016** Jak to funguje / Výsledky — jak to funguje, důvěryhodnost, agregované statistiky dopadu,
  splněné příběhy (`EN0004`; agregovaná čísla možná `EN0032` — nepotvrzeno, §8 IA-Q7).

### 3.2 Příběh a dar

- **S002** Detail příběhu + modální okno jednorázového daru (`EN0004`, `EN0009`) — zobrazuje také
  komentář patrona (`EN0005`), zbývající částku, vstup pro uplatnění voucheru ("Mám dobrošek",
  `EN0013`), CTA pro podporu kategorie.
- **S003** Poděkování / stránka úspěšné platby ("Platba proběhla úspěšně") (`EN0009`).

### 3.3 Proces žádosti (intake)

- **S006** Přistávací stránka volby role — "Požádat o pomoc" volba mezi "pomoci mému dítěti"
  (žadatel/fundraiser) a "pomoci dítěti, které znám" (patron) (`EN0001`). URL kódem nepotvrzeno
  (§8 IA-Q1).
- **S007** Intake žádosti — brána kontakt/souhlasy "Údaje o žadateli" (`/zadost/zadatel`) (`EN0001`,
  `EN0006`) — první krok pro roli žadatele; odkaz "Zpět na výběr" vede zpět na S006.
- **S008a** Krok 1 wizardu žádosti — "Váš příběh" (identita dítěte + příběh + příznaky) (`EN0001`,
  `EN0002`).
- **S008b** Krok 2 wizardu žádosti — "Dar, kterým vám pomůžeme" — výběr kategorie daru (`EN0033`).
- **S008c** Krok 3 wizardu žádosti — "Údaje o vás" — údaje žadatele (`EN0006`).
- **S008d** Krok 4 wizardu žádosti — "Patron" (pouze stepper; pole nezachycena) (`EN0005`).
- **S008e** Krok 5 wizardu žádosti — "Přílohy" (pouze stepper; pole nezachycena) (`EN0001`).

(Kroky 1–5 sdílejí jednu route/agregát `/zadost-formular`; id obrazovky pro každý krok umožňuje
vrstvě WIRE navázat každý krok. Kroky 4–5 existují v evidenci pouze jako popisky stepperu —
viz §8 IA-Q5.)

### 3.4 Autentizace a zřízení účtu

- **S009** Přihlášení — zadání e-mailu pro magický odkaz + potvrzení "odesláno" (`/prihlaseni`)
  (`UC0014`, `EN0008`).
- **S010** Aktivace účtu — nastavení hesla + přijetí podmínek (`/aktivovat-ucet`) (`UC0014`,
  `EN0008`).
- **S021** Vstup do aktivace — "již dárce/žadatel/patron, odeslat aktivační odkaz"
  (`/overit-prihlaseni`) (`UC0014`, `EN0008`).
- **S022** Potvrzení odeslání aktivačního odkazu (`/poslat-aktivacni-email`) — obsah nedoložen
  (zachycena pouze patička); zaznamenáno, netvrzeno (§8 IA-Q9).

### 3.5 Voucher (Dobrošek)

- **S005** Vstup pro nákup voucheru — blok "Dobrošeky" na domovské stránce / "Koupím dobrošek"
  (`EN0013`); vyhrazená obrazovka nákupu **není zachycena** — vstupní bod doložen, obrazovka ne
  (§8 IA-Q10).

### 3.6 Přihlášená zóna účtu "Můj účet"

- **S011** Nastavení účtu — nastavení profilu (jméno, zobrazení e-mailu, profilová fotka)
  (`/muj-ucet/nastaveni`) (`EN0006`, `EN0008`).
- **S012** Potvrzení o darech — formulář žádosti o daňové potvrzení
  (`/muj-ucet/potvrzeni-o-darech`) (`EN0014`, `EN0015`).
- **S018** Zóna dárce — "Moje zóna", historie darů seskupená podle podpořeného příběhu
  (`zona/darce`) (`EN0034`, read-model nad `EN0009`/`EN0004`).
- **S019** Zóna žadatele (fundraiser) (`zona/zadatel`) — vlastní žádosti žadatele (`EN0001`).
  Řízeno rolí; obrazovka nezachycena (§8 IA-Q4).
- **S020** Zóna patrona (`zona/patron`) — vlastní žádosti/příběhy patrona (`EN0001`, `EN0005`).
  Řízeno rolí; obrazovka nezachycena (§8 IA-Q4).
- **S017** Dashboard účtu (složené "Můj účet") — **pouze hypotéza**: naznačeno makketou vloženou do
  marketingového e-mailu, nikdy nezachyceno jako reálná obrazovka; nepovažovat za implementované
  (§8 IA-Q3).

### 3.7 Externí / sdílené platformové povrchy (vyloučeno — nejde o Patronem postavené UI)

Zaznamenáno, aby je vrstvy WIRE/COMP **nerekonstruovaly** jako UI aplikace; Patronus vlastní pouze
integrační hranici, nikoli obrazovku (vyloučené řádky viz `_ar/spec-draft/IA-screen-map.md`):

- **S-EXT1** Hostovaná brána Comgate — výběr platební metody (`pay1gate.cz/specify/…`) (`ES0001`).
- **S-EXT2** Hostovaná brána Comgate — zaplaceno / přesměrování zpět (`pay1gate.cz/dispatcher/…`)
  (`ES0001`).
- **S-EXT3** 3-D Secure výzva Revolut ACS (na straně vydavatele karty) — součást checkoutu `UC0005`,
  nikoli vlastnictví Patronus.
- **S-EXT4** PDF pravidel v prohlížečovém PDF prohlížeči — dokument je vysoce autoritativní zdroj
  EN/glosáře; chrome prohlížeče je platforma, nikoli UI aplikace.

Transakční e-maily (vrstva MSG, nikoli obrazovky): poděkování za dar (`MSG0019`) a follow-up
dokončení účtu (`MSG0003`, sporné) jsou indexovány jako řádky mapované na MSG v
`_ar/spec-draft/IA-screen-map.md`, nikoli jako obrazovky.

---

## 4. Vstupní body

Každý vstup odkazuje na `UCxxxx`, který spouští. "Auth" = vyžaduje autentizovanou relaci.

| Vstup | Spouštěč | První obrazovka | Odkaz UC | Vyžaduje auth |
|---|---|---|---|---|
| `/` | anonymní návštěva | S001 | `UC0023` | ne |
| `/pribeh/<slug>` | odkaz na příběh z katalogu / sdílení | S002 | `UC0005` (přes předání z `UC0023`) | ne |
| modální okno daru → brána | "Přejít k platbě" na S002 | S-EXT1 (`ES0001`) | `UC0005` | ne |
| callback brány → `/dekujeme` | přesměrování s výsledkem platby | S003 | `UC0006` | ne |
| hero přednastavení "Daruj N Kč měsíčně" | CTA trvalého daru na S001 | (proces daru) | `UC0007` | ne |
| "Koupím dobrošek" | CTA nákupu voucheru na S001/S002 | S005 (obrazovka nezachycena) | `UC0009` | ne |
| "Mám dobrošek" / uplatnění voucheru | vstup pro uplatnění voucheru na S002 | S002 (modální okno) | `UC0009` | ne |
| `/blog` | navigace "Blog" | S013 | (žádné UC — `EN0024`) | ne |
| `/o-nas` | navigace "O nás" | S015 | (žádné UC) | ne |
| `/vysledky` | navigace "Jak to funguje" / "Splněné příběhy" | S016 | `UC0011` | ne |
| `/pozadat-o-pomoc` (nebo `/zadost`) | navigace "Požádat o pomoc" / patička "Chci přihlásit příběh" | S006 | `UC0001` | ne |
| `/zadost/zadatel` | karta role žadatele na S006 | S007 → wizard S008a | `UC0001` | ne |
| `/zadost/patron` | karta role patrona na S006 | (intake patrona — nezachyceno) | `UC0001` | ne |
| `/zadost-formular` | přesměrování z S007 po kontaktu/souhlasu | S008a | `UC0001` | ne |
| modál obnovení `/dekujeme` | opakovaná návštěva s aktivní rozpracovanou relací (`EN0003`) | S003 (modál) | `UC0025` | ne |
| `/prihlaseni` | "Můj účet" bez autentizace | S009 | `UC0014` | ne |
| `/aktivovat-ucet` | aktivační odkaz z e-mailu | S010 | `UC0014` | ne |
| `/overit-prihlaseni` | "již dárce/žadatel/patron, aktivovat" | S021 | `UC0014` | ne |
| `/muj-ucet/nastaveni` | "Můj účet" → nastavení (po autentizaci) | S011 | `UC0024` | ano |
| `/muj-ucet/potvrzeni-o-darech` | "Můj účet" → daňová potvrzení (po autentizaci) | S012 | `UC0010` | ano |
| `zona/darce` | zóna účtu dárce (po autentizaci) | S018 | `UC0024` | ano (role `supporter`) |
| `zona/zadatel` | zóna účtu žadatele (po autentizaci) | S019 | `UC0024` | ano (řízeno rolí, §8 IA-Q4) |
| `zona/patron` | zóna účtu patrona (po autentizaci) | S020 | `UC0024` | ano (řízeno rolí, §8 IA-Q4) |

---

## 5. Mezimodulové procesy

Každý krok odkazuje na svůj `UCxxxx`; žádné vnitřní opakování obsahu UC.

### Proces daru (anonymní dárce → zaplaceno)

1. procházení/filtrování katalogu S001 → výběr příběhu (`UC0023`)
2. detail příběhu S002 → otevření modálního okna jednorázového daru, zadání částky + kontaktu +
   souhlasů (`UC0005`)
3. výběr metody Comgate S-EXT1 (`ES0001`, `UC0005`)
4. výzva 3-D Secure Revolut S-EXT3, pokud ji vyžaduje vydavatel karty (`UC0005`)
5. Comgate zaplaceno / přesměrování zpět na obchodníka S-EXT2 (`ES0001`, `UC0006`)
6. stránka úspěšné platby `/dekujeme` S003 (`UC0006`)
7. (asynchronně) e-mail s poděkováním za dar `MSG0019` — propaguje aktivaci účtu

### Proces intake žádosti (žadatel/fundraiser)

1. přistávací stránka volby role S006 → výběr "pomoci mému dítěti" (žadatel) (`UC0001`)
2. brána kontaktu + souhlasu S007 `/zadost/zadatel`; odeslán aktivační e-mail (`UC0001`, `UC0014`)
3. přesměrování na wizard S008a `/zadost-formular` (`UC0001`)
4. S008a krok 1 Váš příběh → S008b krok 2 Dar (kategorie daru, `EN0033`) → S008c krok 3 Údaje o vás
   → S008d krok 4 Patron → S008e krok 5 Přílohy (`UC0001`)
5. (pozdější návštěva) modál obnovení rozpracované žádosti S003/S-any → obnovit / ponechat /
   smazat (`UC0025`, `EN0003`)

### Proces aktivace / zřízení účtu (implicitní strana → přihlášení)

1. anonymní dar (`UC0005`) nebo žádost (`UC0001`) zřídí záznam strany (`EN0006`/`EN0008`)
2. S021 `/overit-prihlaseni` — existující strana požaduje aktivační odkaz (`UC0014`)
3. S022 `/poslat-aktivacni-email` potvrzení odeslání odkazu (`UC0014`; obsah nepotvrzen, §8 IA-Q9)
4. aktivační e-mail `MSG0003` → S010 `/aktivovat-ucet` nastavení hesla + přijetí podmínek (`UC0014`)
5. autentizováno → zóna účtu (S011 / S018) (`UC0024`)

### Proces přihlášení (vracející se strana)

1. S009 `/prihlaseni` zadání e-mailu → e-mail s magickým odkazem `MSG0004` (`UC0014`)
2. odkaz → autentizováno → zóna účtu (S011 / S018) (`UC0024`)
3. záloha: přihlášení heslem pro aktivované účty (`UC0014`)

### Samoobsluha daňového potvrzení (přihlášený dárce)

1. zóna účtu S018/S011 → "Potvrzení o darech" (`UC0024` → `UC0010`)
2. S012 `/muj-ucet/potvrzeni-o-darech` — záložky podle typu osoby, žádost o potvrzení (`UC0010`,
   `EN0014`)

---

## 6. Informační hierarchie

Odkaz na `ENxxxx` na každé úrovni; bez výčtu atributů entit nebo konfiguračních hodnot.

- **Úroveň účtu / strany:** identita autentizované strany a její samoobslužná zóna — Uživatel
  (`EN0008`), Kontakt (`EN0006`), záznam Účtu ve vlastnictví strany (`EN0007`) a read-model zóny
  dárce DonorAccountView (`EN0034`).
- **Úroveň žádosti (Žádost):** případový záznam, který žadatel vytváří a ke kterému se vrací —
  Žádost (`EN0001`), profil žádosti specifický pro roli za kroky wizardu (`EN0002`), relace pro
  přístup k rozpracované žádosti ApplicationSession (`EN0003`), a klasifikace požadovaného daru
  GiftCategory (`EN0033`).
- **Úroveň příběhu (Příběh) / kampaně:** veřejný fundraisingový příběh procházený a podporovaný —
  Kampaň (`EN0004`) a jeho ověřující Patron (`EN0005`).
- **Úroveň daru (Dar):** peníze, které dárce dává — Transakce (`EN0009`), RecurringTransaction pro
  cestu měsíčního přednastavení (`EN0010`), Voucher pro cestu Dobrošeku (`EN0013`) a daňové
  DonationConfirmation CZ, o které dárce žádá (`EN0014`).
- **Úroveň obsahu / instituce:** redakční a důvěryhodnostní obsah — Blog (`EN0024`) a agregovaná
  čísla dopadu, možná podložená ReportSnapshot (`EN0032` — nepotvrzeno, §8 IA-Q7).

---

## 7. Hranice modulů (vrstva UX)

UX-vrstevné seskupení pozorovaného samoobslužného povrchu. Jde o navigační shluky, nikoli o
dekompozici modulů na úrovni kódu (AR rekonstrukce nemá mapu modulů; viz `ARCH0001`). Mezimodulové
závislosti jsou UX předání, nikoli vazby v kódu.

| UX shluk | Vlastní obrazovky | Mezishlukové závislosti |
|---|---|---|
| Veřejný web a obsah | S001, S013, S014, S015, S016 | předává do Příběh a dar (S002) a Intake žádosti (S006) |
| Příběh a dar | S002, S003, S005 | používá externí bránu (S-EXT1/2/3) pro `UC0005`/`UC0006`; vstup ze S001 |
| Intake žádosti | S006, S007, S008a–S008e | po bráně kontaktu přesměrovává sama do sebe (wizard); sdílí Auth (aktivační e-mail) |
| Autentizace a zřízení účtu | S009, S010, S021, S022 | brána do zóny účtu; vstup z "Můj účet" a z výzev po daru/žádosti |
| Zóna účtu ("Můj účet") | S011, S012, S018, S019, S020, (S017 hypotéza) | vyžaduje shluk Auth; S012 realizuje `UC0010`; rozdělení podle role S018/S019/S020 |
| Externí / platforma (vyloučeno) | S-EXT1, S-EXT2, S-EXT3, S-EXT4 | není postaveno Patronem; pouze integrační hranice (`ES0001`) |

**Poznámka k hranicím:** AR rekonstrukce nevytvořila **žádnou** mapu UX modulů ve stylu
`_ar/repo-map/modules.md`, kterou by bylo možné přepsat, takže zde nelze tvrdit žádný konflikt
hranic modulů; výše uvedené shluky jsou seskupení autorovaná v IA. Jediné napětí v hranicích, které
stojí za zmínku, je **trojcestné rozdělení zóny účtu** (`zona/darce` vs `zona/zadatel` vs
`zona/patron`) oproti **dvěma podstránkám `/muj-ucet/*`** — zda se skládají do jedné oblasti
"Můj účet", nebo jde o samostatné oblasti řízené rolí, je nevyřešeno (§8 IA-Q2, IA-Q3).

---

## 8. Otevřené IA otázky

Povinné. Každé nevyřešené rozhodnutí o navigaci/roli/route s uvedeným rozhodovatelem a stavem.
Žádné nesmí být tiše předpokládáno.

| # | Otázka | Kontext / dopad | Rozhoduje | Stav |
|---|---|---|---|---|
| IA-Q1 | Jaká je **URL přistávací stránky volby role** (S006) samotné? | Kód napevno definuje pouze *odchozí* odkazy `/zadost/zadatel` + `/zadost/patron` (`_ar/evidence/gap-closure-evidence.md` OQ-01); na kandidáty ukazují dva odkazy v menu — `'Chci přihlásit příběh' → /zadost` a `'Požádat o pomoc' → /pozadat-o-pomoc` — ale který z nich (nebo zda oba aliasují stejný pohled) je nejisté. Ovlivňuje kanonický vstupní bod URL žádosti pro přestavbu. | Architekt + klient (routy/procesní mapy) | otevřeno |
| IA-Q2 | Je oblast **"Můj účet" jedna složená stránka, nebo několik samostatných stránek řízených rolí**? | Dvě podstránky `/muj-ucet/*` (S011, S012) plus tři zóny `zona/*` podle role (S018–S020) jsou kódem potvrzeny jako oddělené mechanismy (REST resource vs Drupal Views); žádný kód je nepropojuje do jednoho menu/dashboardu (`UC0024` Evidence Pending). Ovlivňuje celou IA účtu a design menu účtu. | UX-lead + architekt | otevřeno |
| IA-Q3 | Existuje skutečně **bohatší složený dashboard účtu (S017)** — záložky "Pro vás / Všechny (N)", odpočet u jednotlivých příběhů, ke stažení dostupná potvrzení, zpětná vazba? | Doloženo **pouze** makketou uvnitř e-mailu "Dokončete svůj uživatelský účet" (`_ar/evidence/ui/ui-observed-areas.md` §19); žádná reálná obrazovka, view ani kontrolér v backend zdrojovém kódu (`EN0034` Evidence Gaps). Považováno za hypotézu; nesmí být rekonstruováno jako implementované. | Produkt + UX-lead | otevřeno |
| IA-Q4 | Jaké jsou **řízení přístupu podle role a skutečné obrazovky** pro `zona/zadatel` (S019) a `zona/patron` (S020)? | `zona/darce` je řízena rolí `supporter` a kódem potvrzena (`EN0034`); sesterské views `fundraiser_zone` / `patron_zone` existují (base_table `application`), ale jejich obrazovky **nebyly zachyceny** a neexistuje vrstva ACL, kterou by bylo možné citovat. Popisky rolí zaznamenány; řízení přístupu nepotvrzeno. Ovlivňuje IA samoobsluhy žadatele/patrona. | Architekt (návazný úkol ACL) | otevřeno |
| IA-Q5 | Co obsahují **kroky wizardu žádosti 4 "Patron" (S008d) a 5 "Přílohy" (S008e)**? | Přítomny v evidenci pouze jako popisky stepperu; pole/chování nikdy nezachyceno (`_ar/coverage/ui-gap-analysis.md` §b C1). Kód potvrzuje, že krok 4 = pole `patron_*`, krok 5 = přílohy/zaměstnání (`_ar/evidence/gap-closure-evidence.md` OQ-01), ale pro WIRE neexistuje žádná evidence obrazovky. | UX-lead (opětovné zachycení / kód) | otevřeno |
| IA-Q6 | Je **navigace RO/MD rovnocenná** pozorované navigaci CZ? | Veškerá evidence pochází z tenantu CZ. `zona/darce` (view `supporter_zone`) je přítomna pouze pod `config_czech`; rovnocennost RO/MD nepotvrzena (`EN0034` Evidence Gap 2, `UC0024`). Ovlivňuje, zda jedna IA pokrývá všechny tři tenanty, nebo jsou potřeba IA per-tenant. | Architekt + klient | otevřeno |
| IA-Q7 | Jsou **agregovaná čísla dopadu "Výsledky"** (S016) počítaný read-model, nebo statický redakční obsah? | Nelze určit ze screenshotu (`_ar/evidence/ui/ui-observed-areas.md` §17); může jít o `EN0032` ReportSnapshot / `UC0017`, nebo o napevno vložený text. Ovlivňuje, zda je S016 dynamická obrazovka, nebo obsahová stránka. | Architekt (kód) | otevřeno |
| IA-Q8 | Na jaké **routy vedou odkazy ve shluku patičky** (Pravidla poskytování pomoci, Naše desatero, Splněné příběhy, Výroční zprávy, "koronakrize", "Souhlas se zpracováním")? | Odkazy v patičce pozorovány doslovně (`_ar/evidence/ui/ui-observed-areas.md` §6, §16), ale jejich cíle jsou doloženy jen částečně — Pravidla vedou na PDF pravidel (S-EXT4), Splněné příběhy na S016; ostatní (Desatero, výroční zprávy) se vykreslují na S015; zbytek je nezmapován. Nízké riziko pro přestavbu; zaznamenáno pro úplnost. | Vlastník obsahu | otevřeno |
| IA-Q9 | Jaký je skutečný **obsah `/poslat-aktivacni-email` (S022)**? | Záznam ukazuje pouze navigaci + cookie banner + patičku; tělo potvrzení je mimo záběr (`_ar/spec-draft/UI-gap-open-questions.md` OQ-03). Chování odvozeno, nedoloženo. Nízká priorita — pravděpodobně triviální potvrzení `UC0014`. | UX-lead (opětovné zachycení / kód) | otevřeno |
| IA-Q10 | Kde je **obrazovka nákupu voucheru (Dobrošek) (S005)** a jaká je jeho route/proces? | Zachyceny jsou pouze *vstupní body* nákupu ("Koupím dobrošek" na S001, "Mám dobrošek" na S002); v evidenci neexistuje žádná obrazovka nákupu. `UC0009` pokrývá uplatnění/ověření; obrazovka checkoutu nákupu je mezera. | UX-lead (opětovné zachycení / kód) | otevřeno |
| IA-Q11 | Jaká je **podmínka spuštění karty SBÍRKOVÝ ÚČET / "Nechám to na vás"** v katalogu (S001)? | Kód potvrzuje, že toto **není** typ příběhu: jde o jedinou transparentní kampaň `isGeneral()` (`Settings::get('transparent_account')`), které je přiznáno zvláštní zacházení kartou dekuplovanou front-end komponentou mimo tento zdrojový kód (`_ar/evidence/gap-closure-evidence.md` OQ-05). Zda kartu "Nechám to na vás" dostává každá kampaň `isGeneral()`, nebo jen konkrétní jedna, není doloženo. Ovlivňuje IA karet katalogu. | Architekt (front-end repozitář / runtime) | otevřeno |
| IA-Q12 | Je **cesta intake patrona `/zadost/patron`** strukturována stejně jako wizard žadatele? | Přistávací stránka volby role S006 nabízí kartu patrona → `/zadost/patron`; zachycena byla pouze cesta žadatele (S007→S008). Obrazovky intake patrona nejsou pozorovány. Ovlivňuje IA žádosti na straně patrona. | UX-lead (opětovné zachycení / kód) | otevřeno |

---

## 9. Co tato IA NEPOKRÝVÁ

Tato IA nerozhoduje (odkazuje na doc_id, nikdy neopakuje obsah):

- detailní procesy use-case → `_ar/spec-draft/UC/`
- atributy entit / životní cyklus → `_ar/spec-draft/EN/`
- business pravidla / konfigurační hodnoty → `_ar/spec-draft/BR/`
- pravidla řízení přístupu — **v této rekonstrukci neexistuje vrstva ACL**; navigační položky
  řízené rolí zaznamenávají pozorovanou roli a vznášejí otevřenou IA otázku (IA-Q4) místo citace
  neexistujícího `ACLxxxx`
- detail integrace externích systémů / vnitřnosti poskytovatelů → `_ar/spec-draft/ES/` (`ES0001`
  ComGate atd.)
- technologický stack / UI kit → `_ar/spec-draft/ARCH/` (`ARCH0001`)
- obsah transakčních zpráv → `_ar/spec-draft/MSG/`
- rozvržení jednotlivých obrazovek, zóny, komponenty, texty → `WIRE` / `COMP` / `COPY`
  (další krok: WIRESynthesizer)
- navigace administračního back-office (`/admin/**`) — zcela mimo zachycenou evidenční sadu
</content>
