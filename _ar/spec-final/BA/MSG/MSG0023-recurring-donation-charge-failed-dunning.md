---
doc_id: MSG0023
title: Recurring Donation Charge Failed (Dunning)
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0007
references:
  - EN0009
  - EN0010
  - EN0022
  - ES0006
---

# MSG0023 – Neúspěšná platba trvalého daru (upomínka)

## Účel

Informovat patrona, že plánovaná platba trvalého daru nemohla být dokončena — platební brána
zamítla nebo skončila chybou u pokusu o platbu, takže nová dceřiná transakce (EN0009) vytvořená pro
tento cyklus byla zaznamenána jako zrušená místo uhrazené. Jde o upomínkové oznámení: sděluje
patronovi, že jeho pravidelná podpora v tomto cyklu neproběhla, na rozdíl od úspěšné cesty pokryté
zprávou MSG0019 (Potvrzení o daru – uhrazeno) a od dobrovolného zrušení trvalého daru samotným
patronem (MSG0021).

---

## Spouštěč

UC0007 (Zpracování trvalého daru), alternativní tok AF1 (Platba u brány selže nebo je zamítnuta) —
spouští se pouze na cestě opakované platby RO/Netopia, když volání brány Netopia pro splatnou
RecurringTransaction (EN0010) vrátí chybu platby a systém označí nově vytvořenou dceřinou transakci
(EN0009) jako zrušenou (UC0007.2 krok 4; UC0007 AF1 kroky 1–3).

Pro cestu CZ/ComGate není doložena žádná ekvivalentní zpráva: selhání brány ComGate rovněž vede
k označení dceřiné transakce jako zrušené (UC0007.2 krok 4), ale AF1 krok 5 pro tuto cestu
nezaznamenává žádné odpovídající oznámení patronovi.

Úroveň evidence: Confirmed pro větev RO/Netopia (UC0007 AF1 krok 5; vedlejší účinky FLW0007);
confirmed absence pro větev CZ/ComGate (stejná evidence, explicitní neekvivalence).

---

## Příjemci

- **Patron** — e-mail, přes ES0006 (Mautic). Jde o jedinou stranu a kanál, kterým je tato zpráva
  adresována; neodesílá se obdarovanému, rodiči ani žádné provozní roli a pro tuto zprávu není
  doložen žádný protějšek ve formě notifikace v zóně.
- Pouze RO: tato zpráva se spouští výhradně na cestě opakované platby RO (Netopia). Neexistuje žádná
  CZ varianta této zprávy (viz Spouštěč); pro UC0007 není vůbec doložena žádná cesta MD recurring
  cronu, takže variantu MD nelze potvrdit ani vyvrátit.

---

## Obsah zprávy

Konceptuálně každá instance této zprávy obsahuje:

- Oznámení adresované patronovi, že jeho pravidelnou (trvalou) platbu daru pro tento cyklus nebylo
  možné dokončit / byla zrušena.
- Implicitní výzvu, že pokračování patronovy trvalé podpory může vyžadovat pozornost (např. obnovení
  nebo aktualizaci způsobu, jakým je opakovaná platba autorizována), bez upřesnění jakéhokoliv detailu
  platebního nástroje.
- Neobsahuje žádný detail karty, bankovního účtu, tokenu ani jiného platebního nástroje.
- V evidenci není u obsahu této zprávy uveden žádný rozpis částky ani přiřazení ke kampani/příběhu.

Žádný pevný text předmětu, značkování těla zprávy ani struktura šablony není v tomto kanonickém
dokumentu tvrzena — viz UC0007 (AF1) a FLW0007 pro mechaniku spouštění v pozadí.

---

## Křížové odkazy

- Spouštěč: UC0007 (Zpracování trvalého daru), alternativní tok AF1.
- Dotčené entity: EN0010 (RecurringTransaction — rozvrh, jehož platba selhala), EN0009
  (Transaction — nová dceřiná transakce zaznamenaná jako zrušená).
- Archiv: EN0022 (EmailArchive) — záznam odeslané zprávy podle obecného vzoru archivace e-mailů
  dokumentovaného na úrovni entity; zde se neopakuje.
- Kanál: ES0006 (Mautic).
- Související zprávy: MSG0019 (Potvrzení o daru – uhrazeno, protějšek úspěšné cesty pro stejný tok
  UC0007 a pro dary obecně); MSG0021 (dobrovolné zrušení trvalého rozvrhu iniciované patronem —
  spouštěč odlišný od tohoto upomínkového oznámení o selhání platby u brány).

Úroveň evidence: Confirmed (větev RO/Netopia) — UC0007 AF1; FLW0007 §B Vedlejší účinky (označení
platby Netopia jako zrušené odešle patronovi dedikovaný e-mail v upomínkovém stylu přes transport
Mautic). Confirmed absence — větev CZ/ComGate, stejné zdroje.
