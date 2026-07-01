# Politika runtime pravdy — AR průchod Patronus (bid-patron-deti)

Stav: aktivní pro tento AR průchod
Naposledy upraveno: 2026-07-01

---

## Účel

Definuje, jaká runtime pozorování smějí být v tomto AR průchodu použita jako evidence a jak silně
mohou ovlivnit kanonické artefakty.

---

## Dostupné runtime povrchy

**Žádné běžící runtime prostředí není pro tento průchod nakonfigurované.**

Rekonstrukce je **statická** — z:

- zdrojového kódu a konfigurace Patronus (`intake/current-solution/_source/patronus/`)
- current-state procesních map (`intake/process-maps/`)
- stavového modelu (`intake/statuses/`), testovacích scénářů (`intake/test-scenarios/`)
- derivované analýzy (`intake/current-solution-analysis/`)
- meetingů (záměr) a zadání (cílový stav — ne current-state)

Pokud později získáš přístup k běžící instanci Patronus, doplň sem endpointy, přihlašovací trezor a
povolená použití a tuto politiku aktualizuj **před** tím, než runtime použiješ jako evidenci.

---

## Autorita a meze (statický průchod)

- **Kód a konfigurace** = autoritativní pro CURRENT chování a kontrakty.
- **Procesní mapy** = autoritativní pro current-state tok; při sporu s kódem zaznamenej konflikt.
- **Zadání (`it-zadani`)** = cílový stav, **NE** current-state — nepřepisuje pozorované chování.
- Žádná runtime pozorování (není běžící prostředí) — netvrdit runtime chování bez evidence.

---

## Řešení konfliktů

Když kód, procesní mapy a zadání nesouhlasí:

1. Konflikt zaznamenej do `_ar/evidence/conflicts.md` (vytvoř, pokud chybí).
2. Postižený kanonický artefakt označ: `Conflict — requires clarification.`
3. Defaultní pořadí důvěry, pokud není zaznamenáno lidské rozhodnutí:
   - **Kód vyhrává** pro current chování a kontrakty.
   - **Procesní mapy vyhrávají** pro current-state tok.
   - **Zadání vyhrává jen pro cílový záměr** (nikdy pro current chování).
4. Konflikt nikdy neřeš tiše.

---

## Omezení

- Žádné write / mutation akce (není runtime).
- Zdroj je scrubnutý od osobních dat (GDPR); přesto nekopíruj konkrétní osobní údaje pozorované v
  kódu/configu/datech do artefaktů v `_ar/**` — používej anonymizované nebo strukturální odkazy.

---

## Mimo rozsah tohoto průchodu

- Jakékoli runtime pozorování běžící aplikace (není nakonfigurováno).
- Zátěžové / bezpečnostní testování.
- Přístup do databáze nebo mutace schématu.
