---
doc_id: MSG0012
title: Application Approved
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0002
  - UC0003
references:
  - EN0001
  - EN0022
  - EN0026
  - ES0006
---

# MSG0012 – Žádost schválena

## Účel

Informovat Žadatele (Parent / Žadatel/fundraiser) a Patrona o tom, že jejich Žádost (EN0001) prošla
posouzením rizika a byla schválena — scoring je v pořádku (scoring OK) — a že případ nyní postupuje
směrem k přípravě příběhu. Jde o zprávu milníku schválení: odlišnou od obecného, na stavu založeného
souhrnného mechanismu (MSG0005/MSG0006), protože dosažení stavu „scoring OK" je klíčovým rozhodovacím
bodem v životním cyklu případu (průchod rizikovou branou), i když je podle aktuální evidence
komunikováno téměř výhradně v zóně, nikoli e-mailem.

---

## Spouštěč

- UC0003 (Posouzení rizika žadatele) — stav Žádosti (EN0001) postoupí na „scoring schválen"
  (`scoring_ok`), a to buď přes manuální schvalovací bránu (Admin/pracovník rizika nastaví rozhodnutí
  „schváleno", zatímco je Žádost ve stavu „scoring"), nebo přes automatickou cestu přepočtu low-risk,
  když je splněn a potvrzen kvalifikační práh.
- UC0002 (Orchestrace změny stavu žádosti) — navazující rozeslání reakcí (UC0002.2), které rozřeší
  ApplicationReaction (EN0026) pro nový stav a roli; jde o mechanismus, který tuto zprávu skutečně
  zobrazí každé straně.
- Doložené spouštěcí stavy: `scoring_ok` (jak schválení Koordinátorem v rámci low-risk, tak schválení
  Risk manažerem po plné revizi dosahují tohoto stavu — akceptační scénáře SC-5A a SC-5B) a
  `in_progress` („Schváleno"), který Notifikační matice eviduje jako samostatný stav nesoucí stejný
  význam „schváleno" s jinou kombinací kanálů.
- **Hypotéza — in_progress je sem zařazen na základě shody textu stavu v Matici; jeho vztah v rámci
  životního cyklu ke `scoring_ok` není potvrzen v EN0001 ani citovaným přechodem UC.** `in_progress` je
  zahrnut do této rodiny zpráv „schváleno" pouze na základě toho, že text stavu v Notifikační matici
  („Schváleno") odpovídá významu schválení; žádný rekonstruovaný přechod ze `scoring_ok` na
  `in_progress` není doložen.

---

## Příjemci

**Hypotéza — in_progress je sem zařazen na základě shody textu stavu v Matici; jeho vztah v rámci
životního cyklu ke `scoring_ok` není potvrzen v EN0001 ani citovaným přechodem UC.** Níže uvedené řádky
příjemce/kanálu pro `in_progress` jsou k této zprávě (MSG) připojeny pouze na základě textu Matice
„Schváleno".

- **Parent / Žadatel** — notifikace v zóně, v Zóně žadatele: „Vaše žádost byla schválena" při stavu
  `scoring_ok`; e-mail při stavu `in_progress` („Schváleno") dle Notifikační matice (E-mail = ANO pro
  Žadatele při `in_progress`).
- **Patron** — notifikace v zóně, v Zóně patrona: „Žádost byla schválena" při stavu `scoring_ok`; také
  notifikován v zóně při stavu `in_progress` („Schváleno"); e-mail Patronovi není doložen pro žádný z
  obou stavů.

Při stavu `scoring_ok` se oba zdroje shodují, že **e-mail není odeslán** ani Žadateli, ani Patronovi —
schválení je viditelné po přihlášení do zóny (SC-5A krok 13–14 a SC-5B krok 25–27 ukazují schválení
zobrazené jako zpráva v zóně bez doprovodného e-mailu). **Konflikt — vyžaduje vyjasnění (kanál v zóně):**
řádky Notifikační matice pro `scoring_ok` (test-scenarios.md řádky 797–798) evidují „Notifikace v účtu
uživatele = NE" pro Žadatele i Patrona, zatímco SC-5A/SC-5B ukazují zónu zobrazující zprávu o schválení.
Tato zpráva (MSG) se řídí evidencí akceptačního scénáře (živé zobrazení v zóně je silnější než příznak v
Matici, jehož přesná sémantika — push/odznak vs. pasivní zobrazení stavu — není potvrzena), ale
nesrovnalost je zaznamenána, nikoli vyřešena. Kanál pro variantu v zóně je interní (zobrazení v zóně);
kanál pro e-mailovou variantu `in_progress` je ES0006 (Mautic).

Pro tuto zprávu není doložen žádný obsah ani odchylka kanálu specifické pro RO/MD nad rámec rozlišení
šablony podle země, které je již zdokumentováno na úrovni schopnosti (FN0019).

---

## Obsah zprávy

- Sdělení, že Žádost (EN0001) byla schválena / scoring je v pořádku — formulované podle role (pohled
  Žadatele a pohled Patrona nesou vlastní rozřešené znění dle ApplicationReaction, EN0026, a sloupce
  „Status zpráva" Notifikační matice; přesné znění je konfigurační/stavová data, zde nejsou opakována
  jako pevný text šablony).
- Implicitní naznačení, že případ nyní postupuje do další fáze (příprava příběhu/smlouvy), aniž by v
  tomto kroku bylo od příjemce vyžadováno další jednání — pro tuto zprávu není doložen žádný explicitní
  podnět „vyžadována akce", na rozdíl od některých jiných notifikací o stavu.
- Identifikace předmětné Žádosti (EN0001), implicitně vymezená vlastním zobrazením zóny dané strany
  (Zóna žadatele / Zóna patrona).
- Tam, kde se spouští e-mailová varianta `in_progress` (pouze Žadatel), je zpráva archivována jako
  záznam EmailArchive (EN0022) v rámci standardního mechanismu odeslání/archivace (UC0012), bez ohledu
  na to, zda k odeslání skutečně došlo.

Z tohoto kontraktu je vyloučeno: přesné řetězce textu předmětu/těla zprávy, HTML/vizuální prezentace a
konfigurace e-mailového poskytovatele/doručení — viz MSG0005 (E-mail o změně stavu žádosti) a MSG0006
(Notifikace o stavu v zóně) pro sdílený mechanismus odeslání, na kterém tato zpráva staví.

---

## Poznámky / Nejistoty

- Tento dokument existuje proto, aby milník schválení (`scoring_ok`) měl vlastní pojmenovanou zprávu
  odlišnou od širokých, na stavu založených souhrnných mechanismů (MSG0005, MSG0006), protože jde o
  klíčovou rozhodovací bránu v životním cyklu Žádosti (EN0001). Mechanicky je stále odesílána stejným
  rozesláním ApplicationReaction (EN0026) řízeným stavem/rolí jako MSG0005/MSG0006 — tato zpráva (MSG)
  nezavádí samostatný mechanismus doručení.
- **Vlastnictví:** MSG0012 je vyhrazeným vlastníkem stavů `scoring_ok` a `in_progress` (rodina
  „schváleno"), vyčleněných ze souhrnného mechanismu MSG0005; tyto stavy jsou z MSG0005 odstraněny, aby
  tento milník schválení pokrýval jediný vlastník.
- `scoring_ok`: pouze v zóně pro Žadatele i Patrona; e-mail explicitně NENÍ odeslán žádné z rolí
  (Notifikační matice; SC-5A kroky 11–14; SC-5B kroky 23–27, přičemž krok 27 výslovně uvádí „ŽÁDNÉ
  e-maily odeslány Žadateli ani Patronovi ve fázi schválení").
- `in_progress` („Schváleno"): e-mail = ANO pro Žadatele, notifikace v zóně = ANO pro Žadatele i
  Patrona, dle Notifikační matice. Zařazeno do této zprávy (MSG) jako stejný význam milníku „schváleno"
  dosahující pozdějšího/paralelního označení stavu v aktuálním slovníku stavů; přesný vztah mezi
  `scoring_ok` a `in_progress` jako odlišnými stavy životního cyklu náleží stavovému modelu a zde není
  opakován.
- Úroveň evidence: Confirmed, že `scoring_ok` neodesílá **žádný e-mail** žádné z rolí (oba zdroje se
  shodují — SC-5A/SC-5B i Notifikační matice). **Partial / Conflict** ohledně kanálu v zóně pro
  `scoring_ok`: SC-5A/SC-5B ukazují zobrazení v zóně, zatímco Matice eviduje „notifikace = NE" —
  zaznamenáno výše jako Conflict, evidence sleduje akceptační scénář, ale zůstává nevyřešeno. Kombinace
  kanálů pro `in_progress` je dle Notifikační matice. Partial ohledně toho, zda do této rodiny
  „schváleno" patří i jiný stav — ponecháno úzké na dva doložené stavy namísto extrapolace.
