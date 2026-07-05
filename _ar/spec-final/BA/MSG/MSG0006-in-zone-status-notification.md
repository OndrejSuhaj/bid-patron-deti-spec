---
doc_id: MSG0006
title: In-Zone Status Notification
layer: MSG
spec_type: transactional-message
status: imported
modules: []
trigger:
  - UC0002
references:
  - EN0001
  - EN0026
  - EN0003
---

# MSG0006 – Notifikace o stavu v zóně (in-zone)

## Účel

Zobrazit aktuální, správný stav Žádosti (EN0001) — a tam, kde je vyžadována akce, i to, o jakou akci
jde — uvnitř Zóny rodiče a Zóny patrona při každém relevantním kroku životního cyklu případu. Jde o
in-app protějšek notifikačního fan-outu řízeného stavem: místo oslovení strany e-mailem se stav
zobrazí přímo v zóně dané strany při jejím příštím zobrazení, takže každá strana vždy ví, kde se její
žádost/příběh nachází, aniž by musela kontrolovat e-mailovou schránku.

---

## Trigger (spouštěč)

UC0002 (Orchestrace změny stavu žádosti) — konkrétně navazující fan-out reakcí (UC0002.2): při každém
uložení, které nastaví Žádosti (EN0001) nový stav, Systém vyhledá ReakciNaŽádost (EN0026)
nakonfigurovanou pro daný stav a roli, a — tam, kde má tato reakce zapnutý in-app/zónový notifikační
kanál ("notifikace v účtu / zóně" = ANO) — je odpovídající zpráva o stavu v zóně zpřístupněna dotčené
straně. Fan-out proběhne bez ohledu na to, zda se stav skutečně změnil (UC0002 hlavní tok krok 7 / AF1);
samotná notifikace se viditelně projeví pouze tehdy, pokud ji ReakceNaŽádost (EN0026) pro daný
vyhodnocený stav a roli povoluje.

Potvrzeno přímo akceptačními scénáři SC-11C (notifikace o stavu viditelné v Zóně rodiče) a SC-11D
(notifikace o stavu viditelné v Zóně patrona) v aktuálních podkladech testovacích scénářů a dále
sloupcem Notifikační matice "Notifikace v účtu / zóně", který označuje tento kanál ANO/NE podle
stavu × role nezávisle na sloupci E-mail.

---

## Příjemci

- **Rodič / Žadatel** (zákonný zástupce žádající jménem dítěte) — vidí zprávu v Zóně rodiče.
- **Patron** (potenciální nebo potvrzený sponzor) — vidí zprávu v Zóně patrona.

Zóna každého příjemce zobrazuje pouze zprávu vyhodnocenou pro ReakciNaŽádost (EN0026) dané role při
aktuálním stavu Žádosti (EN0001); obě role často vidí odlišné znění pro tentýž výchozí stav (např.
jedna strana je vyzvána k akci, zatímco druhá je informována, že má čekat). Zda in-zone kanál pro daný
stav × roli vůbec spustí, nezávisle na tom, zda se odešle i doprovodný e-mail, se řídí příznakem
"Notifikace v účtu / zóně" v Notifikační matici pro daný stav/roli — některé stavy notifikují pouze
v zóně, některé odesílají e-mail i zprávu v zóně zároveň, některé neodesílají dané roli nic.

Kanál: interní, v rámci aplikace (zobrazení zóny) — nejde o e-mail a není směrován přes externí
integraci doručování e-mailů (ES0006). V aktuálních zdrojích nejsou doloženy žádné kanálové varianty
CZ/RO/MD nad rámec již zaznamenaných rozdílů ve slovníku stavů / lokalizaci na úrovni stavového
modelu; samotný mechanismus doručení v zóně je napříč trhy jednotný.

---

## Obsah zprávy

Notifikace o stavu v zóně obsahově nese:

- **Popisek aktuálního stavu** — krátkou, lidsky čitelnou frázi pojmenovávající, kde se Žádost
  (EN0001) nyní nachází, formulovanou pro roli, která ji zobrazuje (např. "Čekáme na Patrona,"
  "Doplňte žádost," "Posuzujeme," "Připravujeme smlouvu," "Příběh je zveřejněn," "Splněno"). Přesné
  znění je specifické podle stavu a role dle konfigurace ReakceNaŽádost (EN0026) a sloupce
  "Status zpráva" v Notifikační matici; tento dokument neopakuje celý slovník stavů (vlastněný
  stavovým modelem / EN0001 Povolené stavy).
- **Signál vyžadované akce, je-li relevantní** — indikaci, zda strana, která zprávu vidí, má něco
  udělat (např. vyplnit formulář, nahrát dokument, potvrdit přijetí) oproti pouhému čekání; přítomno
  pouze u stavů, jejichž reakce je nakonfigurována tak, aby vyzvala k akci.
- **Implicitní odkaz na případ** — zpráva se zobrazuje v kontextu vlastního zobrazení
  Žádosti/Příběhu dané strany, takže je ze své podstaty vázaná na danou Žádost (EN0001), aniž by bylo
  nutné identifikační údaje opakovat v samotné zprávě.

Z tohoto kontraktu je vyloučeno (jde o doručení/implementaci, nikoli o obsah zprávy): přesné texty
kopie pro jednotlivé stavy, HTML/vizuální prezentace zóny a způsob, jakým se zobrazení zóny obnovuje
nebo načítá.

---

## Poznámky / nejistoty

- Jde o **skupinovou** definici zprávy: pokrývá in-zone kanál ("notifikace v účtu / zóně") v podstatě
  pro všechny stavy nesoucí "Status zprávu" v Notifikační matici (téměř všech 117 řádků matice má
  neprázdnou Status zprávu; velká podmnožina má také "Notifikace v účtu / zóně" = ANO). Je záměrně
  ponechána jako jediný dokument MSG namísto rozpadu podle jednotlivých stavů, v souladu s pokynem pro
  seskupování v této syntézní fázi — přesné znění podle stavu/role a vyhodnocení kanálu ANO/NE je
  autoritativně dáno Notifikační maticí (`intake/test-scenarios/test-scenarios.md`) a konfigurací
  ReakceNaŽádost (EN0026), ze které je odvozeno, a zde se neopakuje.
  MSG0006 sdílí svůj trigger a mechanismus fan-outu s MSG0005 (e-mailovým protějškem) — stejné
  přiřazení ReakceNaŽádost (EN0026) dle UC0002.2, ale jde o in-app kanál namísto e-mailového kanálu;
  některé stavy spouští jen jeden z obou, některé oba.
  Reference: `intake/test-scenarios/test-scenarios.md`, listy SC-11C, SC-11D a Notifikační matice
  (sloupce "Status", "Recipient role", "User account notification", "Status message").
- Několik řádků Notifikační matice nese dva kandidátní texty status zprávy oddělené `;` (např.
  `out_of_scope` → "Zrušená žádost; Nemůžeme vám pomoci") nebo je ve zdrojovém listu označeno příznakem
  `CHECK_PARSE` — přesný, jednoznačně vyhodnocený řetězec pro daný řádek je **Uncertain** a je
  ponechán na podkladech stavového modelu / ReakceNaŽádost (EN0026), zde se netvrdí.
- Řádek `mistake` (Rodič) v Notifikační matici má "Notifikace v účtu / zóně" = **NE**, takže in-zone
  kanál se pro Rodiče při tomto stavu **nespouští** — Rodiči se nezobrazí žádná zpráva v zóně (toto je
  ustálené, nikoli otevřené). Prázdná buňka Status zprávy u tohoto řádku (nesoucí `CHECK_PARSE`,
  obecný příznak parsování daného řádku, nikoli signál kanálu) je jediným bodem **Uncertain**: zda jde
  o skutečnou absenci, nebo o mezeru při parsování, je ponecháno na podkladech stavového modelu /
  ReakceNaŽádost (EN0026), zde se netvrdí.
