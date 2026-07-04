---
doc_id: UC0009
title: Redeem / Validate Voucher
canonical_layer: UC
spec_type: use-case
status: canonical
modules: []
---

# UC0009 — Uplatnění / validace poukazu

## Hlavička

| Pole | Hodnota |
|---|---|
| UC ID | UC0009 |
| Název | Redeem / Validate Voucher |
| Bounded Context | C6 |
| Primární aktér(y) | Zákazník |
| Typ spuštění | API |

## Aktéři a odpovědnosti

- **Zákazník** — příjemce poukazu (může být anonymní); zadává kód poukazu k validaci a/nebo jej uplatňuje vůči zvolenému příběhu (EN0004).
- **Systém** — validuje stav poukazu (EN0013), naváže jej na zvolený příběh, aktualizuje související transakci (EN0009) a odešle potvrzovací e-mail.

## Účel

Umožnit příjemci ověřit, že dárkový poukaz (Dobrošek) je pravý a stále použitelný, a následně jej uplatnit navázáním na zvolený příběh — čímž se předplacený, zaplacený, ale dosud nepoužitý poukaz změní na uplatněný dar vůči cílové částce daného příběhu.

## Předpoklady

- Poukaz (EN0013) již existuje a dříve dosáhl stavu zaplaceno (viz životní cyklus EN0013; přechod do tohoto stavu probíhá mimo tento UC).
- Poukaz dosud nebyl uplatněn (viz životní cyklus EN0013 pro rozlišení uplatněno / neuplatněno).
- Pro uplatnění: cílový příběh (EN0004) existuje a lze jej načíst.

## Hlavní tok

### UC0009.1 — Validace poukazu
1. Zákazník: zadá identifikátor poukazu (UUID) k validaci, zatím bez záměru jej uplatnit.
2. Systém: požadavek odmítne, pokud identifikátor chybí, a vrátí neúspěšný výsledek.
3. Systém: vyhledá poukaz podle UUID, přičemž vyžaduje, aby byl ve stavu zaplaceno a dosud nebyl uplatněn.
4. Systém: při úspěšném vyhledání vrátí platný výsledek spolu s kódem poukazu, datem expirace a hodnotou poukazu; jinak vrátí neplatný výsledek.

### UC0009.2 — Uplatnění (redeem) poukazu
1. Zákazník: zadá kód poukazu spolu s identifikátorem cílového příběhu a volitelně e-mailovou adresu příjemce.
2. Systém: požadavek odmítne, pokud chybí kód poukazu nebo identifikátor příběhu, a vrátí neúspěšný výsledek.
3. Systém: načte cílový příběh (EN0004); pokud příběh nelze nalézt, požadavek odmítne.
4. Systém: vyhledá poukaz (EN0013) podle jeho kódu; požadavek odmítne, pokud odpovídající poukaz nebyl nalezen, pokud je již uplatněn, nebo pokud není ve stavu zaplaceno.
5. Systém: naváže poukaz na cílový příběh, označí jej jako uplatněný a zaznamená časové razítko uplatnění.
6. Systém: pokud byla zadána e-mailová adresa příjemce a má platný formát, zaznamená ji u poukazu; neplatný e-mail je tiše ignorován.
7. Systém: přesměruje původní nákupní transakci poukazu (EN0009) na tentýž cílový příběh, takže dar je nyní přiřazen k němu.
8. Integrace(SmartMailing): odešle potvrzovací e-mail o uplatnění na e-mailovou adresu z nákupní transakce.
9. Systém: vrátí zákazníkovi úspěšný výsledek.

## Alternativní toky

### AF1 — Validace selže (neznámý, nezaplacený nebo již uplatněný poukaz)
1. Zákazník: zadá identifikátor poukazu k validaci.
2. Systém: nenajde žádný poukaz splňující zároveň podmínku zaplaceno a dosud neuplatněno.
3. Systém: vrátí neplatný výsledek bez dalších podrobností.

Výsledek: zákazník je informován, že poukaz nelze použít; nedochází k žádné změně stavu.

### AF2 — Uplatnění selže (neznámý kód, již uplatněný nebo nezaplacený poukaz)
1. Zákazník: zadá kód poukazu a identifikátor cílového příběhu.
2. Systém: nenajde odpovídající poukaz podle kódu, nebo zjistí, že poukaz je již uplatněn, případně že dosud nebyl zaplacen.
3. Systém: vrátí neúspěšný výsledek; nedochází k žádné změně stavu.

Výsledek: poukaz zůstává ve svém předchozím stavu; zákazník musí opravit kód nebo kontaktovat podporu.

### AF3 — Kolize duplicitních kódů poukazů (riziko kvality dat)
1. Zákazník: zadá k uplatnění kód poukazu, jehož jedinečnost není v podkladových datech zaručena.
2. Systém: při uplatňování podle kódu libovolně vybere jeden z odpovídajících záznamů poukazu.

Výsledek: Partial / Hypothesis — doloženo jako riziko integrity dat ve flow dossier (u kódu poukazu není vynucena jedinečnost), nejde o navržené chování; označeno jako podnět pro přestavbu, nikoli jako tvrzení o zamýšlené logice.

### AF4 — Souběžné uplatnění téhož poukazu (riziko souběhu)
1. Zákazník: dva požadavky na uplatnění téhož kódu poukazu dorazí těsně po sobě.
2. Systém: oba požadavky mohou projít kontrolou dosud neuplatněno dříve, než je uložena aktualizace kteréhokoli z nich.

Výsledek: Partial / Hypothesis — doloženo jako riziko souběhu / idempotence ve flow dossier (chybí zamykání kolem sekvence kontrola-poté-aktualizace); zaznamenáno jako pozorované riziko, nikoli jako potvrzené ošetřené chování.

## Následné podmínky

- Validace: žádná změna stavu; zákazník obdržel určení platný/neplatný.
- Uplatnění (úspěch): poukaz (EN0013) je navázán na cílový příběh (EN0004), označen jako uplatněný, s nastaveným časovým razítkem uplatnění a volitelně zaznamenaným e-mailem příjemce.
- Uplatnění (úspěch): původní nákupní transakce (EN0009) je přesměrována na tentýž cílový příběh.
- Uplatnění (úspěch): byl odeslán potvrzovací e-mail o uplatnění.
- Uplatnění (neúspěch): žádná změna stavu; poukaz i transakce zůstávají beze změny.

## Trasovatelnost

Cílové SRV:
- Document-Generation-&-Fulfilment
- Payment-Processing

EN entity:
- EN0013 Poukaz — uplatnitelný nástroj; ústřední předmět operací validace i uplatnění
- EN0009 Transakce — původní nákupní platba; při uplatnění přesměrována na cílový příběh
- EN0004 Příběh — cíl uplatnění; přijímá přeřazený dar

Integrační hranice:
- SmartMailing (odeslání transakčního e-mailu při úspěšném uplatnění)

Flow Evidence:
- FLW0018 (uplatnění / validace poukazu)

## Úroveň důkazu

Confirmed — podloženo FLW0018 (úroveň jistoty Confirmed) a návrhy entit EN0013/EN0009/EN0004 pro fakta o životním cyklu poukazu, transakce a příběhu; rizika duplicitního kódu a souběžného uplatnění v AF3/AF4 jsou převzata ze sekce Failure Modes FLW0018 a označena jako Partial/Hypothesis coby pozorování kvality dat / souběhu, nikoli jako navržené chování.
