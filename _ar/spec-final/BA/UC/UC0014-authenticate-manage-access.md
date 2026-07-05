---
doc_id: UC0014
title: Authenticate & Manage Access
layer: UC
spec_type: use-case
status: imported
modules: []
---

# UC0014 — Autentizace a správa přístupu

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0014 |
| Název | Autentizace a správa přístupu |
| Bounded Context | C9 |
| Primární aktér(y) | Customer, Admin, System |
| Typ spuštění | API/UI |

## Aktéři a odpovědnosti

- **Customer** — žadatel, patron, fundraiser nebo podporovatel, který se autentizuje vůči platformě (heslo nebo magic-link) a/nebo si sám zaregistruje účet User (EN0008).
- **Admin** — pracovník back-office, který vytvoří účet User jménem osoby již zachycené na žádosti (EN0001) a přiřadí jí odpovídající roli.
- **System** — vynucuje kontrolu přihlašovacích údajů, vydávání session/tokenů, ochranu proti záplavovým útokům (flood control), vytváření záznamů účtu a propojení nového uživatele User s jeho kontaktem Contact (EN0006).

## Záměr

Poskytnout osobě identifikované v doméně (žadatel, patron, fundraiser, podporovatel nebo dítě jako závislá osoba) trvalou, autentizovanou identitu v platformě — buď ověřením existujících přihlašovacích údajů za účelem otevření session, samoregistrací nového uživatele User, nebo vytvořením uživatele adminem na základě již podané žádosti — aby bylo možné následné akce této identitě přiřadit a autorizovat je vůči ní.

## Předpoklady

- Pro přihlášení: účet User (EN0008) již existuje a není zablokovaný.
- Pro samoregistraci: volající poskytne minimálně e-mailovou adresu; kontakt Contact (EN0006) může být volitelně dodán, nebo je vytvořen nově.
- Pro vytvoření ze žádosti: žádost Application (EN0001) a její přidružený profil žádosti (Application Profile) již existují a obsahují osobní údaje potřebné k založení kontaktu Contact a/nebo uživatele User; jednající Admin má oprávnění přidávat leady.

## Hlavní tok

### UC0014.1 — API přihlášení (heslo nebo magic-link)
1. Customer: odešle e-mail a heslo (nebo token magic-link) na přihlašovací endpoint.
2. System: ověří, že jsou přítomna pole s přihlašovacími údaji; pokud chybí, požadavek zamítne.
3. System: zkontroluje, že účet User není zablokovaný; pokud je, požadavek zamítne.
4. System: před přijetím přihlašovacího údaje uplatní ochranu proti záplavovým útokům při přihlašování (flood control) — limity pokusů na IP adresu a na uživatele.
5. System: ověří odeslané heslo proti uloženému přihlašovacímu údaji uživatele User (nebo v případě tokenu magic-link dekóduje a ověří token a jeho platnost/expiraci).
6. System: po úspěšném ověření založí pro uživatele User autentizovanou session a vydá zákazníkovi session token a přístupový token (typu CSRF).
7. System: zaznamená časové značky posledního přihlášení a posledního přístupu uživatele User.

### UC0014.2 — API samoregistrace
1. Customer: odešle registrační údaje (minimálně e-mail; volitelně jméno, telefon a roli) na registrační endpoint.
2. System: vytvoří nový záznam User (EN0008) s dodaným e-mailem jako identifikátorem účtu i kontaktní adresou, ve stavu aktivní, bez hesla.
3. System: přiřadí novému uživateli User požadovanou roli/role (např. supporter, patron, fundraiser).
4. System: vytvoří propojený kontakt Contact (EN0006) pro nového uživatele User, pokud nebyl již dodán, se jménem, telefonem a e-mailem dané osoby.
5. System: propojí nového uživatele User s jeho záznamem Contact.
6. System: informuje navazující procesy vyhledávacího indexu a synchronizace s CRM o existenci nového uživatele User (asynchronně, mimo tento use case).
7. System: ponechá aktivaci/nastavení hesla na samostatném kroku aktivace vyvolaném volajícím (vydání magic-linku), který není samoregistrací automaticky spuštěn.

### UC0014.3 — Vytvoření uživatele User ze schválené žádosti (sdíleno s UC0001)
1. Admin: otevře akci „vytvořit uživatele" na žádosti Application (EN0001) a určí cílovou roli (fundraiser, patron nebo dítě) a zdrojový profil žádosti (Application Profile).
2. System: potvrdí, že žádost Application, profil žádosti Application Profile i požadovaná role jsou přítomny a platné; jinak je akce přerušena beze změn.
3. System: zkontroluje, zda pro danou osobu již existuje uživatel User nebo kontakt Contact (podle e-mailu u fundraisera/patrona, podle národního identifikátoru u dítěte).
4. System: vytvoří nový kontakt Contact (EN0006) z osobních údajů profilu žádosti Application Profile, pokud neexistuje odpovídající kontakt/uživatel (fundraiser, patron: osobní kontakt se jménem, telefonem, adresou; dítě: osobní kontakt se jménem a národním identifikátorem).
5. System: vytvoří nového uživatele User (EN0008) propojeného s kontaktem Contact, s požadovanou rolí, v případě fundraisera nebo patrona; dítě je reprezentováno pouze kontaktem Contact, bez vytvoření uživatele User.
6. System: nově vytvořený uživatel User zůstává ve stavu zablokovaný, bez hesla; aktivace je samostatný, navazující krok, který tento tok neprovádí.
7. System: propojí vytvořeného uživatele User (fundraiser/patron) nebo kontakt Contact (dítě) zpět na žádost Application v odpovídajícím poli role.
8. System: informuje navazující procesy vyhledávacího indexu a synchronizace s CRM o existenci nového uživatele User a/nebo změny žádosti Application (asynchronně, mimo tento use case).

## Alternativní toky

### AF1 — Přihlášení zamítnuto: neplatné nebo chybějící přihlašovací údaje
1. Customer: odešle přihlašovací požadavek s chybějícími nebo nesprávnými přihlašovacími údaji.
2. System: zamítne požadavek s chybou autentizace a session se nezaloží.

Výsledek: session se nevytvoří; Customer zůstává neautentizován.

### AF2 — Přihlášení zamítnuto: zablokovaný účet
1. Customer: odešle na první pohled platné přihlašovací údaje pro účet, který je administrativně zablokovaný.
2. System: zamítne požadavek s chybou „účet není aktivní".

Výsledek: pro zablokovaný účet se session nevytvoří.

### AF3 — Přihlášení zpomaleno ochranou proti záplavovým útokům (flood control)
1. Customer: opakovaně odesílá neúspěšné pokusy o přihlášení ze stejné IP adresy nebo proti stejnému účtu.
2. System: po dosažení nastaveného prahu počtu pokusů zamítá další pokusy o přihlášení s chybou flood control, dokud neuplyne okno omezení.

Výsledek: další pokusy o přihlášení jsou po dobu ochlazovacího období blokovány. (Evidence uvádí, že toto vynucení je napříč verzemi endpointů nekonzistentní — viz Evidence Level.)

### AF4 — Přihlášení přes magic-link vypršelo nebo je neplatné
1. Customer: otevře magic-link obsahující expirovaný nebo poškozený token.
2. System: zamítne token jako expirovaný/neplatný a session se nezaloží.

Výsledek: session se nevytvoří; Customer si musí vyžádat nový magic-link nebo použít přihlášení heslem.

### AF5 — Registrační data neprojdou validací
1. Customer: odešle registrační data, která kolidují s existujícím účtem (duplicitní e-mail) nebo neprojdou validačními pravidly účtu.
2. System: přeruší registraci bez vytvoření uživatele User nebo kontaktu Contact a volajícímu není vrácen žádný účet.

Výsledek: nový uživatel User/kontakt Contact se nevytvoří; volající musí konflikt vyřešit (např. použít přihlášení nebo obnovu hesla).

### AF6 — Vytvoření uživatele ze žádosti přerušeno kvůli chybějícím předpokladům
1. Admin: spustí akci vytvoření uživatele bez platné žádosti Application, profilu žádosti Application Profile nebo výběru role.
2. System: akci přeruší beze změn uživatele User, kontaktu Contact nebo žádosti Application.

Výsledek: žádost Application zůstává beze změny; Admin musí dodat platné předpoklady a akci opakovat.

### AF7 — Vytvoření uživatele ze žádosti částečně selže po vytvoření kontaktu
1. Admin: spustí akci vytvoření uživatele pro fundraisera nebo patrona, jehož data neprojdou validací uživatele User nebo při vytváření dojde k chybě.
2. System: kontakt Contact vytvořený dříve v rámci téhož toku se nevrací zpět (rollback), ale uživatel User se nevytvoří a žádost Application se novou referencí neaktualizuje.

Výsledek: může zůstat osiřelý kontakt Contact bez propojeného uživatele User a bez reference na žádost Application — označeno jako riziko integrity dat v současném stavu, nikoli jako zamýšlený výsledek.

## Postconditions

- Po úspěšném přihlášení: pro uživatele User zákazníka existuje autentizovaná session; časové značky posledního přihlášení/přístupu jsou aktualizovány.
- Po úspěšné samoregistraci: existuje nový uživatel User propojený s kontaktem Contact, ve stavu aktivní, ale bez hesla, čekající na samostatný krok aktivace.
- Po úspěšném vytvoření ze žádosti: existuje nový (nebo znovupoužitý) uživatel User pro fundraisera/patrona ve stavu zablokovaný, bez hesla, propojený s kontaktem Contact; nebo existuje záznam pouze s kontaktem Contact pro dítě; žádost Application nese odpovídající referenci na fundraisera/patrona/dítě.
- Při jakékoli zamítnuté/přerušené cestě: nevytváří se žádná session a neukládá se žádná nová reference na uživatele User/kontakt Contact/žádost Application (s výjimkou potvrzeného rizika částečného zápisu v AF7).

## Traceability

Cílové SRV:
- Identity-&-Access

Entity EN:
- EN0008 User — autentizovaná/vytvářená identita, která je středem každého dílčího toku.
- EN0006 Contact — propojený záznam strany vytvořený spolu s novým uživatelem User (nebo samostatně pro dítě).
- EN0007 Account — záznam patrona/fundraisera v rozsahu vlastníka (owner-scoped) přidružený k uživateli User; uveden pro úplnost, ačkoli jeho chování v podobě ML doporučení je nečinné a tímto use case se neuplatňuje.

Integrační hranice:
- Žádné synchronní v rámci tohoto use case. Asynchronní navazující notifikace pro procesy vyhledávacího indexu a synchronizace s CRM probíhají po uložení uživatele User/žádosti Application v UC0014.2 a UC0014.3, ale jsou mimo hranice tohoto use case. Odesílání transakčního e-mailu (magic-link) existuje na navazující cestě odkazované z FLW0014/FLW0015, ale samo o sobě není součástí zde modelovaných kroků přihlášení/registrace.

Evidence toku (Flow Evidence):
- FLW0014 (API přihlášení — větve heslo a magic-link)
- FLW0015 (API registrace — registrační engine; samotný verzovaný veřejný registrační endpoint je dle evidence nefunkční stub, takže chování je odvozeno z podkladového registračního enginu, který obaluje)
- FLW0026 (Vytvoření uživatele ze žádosti — sdíleno s UC0001)

## Evidence Level

Confirmed — podloženo SRV0015/Identity-&-Access (UC-srv-traceability.md řádek 21/71), životními cykly entit EN0008/EN0006/EN0007 a dokumentací toků FLW0014, FLW0015 a FLW0026, které jsou ve svých vlastních hlavičkách hodnoceny jako Confirmed nebo Partial s explicitními výhradami; verzově specifické nedostatky flood control a magic-link hashe jsou promítnuty do AF3/AF4, nikoli zamlčeny.
