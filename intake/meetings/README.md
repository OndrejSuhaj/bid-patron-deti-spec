# Meetingy — průvodce

> **Kontextový artefakt** ve správě Delivery Leada. Přepisy schůzek s klientem. Drží **záměr a kontext „mezi řádky"** zadání — preference, omezení, nevyřčené priority. Doplňuje zadání, nenahrazuje ho. **Není zdroj pravdy pro implementaci.**

Přepis děláme **vlastním toolem z audia** ([`tools/transcribe/`](../../tools/transcribe/) — mlx-whisper (Apple GPU) / faster-whisper (CPU fallback) na stejných `large-v3` váhách + diarizace pyannote 3.1, lokálně), protože komerční nástroj (Plaud) vynechával celé věcné pasáže.

---

## Co to je

- **Zdroj:** audio nahrávky schůzek Patron Děti × Argo22.
- **Formát:** Markdown. Zdrojové audio (`.mp3` / `.m4a`) zůstává **jen lokálně** (gitignorováno) — do gitu jdou jen přepisy.
- **Struktura složky meetingu** (`intake/meetings/YYYY-MM-DD-<slug>/`):
  - `transcript.md` — **RAW** z toolu (anonymní mluvčí `SPEAKER_NN` + Speaker Key). **Needituje se.**
  - `transcript-cleaned.md` — vyčištěná verze (opravené přeslechy, pojmenovaní mluvčí, sjednocené termíny).
  - `transcript-cleaning-log.md` — auditovatelný log čištění (mapování mluvčích/termínů, opravy, vynechané pasáže, potvrzená data).
  - `notes.md` — strukturovaný zápis. *Zatím neděláme* — volitelné, až bude potřeba.

## Kdy je použít

- Pro pochopení **záměru a priorit**, které zadání neartikuluje (komerční model, tým, rizika migrace).
- Jako vstup do **produktové vize** (`product/`).

## Kdy je nepoužívat

- Jako acceptance kritéria nebo doménový kontrakt — to drží zadání, scénáře a (po destilaci) `spec/`.

---

## Jak vzniká přepis (raw → cleaned)

Pipeline ve třech krocích; **surový přepis je nedotknutelný a opravy jsou logované** — to je pojistka důvěry (proto jsme opustili Plaud: tiše vynechával pasáže).

1. **RAW** — audio → [`tools/transcribe/`](../../tools/transcribe/) → `transcript.md`. Strojový přepis s anonymními mluvčími (`SPEAKER_NN`) a Speaker Key. **Needituje se**, slouží jako baseline.
2. **Cleanup** — ruční / AI průchod → `transcript-cleaned.md` + `transcript-cleaning-log.md`. Opraví přeslechy, sjednotí termíny, **pojmenuje mluvčí** a vše zaznamená do logu (auditovatelně). Originál zůstává nedotčený.
3. **Notes** *(zatím neděláme)* — strukturovaný zápis nad čistým přepisem.

> **Pozn. pro AI — hlas uživateli během přepisu.** Tool tiskne podrobný průběh (převod → přepis s `%` → diarizace) **schválně, kvůli viditelnosti pro uživatele**. U delšího audia běží minuty; pustit ho detached a mlčet tu viditelnost zabíjí. **Postup:** spusť tool na pozadí (přesměruj do logu) a **hned na něj nasaď `Monitor`** — poll-loop nad logem, který emituje řádek při každém skoku o ~10 % a při přechodu na diarizaci, a **pokrývá i pád** (proces zmizel bez `transcript.md`), ne jen úspěch — ať tě ticho neošálí. Události z Monitoru streamuje harness sám, hlásíš je uživateli. `ScheduleWakeup` na tohle **nespoléhej** (je pro `/loop`, nefiruje spolehlivě). Pozor na `pgrep` vzor: v příkazové řádce je mezi `transcribe.py` a `--speakers` cesta k audiu — matchuj jen `transcribe.py`.

**Identita mluvčích.** Tool rozlišuje hlasy, ne lidi → RAW má `SPEAKER_NN` + Speaker Key (čas prvního výskytu, podíl řeči, ukázky). Kdo je kdo se přiřadí **v cleanupu** (z ukázek nebo přehráním audia) a zaloguje. Žádné hádání podle pořadí výskytu. Detaily v [`tools/transcribe/README.md`](../../tools/transcribe/README.md).

**Škálování.** Jedna složka per meeting (`YYYY-MM-DD-<slug>/`). Až přibude druhý typ jednání (interní), zavedeme typové podsložky (`client/`, `internal/`) — zatím máme jen klientské, neřešíme předčasně.

---

## Katalog

| Schůzka | Přepis | Pozn. |
|---|---|---|
| 2026-06-15 Patron děti — intro | [`2026-06-15-intro/`](2026-06-15-intro/) (RAW + cleaned + log) | První schůzka Patron × Argo22. Mluvčí: Jan Beránek (PD), Libor Suchý (Argo22), Rostislav Levkovich (PD). |

## Kurátorský log

> Co se z meetingů promítlo do kanonické vrstvy. Vlastník: **Delivery Lead** (signály) → **Product Owner** (produktová vize).

| Datum | Co | Kam | Rozhodl |
|---|---|---|---|
| — | *(zatím nic — produktová vize se teprve zakládá)* | — | — |

## Changelog

| Datum | Změna | Autor |
|---|---|---|
| 2026-06-30 | Převzaty **základy metodiky meetingů** z Endorphin repa: konvence souborů per meeting (RAW `transcript.md` → `transcript-cleaned.md` + `transcript-cleaning-log.md`), oddělený cleanup krok, řešení identity mluvčích bez GUI (anonymní RAW + Speaker Key, pojmenování v cleanupu). Tool přepracován (anonymní mluvčí, Speaker Key, `--speaker-map`, ochrana proti přepisu). **Dnešní korigovaný přepis intro callu zahozen** — přegeneruje se novým toolem. (notes / report / typové podsložky odloženy jako overkill.) | Libor Suchý |
| 2026-06-30 | Intro call 2026-06-15 přepsán **vlastním pipeline** (WhisperX `large-v3` + diarizace); nahradil Plaud, který vynechával celé pasáže. Ověřeno side-by-side analýzou. | Libor Suchý |
| 2026-06-30 | Vyčleněno jako samostatný kontextový artefakt (dříve součást společného `intake/README.md`). | Libor Suchý |
| 2026-07-01 | Průvodce přesunut ze sidecaru `intake/meetings.md` do `meetings/README.md` (self-contained složka). Audio zůstává gitignorované ve složkách meetingů; `_source/` se nezavádí (přepisy jsou samy o sobě `.md`). | Libor Suchý |
| 2026-07-01 | Intro call 2026-06-15 zahozen (audio i přepis). README **resetováno na čistou metodiku** — odstraněny závěry z jednoho meetingu („Klíčové signály z intro callu"), katalog řádek a instanční Plaud poznámka. Signály zůstávají v git historii (commit `ca54218` a starší); do product/ se vytáhnou, až vrstva vznikne. Meetingy jedou z nuly novým toolem. | Libor Suchý |
