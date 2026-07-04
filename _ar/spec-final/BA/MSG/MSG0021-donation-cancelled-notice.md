---
doc_id: MSG0021
title: Donation Cancelled Notice
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0006
references:
  - EN0009
  - EN0010
  - EN0022
  - ES0006
---

# MSG0021 – Oznámení o zrušení daru

## Účel

Informovat dárce, že dar/platba neproběhla — buď jednorázová platba ponechaná ve stavu PENDING u
platební brány byla nakonec zrušena (vypršel časový limit) bez jakéhokoli stržení peněz, nebo trvalý
dar, jehož zastavení dárce požadoval, byl na jeho žádost zrušen. V obou případech zpráva potvrzuje, že
na dané transakci (EN0009) / opakované transakci (EN0010) se dále nebudou pohybovat žádné peníze, dokud
dárce nezaloží novou.

---

## Spouštěč

- UC0006 (Potvrzení platby — callback platební brány): transakce (EN0009) ponechaná ve stavu PENDING je
  platební bránou nahlášena jako zrušená/s vypršeným časovým limitem a systém na transakci zaznamená
  stav CANCELLED (dle SC-10B kroků 1–2 a 7: dárce zahájí, ale nedokončí platbu → stav PENDING → platební
  brána odešle požadavek na dokončení → pokud není dokončeno, brána po vypršení časového limitu platbu
  zruší → stav CANCELLED).
- Dárcem iniciované zrušení trvalého daru (samoobsluha v zóně dárce): dárce zruší pravidelný/trvalý dar
  ze zóny dárce a systém změní příslušnou opakovanou transakci (EN0010) na CANCELLED, přičemž zrušení
  potvrdí zpět dárci (dle SC-10E kroku 9–10: dárce zruší pravidelný dar přes zónu dárce → systém změní
  stav na CANCELLED a potvrdí zrušení dárci).
  **Hypotéza — Nedoloženo na úrovni UC; žádný UC v současnosti nemodeluje dárcem iniciované zrušení
  trvalého daru.** Tento spouštěč je doložen pouze scénářem (SC-10E), a proto záměrně **není** uveden
  ve frontmatter poli `trigger` (které zůstává věrné realitě: UC0006 pokrývá pouze cestu callback
  platební brány PENDING→CANCELLED). Tato samoobslužná cesta zrušení by měla být později přidána jako
  vyhrazený UC nebo jako alternativní tok UC0007 (Zpracování trvalého daru); v tu chvíli bude moci
  frontmatter pole `trigger` tohoto MSG na něj odkazovat.
- Spouštěcí stav: CANCELLED (stav daru/předplatného vůči dárci), doložený v Notification Matrix a v
  SC-10B/SC-10E, nikoli ve slovníku stavů žádosti/příběhu používaném jinde v listu Notification Matrix.

---

## Příjemci

- **Dárce** — e-mail, přes ES0006 (Mautic) (SC-10B krok 8: dárce obdrží e-mail o zrušení; SC-10E krok
  10: systém potvrdí zrušení dárci e-mailem). Rovněž se promítá jako stav CANCELLED v zóně dárce (SC-10B
  krok 9; SC-10E krok 10).

Pro tuto zprávu není doložen žádný příjemce v roli rodiče ani patrona — SC-10B a SC-10E dokumentují
pouze e-mail směrem k dárci a změnu stavu v zóně dárce; jde o oznámení vázané na dárce/transakci, nikoli
o součást distribuce stavů žádosti/příběhu adresované rodiči a patronovi (na rozdíl od MSG0005/MSG0006).
Pro RO/MD není doložena žádná varianta obsahu nad rámec obecného rozlišení šablon podle země už
zdokumentovaného na úrovni schopnosti (FN0019).

---

## Obsah zprávy

Zpráva koncepčně obsahuje:

- Informaci, že dar/platba byly zrušeny a nedošlo ke stržení žádné platby (případ jednorázové platby
  PENDING→CANCELLED), nebo že pravidelný/trvalý dar byl na žádost zastaven (případ dárcem iniciovaného
  zrušení trvalého daru) — oba případy sdílejí stejný výsledný stav CANCELLED sdělovaný dárci.
- Dostatečný kontext k identifikaci, kterého daru/předplatného se zpráva týká (např. částku a/nebo
  příběh/kampaň, na kterou dar směřoval), bez opakování detailů platebního nástroje.
- Žádný náznak, že by na dané transakci (EN0009) / opakované transakci (EN0010) mělo dojít k dalšímu
  stržení; nový dar by bylo nutné založit samostatně.

V tomto kanonickém dokumentu není uveden žádný pevný text předmětu, identifikátor šablony ani značkování
těla zprávy (viz omezení rules-MSG).

Každý pokus o odeslání je archivován jako záznam EmailArchive (EN0022), v souladu s FN0019.

---

## Poznámky / Nejistoty

- Úroveň důkazu: Partial. Oba spouštěče jsou doloženy scénářem (SC-10B, SC-10E), nikoli navázány na
  konkrétní vytěžený identifikátor šablony; jsou zde seskupeny jako jeden typ zprávy, protože oba
  sdělují stejný výsledný stav CANCELLED stejnému příjemci (dárci) přes stejný kanál (e-mail). Oba
  spouštěče se liší v pokrytí na úrovni UC: cesta jednorázové platby PENDING→CANCELLED je modelována
  UC0006, zatímco cesta dárcem iniciovaného zrušení trvalého daru **nemá žádný UC** a je v části
  Spouštěč označena jako hypotéza (kandidát na budoucí UC / alternativní tok UC0007).
- Odlišuje se od MSG0023 (selhání opakované platby / dunning), které se týká neúspěšného pokusu o
  periodické stržení platby na aktivní opakované transakci, nikoli vypršení PENDING nebo zrušení na
  žádost dárce.
- Odlišuje se od stavů rodiny CANCELLED na úrovni žádosti/příběhu v Notification Matrix
  (např. `canceled_application`, `canceled_by_user`, `canceled_campaign`, `canceled_lead`,
  `canceled_timeout`) adresovaných rodiči/patronovi — ty se týkají životního cyklu žádosti nebo příběhu
  a jsou pokryty zprávami distribuce stavů (MSG0005/MSG0006), nikoli tímto oznámením vázaným na
  dárce/transakci.
