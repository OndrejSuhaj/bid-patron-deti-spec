---
doc_id: ES0005
title: Client IMAP bank-notification inbox
canonical_layer: ES
spec_type: external-system
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0012
  - UC0008
---

# ES0005 – Klientská IMAP schránka pro bankovní avíza

## Účel

Poskytuje zprávy s platebním avízem ("aviz") české banky, které platforma stahuje formou pollingu,
aby rozpoznala příchozí bankovní kredity v případech, kdy zdrojem není AISP feed (ES pro API banky
Moneta je zdokumentováno samostatně). Jde o jeden ze tří zdrojů párování plateb sdružených pod
schopností Bank & Gateway Reconciliation / Matching (FN0012), vedle AISP feedu banky Moneta a
synchronizace transferů/vypořádání platební brány.

---

## Přehled systému

Klientem provozovaná e-mailová schránka, dostupná přes protokol IMAP, do které česká banka doručuje
zprávy s oznámením transakce ("aviz") jako HTML e-maily vždy, když je na účet platformy připsána
platba. Samotná schránka je klientskou infrastrukturou (není součástí platformy); bance patří role
konečného původce obsahu avíza, přičemž schránka je hraniční bod pro doručení, proti kterému se
platforma integruje.

---

## Integrační model

Příchozí, založený na pollingu. Naplánovaná úloha párování plateb (UC0008) naváže odchozí spojení do
schránky přes IMAP, vybere nepřečtené zprávy s oznámením od odesílatele banky a odpovídající zprávy
naparsuje do normalizovaných řádků bankovní transakce pro logiku párování platformy (UC0008.2).
Jde o samostatnou externí hranici odlišnou od AISP feedu banky Moneta, přestože obě napájejí stejnou
schopnost párování plateb (FN0012).

---

## Výměna dat

- **Příchozí:** e-mailové zprávy s platebním avízem ("aviz") banky, z nichž každá nese koncepční
  platební údaje (datum, částka, platební reference, identifikace protiúčtu, odesílající banka,
  volitelný identifikační znak dárce a volný textový popis). Ty jsou naparsovány do záznamů
  příchozího kreditu, které konzumuje párování plateb (pouze koncepčně — výsledný auditní záznam
  vlastní EN0029, BankTransactionMail).
- **Odchozí:** žádné — platforma ze schránky pouze čte; přes tuto hranici zprávy zpět neodesílá.

---

## Omezení

- Platforma parsuje HTML tělo avíza podle pevného strukturálního vzoru, takže jakákoli změna
  e-mailové šablony banky může vynulovat naparsovaná pole nebo parsování zcela rozbít.
- Idempotentní klíč použitý k zabránění opakovanému zpracování zprávy není plně stabilní, což může
  způsobit, že avízo bude přehlédnuto, nebo se při odchylce naimportuje vícekrát.
- Neúplné nebo chybné parsování může přesto vytvořit záznam transakce z částečných dat namísto
  bezpečného selhání (ARCH0001 §5 řádek 5, HS05).
- Rozsah omezen pouze na CZ; pro RO/MD se nepoužívá.
- Pouze current-state — popisuje integraci tak, jak je implementována dnes, nikoli cílový záměr.
