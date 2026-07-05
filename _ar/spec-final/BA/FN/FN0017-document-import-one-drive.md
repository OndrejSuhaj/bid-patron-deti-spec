---
doc_id: FN0017
title: Document Import (OneDrive)
layer: FN
spec_type: functional-capability
status: imported
modules: []
references:
  - UC0019
  - EN0001
  - EN0004
---

# FN0017 – Import dokumentů (OneDrive)

## Účel

Automaticky stahovat nově vložené faktury ze sdílené složky OneDrive (přes Microsoft Graph) a
přiřazovat jednotlivé faktury ke správné žádosti (Application) prostřednictvím reference na kampaň
(Campaign) zakódované v názvu souboru, aby back-office pracovníci nemuseli faktury stahovat a
nahrávat ručně.

## Odpovědnosti

- Autentizace vůči Microsoft Graph jménem nakonfigurovaného servisního účtu a výpis položek ve
  nakonfigurované sdílené složce s fakturami, a to až do nakonfigurovaného limitu počtu položek.
- Filtrování vypsaných položek na fakturové (PDF) soubory, odvození reference na kampaň z názvu
  každého souboru pomocí implicitní konvence pojmenování a nalezení cílové kampaně a její
  přidružené žádosti.
- Stažení obsahu faktury, jeho uložení jako přílohy, přidání do kolekce fakturových příloh žádosti
  a uložení žádosti — což znovu spustí kapacitu pro stavy žádosti a rozvětvení vedlejších efektů
  (FN0002), přestože se změnila pouze příloha.
- Podpora režimu pouze pro výpis (zkušební běh / dry-run), který provede autentizaci, výpis a
  nalezení kandidátských položek bez uložení jakékoli přílohy.
- Zaznamenání chyby a pokračování ve zpracování zbývajících položek v případě, že název souboru
  nelze přiřadit k existující kampani, namísto přerušení celého běhu.

## Související případy užití

UC0019 (Import faktur z OneDrive).

## Související entity

EN0001 (Žádost — přijímá importovanou fakturu jako přílohu a je znovu uložena), EN0004
(Kampaň — určena z názvu souboru faktury pro nalezení cílové žádosti).

## Integrace

OneDrive / Microsoft Graph API (pojmenovaný integrační klastr; viz ARCH0002 přehled integrací,
řádek pro hranici zdroje faktur OneDrive — pro tuto hranici zatím neexistuje vrstva ES).

## Omezení

- Autentizace probíhá formou grantu resource-owner-password-credentials (ROPC) vůči pevně danému
  tenantovi, klientovi a sadě přihlašovacích údajů servisního účtu — jde spíše o vazbu na
  konkrétního dodavatele/přihlašovací údaje než o delegovaný nebo čistě aplikační (app-only) tok.
- Chybí ochrana proti duplicitám: opakované spuštění importu nad složkou obsahující již
  naimportovanou fakturu připojí k téže žádosti duplicitní záznam přílohy (Partial evidence — nejde
  o zamýšlené chování).
- Případ, kdy je kampaň úspěšně nalezena, ale nemá přiřazenou žádnou žádost, není ošetřen
  odpovídajícím způsobem; důkazy naznačují, že to může vést k selhání zpracování dané položky, spíše
  než aby šlo o navržený alternativní výsledek (Partial evidence).
- Uložení, které mění pouze přílohu, přesto spouští celé rozvětvení stavu žádosti a vedlejších
  efektů (FN0002), včetně navazujícího zpracování notifikací a reindexace vyhledávání, i když se
  žádný stav nezměnil.
- Po zpracování není zaručeno vyčištění dočasně stažitelného obsahu.
