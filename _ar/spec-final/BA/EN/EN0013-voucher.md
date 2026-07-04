---
doc_id: EN0013
title: Voucher
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0009  # Transaction — the purchasing payment; owner and money source
  - EN0004  # Campaign — the Story a voucher is applied to
  - BR-VoucherPolicy  # paid/redemption governance, uniqueness & concurrency gaps
  - UC0006  # Confirm Payment — drives unpaid → paid
  - UC0009  # Redeem / Validate Voucher — drives paid-not-redeemed → redeemed
---

# EN0013 — Dárkový poukaz

## Účel

Dárkový poukaz ("Dobrošek") je předplacený kód daru: zakoupí ho kupující prostřednictvím transakce
(EN0009) a později ho příjemce uplatní na jím zvolený příběh (EN0004). Představuje dar, jehož cílový
příběh se neurčuje při nákupu, ale je odložen až na okamžik uplatnění.

Dárkový poukaz má dva nezávislé rozměry životního cyklu: zda byl uhrazen (připraven k použití) a zda
byl uplatněn (přiřazen k příběhu). Jeho vlastník se u samotného poukazu neukládá — odvozuje se od
transakce, kterou byl zakoupen (viz BR-VoucherPolicy).

---

## Životní cyklus

Rozměr úhrady:
- Neuhrazeno
- Uhrazeno (připraveno k použití)

Rozměr uplatnění:
- Neuplatněno
- Uplatněno

Kombinací obou rozměrů vznikají efektivní stavy, ve kterých se dárkový poukaz může nacházet:
Neuhrazeno; Uhrazeno a neuplatněno (použitelné); Uhrazeno a uplatněno (vyčerpáno). Řídicí omezení viz
BR-VoucherPolicy (úhrada je předpokladem uplatnění; uplatnění je jednorázové).

---

## Přechody stavů

Neuhrazeno → Uhrazeno
spouštěč: UC0006 — Potvrzení platby (Gateway Callback), když nákupní transakce (EN0009) dosáhne
stavu PAID.

Uhrazeno a neuplatněno → Uhrazeno a uplatněno
spouštěč: UC0009 — Uplatnění / ověření poukazu, když příjemce uplatní poukaz na zvolený příběh
(EN0004).

Uhrazeno → Expirováno
Hypothesis — na entitě existuje dvojice atributů pro expiraci/upomínku, ale v nasbíraných důkazech
nebyl nalezen žádný proces expirace ani upomínání. Jako dosažitelný přechod nepotvrzeno.

---

## Atributy

### Systémem spravované atributy

- status (stav úhrady; boolean; povinné; hodnoty: unpaid / paid-ready-to-use; pravidlo přechodu viz
  BR-VoucherPolicy)
- is_applied (stav uplatnění; boolean; povinné; hodnoty: not-redeemed / redeemed; pravidlo přechodu
  viz BR-VoucherPolicy)
- applied (časové razítko; podmíněné; nastaví se při uplatnění poukazu — zaznamenanou nejednoznačnost
  vůči přechodu do stavu uhrazeno viz Otevřené otázky)
- expiration (časové razítko; volitelné; na entitě přítomno; žádné potvrzené chování v životním
  cyklu — viz Otevřené otázky)
- reminded (časové razítko; volitelné; na entitě přítomno; žádné potvrzené chování v životním cyklu —
  viz Otevřené otázky)
- transaction (odkaz na EN0009 — nákupní platbu; zdroj vlastníka poukazu dle BR-VoucherPolicy)
- campaign (odkaz na EN0004 — příběh, na který je poukaz uplatněn; nastavuje se při uplatnění)

### Uživatelem zadávané atributy

- name (text; povinné; kód poukazu a zobrazovaný štítek; zaznamenanou mezeru v jedinečnosti viz
  Otevřené otázky)
- price (částka; povinné; hodnota daru poukazu)
- recipient_name (text; volitelné)
- recipient_email (text; volitelné)
- user_phone (text; volitelné)
- recipient_message (dlouhý text; volitelné)
- delivery_type (seznam; povinné; hodnoty: email / print; výchozí email)

---

## Invarianty

- Životní cyklus úhrady/uplatnění dárkového poukazu a jeho vazba na nákupní transakci a cílový
  příběh se řídí BR-VoucherPolicy (rozměr úhrady, pravidla uplatnění).
- Vlastník dárkového poukazu je odvozený, nikoli uložený — viz BR-VoucherPolicy.
- Současné mezery v jedinečnosti a souběžnosti u kódu poukazu a jeho uplatnění se řídí
  BR-VoucherPolicy (současná rizika jedinečnosti a souběžnosti).

---

## Vztahy

- EN0009 — Transakce (nákupní platba; zdroj vlastníka poukazu)
- EN0004 — Příběh (cíl uplatnění)

---

## Otevřené otázky

1. Zdá se, že časové razítko `applied` se zapisuje jak v okamžiku, kdy je poukaz uhrazen, tak
   v okamžiku, kdy je uplatněn — které z těchto zápisů je autoritativní pro reporting "uplatněno dne"
   zůstává nevyřešeno. Conflict — requires clarification.
2. Kód poukazu (`name`) nemá při generování potvrzenou záruku jedinečnosti (viz BR-VoucherPolicy,
   současná rizika jedinečnosti a souběžnosti). Chybí důkaz, zda existuje jiná pojistka.
3. Na entitě existují atributy `expiration` a `reminded`, ale v nasbíraných důkazech nebyl nalezen
   žádný proces expirace ani upomínání. Missing evidence — stav takového chování je Unknown.
