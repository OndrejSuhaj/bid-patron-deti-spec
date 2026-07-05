---
doc_id: FN0010
title: Recurring Donation Scheduling & Charging
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0007
  - UC0006
  - EN0010
  - EN0009
  - EN0004
---

# FN0010 – Plánování a strhávání trvalého daru

## Účel

Správa plánu opakovaného strhávání trvalého daru (RecurringTransaction, EN0010): jeho vytvoření v neaktivním
stavu společně s prvním darem, aktivace poté, co je tento dar potvrzen jako PAID, a periodické strhávání — kdy
každé strhnutí založí novou transakci daru (EN0009), která vstupuje do platebního uzlu (money hub) (FN0007).
Jde o schopnost správy předplatného (subscription), kterou využívá UC0007 a která je aktivována jako vedlejší
efekt UC0006.

## Odpovědnosti

- Vytvořit plán předplatného (EN0010) společně s prvním darem, zpočátku neaktivní, obsahující periodu a den
  strhávání a (Netopia/RO) token platební brány.
- Aktivovat plán (neaktivní → aktivní) idempotentně ve chvíli, kdy jeho výchozí transakce (EN0009) dosáhne stavu
  PAID, jako součást sdílených vedlejších efektů potvrzení (FN0007).
- Při periodickém běhu vybrat plány splatné ke strhnutí a každý z nich strhnout přes příslušnou regionální
  platební bránu (FN0008), přičemž se vytvoří nová dceřiná transakce daru (EN0009), která vstupuje do platebního
  uzlu (money hub) (FN0007).
- Při úspěšném strhnutí posunout časové razítko posledního strhnutí plánu a podporovat zrušení plánu.

## Související případy užití

UC0007 – Zpracování trvalého daru (primární: výběr splatných plánů, strhávání, posun časového razítka).
UC0006 – Potvrzení platby (callback platební brány) (aktivace plánu a pro Netopia/RO zachycení tokenu, jako
sdílený vedlejší efekt potvrzení).

## Související entity

EN0010 – RecurringTransaction (kořen plánu: perioda, den, token, stav aktivace a stav posledního strhnutí).
EN0009 – Transaction (výchozí platba, která zakládá plán, a každá nová dceřiná transakce vzniklá strhnutím).
EN0004 – Campaign (cílová vybraná částka, kterou FN0007 po každém úspěšném strhnutí přepočítává).

## Integrace

Žádné přímé. Každé periodické strhnutí se provádí prostřednictvím regionální schopnosti platební brány (FN0008),
která izoluje hranice ComGate (CZ) a Netopia/MobilPay (RO); výsledný výstup je předán do FN0007 jako běžné
uložení transakce (Transaction).

## Omezení

- Strhnutí je optimisticky zaznamenáno jako PAID na základě volání platební brány, které proběhne bez chyby,
  ještě před vlastním asynchronním potvrzením výsledku ze strany brány — jde o zaznamenané riziko integrity
  peněz, nikoli o zamýšlené business pravidlo.
- Výběr splatných plánů a posun posledního strhnutí nejsou vůči samotnému strhnutí atomické: po dobu strhávání
  není na plán držen žádný zámek (claim/lock), takže časové okno pro potlačení duplicit (dwell/dedup) je pouze
  aplikační pojistkou, nikoli constraintem jedinečnosti — při překrývajících se bězích hrozí riziko dvojího
  strhnutí.
- Neúspěšné nebo zamítnuté strhnutí neposune časové razítko posledního strhnutí plánu a plán nezruší ani
  nedeaktivuje; plán zůstává splatný a je znovu zkoušen při dalším naplánovaném běhu.
- Zda zrušení plánu zároveň mění i jeho stav aktivace, není doloženo (Hypothesis).
- Způsobilost ke strhnutí a jeho provedení jsou podmíněny podle regionu: napevno zakódované kontroly
  prostředí/země určují, který regionální periodický běh platební brány se použije, přičemž větev RO (Netopia)
  je doložena bez ekvivalentní pojistky omezené na produkční prostředí.
- Pro platební bránu MD neexistuje potvrzená současná cesta periodického strhávání; opakované strhávání přes
  tuto bránu je Partial/Hypothesis, nikoli potvrzené.
