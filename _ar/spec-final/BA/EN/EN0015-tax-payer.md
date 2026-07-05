---
doc_id: EN0015
title: TaxPayer
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0011  # Contract — the sole outbound relation; the RO redirect contract this payer signs
  - BR-ContractAndESignature  # RO tax-redirect declaration pairing invariant
  - BR-DonationConfirmationAndTax  # confirms TaxPayer/Contract pairing is a distinct RO mechanism, not the CZ confirmation path
  - UC0010  # AF4 — RO tax-redirect declaration (adjacent country variant), Partial evidence
---

# EN0015 – TaxPayer

## Účel

Záznam rumunského daňového poplatníka pro přesměrování daně. Zachycuje rumunského dárce, který se
rozhodne přesměrovat procento své daně z příjmu (2 % / 3,5 %) ve prospěch organizace, a nese údaje o
identitě a adrese dárce potřebné pro deklaraci přesměrování spolu s příznakem vícerého souhlasu na
více let. Jde o RO-specifický protějšek k CZ DonationConfirmation (EN0014): oba vyjadřují záznam
dárce vázaný na daň, avšak TaxPayer slouží mechanismu RO přesměrování daně z příjmu, nikoli dokladu o
potvrzení daru.

---

## Lifecycle

Pro TaxPayer není doložen žádný stavový automat na úrovni entity. Jde o zachycený záznam poplatníka,
vytvořený jednorázově a spárovaný se smlouvou o přesměrování (EN0011); žádný další stav typu
promote/approve/void nebyl pozorován.

---

## Přechody stavů

(žádný) → zachyceno
trigger: UC0010 AF4 – RO deklarace přesměrování daně (varianta pro sousední zemi) — Partial evidence;
podání deklarace vytváří záznam TaxPayer společně s jeho spárovanou smlouvou (EN0011).

Žádné další přechody nejsou doloženy.

---

## Atributy

### Systémem spravované atributy

- created (timestamp; systémem spravováno; čas vytvoření záznamu)
- changed (timestamp; systémem spravováno; čas poslední změny)

### Uživatelem zadávané atributy

- name (text; povinné; popisek entity)
- first_name / last_name (text; povinné)
- initial (text; povinné; iniciála otce, dle rumunské identifikační konvence)
- email (text; povinné; validováno jako způsobilá e-mailová adresa)
- numeric_code (text; povinné; rumunský osobní číselný kód / CNP)
- phone (text; povinné; kontext země RO; nemusí být jedinečné)
- fax (text; volitelné; nemusí být jedinečné)
- street / number / town / postal_code (text; povinné)
- county (text; povinné; kraj nebo sektor, dle administrativního členění RO/MD)
- block / staircase / floor / apt (text; volitelné; detail adresy pro RO)
- two_years_agreed (boolean; volitelné; souhlas se závazkem přesměrování daně na dva roky)

---

## Invarianty

- TaxPayer je spárován s právě jednou smlouvou o přesměrování (EN0011) — viz
  BR-ContractAndESignature §RO tax-redirect declaration pairing.
- Spárování TaxPayer/Contract je samostatný RO mechanismus a není lokalizovanou variantou cesty CZ
  potvrzení o daru — viz BR-DonationConfirmationAndTax §Non-Goals.

---

## Vztahy

- EN0011 – Contract (smlouva o přesměrování, se kterou je tento TaxPayer spárován; jediný odchozí vztah)

---

## Otevřené otázky

1. Jak je propojená smlouva (EN0011) generována a podepisována v rámci vytvoření TaxPayer? Cesta
   vytvoření/spárování je doložena pouze jako přilehlý, samostatně sledovaný tok (UC0010 AF4) a nebyla
   podrobně prozkoumána.
2. Řídí `two_years_agreed` potlačení opakovaného víceletého podání, nebo jde pouze o zaznamenaný
   souhlas? Nedoloženo.
3. Vynucují pole CNP a email validaci formátu/způsobilosti nad rámec povinné přítomnosti (např.
   kontrolní součet CNP)? Na kanonické úrovni nedoloženo.
4. Pro TaxPayer není na rozdíl od sourozeneckých entit doložen žádný stavový slovník ani příznak
   zveřejnění — zdá se, že jde o skutečnou absenci, nikoli o mezeru; označeno k potvrzení během
   uzavírání (closure).
