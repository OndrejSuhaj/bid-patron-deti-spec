---
doc_id: EN0010
title: RecurringTransaction
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0009  # Transaction — the originating / linked payment
  - BR-RecurringDonationPolicy
  - BR-PaymentGatewayCallbacks
  - UC0005
  - UC0006
  - UC0007
---

# EN0010 — RecurringTransaction

## Účel

Plán trvalého daru: trvalé ujednání, které autorizuje opakované strhávání dárcovy platby (trvalý
dar / donation na bázi předplatného) namísto jednorázové platby. Nese pravidelnou výši příspěvku,
periodu strhávání a den v měsíci, autorizaci u platební brány potřebnou k budoucímu strhávání plateb
bez opětovného zadání údajů dárcem a záznam o tom, kdy byla platba naposledy strhnuta nebo kdy byl
plán zrušen.

---

## Lifecycle

- Inactive — vytvořen současně s dárcovou první platbou; zatím neautorizován ke strhávání.
- Active — autorizován; způsobilý k pravidelnému strhávání podle nastaveného plánu.

Hypothesis — Not evidenced: po zaznamenání časového razítka zrušení může existovat samostatný stav
Cancelled; zda zrušení skutečně přepne stav Activation (na rozdíl od pouhého zápisu časového
razítka), není vyřešeno — viz Otevřené otázky č. 1. Atribut Activation state je doložen pouze pro
hodnoty Inactive / Active.

---

## Přechody stavů

(žádný) → Inactive
spouštěč: UC0005 — Make a Donation (vytvořen společně s první, výchozí platbou)

Inactive → Active
spouštěč: UC0006 — Confirm Payment (Gateway Callback), když propojená Transaction (EN0009) dosáhne
stavu PAID; viz INV01. Přechod je idempotentní — opětovné potvrzení, pokud je již Active, nemá další
účinek.

Active → Active (charged)
spouštěč: UC0007 — Process Recurring Donation; pravidelné strhnutí vytvoří novou navazující
Transaction (EN0009) a při úspěchu posune záznam o posledním úspěšném strhnutí plánu; viz INV02.

Active → Active (gateway authorization updated)
spouštěč: UC0006 — Confirm Payment (Gateway Callback); autorizace u platební brány použitá pro
budoucí strhávání může být (znovu) ustavena z potvrzovacího callbacku dané oblasti.

(Přechod Active → Cancelled není uveden: jeho spouštěč, ani samotná existence samostatného stavu
Cancelled, nejsou doloženy — viz poznámka Hypothesis u Lifecycle a Otevřené otázky č. 1.)

---

## Atributy

### Systémem spravované atributy

- Pravidelná výše příspěvku (numerický; volitelný; výše pravidelného daru)
- Perioda strhávání (kategoriální; kadence opakování)
- Platební poskytovatel (kategoriální; platební brána směrující strhávání tohoto plánu)
- Den strhávání (numerický; den v měsíci, kdy se plán stává splatným)
- Activation state (kategoriální; hodnoty: Inactive / Active — viz Lifecycle)
- Gateway authorization (opaque; podmíněný; token umožňující budoucí strhávání bez opětovného
  zadání údajů dárcem; není ustaven u každé platební brány — viz Otevřené otázky)
- Platnost gateway authorization (datum/čas; podmíněný; je-li přítomen, okamžik, po kterém již
  gateway authorization nelze použít)
- Poslední úspěšné strhnutí (datum/čas; volitelný; časové razítko posledního úspěšného pravidelného
  strhnutí)
- Časové razítko zrušení (datum/čas; volitelný; kdy bylo zaznamenáno zrušení)

### Uživatelem zadávané atributy

- Label (text; povinný; identifikační název plánu)

---

## Invarianty

- INV01 — Activation závisí na tom, že výchozí Transaction (EN0009) dosáhne stavu PAID; viz BR-RecurringDonationPolicy.
- INV02 — Každé pravidelné strhnutí odvozuje novou navazující Transaction (EN0009) z plánu a jeho
  výchozí Transaction, přičemž výběr splatnosti pro strhávání je řízen společně plánem a touto
  Transaction; viz BR-RecurringDonationPolicy.
- INV03 — RecurringTransaction nemůže existovat bez své výchozí Transaction (EN0009); viz
  BR-RecurringDonationPolicy.
- INV04 — Potvrzení od platební brány, která ustavují nebo aktualizují gateway authorization, jsou
  autentizována a mapována podle BR-PaymentGatewayCallbacks.

---

## Vztahy

- EN0009 — Transaction (výchozí i každá následně strhnutá platba; jediný vztah)

---

## Otevřené otázky

1. Účinek zrušení — časové razítko zrušení je zaznamenáváno, ale zda zrušení také přepíná
   Activation state z Active na Inactive/Cancelled, není doloženo. Status: Uncertain.
2. Granularita periody strhávání — perioda strhávání je kanonická hodnota odvozená z podkladového
   volného textového pole; které konkrétní kadence se v praxi vyskytují (např. pouze měsíční), není
   doloženo. Status: Uncertain.
3. Pokrytí gateway authorization — hodnota gateway authorization byla doložena pouze u jedné
   regionální platební brány; zda jiné platební brány strhávají tento plán bez jakékoli uložené
   autorizace, nebo jiným mechanismem, není doloženo. Status: Uncertain.
