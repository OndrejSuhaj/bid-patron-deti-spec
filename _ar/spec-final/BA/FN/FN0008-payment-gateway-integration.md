---
doc_id: FN0008
title: Payment Gateway Integration
canonical_layer: FN
spec_type: functional-capability
status: canonical
modules: []
references:
  - UC0005
  - UC0006
  - UC0007
  - EN0009
  - EN0010
---

# FN0008 – Integrace platebních bran

## Účel

Izoluje tři regionální hranice platebních bran — ComGate (CZ), Netopia/MobilPay (RO) a MAIB (MD) —
za jednu jednotnou funkčnost: zahájit platbu na správné regionální bráně, přijmout a autentizovat její
potvrzení a namapovat stavový slovník každé brány na doménový platební stav pro FN0007. Sdružuje
rodinu adaptérů ComGate/Netopia/MAIB (nechápat jako tři samostatné funkčnosti).

## Odpovědnosti

- Zahájit checkout/platbu na regionálně příslušné bráně a vrátit přesměrování/handoff potřebné pro
  tok dárce.
- Přijímat potvrzení od brány jejich nativním mechanismem — ComGate server-to-server callback, Netopia
  šifrovaný IPN + návrat prohlížeče, MAIB návrat prohlížeče následovaný aktivním opakovaným dotazem
  (re-poll) na server-to-server stav.
- Autentizovat každé potvrzení podle vlastního schématu dané brány (porovnání sdíleného tajemství,
  dešifrování IPN, nebo důvěryhodný re-poll namísto spoléhání se na referenci dodanou prohlížečem).
- Namapovat stavový/akční slovník specifický pro danou bránu na doménový stav (PENDING / AUTHORIZED /
  PAID / CANCELLED / REFUNDED) a předat vyřešený výsledek do FN0007.
- Zachytit token/expiraci platby brány pro navázaný trvalý plán (Netopia) k pozdějšímu použití
  ve FN0010.

## Související případy užití

UC0005 (zahájení), UC0006 (potvrzení za jednotlivé brány), UC0007 (opakovaná platba využívá klienta
brány).

## Související entity

EN0009 (potvrzovaná transakce), EN0010 (zachycený token trvalé platby).

## Integrace

ComGate (CZ), Netopia / MobilPay (RO), MAIB (MD).

## Omezení

- Podle jednotlivých zemí: přesně jedna brána na region; nejsilnější vendor lock-in je u Netopia
  (vendorované SDK) a MAIB (mutual-TLS certifikát + heslo).
- Callback endpointy jsou fakticky veřejné bez kryptografického podpisu (bez HMAC); autenticita se
  opírá o sdílené tajemství v těle požadavku nebo o re-poll — bez ochrany proti replay útoku / bez
  zajištění idempotence.
- Dvě brány sdílejí stejnou cestu pro aktualizaci stavu (ComGate a MAIB), což představuje
  nedeterministickou kolizi při řešení (Hypothesis, která z nich vyhraje).
- MAIB návrat prohlížeče zobrazuje dárci jako úspěch jakýkoli nezrušený výsledek (včetně stále
  čekajícího stavu).
