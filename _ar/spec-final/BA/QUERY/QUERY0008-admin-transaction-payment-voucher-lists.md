---
doc_id: QUERY0008
title: Admin Transaction / Payment & Voucher Lists
canonical_layer: QUERY
spec_type: query-spec
status: canonical
modules: []
query_type: list
references:
  - EN0009
  - EN0010
  - EN0013
  - EN0004
  - EN0008
  - UC0005
  - UC0006
  - UC0009
  - FN0007
  - FN0010
  - FN0011
  - ARCH0006
  - ARCH0007
---

# QUERY0008 – Administrátorské seznamy transakcí / plateb a dárkových poukazů

## Účel

Administrátorské (back-office) seznamy nad hlavní knihou transakcí a jejími odvozeninami (trvalé
platby, dárkové poukazy). Sdruženo do jednoho kontraktu, protože sdílejí základní entitu `transaction`
a stejný back-office finanční záměr; jsou rozděleny do několika zobrazení (platby, platby dle data,
bez příběhu, ne-dary, vrácené platby) a doplněny sesterskými seznamy pro trvalé platby a dárkové
poukazy.

Evidence: `config/views.view.view_transactions.yml` (5 zobrazení),
`config/views.view.recurring.yml`, `config/views.view.vouchers.yml`,
`config/views.view.payments_report.yml`.

## Konzumenti

- content_admin, risk_manager, manager, marketing, front (transakce/trvalé platby);
  manager, marketing (dárkové poukazy). Omezení rolí dle jednotlivého zobrazení je uvedeno níže.

## Zdrojové entity

- EN0009 – Transaction (základní entita; `ext_status`, `price`, `is_donation`, `is_voucher`, `is_recurring`, `is_sent_to_bank`, `bank_vs`, `bank_date`, `bank_month`, `ext_trans_id`, `ext_fee`, `test`, `transparent`, `parent`, `campaign`)
- EN0010 – RecurringTransaction (seznam trvalých plateb)
- EN0013 – Voucher (seznam dárkových poukazů)
- EN0004 – Campaign (vazba na příběh)
- EN0008 – User (sloupec e-mailu dárce)

## Filtry a seskupení

| Zobrazení / display (cesta) | Filtrační výřez | Rozsah rolí | Poznámky |
|---|---|---|---|
| `view_transactions` výchozí (`admin/transactions`) | Platby s příběhem; exponované filtry id/campaign/ext_status/mail/bank_month/ext_trans_id/transparent/type | content_admin, risk_manager, manager, marketing, front | Plný seznam, 200/stránku. Confirmed. |
| `view_transactions` page_1 „Platby bez příběhu“ (výchozí titulek `admin/transactions`) | viz výše | jako výše | Confirmed. |
| platby dle data (`admin/reports/payments-by-date`) | `ext_status = PAID` + rozsah data vytvoření (exponovaný) | jako výše | Confirmed. |
| transactions_without_campaign | `campaign` prázdné, `ext_status=PAID`, `is_donation=1`, `is_voucher=0` | jako výše | Confirmed. |
| transactions_not_donations | `campaign` prázdné, `ext_status=PAID`, `is_donation=0` | jako výše | Confirmed. |
| vrácené platby (`admin/transactions/refunded`) | `ext_status = REFUNDED` | jako výše | Confirmed. |
| `recurring` (`admin/transactions/recurring`) | Plány trvalých plateb | content_admin, risk_manager, manager, marketing, front | 100/stránku. Confirmed. |
| `vouchers` (`admin/vouchers`) | Dárkové poukazy; exponované filtry status/is_applied/campaign/recipient_email/id | manager, marketing | 200/stránku. Confirmed. |
| `payments_report` (`admin/reports/payments-report`) | Vykreslené entity transakcí | access: none (otevřené) | Viz Otevřené body. Confirmed. |

## Odvozené výstupy

| Výstup | Význam | Poznámky |
|---|---|---|
| sloupce hlavní knihy | `ext_status`, `price`, `bank_vs`, `bank_date`, `bank_month`, `ext_trans_id`, `ext_fee`, `is_recurring`, `is_voucher`, `type`, `comment`, `parent` | Vlastní EN0009. Confirmed. |
| `mail` | E-mail dárce (join na uživatele) | PII. Confirmed. |
| `transparent_views_field` | Projekce příznaku transparentnosti | Vypočítané pole views. Confirmed. |
| sloupce trvalých plateb | `price`, `day`, `last_recurring_payment`, `created`, `canceled`, e-mail dárce | Vlastní EN0010. Confirmed. |
| sloupce dárkových poukazů | kód, cena, status, uplatnění/expirace, e-mail odesílatele/příjemce, comgate id/status | Vlastní EN0013; PII (e-maily). Confirmed. |

## Tvar výsledku

- Stránkované back-office tabulky; exponované filtry; sady sloupců dle jednotlivého zobrazení.

## Reference

- UC: UC0005 (Make a Donation), UC0006 (Confirm Payment), UC0009 (Redeem/Validate Voucher)
- FN: FN0007 (Donation & Payment Processing), FN0010 (Recurring Donation Scheduling), FN0011 (Voucher)
- EN: EN0009, EN0010, EN0013, EN0004, EN0008
- ARCH: ARCH0006 (Donations & Payments), ARCH0007 (Finance & Reconciliation)

## Otevřené body

- **Riziko (nechráněný přístup):** `payments_report` (`admin/reports/payments-report`) má přístup
  zobrazení `type: none` — samotné zobrazení nevynucuje žádnou roli/oprávnění; spoléhá se výhradně na
  ochranu poskytovanou route/menu obalem. Označit pro uzávěrku ACL. `Conflict — requires clarification.`
- Tato zobrazení neuplatňují rozlišení dle země/tenanta (předpoklad samostatné DB pro každou zemi
  zatím nepotvrzen).
