---
doc_id: ES0013
title: Microsoft Graph / OneDrive
canonical_layer: ES
spec_type: external-system
status: canonical
modules: []
references:
  - ARCH0001
  - ARCH0002
  - FN0017
  - UC0019
---

# ES0013 – Microsoft Graph / OneDrive

## Účel

Microsoft Graph / OneDrive poskytuje sdílenou cloudovou složku, ze které Patronus importuje fakturační
dokumenty a přikládá je k žádostem kampaně, ke kterým patří. Jde o protějšek úložiště faktur k hranici
dokumentů/plnění integrační krajiny (ARCH0001 §5 řádek 13).

---

## Přehled systému

Microsoft Graph / OneDrive je cloudová služba pro ukládání souborů od Microsoftu a API rozhraní použité
pro přístup k souborům uloženým ve sdíleném disku OneDrive/SharePoint. Pro tuto integraci slouží čistě
jako externí úložiště dokumentů: platforma čte soubory, které do sdílené složky umístil proces na
straně klienta, ale nespravuje ani needituje je tam.

---

## Integrační model

Příchozí (pull), spouštěné z CLI — není součástí běžného request/response toku ani toku událostí
platformy:

- import spuštěný z konzole se autentizuje vůči Microsoft Graph a stahuje soubory faktur ze sdílené
  složky OneDrive, poté každý stažený soubor přiloží k žádosti, které patří (UC0019);
- je podporován režim pouze pro výpis (dry-run), který vyjmenuje dostupné soubory bez jejich stažení
  nebo přiložení.

To odpovídá řetězci (b) v ARCH0002, tedy CLI řetězci importu faktur ze zdroje OneDrive přes hranici
platformy směřující k OneDrive až do žádosti, ke které je soubor přiložen.

---

## Výměna dat

- Příchozí: soubory fakturačních dokumentů, jejichž názvy souborů naznačují cílovou kampaň, jsou
  stahovány a přikládány jako dokumenty k odpovídající žádosti (pouze koncepčně — samotný vztah
  žádost/kampaň vlastní EN0001/EN0004 a zde není znovu popisován).
- Na této vrstvě není definována žádná smlouva o payloadu na úrovni výpisu/polí; režim dry-run
  vyměňuje stejný výpis souborů bez přenosu obsahu souboru.

---

## Omezení

- Pouze current-state; níže uvedená omezení popisují systém tak, jak je implementován, nikoli cílový
  návrh.
- Autentizace používá grant typu resource-owner-password-credential (ROPC) s přihlašovacími údaji
  uloženými v čitelném textu ve zdrojovém kódu, což představuje vendor/auth lock-in spíše než
  delegovaný nebo pouze aplikační grant (ARCH0001 §5 řádek 13; poznámky ARCH0001 „CLI / konzolové
  příkazy" / „Tajemství (Secrets)").
- Import nemá žádnou deduplikaci: opakované spuštění nad stejnou složkou přidá duplicitní přílohy ke
  stejné žádosti namísto rozpoznání již importovaných faktur.
- Kampaň, která nemá vlastnící žádost, není během importu nijak ošetřena — párování kampaně podle
  názvu souboru může proběhnout i bez platného cíle pro přiložení.
- Obsah staženého souboru není po přiložení uklizen, takže zůstávají zbytkové lokální kopie.
- Selhání importu ponechá faktury nepřiložené k jejich žádosti namísto opakování nebo zařazení do
  fronty (ARCH0001 §5 řádek 13; FLW0028).
