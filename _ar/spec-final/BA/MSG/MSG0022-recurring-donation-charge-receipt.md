---
doc_id: MSG0022
title: Recurring Donation Charge Receipt
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0007
references:
  - EN0010
  - EN0009
  - EN0008
  - EN0022
  - ES0006
---

# MSG0022 – Potvrzení o strhnutí platby trvalého daru

## Účel

Potvrdit Dárci, že periodická platba proti jeho trvalému daru (RecurringTransaction, EN0010) byla úspěšně
zpracována. Jedná se o potvrzení za jednotlivou platbu v rámci již založeného trvalého daru — na rozdíl od
potvrzení jednorázového daru (MSG0019), které se týká první/výchozí platby, ze které je trvalý dar později
odvozen.

---

## Spouštěč

UC0007 (Zpracování trvalého daru), krok UC0007.3.1 — vyvolá se při každé úspěšné periodické platbě, tj. když je
nově vytvořená podřízená Transakce (EN0009) vzniklá touto platbou označena jako PAID (UC0007.2 krok 4). Neodesílá
se při neúspěšné nebo zamítnuté platbě (UC0007 AF1), kde je podřízená Transakce místo toho označena jako canceled.

Evidence: UC0007 krok UC0007.3.1; Notification Matrix SC-10E krok 7 ("Processes each regular card payment; sends
confirmation per payment" / "Donor receives confirmation for each payment") v
`intake/test-scenarios/test-scenarios.md`.

---

## Příjemci

- **Dárce** — e-mail, přes ES0006 (Mautic). Jediný příjemce; neodesílá se Rodiči, Patronovi ani žádné provozní
  roli.
- Podkladový trvalý dar a historie jeho plateb jsou Dárci navíc viditelné v Zóně dárce (v rámci aplikace;
  SC-10E krok 8), odděleně od tohoto kontraktu transakční zprávy.
- U této zprávy není doložena žádná obsahová odlišnost CZ/RO/MD nad rámec rozlišení šablony podle země, které je
  již zdokumentováno na úrovni capability (FN0019); samotná periodická platba probíhá přes regionálně specifickou
  cestu platební brány (ComGate/CZ, Netopia/RO — UC0007), avšak u kontraktu zprávy není doloženo, že by se podle
  regionu lišil.

---

## Obsah zprávy

Konceptuálně nese každá instance této zprávy:

- Poděkování / potvrzení určené Dárci za právě zpracovanou periodickou platbu.
- Potvrzení, že tato platba náleží k jeho probíhajícímu trvalému daru (EN0010), nikoli k jednorázovému daru.
- Částku strhnutou při tomto výskytu.
- Periodu trvalého daru, ke které platba náleží (např. periodicitu trvalého daru), podle EN0010.
- Neobsahuje žádný údaj o kartě, bankovním účtu ani jiném platebním nástroji.

V tomto kanonickém dokumentu není uveden pevný text předmětu, značkování těla zprávy ani struktura šablony —
konkrétní znění je instanční/konfigurační data a je mimo rozsah vrstvy MSG (viz omezení v rules-MSG.md). Každé
odeslání je archivováno jako záznam EmailArchive (EN0022).

---

## Poznámky

- Úroveň evidence: Confirmed pro mechanismus spouštění (úspěšná periodická platba → podřízená Transakce PAID) a
  pro kontrakt „Dárce jako jediný příjemce“, podle UC0007.3.1 a SC-10E krok 7. Partial pro přesné rozdělení
  obsahu (částka + perioda vs. jakékoli další rámování), protože přesné znění je konfigurační data, která nejsou
  z citovaných zdrojů plně viditelná.
- Current-state defekt na cestě CZ/ComGate (zaznamenaný u FN0010, zde neopakovaný): podřízená Transakce může být
  označena jako PAID optimisticky — v okamžiku, kdy volání brány proběhne bez chyby — ještě před vlastním
  asynchronním potvrzením výsledku platby ze strany brány (UC0007 AF3). Protože je tato zpráva spouštěna stavem
  PAID, může být potvrzení odesláno i za platbu, jejíž výsledek ještě není bránou finálně potvrzen.
- Odlišné od notifikace o neúspěšné/zamítnuté platbě odesílané Dárci pouze na cestě RO/Netopia (UC0007 AF1) —
  jde o samostatný záměr zprávy (upomínkové/storno oznámení, nikoli potvrzení) a tento dokument jej nepokrývá.
- Odlišné od potvrzení zrušení ze strany dárce odesílaného, když Dárce zruší svůj trvalý dar přes Zónu dárce
  (SC-10E kroky 9–10) — jde o samostatný záměr zprávy, který tento dokument nepokrývá.
- Odlišné od notifikace o reaktivaci účtu odesílané Dárci, když úspěšná periodická platba reaktivuje dříve
  blokovaný účet (UC0007.3 krok 2) — jde o samostatný záměr zprávy, který není součástí obsahu tohoto potvrzení.
- Odlišné od interní provozní notifikace odesílané při úspěšné CZ periodické platbě (UC0007.3 krok 5, pouze
  produkce) — jde o neuživatelský provozní kanál, mimo rozsah této MSG.
