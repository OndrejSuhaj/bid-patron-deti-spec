---
doc_id: MSG0028
title: Donation Tax Confirmation (Certificate) Email
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0010
references:
  - EN0014
  - EN0009
  - EN0008
  - EN0022
  - ES0006
---

# MSG0028 – E-mail s daňovým potvrzením o daru (certifikát)

## Účel

Doručit dárci jeho oficiální CZ potvrzení o daru ("Potvrzení o daru") jako PDF certifikát,
sčítající jeho uhrazené dary za požadovaný rok, pro účely daňového odpočtu. Jde o dokument
vyžádaný zákazníkem, nikoli o notifikaci řízenou stavem — je vystaven na vyžádání, ať už formou
samoobsluhy, nebo prostřednictvím manuálního vyřízení na backendu, spíše než vyvolán přechodem
stavu žádosti/příběhu.

---

## Spouštěč

UC0010 (Vystavení potvrzení o daru (daňové)) — spouští se, když:

- zákazník podá žádost o potvrzení o daru prostřednictvím veřejného webového formuláře nebo kanálu
  SPA/API (UC0010.1 / UC0010.3) a vypočtená celková částka uhrazených darů pro požadovaného
  uživatele/rok je větší než nula; nebo
- zákazník se nemůže obsloužit sám (např. anonymní dar bez přístupu do zóny) a místo toho zašle
  e-mailem žádost koordinátorovi INFO, který ověří identitu dárce a dar a vystaví potvrzení
  manuálně (Matice notifikací SC-10G, kroky 3–5).

Neodesílá se, pokud je vypočtená celková částka darů pro požadovaného uživatele/rok nulová
(UC0010 AF1 — žádost je přerušena, potvrzení se nevytváří, e-mail se neodesílá).

Evidence: UC0010 hlavní tok a AF1; Matice notifikací list SC-10G ("Certifikát potvrzení o daru"),
řádky 1–5, v `intake/test-scenarios/test-scenarios.md`.

---

## Příjemci

- **Dárce** — e-mailem, přes ES0006 (Mautic). Jediný příjemce této zprávy; neodesílá se rodiči,
  patronovi ani žádné provozní roli.
- Samoobslužná potvrzení (SC-10G krok 1) jsou také generována jako dokument přímo ke stažení
  z dárcovské zóny (SC-10G krok 2) — jde o výsledek v podobě dostupnosti dokumentu v aplikaci,
  odlišný od tohoto transakčního e-mailu a existující navíc k němu.
- **Pouze CZ.** Podkladová šablona potvrzení je definována pouze pro tenant CZ; žádost zpracovaná
  v konfiguraci země RO/MD tuto zprávu nenese — pro ni se neodesílá žádný e-mail (UC0010 úroveň
  evidence; FLW0009).
- Neexistuje žádná varianta obsahu této zprávy pro RO/MD: mechanismus RO přesměrování daně
  ("2%"/3,5 %) (UC0010 AF4) je samostatný, odděleně doložený tok produkující podepsaný záznam
  prohlášení, nikoli PDF DonationConfirmation (EN0014), a je mimo rozsah této zprávy.

---

## Obsah zprávy

Koncepčně každá instance této zprávy nese:

- Tvrzení, že přiložený dokument je oficiálním potvrzením o daru dárce ("Potvrzení o daru") pro
  požadovaný rok potvrzení.
- Identifikační údaje žadatele dodané spolu s žádostí (jméno/název organizace a adresa) —
  dodané volajícím, nikoli nezávisle ověřené jako součást vystavení zprávy.
- Potvrzenou celkovou částku uhrazených darů za požadovaný rok, vypočtenou na straně serveru
  z uhrazených transakcí (EN0009) — tento peněžní údaj je autoritativní, na rozdíl od polí
  identity žadatele.
- Tutéž potvrzenou částku vyjádřenou slovy, vedle číselného součtu.
- Rok potvrzení, který dokument pokrývá.
- Vyrenderovaný PDF daňový potvrzovací certifikát jako přílohu e-mailu.

V tomto kanonickém dokumentu není uveden žádný pevný text předmětu, značkování těla zprávy ani
struktura šablony — konkrétní znění a rozvržení PDF jsou instanční/konfigurační data a jsou mimo
rozsah vrstvy MSG (viz omezení rules-MSG.md). Každé odeslání je archivováno jako záznam
EmailArchive (EN0022), bez ohledu na to, zda podkladový přenos zprávu skutečně doručil.

---

## Poznámky

- Úroveň evidence: Confirmed pro mechanismus spouštění (žádost vyvolaná zákazníkem s vypočtenou
  celkovou částkou daru větší než nula → snímek potvrzení → PDF → e-mail), pro smlouvu
  dárce-jako-jediný-příjemce, rozsah pouze pro CZ a archivační postcondition, dle UC0010 a Matice
  notifikací SC-10G. Partial pro přesné rámování obsahu (rozdělení prezentace identifikačních polí
  vs. částky vs. částky slovy), jelikož přesné znění je konfigurační/šablonová data plně
  neviditelná z citovaných zdrojů.
- Bez ochrany proti duplicitě: opakované žádosti téhož dárce/roku nezávisle vytvářejí vždy
  samostatný snímek DonationConfirmation (EN0014) a samostatný e-mail — duplicitní potvrzení
  a duplicitní e-maily jsou za současného stavu možné, nejde o chybový stav (UC0010 AF3).
- Režim částečného dokončení: snímek DonationConfirmation (EN0014) je uložen dříve, než je
  provedeno vyrenderování dokumentu a odeslání; pokud vyrenderování nebo přenos selžou, existuje
  záznam potvrzení bez odpovídajícího odeslaného e-mailu — tichý, částečný výsledek z pohledu
  dárce (UC0010 AF2).
- Odlišné od mechanismu RO přesměrování daně ("2%"/3,5 %) (UC0010 AF4) — tato cesta produkuje
  podepsané prohlášení a záznam TaxPayer, nikoli tento e-mail s PDF přílohou, a není tímto
  dokumentem pokryta.
