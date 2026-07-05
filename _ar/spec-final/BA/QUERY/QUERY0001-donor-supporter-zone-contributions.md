---
doc_id: QUERY0001
title: Donor / Supporter Zone Contributions
layer: QUERY
spec_type: query-spec
status: imported
modules: []
query_type: summary
references:
  - EN0009
  - EN0004
  - EN0034
  - EN0008
  - UC0024
  - FN0007
  - ARCH0006
---

# QUERY0001 – Kontribuce dárce / zóny podporovatele

## Účel

Read-model stojící za zónou účtu přihlášeného podporovatele ("Moje zóna"): vlastní
**uhrazené, reálné (netestovací) dary** dárce agregované po příbězích, plus dvě souhrnné
částky ("transparentně darováno" / "alokováno") zobrazené na účtu dárce. Umožňuje
podporovateli vidět, které příběhy podpořil a v jaké výši.

Evidence: `sync_config/config_czech/views.view.supporter_zone.yml` (stránka `zona/darce`);
sesterský blok `config/views.view.donations.yml` (identický read-model, zobrazení bloku);
`web/modules/custom/campaign/src/Plugin/rest/resource/v33/CampaignsResource.php`
`getTransparentAmountDonated()` / `getTransparentAmountAllocated()` (souhrnné částky dárce).

## Konzumenti

- Podporovatel / dárce (role `supporter`) — pouze vlastní zóna účtu.
- Kontext dárce v API katalogu příběhů (interagované / alokované částky ve vlastním záznamu dárce).

## Zdrojové entity

- EN0009 – Transaction (základní řádek; `price`, `ext_status`, `is_donation`, `user_id`, `campaign`, `test`, `transparent`, `is_recurring`)
- EN0004 – Campaign (klíč pro seskupení / název příběhu)
- EN0034 – DonorAccountView (projekce dárce, kterou tato zóna materializuje)
- EN0008 – User (aktuální dárce; rozsah argumentu)

## Filtry a seskupení

| Filtr / seskupení | Význam | Poznámky |
|---|---|---|
| `user_id = current_user` | Omezuje na vlastní transakce přihlášeného dárce | Argument view `user_id`, `default: current_user`; bez cesty pro přepsání. Confirmed. |
| `ext_status = 'PAID'` | Započítávají se pouze vypořádané platby | Natvrdo zakódovaný filtr view. Confirmed. |
| `is_donation = 1` | Vylučuje transakce, které nejsou dary (např. poukazy) | Natvrdo zakódovaný filtr view. Confirmed. |
| group by `campaign` | Jeden řádek za každý podpořený příběh | View `group_by: true`, `campaign` seskupena, `price` agregována jako `sum`. Confirmed. |
| access: role `supporter` | Stránka/blok zóny viditelný pouze podporovatelům | Přístup view `type: role`. Confirmed. |

Zdrojem obou souhrnných částek dárce je raw SQL v `CampaignsResource`, **podmíněné podle země**:
CZ sčítá `transaction.price WHERE transparent = 1 AND user_id = :uid`; mimo CZ se sčítá
`... WHERE is_recurring = 1 AND user_id = :uid`. "Alokováno" opakuje totéž, ale vylučuje
transparentní/nekonečný účet (`campaign <> :transparent_account`). Na tyto dvě souhrnné částky
není aplikován žádný filtr `ext_status` (na rozdíl od view výše). Confirmed / Partial (sémantika
rozdělení `transparent` vs. `is_recurring` není plně evidována).

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| `campaign` | Příběh, ke kterému dary patří | Popisek entity-reference, odkazuje na příběh. Confirmed. |
| `price` (sum) | Celková částka uhrazená tímto dárcem danému příběhu | Celočíselný součet přes seskupené řádky. Confirmed. |
| souhrnná částka "darováno" dárce | Přehled: celoživotně transparentně darováno (CZ) / trvale darováno (mimo CZ) | Raw-SQL `SUM(price)`, bez ochrany `ext_status`/`test` → viz Otevřené body. Partial. |
| souhrnná částka "alokováno" dárce | Jako výše, s vyloučením transparentního/nekonečného účtu | Raw-SQL `SUM(price)`. Partial. |

## Tvar výsledku

- Stránka zóny (`zona/darce`) a znovupoužitelný blok: plochý seznam, jeden řádek za příběh, bez stránkování (všechny řádky).
- Seřazeno podle `campaign` vzestupně.
- Souhrnné částky: dvě skalární celá čísla vykreslená na objektu účtu dárce.

## Odkazy

- UC: UC0024 (Manage Donor Account)
- FN: FN0007 (Donation & Payment Processing — sémantika peněz je odkazována, nikoli opakována)
- EN: EN0009, EN0004, EN0034, EN0008
- ARCH: ARCH0006 (Donations & Payments Domain)

## Otevřené body

- **Riziko (raw-SQL součet obchází persistovanou hodnotu):** souhrnné částky dárce jsou počítány
  ad-hoc raw-SQL `SUM(price)` v `CampaignsResource` místo znovuužití read path `campaign_raised`
  příběhu; obě definice se mohou rozejít. Viz Otevřené body QUERY0004 a vlastnictví BR.
- **Riziko (chybí ochrana test/vypořádáno u souhrnných částek):** raw-SQL součty
  "darováno"/"alokováno" nefiltrují `ext_status = 'PAID'` ani `test = 0`, na rozdíl od view zóny
  po příbězích — mohou se započítávat čekající/testovací řádky. Ověřit zamýšlenou sémantiku s BR/FN0007.
- Větvení `transparent` (CZ) vs. `is_recurring` (mimo CZ), které vybírá, jaké řádky se počítají
  jako kontribuce dárce, není ve stávajících zdrojích vysvětleno —
  `Hypothesis — Not evidenced in current sources.`
