---
doc_id: EN0023
title: UserNote
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0006 (Contact)
  - EN0008 (User)
  - UC0016
  - BR-DataProtectionAndErasure
---

# EN0023 — Poznámka

## Účel

Poznámka (UserNote) je záznam volného textu připojený ke straně (party). Nese rozšířený komentář
back-office, který si zaměstnanci vedou ke kontaktu (EN0006), jenž má napojenou jednu poznámku. Každá
úprava poznámky je uchována jako samostatná, dohledatelná revize, takže historie back-office anotací
je v čase auditovatelná.

---

## Životní cyklus

- Aktivní — poznámka existuje, je propojena se svým vlastnickým kontaktem a je buď publikovaná, nebo
  nepublikovaná (viz Atributy).
- Revidovaná — úprava existující poznámky je uchována jako předchozí revize, dohledatelná a
  vratitelná nezávisle na aktuálním obsahu.

Otevřená otázka: mimo vytvoření a revizi není doložen žádný přechod týkající se expirace, archivace
ani smazání — viz Otevřené otázky.

---

## Přechody stavů

(žádný) → Aktivní
spouštěč: UC0016 — Správa záznamů o straně (vytvoření anotace a jejího propojení s vlastnickým
kontaktem)

Aktivní → Revidovaná
spouštěč: UC0016 — Správa záznamů o straně (úprava obsahu poznámky, uchovaná jako nová revize;
předchozí revize zůstávají vratitelné)

Otevřená otázka: UC0016 v rekonstruované podobě popisuje deduplikaci a sloučení kontaktů/organizací/
leadů; jde o jediný identifikovaný use case dotýkající se záznamů o straně a je zde uveden jako
nejlépe dostupný spouštěč pro vytvoření/úpravu poznámky, avšak žádný krok flow konkrétně jmenující
poznámku nebyl potvrzen — evidence je Partial.

---

## Atributy

### Systémem spravované atributy

- Příznak publikace (boolean; povinný; stav publikováno/nepublikováno u poznámky; žádný doménový
  status slovník nad rámec tohoto příznaku)
- Časová razítka vytvoření / změny (datum-čas; povinné)
- Autor revize (odkaz na EN0008 – Uživatel; povinný pro každou revizi; identifikuje, kdo danou revizi
  vytvořil)

### Uživatelem zadávané atributy

- Název (text; povinný; krátký popisek/titulek poznámky)
- Text poznámky (text; povinný; obsah volné textové anotace)
- Vlastník (odkaz na EN0008 – Uživatel; volitelný; uživatel přiřazený k poznámce)

---

## Invarianty

- Osobní údaje obsažené v poznámce nejsou zahrnuty do kaskády use case pro výmaz dle GDPR — viz
  BR-DataProtectionAndErasure.

Otevřená otázka: není vyřešeno, zda může mít kontakt nejvýše jednu poznámku (jediné aktuální
propojení), nebo zda se může hromadit více poznámek — viz Otevřené otázky. V aktuální sadě zdrojů
nebylo identifikováno žádné business pravidlo (BR) upravující jedinečnost, retenci ani rozsah
připojení poznámky.

---

## Vztahy

- EN0006 (Kontakt) — kontakt má napojenou jednu poznámku jako svůj anotační záznam.
- EN0008 (Uživatel) — poznámka může odkazovat na vlastnícího uživatele; každá revize zaznamenává
  svého autorského uživatele.

---

## Otevřené otázky

1. Je poznámka striktně vázána v poměru jedna ku jedné ke kontaktu, nebo se v čase může hromadit více
   poznámek (přičemž z kontaktu je propojena jen ta nejnovější)?
2. Může se poznámka připojit k jiné straně než ke kontaktu (např. přímo k uživateli)? Doloženo je
   pouze propojení s kontaktem.
3. GDPR: obsah poznámky může nést osobní údaje, ale není zahrnut do kaskády use case pro výmaz (viz
   BR-DataProtectionAndErasure) — jde o záměrně neomezenou retenci, o neúplnost současného stavu, nebo
   o mezeru?
4. Mimo vytvoření/revizi/publikaci není doložen žádný přechod životního cyklu týkající se
   expirace/archivace — jde o záměrné návrhové rozhodnutí, nebo o nezrekonstruovanou mezeru?
