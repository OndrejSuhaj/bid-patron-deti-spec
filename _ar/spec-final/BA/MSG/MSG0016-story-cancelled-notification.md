---
doc_id: MSG0016
title: Story Cancelled Notification
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0011
references:
  - EN0004
  - EN0001
  - EN0009
  - EN0022
  - EN0026
  - ES0006
---

# MSG0016 – Notifikace o zrušení příběhu

## Účel

Informovat Žadatele (Parent / Žadatel) a Patrona o tom, že Příběh dítěte (Campaign, EN0004) byl
zrušen — jeho veřejný fundraisingový případ je uzavřen bez úspěšného výsledku. Jde o samostatnou,
vysoce významnou zprávu vázanou na terminální stav Příběhu `canceled_campaign` ("Příběh zrušen"),
vyčleněnou z obecných katch-all zpráv řízených stavem (MSG0005/MSG0006) ze stejného důvodu, proč je
samostatně vyčleněn i MSG0013 (Notifikace o publikování příběhu): zrušení Příběhu je vysoce významný
okamžik pro obě strany v životním cyklu případu, odlišný od rutinního provozu notifikací při změně
stavu, který tyto dva dokumenty pokrývají.

Doložené současné příčiny dosažení tohoto stavu:

- smlouva k Žádosti nebyla Žadatelem podepsána v rámci povoleného okna urgencí (nespolupracující
  případ) a Provoz (Operations) přealokoval přislíbený dar na příběhy jiných dětí;
- fundraisingová sbírka skončila na 0 % cílové částky a rezervace u dodavatele byla zrušena;
- Žadatel nebo Patron požádal o odstranění Příběhu po publikaci (požadavek na změnu eskalovaný do
  zrušení, nikoli do opravy obsahu).

---

## Spouštěč (Trigger)

UC0011 (Správa životního cyklu příběhu / kampaně) — Systém nastaví stav Kampaně (EN0004) a k ní
navázané Žádosti (EN0001) na `canceled_campaign` ("Příběh zrušen"), což spustí distribuci notifikací
při změně stavu žádosti popsanou v UC0011.3 — stejný mechanismus, na kterém stojí MSG0005/MSG0006.

Potvrzeno narativně třemi současnými cestami v evidenci testovacích scénářů
(`intake/test-scenarios/test-scenarios.md`):

- SC-8B (Žadatel nepodepíše smlouvu – nespolupracující), kroky 7–10: poté, co Žadatel nepodepíše
  smlouvu ani v jednom z obou oken urgencí, Provoz přealokuje dar, stav se změní na
  `canceled_campaign` a Systém odešle notifikaci o zrušení Žadateli i Patronovi.
- SC-8D (Sbírka nenaplněna na 0 %), kroky 7–9: poté, co Koordinátor zruší rezervaci u dodavatele
  a zruší Příběh v systému (vybráno 0 %), stav se změní na `canceled_campaign` a Systém odešle
  finální notifikaci o zrušení oběma stranám.
- SC-9B (Žadatel nebo Patron žádá o změny příběhu), kroky 5–8: požadavek na změnu po publikaci
  eskaluje na žádost o zrušení; Koordinátor odstraní Příběh z webu a stav se odpovídajícím způsobem
  změní, s notifikací o zrušení odeslanou Žadateli i Patronovi.

Matice notifikací potvrzuje rozřešený kanál/obsah pro stav `canceled_campaign` (obě role) a navíc
uvádí stav/zprávu `canceled_by_user` ("Příběh zrušen") na řádku Patrona, doloženou jako dosahující
stejné status zprávy "Příběh zrušen" jako `canceled_campaign` — zaznamenáno zde jako související,
ale ne zcela jednoznačně odlišený status alias (viz Poznámky).

Evidence Level: Confirmed pro spouštěcí stav (`canceled_campaign`), záměr informovat obě strany a
tři současné kauzální cesty (SC-8B, SC-8D, SC-9B); Partial pro přesné mapování status kódu
u řádku `canceled_by_user`/Patron v matici (viz Poznámky).

---

## Příjemci

- **Žadatel / Parent** — informován, že Příběh/případ byl zrušen.
- **Patron** — informován, že Příběh byl zrušen.

Kanál dle Matice notifikací (řádky `canceled_campaign`, Žadatel i Patron): E-mail = ANO
a notifikace v účtu (in-zone) = ANO pro obě role — tj. současný kontrakt je **oba zároveň**: e-mail
(přes ES0006, Mautic) i notifikace v zóně (Zóna žadatele / Zóna patrona) pro tento stav, na rozdíl od
MSG0013 (Publikování příběhu), kde matice rozřeší pouze notifikaci v zóně. Každé odeslání e-mailu je
archivováno jako záznam EmailArchive (EN0022), v souladu s obecným mechanismem odesílání
zdokumentovaným v MSG0005.

Žádné CZ/RO/MD varianty kanálu nejsou nad tento rámec doloženy; dvojí doručení e-mailem a v zóně je
zaznamenáno jednotně napříč citovanými scénáři i Maticí notifikací, bez tržně specifického rozlišení
kanálu v současných zdrojích.

---

## Obsah zprávy

Koncepčně nese každá instance této zprávy:

- Status zprávu potvrzující, že Příběh byl zrušen — literál z Matice notifikací: "Příběh zrušen"
  (zobrazeno Žadateli i Patronovi pro `canceled_campaign`).
- Tam, kde je to relevantní (cesty nespolupráce při podpisu smlouvy a 0% sbírky dle SC-8B/SC-8D),
  informaci o tom, že jakýkoli dar již vybraný/přislíbený na tento Příběh je přesměrován/přealokován
  na příběhy jiných dětí, namísto toho, aby byl vázán na tento případ — jde o podstatnou skutečnost,
  kterou příjemce potřebuje znát, aby pochopil, co se stane s již provedeným příslibem nebo
  příspěvkem, odlišnou od rutinního statusového označení.
- Implicitní odkaz na případ: zobrazeno v kontextu vlastního pohledu příjemce do Zóny žadatele /
  Zóny patrona na jeho Žádost (EN0001) / Příběh (EN0004), v souladu se stavem "Příběh zrušen" /
  zrušeno, nyní viditelným v obou zónách dle SC-8B kroku 9 / SC-8D kroků 10–11.

Z tohoto kontraktu vyloučeno (jde o doručení/implementaci, nikoli obsah zprávy): přesný text
kopie/předmětu nad rámec výše citovaného literálu z matice, HTML/vizuální prezentace a to, jakým
technickým způsobem je realizována přealokace daru (EN0009 Transakce) na jiný Příběh.

---

## Poznámky / Nejistoty

- Tato zpráva sdílí svůj podkladový distribuční mechanismus s MSG0005 (e-mail při změně stavu)
  a MSG0006 (notifikace o stavu v zóně) — stejná shoda ApplicationReaction (EN0026) na stavu
  `canceled_campaign` Žádosti (EN0001) dle UC0011.3 — a MSG0005 již uvádí `canceled_campaign`
  a `canceled_by_user` mezi stavy zahrnutými do svého obecného katch-all výčtu. Zde je dokumentována
  samostatně, stejným způsobem jako byl vyčleněn MSG0013 (Publikování příběhu), protože zrušení
  Příběhu je samostatný, vysoce významný, oba strany zasahující terminální výsledek, který stojí za
  to izolovat s vlastním kontraktem zprávy (včetně prvku obsahu o přealokaci daru, který obecný
  katch-all nezachycuje), namísto ponechání tichého začlenění do rutinního statusového provozu.
- Odlišné od notifikací o zrušení na úrovni žádosti, které se spouštějí dříve v životním cyklu
  případu, ještě než Příběh/Kampaň existuje nebo je publikován (`canceled_application`,
  `canceled_lead`, `canceled_timeout` — "Žádost zrušena" / "Zrušená žádost") — jde o zrušení ve fázi
  Žádosti/Leadu, mimo rozsah tohoto dokumentu, a nadále je pokrývá katch-all MSG0005/MSG0006.
- Řádek `canceled_by_user` v Matici notifikací pro roli Patrona se rozřeší na stejnou status zprávu
  ("Příběh zrušen") jako `canceled_campaign`, s Email = ANO / notifikace v účtu = NE pro tento
  konkrétní řádek — užší než plný pár kanálů u `canceled_campaign`. Evidence nepostačuje k
  definitivnímu tvrzení, zda je `canceled_by_user` samostatnou spouštěcí cestou, nebo aliasem
  projevujícím se skrze stejný výsledek zrušení jako SC-9B (zrušení na žádost Žadatele/Patrona);
  ponecháno jako otevřená otázka ke sladění, nikoli tvrzeno jako totožné. Řádek `canceled_by_user`
  pro roli Žadatele ("Zrušeno žadatelem") nese odlišnou status zprávu a není považován za součást
  této zprávy o zrušení Příběhu.
- Evidence Level: Confirmed pro spouštěč `canceled_campaign`, záměr informovat obě strany, doručení
  dvěma kanály a prvek obsahu o přealokaci daru (SC-8B, SC-8D); Partial pro výše uvedený vztah aliasu
  `canceled_by_user`; SC-9B potvrzuje cestu zrušení na žádost narativně, ale bez stejně explicitního
  detailu kanálu jako SC-8B/SC-8D (jeho vlastní sloupce matice v daném listu ukazují všude NE/NE, což
  je ve zjevném napětí s ANO/ANO u `canceled_campaign` v kanonické Matici notifikací — zaznamenáno
  jako Conflict, přičemž list kanonické Matice notifikací je dle projektové instrukce považován za
  vyšší autoritu pro současné chování kanálů).
