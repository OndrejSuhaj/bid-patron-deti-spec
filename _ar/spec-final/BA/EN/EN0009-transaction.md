---
doc_id: EN0009
title: Transaction
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0004  # Campaign (Story) — donation target
  - EN0008  # User — owner / donor
  - EN0010  # RecurringTransaction — subscription schedule promoted from a paid transaction
  - EN0013  # Voucher — Dobrošek promoted from a paid transaction
  - BR-PaymentAndMoneyIntegrity
  - BR-PaymentGatewayCallbacks
  - BR-BankReconciliationAndMatching
  - BR-RecurringDonationPolicy
  - BR-VoucherPolicy
---

# EN0009 — Transakce

## Účel

Transakce je záznam jednoho pohybu peněz do platformy: jednorázový dar, firemní dar, nákup
dárkového poukazu, opakovaná platba za dítě (recurring), nebo importovaný bankovní/gateway kredit.
Jde o centrální peněžní entitu domény — dosažení stavu paid u transakce je to, co pohání vybranou
částku cíle daru, promuje opakující se plány a poukazy a spouští potvrzení směrem k dárci.

## Životní cyklus

- PENDING
- AUTHORIZED
- PAID
- CANCELLED
- REFUNDED

## Přechody stavů

(žádný) → PENDING
trigger: UC0005 – Make a Donation (transakce vytvořena s referencí platební brány při nákupu daru/poukazu)

PENDING | AUTHORIZED → PAID | CANCELLED | REFUNDED
trigger: UC0006 – Confirm Payment (Gateway Callback)

(žádný) → PAID
trigger: UC0008 – Reconcile Bank Transactions (bankovní/AISP import vytvoří transakci již ve stavu paid)

PAID (nespárováno) → PAID (spárováno)
trigger: UC0008 – Reconcile Bank Transactions (na transakci se otiskne bankovní datum/období a párovací identifikátory; viz BR-BankReconciliationAndMatching)

PAID → nová podřízená transakce (rozdělení přeplatku)
trigger: UC0005 / UC0006 / UC0007 (zaplacená transakce, jejíž cíl daru je přeplacen, se rozdělí na novou podřízenou transakci zaúčtovanou na transparentní/sběrný účet; viz BR-PaymentAndMoneyIntegrity)

PAID → promuje EN0010 (RecurringTransaction) a EN0013 (Voucher)
trigger: UC0006 – Confirm Payment (Gateway Callback) (první dosažení stavu paid aktivuje navázanou RecurringTransaction a/nebo označí navázaný Voucher jako zaplacený; viz BR-RecurringDonationPolicy, BR-VoucherPolicy)

Conflict — requires clarification: REFUNDED je deklarovaná hodnota stavu; zda je dosažitelná pouze přes callback platební brány (UC0006), nebo i jinou cestou, není doloženo (viz Otevřené otázky).

## Atributy

### Systémem spravované atributy

- status (výčet; povinný; hodnoty: PENDING, AUTHORIZED, PAID, CANCELLED, REFUNDED — platební stav)
- fee (desetinné číslo; nepovinný; poplatek za zpracování hlášený platební bránou)
- gateway reference (řetězec; nepovinný; identifikátor této transakce v platební bráně)
- payment-identity key (řetězec; nepovinný; zamýšlená unikátní identita transakce na úrovni aplikace; viz Invarianty)
- reconciliation markers (datum/období a párovací identifikátory; nepovinné; nastaveno při spárování transakce s bankovním kreditem — viz BR-BankReconciliationAndMatching)
- confirmation-sent flag (boolean; nepovinný; zda bylo dárci u této transakce odesláno potvrzení/poděkování)
- reconciled flag (boolean; nepovinný; zda byla transakce spárována s bankovním/gateway vypořádáním)
- donation-kind flags (množina booleanů; nepovinná; donation / voucher / recurring / transparent-account — popisují, co transakce představuje; nejde o jediný výčet)
- kind (výčet; nepovinný; hodnoty: corporate, owner)
- parent (odkaz na EN0009 – Transaction; nepovinný; nastaveno u podřízené transakce vzniklé rozdělením přeplatku)
- original donation target (odkaz na EN0004 – Campaign; nepovinný; cíl daru zaznamenaný při vytvoření transakce, zachovaný i po pozdější změně cíle)

### Uživatelem zadávané atributy

- amount (desetinné číslo; povinný; darovaná/zaplacená částka)
- donation target (odkaz na EN0004 – Campaign; povinný; příběh, ke kterému transakce přispívá)
- owner (odkaz na EN0008 – User; nepovinný; dárce/kupující, pokud je identifikovatelný)
- payment method (řetězec; nepovinný)
- comment (řetězec; nepovinný; poznámka od dárce)
- voucher selection data (strukturovaná hodnota; nepovinná; přítomná u transakce nákupu poukazu; řídí vytvoření poukazu — viz EN0013, BR-VoucherPolicy)

## Invarianty

- Příspěvek transakce do vybrané částky jejího příběhu se počítá pouze ve stavu paid; viz BR-PaymentAndMoneyIntegrity.
- Vybraná částka cíle daru je odvozený součet přes jeho zaplacené transakce, přepočítávaný při každém uložení transakce; viz BR-PaymentAndMoneyIntegrity.
- Přípustnost peněžního záznamu vůči nafinancovanému příběhu se řídí pravidlem BR-PaymentAndMoneyIntegrity (INV06).
- Sebereference parent/child existuje kvůli přenosu rozdělení přeplatku (pravidlo rozdělení přeplatku vlastní BR-PaymentAndMoneyIntegrity, INV07).
- Mapování stavů z callbacku platební brány a autenticita callbacku se řídí pravidlem BR-PaymentGatewayCallbacks; stav transakce se smí měnit pouze cestou povolenou touto politikou.
- Payment-identity key má být unikátní pro každou transakci, ale tato jedinečnost je vynucována pouze na úrovni aplikace, nikoli databázovým omezením; viz mezera v invariantech v Otevřených otázkách a BR-PaymentAndMoneyIntegrity.
- Aktivace RecurringTransaction závisí na tom, zda její zdrojová transakce dosáhne stavu paid; viz BR-RecurringDonationPolicy.
- Stav paid/publikováno u poukazu závisí na tom, zda jeho nákupní transakce dosáhne stavu paid; viz BR-VoucherPolicy.
- První transakce, kterou vlastnící uživatel dovede do stavu paid, tomuto uživateli uděluje povýšení role dárce; obsah pravidla vlastní BR-PaymentAndMoneyIntegrity (vedlejší efekt na roli strany).

## Vztahy

- EN0004 – Campaign (Story): cíl daru a původní cíl daru
- EN0008 – User: vlastník/dárce
- EN0009 – Transaction (sebereference): parent, u podřízené transakce vzniklé rozdělením přeplatku
- EN0010 – RecurringTransaction: promována/aktivována, jakmile tato transakce dosáhne stavu paid
- EN0013 – Voucher: promován/označen jako zaplacený, jakmile tato transakce dosáhne stavu paid

## Otevřené otázky

1. Je REFUNDED dosažitelný ze stavu PAID pouze cestou callbacku platební brány, nebo i jinou cestou? Není plně doloženo.
2. Co řídí zachycení (capture) AUTHORIZED → PAID mimo cron cestu opakovaných plateb? Není plně doloženo.
3. Payment-identity key nemá databázové omezení jedinečnosti — souběžné callbacky nebo opakovaná podání mohou potenciálně vytvořit duplicitní transakce nebo obejít kontrolu identity souběhem (race). Označeno jako mezera v peněžní integritě pod BR-PaymentAndMoneyIntegrity, nikoli jako potvrzený invariant.
