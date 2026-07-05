---
doc_id: MSG0020
title: Donation Pending Notice
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0005
  - UC0006
references:
  - EN0009
  - EN0004
  - EN0022
  - ES0006
---

# MSG0020 – Notifikace o nedokončeném daru

## Účel

Informovat dárce, že dar, který začal, ale nedokončil, je aktuálně ve stavu PENDING, a poskytnout mu
způsob, jak se vrátit a dokončit platbu. Jedná se o obnovovací/upomínací zprávu pro platbu rozpracovanou
a opuštěnou v průběhu — odlišnou od potvrzovací poděkovací zprávy za platbu, která se odesílá, jakmile
transakce (EN0009) poprvé dosáhne stavu PAID, a odlišnou od zprávy zasílané v případě, že je nedokončený
pokus následně natrvalo opuštěn a transakce přejde do stavu CANCELLED.

---

## Spouštěč

- UC0005 (Provedení daru), UC0005.1 krok 10: systém vytvoří transakci (EN0009) ve stavu PENDING, jakmile
  zákazník odešle požadavek na dar a je předán zemské platební bráně.
- UC0006 (Potvrzení platby – callback platební brány): transakce (EN0009) zůstává ve stavu PENDING, nebo
  je do stavu PENDING zpětně potvrzena, pokud dárce zahájí platbu na platební bráně, ale nedokončí ji
  (zavření prohlížeče, vypršení relace, nebo samotná brána vrátí nedokončený/čekající výsledek – viz
  UC0006.1 krok 5, UC0006.2 krok 4 a UC0006.3 krok 5/AF3).
- Spouštěcí stav: transakce (EN0009) `ext_status` = PENDING, dosažená bez potvrzení PAID v rámci téhož
  požadavku. Doloženo scénářem SC-10B ("Donation via Website – Not Completed (PENDING → CANCELLED)"),
  kroky 2–3: systém nastaví stav daru na PENDING a odešle dárci e-mail s notifikací o stavu PENDING
  s možností dokončit platbu.

---

## Příjemci

- **Dárce** – e-mail, prostřednictvím ES0006 (Mautic). Podle kroku 3 scénáře SC-10B je e-mail odeslán
  pouze dárci; pro tuto zprávu není doložen žádný příjemce Rodič/Patron (list matice notifikací pro
  fan-out podle stavu pokrývá stavy žádosti/příběhu pro rodiče a patrona, nikoli vlastní stavy PENDING/
  CANCELLED transakce daru řešené zde).
- Rovněž se promítá jako stav daru PENDING v zóně dárce (SC-10B krok 4) – jde o zobrazení stavu v rámci
  zóny, nikoli o samostatný notifikační kanál.
- Pro tuto zprávu není doložena žádná obsahová varianta CZ/RO/MD.

---

## Obsah zprávy

Zpráva koncepčně obsahuje:

- Upozornění, že platba daru byla zahájena, ale nebyla dokončena, a aktuálně čeká na dokončení.
- Dostatečnou identifikaci pokusu o dar (cílový příběh/kampaň, EN0004, a/nebo částka), aby dárce
  rozpoznal, ke které platbě se zpráva vztahuje.
- Způsob, jak se dárce může vrátit a dokončit platbu.

V tomto kanonickém dokumentu není uveden žádný pevný text předmětu, identifikátor šablony ani značkování
těla zprávy (viz omezení rules-MSG). Součástí obsahu této zprávy nejsou žádné detaily platebního
prostředku (číslo karty, data relace platební brány).

Každý pokus o odeslání je archivován jako záznam EmailArchive (EN0022), v souladu s FN0019; archiv
nerozlišuje mezi doručeným odesláním a odesláním potlačeným prostředím pomocí send-gate.

---

## Poznámky / Nejistoty

- Úroveň evidence: Partial. SC-10B potvrzuje platformou odeslaný e-mail PENDING dárci, avšak žádná
  vyhrazená šablona ani krok odeslání notifikace PENDING nebyl zjištěn v minutých tocích evidence
  UC0005/UC0006 (FLW0006, FLW0003, FLW0004, FLW0005) nad rámec vytvoření/ponechání transakce ve stavu
  PENDING; upomínka k dokončení v kroku 5 SC-10B ("Comgate odesílá dárci žádost o dokončení") je
  explicitně vlastní upomínkou platební brány, mimo transakční notifikační kapacitu platformy (FN0019),
  nikoli tato zpráva. Zaznamenáno jako doložené scénářem, nikoli potvrzené tokem, v souladu s politikou
  proti halucinacím – nezaměňovat s vlastní upomínkou platební brány.
- Tato zpráva je omezena pouze na milník PENDING. Výsledek dokončení (transakce dosáhne stavu PAID) a
  výsledek opuštění (transakce dosáhne stavu CANCELLED po timeoutu, podle kroků 7–8 SC-10B) jsou každý
  samostatnou zprávou a zde nejsou znovu popisovány.
