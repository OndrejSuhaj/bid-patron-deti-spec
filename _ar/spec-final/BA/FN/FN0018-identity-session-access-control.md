---
doc_id: FN0018
title: Identity, Session & Access Control
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0014
  - UC0001
  - UC0005
  - UC0006
  - UC0016
  - EN0008
  - EN0006
  - EN0007
---

# FN0018 – Identita, relace a řízení přístupu

## Účel

Poskytnout osobě identifikované v doméně trvalou, autentizovanou identitu: ověřit přihlašovací údaje
(heslo nebo magic-link) a otevřít relaci, provést self-registraci uživatele (EN0008), vytvořit
uživatele z již podané žádosti (EN0001) a udržovat model rolí, který autorizuje následné akce. Jde o
kanonickou schopnost identity/relace, na kterou se napříč specifikací odkazuje všude tam, kde je
aktér autentizován, registrován nebo je mu přidělena role.

## Odpovědnosti

- Autentizovat uživatele (EN0008) pomocí hesla nebo magic-link tokenu, s uplatněním flood control a
  kontroly zablokovaného účtu, a při úspěchu vydat token relace spolu s CSRF-podobným přístupovým
  tokenem.
- Provést self-registraci nového uživatele — aktivního, bez hesla — s požadovanou rolí/rolemi a
  napojeným kontaktem (EN0006), přičemž nastavení hesla/aktivaci ponechává na samostatném kroku
  vyvolaném volajícím.
- Vytvořit uživatele a/nebo kontakt ze schválené žádosti (EN0001): dodavatel nebo patron se stává
  zablokovaným uživatelem bez hesla napojeným na kontakt; dítě je reprezentováno pouze jako kontakt,
  bez vytvoření uživatele.
- Spravovat model rolí (dodavatel, patron, podporovatel, koordinátor, účetní, pracovník organizace a
  další back-office role), který řídí, kdo smí jednat, včetně přidělení role podporovatele při prvním
  dosažení stavu PAID u transakce (FN0007).
- Napojit každého nového uživatele na jeho kontaktní záznam a informovat navazující procesy
  vyhledávacího indexu a CRM synchronizace vždy, když je vytvořena nebo změněna strana (party).
- Vytvořit nebo aktualizovat uživatele typu pracovník organizace napojeného na kontakt při údržbě
  seznamu pracovníků organizace (UC0016), včetně odeslání zprávy pro aktivaci účtu u nově vytvořeného,
  dosud neaktivního pracovníka.
- Přeřadit nebo odstranit záznamy identity uživatel/kontakt jako důsledek deduplikace stran (UC0016):
  přesměrovat referenci strany na úrovni žádosti na přežívající kontakt a odstranit uživatele, který
  vlastnil zanikající duplicitní kontakt.

## Související případy užití

UC0014 (Autentizace a správa přístupu — vlastní přihlášení, self-registraci a administrátorem
vyvolané vytvoření z žádosti), UC0001 (Podání žádosti — self-registrace a opětovné využití existujícího
uživatele při příjmu leadu sdílí tuto schopnost), UC0005 (Provedení daru — dohledává/vytváří/povyšuje
roli uživatele dárce), UC0006 (Potvrzení platby — přiděluje roli podporovatele při prvním dosažení
PAID), UC0016 (Správa záznamů stran — vytváření pracovníka organizace a přeřazení/odstranění identity
při sloučení).

## Související entity

EN0008 Uživatel (autentizovaná/vytvořená/roli nesoucí identita ve středu této schopnosti), EN0006
Kontakt (napojený záznam strany vytvořený spolu s novým nebo vytvořeným uživatelem), EN0007 Účet
(vlastníkem vymezený záznam patrona/dodavatele napojený na uživatele; uveden pro úplnost, ačkoli jeho
chování týkající se doporučení je neaktivní a mimo aktivní rozsah této schopnosti).

## Integrace

Žádné přímo na cestě autentizace/registrace/vytváření samotné. Odesílání e-mailu s magic-linkem je
přilehlá cesta zajišťovaná schopností transakčního zasílání zpráv (FN0019). Navazující notifikace
vyhledávacího indexu a CRM synchronizace vyvolaná při vytvoření/změně strany je rovněž předávána
asynchronně mimo hranici této schopnosti. Viz ARCH0002 pro konsolidovaný přehled integrací.

## Omezení

- Zápisová cesta historie přihlášení je zcela vypnutá (hook pro zápis je zakomentovaný), takže se
  neukládá žádný záznam o pokusu o přihlášení — mezera v auditovatelnosti současného stavu.
- Vynucování flood control je napříč verzemi přihlašovacího endpointu nekonzistentní: u dvou ze tří
  verzí je výsledek flood-check sice vypočten, ale jeho návratová hodnota je ignorována, takže limity
  pro pokusy hrubou silou nejsou u těchto endpointů skutečně vynucovány; pouze nejnovější verze jej
  respektuje.
- Větev přihlášení založená na hashi v nejnovější verzi endpointu volá metodu account-service, která
  v kódové základně neexistuje, což tuto větev činí nefunkční (skrytá fatální chyba), nikoli pouze
  neaktivní.
- Tokeny magic-linku mají pevné okno platnosti 90 dní.
- Veřejný endpoint self-registrace je nefunkční stub, který vždy hlásí úspěch, aniž by cokoli
  vytvořil; skutečné chování registrace zajišťuje sdílený registrační engine volaný jinými toky
  (UI self-registrace, dar, příjem žádosti), nikoli tento endpoint.
- Administrátorem vyvolané vytvoření uživatele ze žádosti je spouštěno požadavkem ve stylu čtení,
  který ale mění stav, bez CSRF ochrany nad rámec kontroly oprávnění — bezpečnostní slabina
  současného stavu.
- Částečné selhání po vytvoření kontaktu během administrátorem vyvolaného vytváření uživatele může
  zanechat osiřelý kontakt bez napojeného uživatele a bez reference na žádost — zaznamenané riziko
  integrity dat, nikoli zamýšlené chování.
- Nově vytvoření uživatelé (ať už self-registrovaní, nebo vytvoření ze žádosti) zůstávají bez hesla;
  aktivace/nastavení hesla je vždy samostatný, následný krok, nikdy automatický.
