---
doc_id: EN0032
title: ReportSnapshot
layer: EN
spec_type: entity
status: imported
modules: []
references:
  - EN0008
  - BR-ReportingAndDataAccess
  - UC0017
---

# EN0032 — Snímek reportu

## Účel

ReportSnapshot představuje jednu pojmenovanou reportovací metriku — název metriky a její hodnotu,
označenou identifikátorem reportu a zachycenou v určitém časovém okamžiku — aby reportovací dashboardy
mohly dotazovat hodnoty metrik za dané časové rozmezí. Jde o obecnou key/value reportovací projekci
spotřebovávanou reportovacími dashboardy (viz `UC0017`, dílčí tok UC0017.3), nikoli o transakční
případ, subjekt (party) nebo peněžní záznam.

*Confidence: Low — viz Otevřené otázky.*

## Životní cyklus

Existující — jediný, neworkflow stav. ReportSnapshot nemá žádný doménový životní cyklus: řádky jsou
zachyceny jednorázově a zpětně čteny dotazem na rozsah; nebyla pozorována žádná aktualizace, mazání
ani přechod řízený stavem.

*Confidence: Low — nebyl vytěžen žádný zapisovací tok; viz Otevřené otázky.*

## Přechody stavů

(žádné) — ReportSnapshot nemá stavový automat ani žádné pozorované přechody řízené stavem.

- Vytvoření: řádky jsou zachycovány (pravděpodobně reportovací/snapshotovou úlohou) — `Hypothesis`,
  nebyl vytěžen žádný zapisovací tok; viz Otevřené otázky.
- Čtení: spotřebováváno pouze pro čtení reportovací dashboardovou funkcionalitou, filtrováno podle
  identifikátoru reportu a časového rozsahu na časové značce zachycení, spouštěč: UC0017 (dílčí tok
  UC0017.3). Důkaz pro tuto cestu spotřeby je Partial — viz `BR-ReportingAndDataAccess`.

## Atributy

### Systémem spravované atributy

- Autor (reference na EN0008 – User; povinné) — uživatel zaznamenaný jako autor záznamu.
- Časová značka zachycení (datetime; povinné) — okamžik, kdy byla metrika zachycena; slouží také jako
  klíč pro dotaz na rozsah, když reporty filtrují podle časového rozsahu.
- Časová značka změny (datetime; povinné)

### Uživatelem zadávané atributy

- Identifikátor reportu (string, max 50; povinné) — filtrovací/seskupovací klíč identifikující, ke
  kterému reportu řádek metriky patří.
- Název metriky (string, max 50; povinné) — název zachycené metriky.
- Hodnota metriky (string, max 50; povinné) — zachycená hodnota metriky; *Otevřená otázka — viz níže
  k číselnému zpracování.*

Na úrovni datového modelu je deklarován atribut podobný stavu bez povolených hodnot a bez
pozorovaného použití při vytváření, editaci nebo filtrování řádků — `Conflict`, není přenášen dále
jako kanonický stav životního cyklu; viz Otevřené otázky.

## Invarianty

- Reportovací hodnoty držené v ReportSnapshot jsou z pohledu záznamů případu, subjektu (party), peněz,
  kampaně a smlouvy pouze pro čtení — viz `BR-ReportingAndDataAccess`.
- Zachycení ReportSnapshot není podmíněno workflow ve stylu případu; žádné pravidlo neřídí přechody
  mezi stavy nad rámec jejich absence (viz Životní cyklus).

## Vztahy

- EN0008 – User (autor záznamu)

## Otevřené otázky

1. Co zachycuje řádek ReportSnapshot a v jaké periodicitě (naplánovaná úloha vs. ruční zadání) není
   vyřešeno — pro tuto entitu nebyl vytěžen žádný zapisovací tok.
2. Hodnota metriky je uchovávána jako krátký textový řetězec — zda a jak jsou číselné metriky
   agregovány nebo přetypovány při zpětném čtení reporty, není vyřešeno.
3. Atribut podobný stavu je deklarován bez jakýchkoli povolených hodnot nebo pozorovaného použití —
   zda jde o nevyužitou konstrukci nebo nevyužitou reportovací dimenzi, není vyřešeno (`Conflict`).
