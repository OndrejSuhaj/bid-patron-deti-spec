---
doc_id: MSG0029
title: Feedback Request & Reminders
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0021
  - EN0022
  - ES0006
---

# MSG0029 – Žádost o zpětnou vazbu a urgence

## Účel

Požádat rodiče/žadatele o poskytnutí zpětné vazby po uskutečnění daru — jak byl dar využit, popsáno
prostřednictvím výsledku příběhu, fotografií a slovního popisu — v rámci stanoveného termínu a
eskalovat pomocí dvou urgencí (druhá z nich navíc informuje i patrona), než je případ označen jako
nespolupracující. Jde o žádající/eskalační stranu cyklu zpětné vazby; tato zpráva předchází předání
zpětné vazby dárcům a je od něj odlišná (MSG0030).

---

## Spouštěč

UC0002 – Orchestrace změny stavu žádosti — hromadné rozeslání notifikací řízené stavem
(UC0002.2 krok 6) spouští tuto zprávu vždy, když žádost (EN0001) vstoupí do jednoho z následujících
stavů (slovník stavů, Confirmed vůči Notification Matrix):

- `waiting_for_feetback` — počáteční žádost o zpětnou vazbu, do tohoto stavu se vstupuje jednou po
  vypořádání cyklu daru/daru pro příběh.
- `waiting_feedback_reminder_1` — 1. urgence, dosažena prostřednictvím dílčího procesu stárnutí
  řízeného plánovačem (UC0002.3) poté, co rodič nepodal zpětnou vazbu v rámci nastaveného termínu.
- `waiting_feedback_reminder_2` — 2. urgence, dosažena po dalším období stárnutí, kdy zpětná vazba
  stále chybí; toto je zároveň okamžik, kdy je o zpoždění poprvé informován i patron.
- `waiting_feedback_uncooperative` — koncový eskalační stav dosažený po pokračující nereakci; označuje
  rodiče jako nespolupracujícího pro tento cyklus (což se promítá do budoucího hodnocení rizika –
  mimo rozsah této zprávy; viz UC0003) a předchází rozeslání univerzálního, nepersonalizovaného
  poděkování dárcům namísto vlastní zpětné vazby rodiče (pokryto v MSG0030, nikoli v tomto dokumentu).

Evidence: řádky Notification Matrix pro výše uvedené čtyři stavy; SC-8A kroky 22–25; SC-9C krok 1;
SC-9D kroky 1–3 (`intake/test-scenarios/test-scenarios.md`).

---

## Příjemci

- **Rodič/Žadatel** — oslovená strana v každém kroku této eskalace. Kanál: e-mail (přes ES0006
  Mautic) a notifikace v účtu/zóně, dle Notification Matrix, pro stavy `waiting_for_feetback`,
  `waiting_feedback_reminder_1` a `waiting_feedback_reminder_2`. U koncového stavu
  `waiting_feedback_uncooperative` Notification Matrix pro tento konkrétní stavový řádek neeviduje
  žádné další příznaky e-mailu/notifikace v zóně směrem k rodiči — aktivní odesílání zpráv v rámci
  této eskalace končí u 2. urgence.
- **Patron** — není oslovován při počáteční žádosti ani při 1. urgenci (Notification Matrix: žádné
  příznaky e-mailu/notifikace pro `waiting_for_feetback` ani `waiting_feedback_reminder_1` na straně
  patrona). Při **2. urgenci** (`waiting_feedback_reminder_2`) je patron navíc informován e-mailem
  (Notification Matrix: e-mail patronovi = ANO), aby věděl, že rodič dosud zpětnou vazbu neposkytl;
  SC-9D krok 2 potvrzuje „patron je také informován" v tomto okamžiku.
- Není doložena žádná obsahová odlišnost CZ/RO/MD nad rámec obecného rozlišení šablon podle země, které
  se uplatňuje u všech transakčních zpráv [ES0006]; samotný slovník stavů nese aliasy CZ/RO/MD (viz
  glosář), jde ale o fakt týkající se pojmenování stavu, nikoli o odlišný návrh zprávy.

---

## Obsah zprávy

Konceptuální informační prvky, které musí zpráva obsahovat:

- Žádost, aby rodič/žadatel poskytl zpětnou vazbu o tom, jak byl dar/příspěvek pro jejich příběh
  využit — v akceptační evidenci popsáno jako výsledek, fotografie a popis toho, jak byl dar využit
  (SC-8A krok 26; SC-9C).
- Termín, do kterého se zpětná vazba očekává, po jehož uplynutí eskalace pokračuje (SC-8A kroky
  22–25 dokládají přibližně 14denní počáteční okno a další 14denní okno před 2. urgencí; ponecháno
  jako `Partial` — viz Nejistota níže).
- Kde/jak zpětnou vazbu podat: prostřednictvím zóny rodiče (odeslání textu a fotografií přímo v
  systému), nebo alternativně e-mailem na platformu (SC-9C Varianty A/B/C dokumentují odeslání v
  systému, odeslání e-mailem a odeslání videa e-mailem jako alternativní kanály — samotné zpracování
  kanálu je provozní/back-office směrování, nikoli součást kontraktu této odchozí zprávy).
- U 1. a 2. urgence: signál, že jde o urgenci (eskalační krok), protože zpětná vazba dosud nebyla
  přijata.
- U 2. urgence, konkrétně patronovi: sdělení, že rodič dosud neposkytl zpětnou vazbu ke svému
  sponzorovanému příběhu.
- Implicitní náznak důsledku: pokračující nereakce vede k označení rodiče jako nespolupracujícího pro
  tento cyklus a k odeslání univerzálního, nepersonalizovaného poděkování dárcům namísto rodiče —
  není doloženo, že by samotné urgenční zprávy tento konkrétní důsledek ve svém obsahu výslovně
  uváděly, tento výsledek ustavují pouze okolní procesní kroky (SC-9D kroky 3–4).

Znění šablony, text předmětu ani grafická úprava zde nejsou specifikovány — jde o záležitosti
doručovací/šablonové vrstvy náležející odchozímu transportu, nikoli tomuto kontraktu [ES0006]. Každé
odeslání je archivováno jako záznam EmailArchive (EN0022).

---

## Poznámky

- Sloučeno do **jednoho typu zprávy** zahrnujícího počáteční žádost o zpětnou vazbu i obě eskalační
  urgence (`waiting_for_feetback` → `waiting_feedback_reminder_1` → `waiting_feedback_reminder_2`
  → `waiting_feedback_uncooperative`), dle pravidla seskupování MSG (seskupovat podle typu zprávy,
  nikoli podle řádku matice): všechny čtyři stavy realizují stejný mechanismus žádosti a eskalace,
  liší se pouze rolí/krokem a přidáním patrona jako příjemce u 2. urgence.
- Odlišné od **MSG0030** (případně ekvivalentu, je-li dokumentováno samostatně): následné předání
  skutečné zpětné vazby rodiče — nebo při nespolupráci univerzálního poděkování — dále dárcům
  (`feedback_to_proccess` → `feedback_sent`); jde o odlišný záměr zprávy (adresovaný dárcům,
  distribuce obsahu) a je mimo rozsah tohoto dokumentu.
- Odlišné od páru upomínek na dokončení žádosti (MSG0007) a páru upomínek na podpis smlouvy
  (`waiting_signature_reminder_1/2`, vlastní typ zprávy) — oba mají podobný tvar eskalace 1./2.
  upomínky, ale týkají se jiných čekacích stavů.
- SC-11E (Mautic Integration) řádek 2 potvrzuje, že e-maily s urgencí zpětné vazby rodičům jsou
  odesílány přes Mautic, což potvrzuje kanál ES0006 pro tuto zprávu.
- Entita `feedback` (EN0021) zachycuje samotný obsah zpětné vazby po jejím podání rodičem; tato zpráva
  (MSG) se týká pouze žádající/urgenční komunikace, která podání předchází a vyvolává ho, nikoli
  atributů samotného záznamu zpětné vazby (ty náleží EN0021).

---

## Nejistota / Poznámky

- Úroveň evidence: `Confirmed` pro existenci čtyřstavové eskalace
  (žádost → urgence 1 → urgence 2 → nespolupracující), pro mix kanálů (e-mail + notifikace v zóně
  přes ES0006) a pro to, že patron je zapojen u 2. urgence (Notification Matrix +
  SC-8A/SC-9C/SC-9D).
- `Partial` pro přesnou délku termínů: SC-8A (krok 22–25) i SC-9D (kroky 1–3) popisují vícestupňové
  okno stárnutí, ale uvádějí ho nekonzistentně — SC-8A naznačuje zhruba 14 dní do počátečního termínu
  a dalších 14 dní do 2. urgence, zatímco poznámka v kroku 2 SC-9D upozorňuje na vnitřní rozpor v
  dokumentech („dokumenty uvádějí 14denní interval[y]") a krok 3 navíc uvádí 30denní finální okno
  před stavem nespolupracující; přesné prahové hodnoty stárnutí řízeného cronem nejsou zde nezávisle
  ověřeny proti vytěženému souboru toků pro tuto konkrétní eskalaci
  (`Conflict — requires clarification`, zaznamenáno dle pravidla evidence-first namísto tichého
  vyřešení).
- `Hypothesis — Not evidenced in current sources` ohledně toho, zda samotná žádající/urgenční zpráva
  ve svém obsahu uvádí přesné datum/počet dnů termínu, nebo zda je termín vynucován pouze okolní
  logikou plánovače (UC0002.3), aniž by byl příjemci výslovně sdělen.
