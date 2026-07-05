---
doc_id: MSG0017
title: Application Cancelled — Timeout
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0022
  - ES0006
---

# MSG0017 – Zrušená žádost — Timeout

## Účel

Informovat Žadatele i Patrona o tom, že Žádost (EN0001) byla automaticky zrušena, protože povinný
krok — dokončení části formuláře Žadatelem nebo Patronem, případně nominace náhradního Patrona
Žadatelem — nebyl proveden v rámci nastaveného okna urgencí a lhůt. Jde o finální, systémem iniciovanou
(nikoli člověkem iniciovanou) uzavírací zprávu pro timeoutovou cestu, odlišnou od dobrovolného zrušení
ze strany některé ze stran i od zrušení na straně Příběhu.

---

## Spouštěč

UC0002 (Orchestrace změny stavu žádosti) — konkrétně dílčí tok automatického přechodu stavu řízeného
plánovačem (UC0002.3): jakmile Žádost (EN0001) překročí stáří druhé urgence o nastavené další období
(doloženo jako 7 kalendářních dnů) a stále nedojde k dokončení, Scheduler ji přesune do stavu zrušení
kvůli timeoutu, což se opět vrací do hlavního toku (UC0002.1) a spouští fan-out notifikací řízený
stavem (UC0002.2 krok 6).

Spouštěcí stavy (slovník stavů, Confirmed vůči Notification Matrix):

- `canceled_timeout` — dosažen z cesty timeoutu dokončení Žadatelem (SC-3C), z cesty timeoutu vrácení
  k dokončení (SC-4B krok 13), z cesty nedokončení novým Patronem (SC-6B krok 6) a z cesty, kdy Žadatel
  neposkytne údaje o novém Patronovi (SC-6C krok 4). Ve všech těchto akceptačních scénářích zprávu
  dostávají jak Žadatel, tak Patron (e-mail + notifikace v zóně), v souladu s řádky `canceled_timeout`
  v Notification Matrix pro obě role.
- `canceled_fundraiser` — obdobný výsledek zrušení kvůli timeoutu u varianty toku žádosti iniciované
  Patronem („fundraiser“ / strana Žadatele čeká na vyřízení) (cesta SC-2* Patron žádost zakládá jako
  první), doložený v Notification Matrix jako řádek pouze pro Patrona (Email = YES, Notification =
  YES); odpovídající řádek matice pro roli Žadatele u tohoto stavu doložen není.

Oba stavy představují stejnou koncepční událost — automatické zrušení po vyčerpání sekvence
urgence/lhůty — aplikovanou na různé cesty vzniku Žádosti. Tento dokument je proto pojímá jako jeden
typ zprávy s variantou dle stavu/role, nikoli jako dvě samostatné zprávy.

Úroveň evidence: Confirmed pro existenci, mechanismus spouštění a doručení oběma stranám u
`canceled_timeout` (křížově ověřeno napříč SC-3C, SC-4B, SC-6B, SC-6C a Notification Matrix). Partial
pro `canceled_fundraiser`: doloženo pouze jedním řádkem Notification Matrix (směrem k Patronovi), bez
odpovídajícího průchodu akceptačním scénářem nebo potvrzeného protějšího řádku pro stranu Žadatele.

---

## Příjemci

- **Žadatel** — e-mail (přes ES0006 Mautic) a notifikace v zóně, pro stav `canceled_timeout`
  (Notification Matrix: Email = YES, Notification = YES). Samostatně nedoloženo pro
  `canceled_fundraiser` (pro tento stav není v matici přítomen řádek pro roli Žadatele).
- **Patron** — e-mail (přes ES0006 Mautic) a notifikace v zóně, pro oba stavy `canceled_timeout` i
  `canceled_fundraiser` (Notification Matrix: Email = YES, Notification = YES u obou stavů).

Nad rámec obecného rozlišení šablon podle země, které platí pro všechny transakční zprávy [ES0006],
není doložena žádná odlišnost obsahu pro CZ/RO/MD.

---

## Obsah zprávy

Koncepční informační prvky, které zpráva musí obsahovat:

- Konstatování, že Žádost (EN0001) byla zrušena a že důvodem je timeout — požadovaný krok (dokončení
  formuláře nebo nominace náhradního Patrona) nebyl proveden v rámci lhůt daných sekvencí urgencí.
- Identifikaci předmětné Žádosti (EN0001) a případně přiřazeného dítěte, aby příjemce poznal, o který
  případ se při uzavření jedná.
- Zdvořilý uzavírací tón potvrzující výsledek, aniž by samotné znění přisuzovalo vinu (podkladová
  příčina — nedokončení — vyplývá z kontextu implicitně, nemusí být nutně vyjádřena doslovně).
- Pozvánku k opětovnému podání žádosti / založení nové žádosti, pokud má příjemce o účast stále zájem,
  v souladu s tím, že zrušení je výsledkem procesního timeoutu, nikoli zamítnutím na základě obsahu.
- Odkaz zpět do zóny příjemce (zóna Žadatele / zóna Patrona), kde zůstává zrušený stav viditelný i po
  odeslání zprávy.

Tento kanonický dokument nestanovuje žádný pevný text předmětu, formátování těla ani strukturu šablony
— konkrétní znění je instanční data podle konfigurace ApplicationReaction a je mimo rozsah vrstvy MSG.
Každé odeslání je archivováno jako záznam EmailArchive (EN0022), v souladu s obecným archivačním
chováním transakčních zpráv.

---

## Nejistoty / poznámky

- Tato zpráva představuje **systémový/automatický** výsledek zrušení kvůli timeoutu. Je odlišná od:
  - **dobrovolného**, člověkem iniciovaného zrušení ze strany Žadatele, Patrona nebo Koordinátora
    (samostatný typ zprávy, zde nepokrytý);
  - zrušení na straně **Příběhu** (zrušení na úrovni kampaně/sbírky, samostatný typ zprávy, zde
    nepokrytý);
  - stavu `canceled_lead`, který je zahrnut do obecné souhrnné zprávy řízené stavem, a není tedy
    veden jako samostatný dokument.
- `canceled_fundraiser` je záměrně veden společně s `canceled_timeout` v rámci jednoho typu zprávy,
  protože oba představují stejnou koncepční událost (automatické zrušení po vypršení sekvence
  urgence/lhůty) na různých cestách vzniku Žádosti; evidence příjemce pouze na straně Patrona pro
  `canceled_fundraiser` je výše zaznamenána jako mezera typu Partial, nikoli řešena domněnkou.
- `Hypothesis — Not evidenced in current sources`: přesné znění pozvánky k opětovnému podání žádosti
  a to, zda je přítomno v každé instanci této zprávy, nebo jde o obecný standardní text sdílený s
  ostatními zprávami z rodiny zrušení — ze sémantiky stavů a okolních akceptačních scénářů lze
  odvodit pouze celkový záměr (zdvořilé uzavření, možnost opětovného podání), nikoli ze zachyceného
  těla zprávy.
