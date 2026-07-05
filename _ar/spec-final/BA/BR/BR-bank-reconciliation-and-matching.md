---
doc_id: BR-BankReconciliationAndMatching
title: Bank & Gateway Reconciliation / Matching
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0009
  - EN0029
  - EN0030
  - EN0004
  - SYSTEM
references:
  - EN0009
  - EN0029
  - EN0030
  - EN0004
  - UC0008
---

# BR – Párování plateb s bankou a platební bránou

## Účel

Určuje, jak je vypořádání z banky a platební brány spárováno s peněžními záznamy (transakce, EN0009)
a jak jsou zaúčtovány nepřiřazené kredity, a zaznamenává současný stav, kdy je párování omezeno pouze
na CZ, včetně rizik ztrátovosti tohoto párování.

## Párování a zaúčtování

- Vypořádaný kredit MUSÍ být spárován s existujícím peněžním záznamem (EN0009) podle bankovní
  reference nebo variabilního symbolu; dosud nezaznamenaný kredit MUSÍ být zaúčtován jako nový
  uhrazený peněžní záznam přiřazený k transparentní sbírkové kampani (EN0004).
- Spárování vypořádání z platební brány MUSÍ nastavit variabilní symbol a příznak bankovního
  vypořádání na spárovaném peněžním záznamu (EN0009).
- Za každou zpracovanou bankovní avizo-zprávu MUSÍ být zapsán jeden auditní záznam (EN0029), bez
  ohledu na výsledek.

## Rozsah (současný stav)

- Současný stav: nelze předpokládat, že párování běží pro RO nebo MD — zdroje párování jsou pouze
  pro CZ (UC0008).
- Současný stav: každý zdroj párování MUSÍ být chráněn proti opakovanému zpracování v rámci svého
  vlastního cyklu běhu.

## Rizika párování v současném stavu

- Současný stav: denní kontrola transparentního účtu si označí čas posledního běhu ještě před
  načtením dat a vždy dotazuje předchozí den, takže neúspěšný běh tiše přeskočí kredity daného dne
  bez opakování.
- Současný stav: parsování bankovní avizo-zprávy závisí na pevném formátu zprávy a při odchylce
  formátu může vytvořit záznam z neúplných polí místo odmítnutí zprávy.
- Současný stav: synchronizace převodů z platební brány omezuje počet záznamů aktualizovaných za
  jeden běh, takže vypořádání rozdělené do více záznamů, než je tento limit, ponechá zbytek
  neoznačený až do dalšího běhu.

## Co pravidlo neřeší

Toto pravidlo nedefinuje životní cyklus platebního stavu transakce (EN0009) ani mechaniku rozdělení
přeplatku (viz BR-PaymentAndMoneyIntegrity, které vlastní pravidlo „vybraná částka nepřekračuje
cíl", do něhož se promítá i peněžní záznam vytvořený párováním), ani pravidla financování/dokončení
kampaně (EN0004) spouštěná po zaúčtování spárovaného peněžního záznamu (viz
BR-CampaignStoryLifecycle). Definuje pouze způsob, jakým jsou data o vypořádání spárována,
přiřazena a auditována.
