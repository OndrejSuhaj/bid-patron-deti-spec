---
doc_id: MSG0004
title: Magic-Link Login
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0014
references:
  - EN0008
  - ES0006
---

# MSG0004 – Přihlášení pomocí magic-linku

## Účel

Umožnit stávajícímu držiteli účtu bezheslový návrat do jeho zóny: na vyžádání platforma odešle
na registrovanou e-mailovou adresu účtu jednorázový přihlašovací odkaz, aby držitel účtu mohl otevřít
autentizovanou relaci bez zadání hesla [UC0014].

---

## Spouštěč

UC0014 – Authenticate & Manage Access — konkrétně větev vytvoření magic-linku na vyžádání
(větev magic-linku v rámci UC0014.1; požadavek na vytvoření magic-linku pro existující účet User).
Jedná se o akci **iniciovanou uživatelem**, nikoli vyvolanou přechodem stavu žádosti/příběhu/leadu —
nemá odpovídající řádek ve stavově řízené matici notifikací, na rozdíl od většiny ostatních dokumentů
MSG v této vrstvě.

Odlišné od aktivace účtu u nově vytvořeného účtu (samostatný koncept zprávy, kterým se tento dokument
nezabývá): MSG0004 se týká opakovaného přihlášení k **existujícímu** User (EN0008), nikoli prvotní
aktivace nového účtu.

---

## Příjemci

- Žadatel o přihlášení — osoba identifikovaná účtem User (EN0008), pro který byl magic-link vyžádán.
  Příjemcem může být jakákoli role v zóně, která drží účet User (žadatel/patron, fundraiser,
  podporovatel, administrátor atd. dle EN0008); zpráva není vázaná na konkrétní roli.
- Kanál: pouze e-mail, odesílaný prostřednictvím transakční komunikační kapacity platformy přes
  Mautic (ES0006). Pro tuto zprávu není doložen žádný protějšek v podobě notifikace v zóně — nelze ji
  doručit v rámci aplikace, protože příjemce z definice ještě není autentizovaný.
- Kromě obecného řešení šablon podle jednotlivých zemí, které se uplatňuje u všech transakčních zpráv,
  není doložena žádná obsahová odlišnost pro CZ/RO/MD [ES0006; FN0019].

---

## Obsah zprávy

Konceptuální informační prvky, které zpráva musí obsahovat:

- Jednorázový přihlašovací odkaz, který po otevření přímo autentizuje žadatele o přihlášení do jeho
  zóny (bez nutnosti zadat heslo).
- Informaci o tom, že odkaz je časově omezený a po uplynutí doby platnosti přestane fungovat, aby
  příjemce věděl, že si v případě expirace má vyžádat nový.
- Dostatek kontextu, aby příjemce rozpoznal, že jde o přihlašovací odkaz, který si on (nebo někdo
  používající jeho e-mailovou adresu) vyžádal, a odlišil ho od zprávy o resetu hesla nebo aktivaci
  účtu.

Žádná šablonová značka, znění předmětu ani styling zde nejsou specifikovány — jde o záležitosti
doručování/šablon, které patří pod odchozí přenosovou vrstvu, nikoli pod tento kontrakt [ES0006].

---

## Nejistota / poznámky

- Není zastoupena jako řádek ve vstupní matici notifikací (`test-scenarios.md`), která je stavově
  řízená; tato zpráva je spouštěna přímo API voláním souvisejícím s přihlášením, nikoli změnou stavu
  žádosti/příběhu/leadu. Její existence a podoba se opírají místo toho o UC0014 a podkladovou evidenci
  toku (FLW0014), která je `Confirmed`.
- Evidenční stopa pro *samotné vytvoření* magic-linku je `Partial`: dokumentace toku zaznamenává
  latentní defekt v související větvi přihlášení založené na hashi a nekonzistentní vynucování
  flood-control ochrany napříč verzemi endpointu, avšak krok odeslání zprávy pro vytvoření
  magic-linku (odchozí e-mail přes transakční komunikační kapacitu) je sám o sobě potvrzený a tímto
  defektem není dotčen.
- Záměrně ponecháno obecnější: evidence nezakládá žádnou roli-specifickou ani zemi-specifickou
  obsahovou variantu této zprávy nad rámec obecného řešení šablon podle jednotlivých zemí, společného
  všem transakčním zprávám [FN0019]; žádná taková varianta zde není tvrzena.
