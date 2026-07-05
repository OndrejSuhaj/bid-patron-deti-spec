---
doc_id: EN0028
title: CampaignLog
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0004  # Campaign (logged Story/Příběh)
  - EN0008  # User (author)
  - UC0011  # Manage Campaign / Story Lifecycle (candidate writer context; Hypothesis)
---

# EN0028 — CampaignLog

## Účel

Auditní záznam vztažený k jednotlivému Příběhu (Story/Příběh, EN0004), jehož účelem je zachytit, jak
se v daném intervalu změnila hodnota nějakého pole — spároval počáteční a koncový časový bod se
změněným polem a jeho hodnotou. Strukturně srovnatelné s ApplicationLog (EN0025), avšak vztažené
k agregátu Příběh, nikoli k agregátu Žádost.

---

## Životní cyklus

Recorded (zaznamenáno) — jediný stav. Záznam CampaignLog je auditní řádek pouze pro připojování
(append-only): jednou vytvořený, nikdy nepřechází do jiného stavu a není odstraňován. Pro tuto
entitu není definován žádný stavový slovník.

---

## Přechody stavů

(žádný) → Recorded

trigger: Hypothesis — žádný potvrzený případ užití nezapisuje CampaignLog. UC0011 (Manage Campaign /
Story Lifecycle) řídí změny polí Příběhu (aktivace, vypršení termínu, dokončení), které by
pravděpodobně mohly být zdrojem těchto záznamů, avšak UC0011 výslovně netvrdí CampaignLog jako
součást svého potvrzeného chování — vazba je pouze Hypothesis. **Chybějící důkaz** pro skutečného
zapisovatele.

Žádný přechod ze stavu Recorded ven není doložen — záznamy by měly být pouze pro připojování
(append-only), v souladu se vzorem ApplicationLog (EN0025).

---

## Atributy

### Systémem spravované atributy

- Campaign (odkaz na EN0004; povinné) — Příběh, ke kterému je tento záznam veden.
- Author (odkaz na EN0008; povinné) — uživatel uvedený jako autor záznamu.
- Start (časové razítko; povinné) — okamžik, kdy zaznamenaný interval začíná.
- Finish (časové razítko; povinné) — okamžik, kdy zaznamenaný interval končí.

### Uživatelem zadávané atributy

- Field name (text, max. 50 znaků; nepovinné, výchozí prázdné) — popisek identifikující změněné
  pole.
- Field value (text, max. 255 znaků; nepovinné, výchozí prázdné) — hodnota přiřazená ke změněnému
  poli.

---

## Invarianty

- Pro tuto entitu není definován žádný atribut stavu životního cyklu — Recorded je jediným stavem
  entity, nikoli hodnotou statusu vybíranou ze slovníku (strukturně v souladu s ApplicationLog,
  EN0025).
- Conflict — requires clarification: dřívější důkazy poukazovaly na scaffoldingové mapování
  atributu label/status na této entitě bez odpovídajícího podkladového pole — stejný vzor
  "visícího" (dangling) mapování, jaký byl pozorován u ApplicationLog (EN0025). Není vyřešeno jako
  kanonický fakt.

---

## Vztahy

- EN0004 — Campaign (zaznamenávaný agregát; povinné, jeden Příběh na záznam)
- EN0008 — User (autor záznamu)

---

## Otevřené otázky

1. Který případ užití nebo systémový proces zapisuje záznam CampaignLog? Žádný případ užití to
   netvrdí jako potvrzené chování (UC0011 odkazuje na EN0028 pouze jako Hypothesis). **Chybějící
   důkaz** pro zapisovatele.
2. Mají Start/Finish vymezovat dobu, po kterou byla držena konkrétní hodnota pole (auditování
   intervalu), nebo pouze označují okamžiky vytvoření/změny? Nedoloženo.
3. Uncertain: jde u visícího mapování atributu label/status o sdílený, zkopírovaný scaffolding
   společný s ApplicationLog (EN0025), nebo o dvě nezávisle mrtvé konfigurace? Nevyřešeno.
