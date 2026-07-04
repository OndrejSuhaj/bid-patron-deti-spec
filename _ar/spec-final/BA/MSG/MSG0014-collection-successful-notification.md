---
doc_id: MSG0014
title: Collection Successful Notification
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0011
  - UC0006
references:
  - EN0004
  - EN0001
  - EN0022
  - ES0006
  - FN0019
---

# MSG0014 – Notifikace o úspěšném vybrání sbírky

## Účel

Informovat Žadatele (Parent, Žadatel) a Patrona o tom, že cílová částka Příběhu (Campaign, EN0004) byla
vybrána — sbírka je úspěšná — a že budou následovat další kroky na straně back-office (příprava
smlouvy, nákup daru). Jde o vysoce prioritní zprávu o dokončení v rámci životního cyklu Příběhu,
odlišnou od obecného stavově řízeného souhrnného mechanismu (MSG0005/MSG0006): označuje okamžik
dosažení cíle sbírky, nikoli libovolný přechod stavu.

---

## Spouštěč

- UC0006 (Potvrzení platby — Gateway Callback), sdílený krok UC0006.4.9: při jakékoli potvrzené platbě,
  která přivede přepočtenou vybranou částku Příběhu (EN0004) na cílovou částku nebo nad ni, Systém
  označí Příběh a jeho nadřazenou Žádost (EN0001) jako dokončené a — v produkci — odešle potvrzení o
  úspěšném vybrání sbírky.
- UC0011 (Správa životního cyklu Příběhu/Story), UC0011.1 krok 7: stejný přechod do stavu dokončeno je
  rovněž vyhodnocen jako vedlejší efekt jakéhokoli uložení Příběhu (např. publikace), nejen v důsledku
  platebního callbacku, ačkoli v praxi je nejčastějším spouštěčem uhrazený příspěvek (PAID).
- Spouštěcí stav: Žádost (EN0001) / Příběh (EN0004) dosáhnou stavu `completed` ("Vybráno"), podle
  Notification Matrix (`intake/test-scenarios/test-scenarios.md`, list Notification Matrix, řádek
  `completed`) a kroků 1–4 scénáře SC-8A (sbírka dosáhne 100 % cíle → stav se změní na "splněný
  příběh" → e-maily o úspěchu jsou odeslány Žadateli a Patronovi).

---

## Příjemci

- **Žadatel (Parent / Žadatel)** — e-mail (Notification Matrix: `completed` / Parent → Email = YES)
  prostřednictvím ES0006 (Mautic), plus notifikace v zóně (Parent Zone) (Notification Matrix:
  `completed` / Parent → in-zone = YES; SC-8A krok 3 in-zone = YES — oba zdroje se u Žadatele shodují).
- **Patron** — e-mail (Notification Matrix: `completed` / Patron → Email = YES) prostřednictvím ES0006
  (Mautic). Oba zdroje se shodují, že Patron dostává e-mail. **Kanál notifikace v zóně u Patrona je
  Conflict — requires clarification:** SC-8A krok 4 označuje sloupec notifikace v zóně u Patrona jako
  YES, zatímco řádek Notification Matrix `completed` / Patron označuje notifikaci v zóně (notifikace v
  účtu / zóně) jako NO. Toto není zde tiše vyřešeno, v souladu s politikou proti halucinacím; Matrix je
  autoritativním zdrojem příjemce/kanálu, ale nesoulad je zaznamenán, nikoli přepsán.

Obě strany jsou o téže události informovány e-mailem. Kromě obecného rozlišení šablon podle země, které
je již zdokumentováno na úrovni capability (FN0019), není doložena žádná varianta obsahu specifická pro
RO/MD; tento dokument netvrdí nic o RO/MD specifickém znění.

**Konflikt v důkazech ohledně cesty doručení v CZ (Partial):** podle FLW0019 (zjištění o režimech
selhání) událost dokončení spouští na cestě CZ ještě dvě další šablony (identifikátory doložené v
podkladovém dossier o toku jako zakomentované v aktuální mapě CZ šablon), které se překládají na
neznámé názvy šablon a míří na cestu zahození namísto přenosu v CZ. Stavově řízený souhrnný e-mail pro
stav completed (obecný mechanismus změny stavu, MSG0005) se stále spouští nezávisle pro roli/stav
`completed`. Čistý efekt: je Confirmed, že Žadatel a Patron jsou o stavu `completed` informováni
e-mailem (prostřednictvím stavově řízeného souhrnného mechanismu) a Žadatel navíc v zóně; kanál
notifikace v zóně u Patrona zůstává zdrojovým Conflict zaznamenaným výše v části Příjemci. Je
Conflict / Uncertain, zda zamýšlený obsah dedikované šablony "úspěšné vybrání sbírky" (na rozdíl od
obecné stavové zprávy) skutečně dorazí k příjemci v nasazení CZ. Zaznamenáno zde, nikoli tiše
vyřešeno, v souladu s politikou proti halucinacím.

Odeslání spouštěné dokončením navíc podléhá stejné produkční/allow-list bráně pro odesílání jako veškerá
transakční e-mailová komunikace (FN0019 Constraints) — neprodukční prostředí mimo allow-list zprávu
archivuje, ale nepřenáší ji.

---

## Obsah zprávy

Zpráva koncepčně nese:

- Potvrzení, že sbírka Příběhu (Campaign, EN0004) dosáhla 100 % své cílové částky — sbírka je úspěšná.
- Sdělení, že budou následovat další kroky back-office: příprava smlouvy a nákup daru, aby příjemce
  věděl, že proces pokračuje, a neskončil.
- Implicitní identifikaci předmětného Příběhu/Žádosti (EN0004 / EN0001), aby příjemce poznal, který
  případ dosáhl svého cíle, v souladu s odpovídajícím zobrazením stavu v zóně, které ukazuje stav
  "Vybráno" (completed) jak v Parent Zone, tak v Patron Zone.

Tento kanonický dokument netvrdí žádný pevný text předmětu, identifikátor šablony ani značkování těla
zprávy (viz omezení rules-MSG); dva kandidátské identifikátory dedikovaných šablon pozorované v
důkazech o toku jsou zaznamenány pouze jako poznámka o konfliktu implementace výše, nikoli jako obsah
zprávy.

Zda pro daný pokus o odeslání existuje záznam EmailArchive (EN0022) — a zda jeho existence znamená
doručení, nebo potlačení bránou pro odesílání — se řídí mechanikou archivace a brány pro odesílání,
kterou vlastní FN0019 (viz FN0019 Constraints), a zde není opakováno. V důsledku toho dvě kandidátské
dedikované šablony pro úspěch, zaznamenané (v důkazech o toku) jako zakomentované v mapě CZ (viz
Příjemci), nemusí na cestě CZ zanechat žádnou archivní stopu — jde o omezení důkazů FN0019 / FLW0019,
nikoli o součást zamýšleného kontraktu této zprávy.

---

## Poznámky / Nejistoty

- Úroveň důkazu: Confirmed pro podmínku spouštění (vybraná částka ≥ cíl → stav `completed`) a pro
  existenci záměru dedikované notifikace o úspěchu (SC-8A kroky 3–4; UC0006.4.9; UC0011.1 krok 7).
  Partial / Conflict ohledně toho, jaký konkrétní obsah šablony skutečně dorazí k příjemcům v CZ, s
  ohledem na zakomentované dedikované šablony úspěchu zaznamenané ve FLW0019 — viz část Příjemci výše.
- Tato MSG je záměrně omezena pouze na milník `completed` ("Vybráno"); následné kroky back-office
  zmíněné v jejím obsahu (smlouva, platba, zpětná vazba) jsou každý pokryt vlastní dedikovanou zprávou
  (smlouva/podpis, potvrzení o daru, zpětná vazba) a zde nejsou opakovány.
