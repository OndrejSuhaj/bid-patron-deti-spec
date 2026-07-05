---
doc_id: FN0014
title: Party & Contact Management + Deduplication / Merge
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0016
  - EN0006
  - EN0018
  - EN0001
  - EN0008
  - EN0002
---

# FN0014 – Správa subjektů a kontaktů + deduplikace / sloučení

## Účel

Udržuje univerzální registry subjektů platformy — přetíženou datovou tabulku kontaktů (Contact), která
reprezentuje každý druh osoby nebo instituce v doméně (dítě, fundraiser, patron, škola, zaměstnavatel,
lead), a registr organizací/zaměstnavatelů (Organisation) — a umožňuje administrátorovi sloučit
duplicitní záznamy (kontakt, organizace nebo lead) do jednoho kanonického přežívajícího záznamu, aby
navazující procesy (žádosti, scoring, notifikace, vyhledávání) pracovaly s jediným subjektem místo s
roztříštěnou množinou.

---

## Odpovědnosti

Kapabilita odpovídá za:

- Detekci skupin duplicitních kontaktů podle shodného rodného čísla / cnp, telefonu nebo e-mailu,
  tranzitivní rozšíření kandidátní skupiny o jakékoli další překryvy a umožnění administrátorovi
  sloučit skupinu do zvoleného přežívajícího kontaktu — přeřazením každého závislého odkazu z Application
  a role v ApplicationProfile (kontakt leadu, dítě, fundraiser, patron, škola) na přežívající záznam a
  následným smazáním prohrávajících záznamů kontaktu (včetně jejich historie změn) a uživatelského účtu,
  který každý z nich vlastnil.
- Umožnění administrátorovi vyloučit konkrétní duplicitní kritérium z budoucí detekce, aniž by se
  jakkoli měnil samotný záznam kontaktu.
- Detekci a slučování duplicitních záznamů organizací do zvoleného přežívajícího záznamu, přeřazení
  odkazu na zaměstnavatele u každé dotčené žádosti na přežívající záznam a odstranění duplicitních
  záznamů organizace.
- Správu pracovníků organizace: validaci zadaných údajů o pracovníkovi, propojení nebo vytvoření
  uživatelského účtu pracovníka s rolí pracovníka organizace a administrativním příznakem, jeho připojení
  do seznamu pracovníků organizace a spuštění zprávy pro aktivaci účtu u nově vytvořeného, dosud
  neaktivního pracovníka.
- Párování duplicitního leadu pocházejícího od patrona na přežívající hlavní žádost zkopírováním odkazu
  na ApplicationProfile duplicitního leadu (a propojeného odkazu na patrona, pokud existuje) na
  přežívající záznam, s následným degradováním duplicitního leadu do stavu „duplikát“ a vyčištěním jeho
  odkazů na subjekty.
- Zařazení každé žádosti nebo organizace dotčené přeřazením do fronty pro reindexaci vyhledávání jako
  vedlejší efekt uložení.

---

## Související případy užití

- UC0016 – Údržba záznamů subjektů (deduplikace / sloučení)

---

## Související entity

- EN0006 – Contact
- EN0018 – Organisation
- EN0001 – Application
- EN0008 – User
- EN0002 – ApplicationProfile

---

## Integrace

Tato kapabilita sama o sobě neprovádí žádnou přímou integraci s externím systémem. Přeřazené záznamy
Application a Organisation jsou zařazovány do fronty vedlejšího efektu reindexace vyhledávání platformy
a registr organizací je navíc pravidelně na základě rozvrhu synchronizován do externího vyhledávacího
indexu — viz ARCH0002_ContextInteractionMap pro integrační krajinu platformy; mechanismus
zařazování/indexace sám o sobě není vlastněn touto kapabilitou.

---

## Omezení

- Operace slučování jsou destruktivní a nenabízí žádný zkušební (dry-run) režim: deduplikace kontaktů
  trvale smaže prohrávající kontakt spolu s uživatelským účtem, který jej vlastnil (smazání relevantní
  z hlediska GDPR, ke kterému dochází jako vedlejší efekt sloučení, nikoli jako vyhrazený proces
  výmazu).
- Párování leadu bezpodmínečně přepíše existující odkaz na ApplicationProfile u přežívající žádosti,
  pokud už je nějaký přítomen; předchozí odkaz se stane nedostupným — ztrátové i na úspěšné cestě,
  nezávisle na jakémkoli selhání.
- Sloučení organizací přeřazuje pouze odkaz na zaměstnavatele držený žádostmi; ostatní odkazy na
  duplicitní organizaci (například odkazy na pracovníky) přeřazeny nejsou a po smazání duplicity
  zůstávají osiřelé (dangling).
- Žádný ze tří dílčích toků sloučení (kontakt, organizace, lead) není transakční: selhání uprostřed
  sloučení může ponechat některé závislé odkazy směřující na přežívající záznam a jiné stále směřující
  na odstraněný nebo degradovaný záznam, bez rollbacku již dokončených kroků.
- Seznamy subjektů použité pro výběr kandidátů na sloučení organizací jsou sestavovány z nevázaných,
  řetězcově skládaných dotazů, které přímo vkládají identifikátory dodané v požadavku do aktualizace
  přeřazení — expozice vůči SQL injection chráněná pouze běžným oprávněním pro úpravu obrazovky
  sloučení, nikoli dalším zpevněním vstupu.
- Všechny tři akce sloučení a správa pracovníků jsou chráněny výhradně běžnými oprávněními pro úpravu
  záznamu; žádný potvrzovací krok nad rámec jediného potvrzení sloučení/párování nechrání destruktivní
  výsledek.
