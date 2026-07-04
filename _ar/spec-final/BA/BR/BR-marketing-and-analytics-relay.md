---
doc_id: BR-MarketingAndAnalyticsRelay
title: Marketing / CRM Sync & Analytics Relay
canonical_layer: BR
spec_type: business-rule
status: canonical
modules: []
affects:
  - EN0006
  - EN0008
  - EN0009
  - SYSTEM
references:
  - EN0006
  - EN0008
  - EN0009
  - UC0012
  - UC0013
  - UC0015
  - BR-DataProtectionAndErasure
---

# BR – Synchronizace marketingu / CRM a předávání analytických dat

## Účel

Upravuje current-state pravidla pro synchronizaci subjektů platformy do externího marketingového CRM,
předávání signálů o konverzi daru a analytických signálů do externích měřicích nástrojů a vstupní
rozhraní pro příjem marketingových leadů. Tato pravidla se týkají výhradně marketingové strany; nemají
žádné doménové dopady na agregáty žádosti, příběhu ani peněz.

---

## Synchronizace kontaktu s CRM

- Systém MUSÍ provést upsert marketingového CRM kontaktu subjektu při uložení záznamu Uživatel
  (EN0008) daného subjektu — což zahrnuje registraci, pozdější změny i GDPR anonymizaci — a dále
  jako vedlejší efekt při každém odeslání transakční zprávy (viz UC0012, UC0013).
- Current-state: synchronizace s CRM SE POVAŽUJE za best-effort a nezávaznou — neúspěšná synchronizace
  ovlivní pouze kopii v CRM a NESMÍ změnit výsledek původního uložení nebo odeslání.
- Current-state: mazání kontaktu v marketingovém CRM vyvolané výmazem neprovádí skutečné odstranění
  a opětovná synchronizace po anonymizaci kontakt znovu vytvoří — tato anti-erasure interakce spadá
  pod BR-DataProtectionAndErasure a zde není znovu popisována.

---

## Předávání konverzí a analytických dat

- Systém MUSÍ předat událost konverze dokončeného daru pro kvalifikující se Transakci (EN0009) do
  externího kanálu pro konverze za účelem atribuce kampaně (viz UC0013).
- Systém MUSÍ vysílat klientské konverzní/analytické signály prostřednictvím externího kanálu pro
  správu značek / pixelů při vykreslení stránky, nezávisle na serverovém předávání.
- Předávání konverzí/analytických dat MUSÍ být pouze marketingovým signálem: NESMÍ vytvářet,
  aktualizovat ani přecházet stav žádného záznamu Žádosti, Kontaktu (EN0006) ani Transakce (EN0009).
- Current-state: selhání nebo nedostupnost předávání MUSÍ způsobit pouze ztrátu marketingového signálu
  a NESMÍ ovlivnit zpracování daru ani žádosti.

---

## Vstupní příjem marketingových leadů (current-state: Planned / Not Implemented)

- Current-state: vstupní webhook pro příjem marketingových leadů SE POVAŽUJE za **neimplementovaný** —
  odpovídá pouze na handshake ověření odběru (subscription-verification); volání pro doručení leadu
  je přijato, ale jeho data jsou zahozena, nevytváří se žádný Kontakt (EN0006) ani Žádost a odesílateli
  je vrácena úspěšná odpověď (viz UC0013, alternativní tok Planned/Not-Implemented).
- Current-state: webhook přijímá anonymní volání a jeho ověřovací token je pevná, natvrdo
  nakonfigurovaná hodnota namísto rotovatelného přihlašovacího údaje — zaznamenáno jako current-state
  bezpečnostní mezera, nikoli navržená kontrola.

---

## Non-Goals

- Toto pravidlo nedefinuje kontrakt transakční zprávy (spouštěč, příjemci, obsah) — spadá pod vrstvu
  MSG a BR-TransactionalMessaging.
- Toto pravidlo nedefinuje politiku výmazu osobních údajů ani samotný anti-erasure důsledek — spadá
  pod BR-DataProtectionAndErasure.
- Toto pravidlo nedefinuje hranice integrace s externími systémy — spadá pod vrstvu ES.
