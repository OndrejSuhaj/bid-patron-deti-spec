---
doc_id: MSG0030
title: Donor Feedback / Post-Campaign Thank-You
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - FN0006
references:
  - FN0006
  - FN0019
  - EN0021
  - EN0004
  - EN0009
  - EN0022
  - ES0006
---

# MSG0030 – Zpětná vazba dárcům / poděkování po ukončení kampaně

## Účel

Uzavřít smyčku s Dárci Příběhu poté, co byla kampaň finančně naplněna: doručit Dárcům vlastní
vyjádření Rodiče o tom, jak byl dar dítěti využit (nebo, pokud Rodič nespolupracoval, obecné
poděkování místo něj), aby Dárci viděli výsledek daru, který poskytli. Jedná se o dárcům určený
protějšek fáze zpětné vazby v životním cyklu Kampaně/Příběhu — odlišný od výzev v zóně/e-mailem,
které žádají Rodiče o *podání* zpětné vazby (spravováno jinde; viz Poznámky).

---

## Spouštěč

FN0006 (Správa životního cyklu Kampaně / Příběhu) — fáze zpětné vazby po ukončení kampaně v rámci
životního cyklu Kampaně (EN0004), která spravuje sesbíranou Zpětnou vazbu (EN0021), v okamžiku, kdy
Koordinátor obsahu odešle tuto Zpětnou vazbu Dárcům Příběhu a stav Žádosti/Kampaně se nastaví na
`feedback_sent` ("Poděkování dárcům odesláno" / "Zpětná vazba odeslána").

K tomuto odeslání vedou dvě doložené cesty:

- **Osobní zpětná vazba**: Rodič poskytl zpětnou vazbu (prostřednictvím systému, e-mailem nebo jako
  odkaz na video) a Koordinátor obsahu předá tento konkrétní obsah Dárcům Příběhu.
- **Univerzální zpětná vazba**: Rodič v rámci okna pro zpětnou vazbu nespolupracoval (ani po sekvenci
  urgencí) a Koordinátor obsahu místo osobního vyjádření odešle Dárcům Příběhu univerzální/obecné
  poděkování.

Evidence: `intake/test-scenarios/test-scenarios.md` — SC-9C (kroky 5, 6, 9, 14, 15) a SC-9D (kroky
4, 5); řádky Notifikační matice pro stav `feedback_sent` (E-mail→Dárce = ANO, Notifikace→Dárce =
ANO).

---

## Příjemci

- **Dárci Příběhu** — strana, která finančně podpořila konkrétní Kampaň (EN0004), k níž se tato
  zpětná vazba vztahuje. Doručováno e-mailem přes ES0006 (Mautic).

Změna stavu `feedback_sent` se rovněž promítá Rodiči a Patronovi, avšak pouze jako signál v
účtu/zóně, nikoli jako e-mail (Notifikační matice: E-mail→Rodič = NE, E-mail→Patron = NE pro
`feedback_sent`) — toto promítnutí v zóně pokrývá MSG0006, nikoli tento dokument. Tato MSG pokrývá
pouze odchozí odeslání Dárcům Příběhu, což je skutečná transakční zpráva nesoucí obsah zpětné vazby.

Pro tuto zprávu není doložena žádná varianta obsahu podle CZ/RO/MD nad rámec obecného řešení
šablon podle země, které je již zdokumentováno na úrovni schopnosti (FN0019); tok stavů fáze zpětné
vazby je podle citovaných zdrojů sdílený napříč trhy.

---

## Obsah zprávy

Koncepčně každá instance této zprávy nese:

- Poděkování Dárci za podporu Příběhu (Kampaně, EN0004).
- Podstatu zpětné vazby Rodiče o tom, jak byl dar/podpora využita — u cesty osobní zpětné vazby jde
  o vlastní vyjádření Rodiče (textový popis a/nebo fotografie a/nebo odkaz na video) o výsledku; u
  cesty univerzální zpětné vazby jde o obecné poděkování/závěrečné sdělení použité místo osobního
  vyjádření, protože zpětná vazba autorizovaná Rodičem nebyla včas k dispozici.
- Identifikaci, kterého Příběhu (Kampaně, EN0004) se zpětná vazba/poděkování týká.

Zde není stanoven žádný pevný text předmětu, značkování těla zprávy ani struktura šablony —
konkrétní znění je instanční/konfigurační data a je mimo rozsah vrstvy MSG. Každé odeslání je
archivováno jako záznam EmailArchive (EN0022), v souladu s obecným archivačním chováním schopnosti
transakčního zasílání zpráv.

---

## Poznámky / Nejistoty

- **Odlišné od zprávy s žádostí o zpětnou vazbu.** Tento dokument pokrývá odchozí zprávu *Dárcům*
  nesoucí zpětnou vazbu/poděkování. Nejedná se o zprávu, která žádá Rodiče o *podání* zpětné vazby
  jako takové, ani o žádnou z obou urgencí ohledně zpětné vazby zasílaných Rodiči — ty představují
  samostatný záměr zprávy (vyžádání obsahu od Rodiče) a jsou pokryty jinde, nikoli tímto dokumentem.
- **Osobní a univerzální zpětná vazba jsou jeden typ zprávy, ne dva.** Podle pravidla seskupování
  pro tento syntézní průchod jsou odeslání osobně vytvořené zpětné vazby a odeslání
  univerzálního/obecného poděkování (použité po nespolupráci, dle SC-9D) považovány za jednu
  kanonickou zprávu — stejný spouštěcí bod (stav → `feedback_sent`), stejná množina příjemců (Dárci
  Příběhu), stejný strukturální obsah (poděkování + vyjádření o výsledku), lišící se pouze v tom,
  zda je vyjádření o výsledku specifické pro Rodiče, nebo obecné.
- **Mechanika odesílání podkladové entity Zpětná vazba je Partial evidence.** EN0021 (Zpětná vazba)
  zaznamenává časovou značku `sent` na cestě formuláře zpětné vazby a rekonstruovaný tok odesílání
  není plně dohledán od akce odeslání Koordinátorem obsahu až po e-mailové odeslání jednotlivým
  Dárcům (na rozdíl od MSG0019/UC0006, kde je spouštěč odeslání plně vytěžen). Tento dokument je
  založen na evidenci stavu/role/kanálu z Notifikační matice (SC-9C, SC-9D) a na obecné mechanice
  transakčního zasílání zpráv/EmailArchive (FN0019, EN0022) a je ukotven na schopnosti, která
  spravuje fázi zpětné vazby po ukončení kampaně (FN0006), nikoli na konkrétním číslovaném kroku
  use-case, protože **žádný vytěžený krok UC toto odeslání směrem k dárcům explicitně
  nepojmenovává.** Konkrétně UC0011 (životní cyklus Kampaně/Příběhu) obsahuje pouze kroky publikace /
  vypršení termínu / automatického dokončení / reindexace a žádný krok zpětné vazby a UC0002 pouze
  *vytváří* relaci zpětné vazby — žádný z UC nevytěžuje odchozí odeslání Dárcům, proto tato MSG
  záměrně necituje jako svůj spouštěč žádný UC.
- **Příjem videa se zpětnou vazbou (SC-9C možnosti B/C) je interní proces zpracování obsahu**
  (e-mail přeposlaný Informačnímu koordinátorovi, poté specialistovi na sociální sítě a následně
  odkaz na YouTube vložený Koordinátorem obsahu), který po dokončení produkuje stejnou odchozí zprávu
  Dárci; mechanika samotného příjmu není součástí smluvního obsahu této zprávy.
- **Množina příjemců je Dárci Příběhu jako skupina**, nikoli jmenovaný jednotlivec; přesná logika
  vymezení "všech Dárců tohoto Příběhu" (např. jednorázoví vs. trvalí dárci, minimální prahové
  hodnoty daru) není v citovaných zdrojích doložena a zde není tvrzena.
- Evidence Level: Confirmed pro spouštěcí stav (`feedback_sent`), roli příjemce (Dárce, e-mailový
  kanál) a obě varianty obsahu (osobní / univerzální), dle SC-9C a SC-9D. Uncertain pro přesný
  interní krok odeslání a pro jakákoli jemnozrnná pole obsahu nad rámec poděkování + vyjádření o
  výsledku + identifikace Příběhu.
