---
doc_id: MSG0013
title: Story Published Notification
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0011
references:
  - EN0004
  - EN0001
  - EN0022
---

# MSG0013 – Notifikace o zveřejnění příběhu

## Účel

Informovat Žadatele (Parent) a Patrona o tom, že Příběh dítěte (Kampaň, EN0004) byl zveřejněn a je
nyní živý na webu, a poskytnout každému z nich odkaz na jeho zobrazení. Jde o samostatnou,
vysoce prioritní zprávu vázanou na okamžik aktivace Kampaně — bod, kdy se případ stává veřejně
viditelným a formálně začíná fundraising — a z tohoto důvodu je vyčleněna z obecného
stavově řízeného souhrnu (MSG0005/MSG0006), v souladu s tím, jak i jiné vysoce prioritní
přechody stavu (podání žádosti, rozhodnutí scoringu, smlouva, potvrzení daru) již mají vlastní
dedikované MSG dokumenty.

---

## Spouštěč

UC0011 (Správa Kampaně / životního cyklu Příběhu), dílčí tok UC0011.1 (Admin zveřejní / nastaví
Kampaň jako aktivní) — Systém nastaví stav navázané Žádosti (EN0001) na `active` (krok 10) a uloží
ji, čímž se spustí distribuce notifikace o změně stavu žádosti popsaná v UC0011.3. Podkladovým
okamžikem „zveřejnění Příběhu" je akce Admina zveřejnit počínaje krokem 1 v UC0011.1; notifikace se
odešle v okamžiku, kdy je Kampaň aktivní a stav Žádosti byl aktualizován v jednom kroku.

Potvrzeno narativně scénářem SC-9A („Příběh úspěšně zveřejněn"), kroky 6–9: Content Coordinator
zveřejní příběh na webu, stav se změní na Aktivní příběh a Systém odešle zprávu o zveřejnění
Žadateli i Patronovi s odkazem na příběh.

Úroveň evidence: Confirmed pro okamžik spouštěče a záměr adresovat obě strany (UC0011, SC-9A); viz
níže Příjemci pro zaznamenaný konflikt ohledně přesného kanálu.

---

## Příjemci

- **Žadatel (Parent)** — informován, že Příběh je nyní zveřejněn, s odkazem na jeho zobrazení.
- **Patron** — informován, že Příběh je nyní zveřejněn, s odkazem na jeho zobrazení.

Kanál — Conflict, zaznamenáno dle projektové instrukce (kód/konfigurace má přednost pro aktuální
stav): Notification Matrix (`intake/test-scenarios/test-scenarios.md`, list „Notification Matrix",
stav `active`) označuje pro řádky Žadatele i Patrona Email = NO a User account notification = YES
— tj. aktuální konfigurace (ApplicationReaction, EN0026) doručuje tuto zprávu pouze jako notifikaci
v zóně (Zóna žadatele / Zóna patrona), nikoli e-mailem. Narativní kroky 8–9 scénáře SC-9A naopak
popisují, že Systém „odesílá e-mail" každé straně. Vzhledem k tomu, že Notification Matrix vychází
z živé konfigurace `application_reaction` a je vyšší autoritou evidence pro aktuální chování kanálu,
je aktuální smlouva (contract) posuzována jako **pouze notifikace v zóně** pro obě role; formulace
„e-mail" v SC-9A není tvrzena jako aktuální kanál. Pro tuto zprávu v aktuálním stavu není tvrzeno
žádné odeslání e-mailu (a tedy ani doručení přes ES0006/Mautic, ani záznam EmailArchive dle EN0022).

Kromě výše uvedeného nejsou doloženy žádné varianty kanálu pro CZ/RO/MD; mechanismus doručení v
zóně je dle aktuálních zdrojů napříč trhy jednotný.

---

## Obsah zprávy

Koncepčně každá instance této zprávy nese:

- Status zprávu potvrzující, že Příběh je nyní zveřejněn/aktivní — literál z Notification Matrix:
  „Příběh je zveřejněn" (zobrazeno Žadateli i Patronovi).
- Odkaz na živou, zveřejněnou stránku Příběhu (Kampaň, EN0004), aby si ji příjemce mohl přímo
  zobrazit.
- Implicitní referenci na případ: zobrazeno v kontextu vlastního pohledu příjemce do Zóny žadatele
  / Zóny patrona na jeho Žádost (EN0001) / Příběh, v souladu se stavem „Aktivní příběh" nyní
  viditelným v obou zónách dle kroků 10–11 SC-9A.

Z této smlouvy (contract) je vyloučeno (jde o doručení/implementaci, nikoli o obsah zprávy): přesný
text kopie/předmětu nad rámec citovaného literálu z matice, HTML/vizuální prezentace a způsob, jakým
se pohled zóny obnovuje.

---

## Poznámky / Nejistoty

- Požadavky na změnu příběhu vznesené po zveřejnění (SC-9B — Žadatel nebo Patron žádá o změny
  příběhu) jsou řešeny přímo provozním personálem a není doloženo, že by produkovaly vlastní
  samostatnou transakční zprávu; tímto dokumentem nejsou pokryty.
- Tato zpráva sdílí svůj podkladový mechanismus distribuce s MSG0005 (e-mail o změně stavu) a MSG0006
  (notifikace o stavu v zóně) — stejné shodné pravidlo ApplicationReaction (EN0026) na stav `active`
  Žádosti (EN0001) dle UC0011.1 krok 10–11 / UC0011.3 — je zde ale dokumentována samostatně, protože
  záměr zveřejnění Kampaně je odlišný a natolik vysoce prioritní, že si zaslouží vlastní smlouvu
  zprávy (message contract), a také kvůli výše zaznamenanému konfliktu kanálu, který je specifický
  pro tento stav a stojí za to jej vyčlenit, místo aby byl tiše sloučen do obecného souhrnu.
- Úroveň evidence: Confirmed pro spouštěč a záměr adresovat oba příjemce; Partial/Conflict pro
  kanál, jak je zaznamenáno výše.
