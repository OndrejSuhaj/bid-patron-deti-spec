# Log čištění — 2026-06-15 Patron dětí intro

Auditovatelný záznam zásahů mezi [`transcript.md`](transcript.md) (RAW) a [`transcript-cleaned.md`](transcript-cleaned.md). Účel: důvěra — RAW zůstává nedotčený, každá oprava je dohledatelná.

- **RAW:** mlx `large-v3` + diarizace pyannote 3.1, 87 replik, 3 clustery.
- **Vyčištěno:** 2026-07-01. **Nic obsahového nebylo vynecháno** — jen sloučeny fragmenty, opraveny přeslechy a sjednoceny termíny.

## 1. Mapování mluvčích

| RAW cluster | Jméno (firma) | Jak určeno |
|---|---|---|
| SPEAKER_00 (~64 %) | **Jan Beránek (PD)** — „Honza" | Sebe-identifikace [02:19] „já jsem Honza"; role IT delivery/organizace, interní tým, migrace, Pavel/Edita. |
| SPEAKER_01 (~25 %) | **Libor Suchý (Argo22)** | „My jsme Argo22" [05:33]; strana dodavatele, klade otázky, technické návrhy. |
| SPEAKER_02 (~10 %) | **Rostislav Levkovich (PD)** — „Rosťa" | Autor stávajícího systému; [08:07] „jsem tu spíš, abych poradil ohledně stávajícího řešení", [25:56] „u nás ještě nebyl Honza… prohrál jsem", [24:01] geneze designu. |

Jména potvrzena Delivery Leadem 2026-07-01 (PD = Patron děti). V tělě replik se používá celé jméno, firma je v legendě cleaned přepisu.

> **Kontext k diarizaci:** předchozí RAW (sherpa-onnx) slil Honzu+Rosťu do jednoho clusteru; blok [08:07] byl chybně připsán Honzovi. Nový RAW (pyannote 3.1) Rosťu oddělil — ověřeno bake-offem (viz `tools/transcribe/README.md`, commit s integrací).

## 2. Sloučené / přeřazené fragmenty (hranové artefakty diarizace)

Diarizace per-slovo občas usekne krátký fragment na hranici věty k sousednímu mluvčímu. Sloučeno zpět k reálnému mluvčímu (obsah věty je jednoznačný):

| Čas (RAW) | RAW přiřazení | Oprava | Důvod |
|---|---|---|---|
| [04:19] „A předávám" | SPEAKER_02 (Rosťa) | → Honza | Honzova věta „A předávám slovo Rosťovi…" useknutá na hranici. |
| [15:43] „to" | SPEAKER_01 (Libor) | → Honza | Součást Honzova „to se tomu rozumí". |
| [21:23] „že" | SPEAKER_02 (Rosťa) | → Honza | Uvnitř Honzovy věty „…si myslím, že by to mohlo být…". |
| [21:38] „Ale" | SPEAKER_01 (Libor) | → Honza | Uvnitř Honzovy věty „Ale tím pádem i ten závazek…". |
| [26:25] „To" / „asi" / „schápem" | mix 00/02 | → Honza | Honzova věta „To asi chápeme všichni" rozsekaná na slova. |
| [26:30] „té"/„nabídce" | mix 00/02 | → Honza | Honzova věta „…část v té nabídce". |
| [41:35] „ten" | SPEAKER_01 (Libor) | → Honza | Honzova ironická věta „A ten dodavatel si to vysvětlí…". |
| [49:10] „je" | SPEAKER_00 | → Libor | Součást Liborovy věty „ono je to o programátorech". |
| [50:58] „tak" | SPEAKER_02 (Rosťa) | → Honza | Uvnitř Honzovy věty „…tak by to mohlo jít ruku v ruce". |

Krátké backchannely ponechány u svého mluvčího (např. [05:16] Libor „super", [27:05] Libor „Super, OK").

## 3. Opravené přeslechy ASR — věcné termíny

| RAW | Opraveno | Pozn. |
|---|---|---|
| „ve VŮčku" | **ve Vue** | frontend framework (Vue.js) — stávající public frontend Česka. |
| „drupalu" | **Drupalu** | CMS, jádro systému. |
| „Gutenberga editoru" | **Gutenberg editoru** | editor bloků. |
| „headless CMS typu payload" | **…typu Payload** | Payload CMS. |
| „Clodovi zadávali" | **Claudovi zadávali** | Claude (AI asistent). |
| „v antropopiku mají" | **v Anthropicu mají** | Anthropic (poskytovatel Claude). |
| „crown founding" (2×) | **crowdfunding** | sjednoceno s ostatními výskyty. |
| „diskovým procesem" / „diskový" | **riskovým procesem** / **riskový** | risk proces (prověřování žadatelů). |
| „za to oriskování" | **oriskování** | ponecháno (žargon týmu pro risk-proces). |

## 4. Opravené přeslechy ASR — běžná slova (výběr)

„uvízt" → uvést · „z pánky" → zpátky · „provrát" → probrat · „líp než vůř" → líp než hůř · „nabíšit kapacity" → navýšit kapacity · „vypinkat" → vypinknout · „prejsou" → prý jsou · „karikopitulace" → rekapitulace · „SLáčko" → SLA · „administratorský rozhradní" → administrátorské rozhraní · „kodigovat" → ponecháno [?] (pravděpodobně „nakódovat/nakonfigurovat") · „za stolik / za stůl" → za stůl. Drobné gramatické a interpunkční úpravy pro čitelnost bez změny významu.

## 5. Sjednocené termíny / jména

- **Patron / Patron děti** (systém i organizace), **Argo22** (dodavatel).
- Osoby: **Honza**, **Libor**, **Rosťa**, **Pavel** (Kůn, byznys/finance), **Edita** (ředitelka), **Ondra** (design).
- „NDAčko / endáčko" → **NDAčko** (hovorové ponecháno, sjednocený tvar).

## 6. Nejisté / neověřené

| Místo (audio) | RAW | Stav |
|---|---|---|
| [15:31] | „operační ředitelka z VATAVA" | **vyřešeno → Svatava** (jméno kolegyně; potvrdil Delivery Lead). Ponechán `[?]` v cleaned, dokud se pravopis 100% neověří. |
| ~[33:50] | „CCDS a podobně" | `[?]` — název rejstříku/integrace pro risk proces. Ověřit přehráním audia na **~33:50**. |
| ~[35:00–35:30] (v replice [33:58], pasáž o dodavatelích) | „zavolá do Plzně Houtkovi" | `[?]` — jméno dodavatele (kytary, Plzeň). Ověřit přehráním audia kolem **35:00–35:30**. |

> Timestampy pro doposlech: **CCDS ~33:50**, **Houtek ~35:00–35:30** (dlouhá Honzova replika [33:58]–[36:33], část o vypořádání darů s dodavateli). Svatava je [15:31].

## 7. Otevřené otázky

- **needs:** @DeliveryLead — potvrdit `[?]` položky (VATAVA, CCDS, Houtek) přehráním audia / z paměti.
- Blok [42:51] (Honza, GDPR + LLM + „zdrojáky už dávno v Anthropicu mají") je věcně nejhutnější k budoucímu vytažení do `product/` (postoj k AI, ochraně osobních údajů, cloud-first vývoji).
