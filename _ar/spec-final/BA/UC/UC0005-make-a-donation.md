---
doc_id: UC0005
title: Make a Donation
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0005 — Vytvoření daru

## Header

| Field | Value |
|---|---|
| UC ID | UC0005 |
| Name | Make a Donation |
| Bounded Context | C4 |
| Primary Actor(s) | Customer, Integration(PaymentGateway) |
| Trigger Type | API |

## Actors & Responsibilities

- **Customer** — iniciuje jednorázový nebo trvalý dar (EN0009) k příběhu (EN0004); může být anonymní (identifikovaný pouze e-mailem) nebo již přihlášeným dárcem.
- **System** — validuje požadavek na dar, dohledá nebo založí identitu dárce, vytvoří transakci (EN0009) a u trvalých darů také plán trvalé transakce (EN0010); zvolí platební bránu podle země a vrátí zákazníkovi cíl přesměrování.
- **Integration(PaymentGateway)** — platební brána specifická pro danou zemi (ComGate pro CZ, Netopia/MobilPay pro RO, MAIB pro MD), která přijme požadavek na transakci a vygeneruje stránku/URL, na kterou je zákazník přesměrován k provedení platby.

## Intent

Umožnit zákazníkovi přispět peněžní částkou na příběh (EN0004), a to buď jednorázovým darem, nebo trvalým měsíčním darem, a předat platbu příslušné platební bráně dané země k provedení. Skutečné potvrzení platby (zaúčtování prostředků, změna stavu na PAID) řeší samostatný use case zpracování callbacku od platební brány (UC0006).

## Preconditions

- Existuje cílový příběh (EN0004), který ještě není plně financován (vybraná částka nedosáhla cílové částky).
- Částka daru je platná číselná hodnota.
- Je nakonfigurována provozní země (CZ / RO / MD), která určuje, která platební brána se použije.

## Main Flow

### UC0005.1 — Odeslání daru a dohledání identity dárce

1. Customer: odešle požadavek na dar k příběhu (EN0004), přičemž uvede částku a — pokud ještě není přihlášen — e-mailovou adresu a jméno; volitelně označí dar jako trvalý.
2. System: ověří, že částka daru je číselná hodnota; pokud tomu tak není, požadavek zamítne.
3. System: načte cílový příběh (EN0004) a zamítne požadavek, pokud příběh neexistuje nebo je již plně financován.
4. System: dohledá identitu dárce — pokud je zákazník již přihlášen, jako dárce se použije existující uživatel (EN0008).
5. System: pokud zákazník není přihlášen, ověří zadanou e-mailovou adresu a vyhledá existujícího uživatele (EN0008) podle e-mailu.
6. System: pokud není nalezen odpovídající uživatel (EN0008), zaregistruje nového uživatele (EN0008) s rolí podporovatele spolu s propojeným záznamem kontaktu (EN0006) pro dárce.
7. System: pokud je nalezen odpovídající uživatel (EN0008), který ale ještě nemá roli podporovatele, přidělí tomuto uživateli roli podporovatele.
8. System: pokud je účet dohledaného uživatele-dárce (EN0008) v danou chvíli blokovaný, odešle dárci zprávu k aktivaci účtu.
9. System: normalizuje částku daru na celočíselnou hodnotu; pro český trh navýší částky pod minimální jednotkou na toto minimum.
10. System: vytvoří transakci (EN0009) propojenou s uživatelem-dárcem (EN0008) a cílovým příběhem (EN0004), ve stavu PENDING, přičemž zaznamená, zda byl dárce autentizovaný, a označí transakci jako testovací, pokud probíhá mimo produkční prostředí.

### UC0005.2 — Nastavení plánu trvalého daru (volitelné)

1. System: pokud zákazník požadoval trvalý dar, vytvoří trvalou transakci (EN0010) propojenou s nově vytvořenou transakcí (EN0009), v neaktivním stavu, s měsíční periodou platby a dnem platby odvozeným od dnešního data (omezeným tak, aby vždy spadal do rozsahu daného měsíce).
2. System: pokud se vytvoření trvalé transakce (EN0010) nezdaří, zaloguje selhání a pokračuje bez nastavení trvalého daru; záměr zřídit trvalý dar je pro tento dar ztracen.

### UC0005.3 — Předání platební bráně dané země

1. System: zvolí platební bránu podle nakonfigurované provozní země — Integration(MAIB) pro Moldavsko, Integration(Netopia) pro Rumunsko, jinak Integration(ComGate) pro Česko.
2a. Integration(MAIB): pro Moldavsko přijme detaily transakce (částka, měna, odkaz na příběh) a připraví platební stránku nebo cíl přesměrování pro zákazníka.
2b. Integration(Netopia): pro Rumunsko přijme detaily transakce (částka, měna, odkaz na příběh) a připraví platební stránku nebo cíl přesměrování pro zákazníka.
2c. Integration(ComGate): jinak, pro Česko, přijme detaily transakce (částka, měna, odkaz na příběh) a připraví platební stránku nebo cíl přesměrování pro zákazníka.
3. System: vrátí zákazníkovi úspěšnou odpověď obsahující cíl přesměrování na platební bránu.
4. Customer: je přesměrován na zvolenou platební bránu k dokončení platby (pokračování v UC0006).

## Alternative Flows

### AF1 — Neplatná částka daru

1. Customer: odešle požadavek na dar s nečíselnou částkou.
2. System: zamítne požadavek bez vytvoření transakce (EN0009).

Outcome: Nedojde k vytvoření transakce (EN0009); zákazník musí požadavek odeslat znovu s platnou částkou.

### AF2 — Příběh neexistuje nebo je již plně financován

1. Customer: odešle požadavek na dar k příběhu (EN0004), který neexistuje, nebo jehož vybraná částka již dosáhla cílové částky.
2. System: zamítne požadavek bez vytvoření transakce (EN0009).

Outcome: Nedojde k vytvoření transakce (EN0009).

### AF3 — Účet dárce je v okamžiku daru blokovaný

1. System: dohledá identitu dárce jako uživatele (EN0008), jehož účet je blokovaný.
2. System: odešle dárci zprávu k aktivaci účtu.
3. System: pokračuje ve vytvoření transakce (EN0009) stejně jako v UC0005.1, bez ohledu na blokovaný účet.

Outcome: Transakce (EN0009) je vytvořena; dárce samostatně obdrží aktivační zprávu pro obnovení plného přístupu k účtu.

### AF4 — Vytvoření plánu trvalého daru se nezdaří

1. System: pokusí se vytvořit trvalou transakci (EN0010) stejně jako v UC0005.2 a vytvoření se nezdaří.
2. System: zaloguje selhání.

Outcome: Transakce daru (EN0009) přesto pokračuje k platební bráně; pro ni neexistuje žádný plán trvalého daru.

## Postconditions

- Existuje transakce (EN0009) ve stavu PENDING, propojená s uživatelem-dárcem (EN0008) a cílovým příběhem (EN0004); peníze zatím nebyly zaúčtovány.
- Pokud byl dar trvalý a vytvoření plánu bylo úspěšné, existuje trvalá transakce (EN0010), neaktivní, propojená s transakcí (EN0009).
- Pro prvodárce-anonymní uživatele nyní existuje nový uživatel (EN0008) s rolí podporovatele a propojený kontakt (EN0006).
- Zákazník má k dispozici cíl přesměrování na zvolenou platební bránu (Integration(PaymentGateway)) k dokončení platby; závěrečné potvrzení a změna stavu na PAID je řešena v UC0006.

## Traceability

Target SRVs:
- Payment-Processing
- ComGate-Adapter
- Netopia-Adapter
- MAIB-Adapter
- Identity-&-Access
- Campaign-&-Story-Lifecycle

EN entities:
- EN0009 Transaction — platební záznam daru vytvořený ve stavu PENDING
- EN0010 RecurringTransaction — plán trvalého daru, vytvořený neaktivní společně s transakcí
- EN0004 Campaign — cíl daru; čte se pro ověření stavu financování
- EN0006 Contact — vytvořen společně s novým uživatelem-dárcem u prvodárců-anonymních uživatelů
- EN0008 User — identita dárce; dohledávaná, vytvářená nebo povyšovaná rolí v průběhu daru

Integration boundaries:
- Integration(ComGate) — česká platební brána
- Integration(Netopia) — rumunská platební brána
- Integration(MAIB) — moldavská platební brána

Flow Evidence:
- FLW0006 (Create transaction / donate)

## Evidence Level

Confirmed — podloženo FLW0006 (jistota Confirmed) pro chování při vytváření daru a předávání platební bráně, a EN0009/EN0010/EN0004/EN0006/EN0008 pro pole entit a stavy životního cyklu; průběhy selhání vytvoření plánu trvalého daru a blokovaného účtu jsou Confirmed jako potlačené/logované chování podle stejného podkladu, nikoli hypoteticky odvozené.
</content>
