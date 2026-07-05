---
doc_id: JOB0014
title: Transactional Mail Queue Consumer
layer: JOB
spec_type: job-contract
status: imported
modules: []
job_type: async-consumer
references:
  - FN0019
  - EN0022
  - ES0006
---

# JOB0014 – Konzument fronty transakčních e-mailů

## Účel

Konzumovat zařazené požadavky na odeslání transakční zprávy a doručit každý e-mail přes messaging
službu. Jde o zamýšlenou asynchronní doručovací cestu pro FN0019 (Transakční zprávy a šablonování).

Klasifikace: **Confirmed** (worker existuje) — ale **aktuálně nečinný / obcházený** (viz Trigger
Model): messaging služba odesílá synchronně a v současném zdrojovém kódu tuto frontu nepoužívá.

## Trigger Model

- Asynchronní konzument (queue worker `id="mailing_queue"`). Worker předává každou položku metodě
  přímého odeslání messaging služby.
- **Aktuálně obcházeno:** příznak use-queue messaging služby je vypnutý, takže e-maily se odesílají
  **synchronně v rámci requestu/ukládání** místo zařazení do fronty; a žádný cron klíč ani modulový
  cron tuto frontu nevyprazdňuje. V současném stavu je fronta fakticky nevyužívaná. `Confirmed`.
- Evidence: `patron_base/src/Plugin/QueueWorker/MailingQueue.php` (`id="mailing_queue"`) předávající
  messaging službě; příznak vypnuté fronty zaznamenaný napříč FLW0007/FLW0012/FLW0022 a FN0019.

## Vstupní rozsah

- Položky fronty nesoucí adresy příjemců, název šablony, parametry, reply-to, přílohy a argumenty
  (plně připravený požadavek na odeslání). Viz EN0022.

## Zpracovatelská pravidla

- Pro každou položku: zavolat metodu přímého odeslání messaging služby se zařazenými argumenty, což
  vyřeší šablonu pro danou zemi, aplikuje prostředím podmíněnou pojistku (send-gate) a archivuje
  zprávu.

## Vedlejší efekty

- Odchozí e-mail přes messaging transport (Mautic, ES0006) a záznam v archivu zpráv — ale pouze
  pokud/když je fronta skutečně vyprázdněna. V současném stavu tyto efekty nastávají synchronně
  přímo v rámci volajícího toku, nikoli přes tento worker.

## Idempotence

- Požadavek na odeslání nemá idempotentní klíč; opětovné zpracování zabrané, ale nesmazané položky
  by vedlo k opětovnému odeslání. V praxi fronta v současném stavu není využívána (viz Trigger
  Model).

## Zpracování chyb

- Sémantika chyby doručení by odpovídala tomu, jaká vyprazdňovací smyčka worker volá; žádná taková
  dnes není zapojena. Protože se odesílá synchronně, pomalý/nefunkční transport blokuje nebo přeruší
  navazující perzistenci (zdokumentováno v rámci FN0019).

## Odkazy

- FN: FN0019
- UC: UC0012 a volající triggery (UC0002/UC0004/UC0006/UC0010/UC0011/UC0015)
- EN: EN0022
- ES: ES0006
- Evidence: MailingQueue worker; FN0019 (USE_QUEUE vypnuto)

## Otevřené body

- **Stav: Přítomno, ale obcházeno.** Fronta a worker existují, ale v současném stavu nejsou
  poháněny (synchronní odesílání + žádné vyprazdňování). Zaznamenáno, aby rebuild zacházel s
  asynchronním doručováním e-mailů jako s *cílovým* stavem, nikoli potvrzeným současným chováním.
