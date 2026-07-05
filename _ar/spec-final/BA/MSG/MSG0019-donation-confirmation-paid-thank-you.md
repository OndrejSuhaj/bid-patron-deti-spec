---
doc_id: MSG0019
title: Donation Confirmation — Paid (Thank-You)
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0006
references:
  - EN0009
  - EN0004
  - EN0008
  - EN0022
  - ES0006
---

# MSG0019 – Potvrzení daru — uhrazeno (poděkování)

## Účel

Poděkovat dárci a potvrdit, že jeho dar byl úspěšně přijat — tj. že podkladová transakce (EN0009)
dosáhla stavu PAID. Tato zpráva pokrývá tři platební cesty iniciované dárcem, které vyúsťují v první
potvrzení PAID: jednorázový dar na konkrétní příběh (kampaň, EN0004), dar na obecný/transparentní
sběrný účet a bankovní převod spárovaný se sběrným účtem. Jde o dárcem adresovaný protějšek
stavově řízené komunikace s rodičem/patronem (MSG0005/MSG0006) — tato zpráva je adresována dárci,
nikoli rodiči nebo patronovi.

---

## Spouštěč

UC0006 (Potvrzení platby — callback platební brány), sdílený krok vedlejšího efektu UC0006.4 —
spouští se při prvním uložení dané transakce (EN0009) do stavu PAID, bez ohledu na to, která
regionální cesta platební brány jej vyřešila (ComGate/CZ, Netopia/RO, MAIB/MD callback nebo poll)
nebo zda byl stav PAID místo toho nastaven na základě spárovaného bankovního převodu. Systém
označí transakci jako již odeslanou pro toto potvrzení, aby pozdější opětovné uložení, které
stav nezmění, tuto zprávu znovu nespustilo (UC0006.4 krok 2; UC0006 AF2).

Pro cestu bankovního převodu spouštěč dále vyžaduje, aby dárce uvedl odpovídající e-mailovou
adresu (zaznamenanou u převodu při párování plateb) — pokud e-mail zachycen nebyl, tato zpráva
se pro danou transakci nespustí.

Evidence: UC0006 krok UC0006.4.1–2; akceptační scénáře Notification Matrix SC-10A (krok 8), SC-10C
(krok 6), SC-10D (krok 5) v `intake/test-scenarios/test-scenarios.md`.

---

## Příjemci

- **Dárce** — e-mail, přes ES0006 (Mautic). Jde o jediného adresáta této zprávy; neodesílá se
  rodiči, patronovi ani žádné provozní roli.
  - Jednorázový dar na příběh a dar na obecný/transparentní sběrný účet: odesílá se vždy
    (e-mailová adresa je povinné pole zachycené v okamžiku daru).
  - Bankovní převod: odesílá se pouze tehdy, pokud dárce uvedl odpovídající e-mailovou adresu
    v okamžiku převodu (SC-10D); jinak dárce pro danou transakci žádný e-mail neobdrží.
- Potvrzený stav PAID a samotný dar jsou dárci navíc viditelné v Donor Zone (v rámci aplikace,
  mimo rámec této smlouvy o transakční zprávě).
- Pro tuto zprávu není doložena žádná obsahová odlišnost CZ/RO/MD nad rámec už na úrovni
  schopnosti zdokumentovaného rozlišení šablon podle země (FN0019); podkladová platební brána se
  podle regionu liší (ComGate/CZ, Netopia/RO, MAIB/MD), ale u samotné smlouvy o zprávě odlišnost
  podle regionu doložena není.

---

## Obsah zprávy

Konceptuálně každá instance této zprávy obsahuje:

- Poděkování adresované dárci za jeho podporu.
- Potvrzení, že platba daru byla úspěšně přijata (stav PAID) — nikoli pouze zahájena nebo čeká
  na vyřízení.
- Potvrzenou částku daru.
- Identifikaci toho, co dar podporuje, je-li to přiřaditelné: konkrétní příběh/kampaň (EN0004)
  u daru cíleného na příběh, nebo obecný/transparentní sběrný účet u daru na sběrný účet nebo
  u spárovaného bankovního převodu bez přiřazení ke konkrétnímu příběhu v okamžiku odeslání.
- Neobsahuje žádný detail platební karty, bankovního účtu ani jiného platebního nástroje.

V tomto kanonickém dokumentu není uveden žádný pevný text předmětu, značkování těla ani struktura
šablony — konkrétní znění je instanční/konfigurační data a je mimo rozsah vrstvy MSG (viz omezení
v rules-MSG.md). Každé odeslání je archivováno jako záznam EmailArchive (EN0022).

---

## Poznámky

- Na konfigurační úrovni existují dvě odlišné varianty zprávy podle cíle daru (přiřazený k
  příběhu vs. obecný/transparentní sběrný účet), obě však naplňují stejnou výše popsanou smlouvu
  o zprávě — poděkování + potvrzení PAID + částka + (je-li přiřaditelné) podporovaný příběh; tento
  dokument je proto považuje za jednu kanonickou zprávu, nikoli za dvě, v souladu s pravidlem
  seskupování MSG (seskupovat podle typu zprávy, nikoli podle konfigurační varianty nebo řádku
  matice).
- Odesílá se jednou na transakci (EN0009), chráněno příznakem již odesláno na transakci
  (UC0006.4 krok 2); pozdější opakované zpracování téže transakce, které nezmění její stav, tuto
  zprávu znovu neodešle (UC0006 AF2).
- Odeslání probíhá synchronně jako součást zpracování potvrzení platby v UC0006.4, nikoli jako
  odložené/dávkové odeslání.
- Odlišuje se od interní, pouze provozní notifikace o události daru na ES0015 (Slack): jde o
  samostatný kanál neurčený uživatelům, určený provoznímu personálu, a je mimo rozsah této MSG.
- Odlišuje se od potvrzení nákupu dárkového poukazu (rovněž spouštěného v UC0006.4, adresovaného
  příjemci poukazu) a od potvrzení úspěšného naplnění kampaně (spouštěného při dosažení cílové
  částky kampaně) — obě jsou samostatné záměry zpráv, které tento dokument nepokrývá.
- Úroveň evidence: Confirmed pro mechanismus spouštění, ochranu proti opakování při stavu PAID
  a smlouvu dárce-jako-příjemce (UC0006.4; SC-10A/10C/10D). Partial pro přesné konceptuální
  rozdělení obsahu mezi variantu přiřazenou k příběhu a variantu se sběrným účtem, protože přesné
  rozdíly ve znění jsou konfigurační data, která nejsou z citovaných zdrojů plně viditelná.
