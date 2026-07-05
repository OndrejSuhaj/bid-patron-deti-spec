---
doc_id: ACL0005
title: Donations & Payments Access
canonical_layer: ACL
spec_type: access-control
status: canonical
modules: []
references:
  - EN0009
  - EN0010
  - UC0005
  - UC0006
  - UC0007
  - FN0007
  - FN0008
  - FN0010
  - BR-PaymentAndMoneyIntegrity
  - BR-PaymentGatewayCallbacks
  - BR-RecurringDonationPolicy
  - ARCH0006
---

# ACL0005 – Přístup k darům a platbám

## Účel

Přístup k Transaction (EN0009), RecurringTransaction (EN0010), REST rozhraní pro vytvoření daru
a callback routám platebních bran (ComGate ES0001, Netopia ES0002, MAIB ES0003, Moneta ES0004).
Model aktorů je ve vlastnictví ACL0001.

## Model aktorů

- Vytvoření daru je **veřejná** akce: `anonymous` i `authenticated` mohou přes REST vytvářet
  (POST) transakce a poukazy.
- `supporter` může zrušit **svůj vlastní** trvalý dar (recurring transaction).
- `manager` je jediná backoffice role s CRUD oprávněním na Transaction.
- Callback routy platebních bran jsou fakticky veřejné (`access content`) a spoléhají na podpisy
  brány.

Evidence: `config/user.role.anonymous.yml`, `config/user.role.authenticated.yml`,
`config/user.role.supporter.yml`, `config/user.role.manager.yml`; routing
`comgate/comgate.routing.yml`, `maib/maib.routing.yml`, `netopia/netopia.routing.yml`,
`monetaapi/monetaapi.routing.yml`; permission defs `transaction/transaction.permissions.yml`,
`transaction_recurring/transaction_recurring.permissions.yml`.

## Zdroje (Resources)

- Transaction (EN0009) — vytvoření (veřejné REST), CRUD (backoffice)
- RecurringTransaction (EN0010) — zrušení (vlastní, veřejné REST)
- Uplatnění/validace poukazu (v kontextu transakce) — veřejné REST
- Callbacky platebních bran — ComGate/MAIB status update, Netopia confirm/redirect

## Matice

| Aktor / role | Zdroj | Akce | Rozsah | Poznámky |
|---|---|---|---|---|
| `anonymous` | Transaction (EN0009) | create | public | `restful post transaction_rest_resource`, `..._32`, `transaction_voucher__*`, `transaction_vouchers__*`. |
| `anonymous` | Uplatnění/validace poukazu | POST | public | `restful post voucher_apply_resource(_v32)`, `voucher_validation_resource(_v32)`. |
| `anonymous` | Potvrzení o daru | POST | public | `restful post donation_confirmation_resource_v31/_v32`. |
| `authenticated` | Transaction (EN0009) | create | public | Stejný allow-list POST pro transakci/poukaz jako u anonymous. |
| `supporter` | RecurringTransaction (EN0010) | cancel | own | `cancel own recurring transaction` + `restful post transaction_recurring_cancel_resource`. Vlastnictví je vynucováno v kódu resource. |
| `manager` | Transaction (EN0009) | add, edit, view published/unpublished | global | `add/edit transaction entities`, `view (un)published transaction entities`. |
| `anonymous`/`authenticated` (via route) | ComGate callback `/transaction/status_update` | POST/update | public | Route vyžaduje pouze `access content` (ACL0001 G-05). Evidence: `comgate/comgate.routing.yml`. |
| `anonymous`/`authenticated` (via route) | MAIB callback `/transaction/status_update` | update | public | Route vyžaduje pouze `access content` (ACL0001 G-05). Evidence: `maib/maib.routing.yml`. |
| `anonymous`/`authenticated` (via route) | Netopia confirm/redirect/result | POST/redirect | public | Všechny tři routy Netopia vyžadují pouze `access content` (ACL0001 G-05). Evidence: `netopia/netopia.routing.yml`. |
| — | Moneta `/monetaapiid` | — | none | Route `_access: 'FALSE'` — vypnutá/nedostupná. Evidence: `monetaapi/monetaapi.routing.yml`. |

## Výjimky

- **Veřejné vytvoření daru je záměrné** (flow pro koncového uživatele). Je zde uvedeno, protože se
  jedná o autorizační rozhraní, nikoli o defekt.
- **Callback routy platebních brány nemají žádné Patronus ACL** nad rámec `access content`;
  autenticita je delegována na podpisy/IPN validaci na straně brány, nikoli na oprávnění vázaná na role
  (ACL0001 G-05). Sémantika pravidla je ve vlastnictví BR-PaymentGatewayCallbacks.
- Rozsah `own` u zrušení trvalého daru u role `supporter` je určen logikou vlastnictví resource-pluginu,
  nikoli sloupcem rozsahu role.

## Reference

- UC: UC0005 (vytvoření daru), UC0006 (potvrzení platby), UC0007 (zpracování trvalého daru)
- FN: FN0007 (zpracování daru/platby), FN0008 (integrace platební brány), FN0010 (plánování trvalého daru)
- EN: EN0009 (Transaction), EN0010 (RecurringTransaction)
- ES: ES0001 (ComGate), ES0002 (Netopia), ES0003 (MAIB), ES0004 (Moneta)
- BR: BR-PaymentAndMoneyIntegrity, BR-PaymentGatewayCallbacks, BR-RecurringDonationPolicy
- ARCH: ARCH0006 (Dary a platby)

## Otevřené body

- Predikáty vlastnictví pro jednotlivé resources u veřejného POST transakce/poukazu jsou detaily
  resource-pluginu odložené na fázi API/contract.
