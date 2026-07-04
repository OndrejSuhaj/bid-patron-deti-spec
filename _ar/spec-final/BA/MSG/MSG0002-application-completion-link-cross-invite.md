---
doc_id: MSG0002
title: Application Completion Link (Cross-Invite)
canonical_layer: MSG
spec_type: transactional-message
status: canonical
modules: []
trigger:
  - UC0001
  - UC0002
references:
  - EN0001
  - EN0003
  - ES0006
---

# MSG0002 – Odkaz na dokončení žádosti (křížové pozvání)

## Účel

Pozvat protistranu na oboustranné žádosti (Žádost), aby dokončila svou polovinu formuláře žádosti.
Ať už svou část jako první vyplní kterákoli ze stran (Rodič/Žadatel nebo Patron), systém odešle tuto
zprávu druhé, dosud nezapojené straně, aby mohla být žádost dokončena. Stejný typ zprávy se používá
znovu i v případě, že je nominován nový Patron poté, co původní Patron žádost nedokončil nebo ji
odmítl — nově nominovaný Patron obdrží stejný druh pozvánky k dokončení své části.

Jde o samostatné odeslání odlišné od stavem řízeného rozesílání notifikací (viz třída MSG0001,
zprávy typu stav→role řízené entitou ApplicationReaction, UC0002.2): tato zpráva je spouštěna přímo
akcí odeslání formuláře / nominace patrona, nikoli obecnou reakcí na změnu stavu.

---

## Spouštěč

- **UC0001 (Odeslání žádosti)** — dílčí tok samoregistrace/odeslání, v okamžiku, kdy je přijata
  část žádosti od první strany a je vytvořena žádost (EN0001) se svými dvěma relacemi rolí
  (Confirmed — UC0001 hlavní tok, krok 9; podloženo FLW0010: jedna relace je vytvořena pro
  odesílající roli s rozhraním `authenticated`/výchozím a jedna pro protistranu s rozhraním
  `invited`).
- **UC0002 (Orchestrace změny stavu žádosti)**, větev změny patrona — když žádost vstoupí do stavu
  „vrácená žádost / hledání nového patrona" (původní Patron nedokončil žádost včas nebo ji aktivně
  odmítl) a Rodič následně poskytne kontaktní údaje nového Patrona, je stejná zpráva s odkazem na
  dokončení odeslána tomuto nově nominovanému Patronovi.

Spouštěcí stavy/události pozorované v Notification Matrix a v akceptačních scénářích SC:

- Rodič odešle jako první → odkaz je odeslán Patronovi (je vstoupeno do stavu `waiting_for_patron`)
  — SC-1A, krok 11.
- Patron odešle jako první → odkaz je odeslán Rodiči (je vstoupeno do stavu
  `waiting_for_fundraiser`) — SC-1B, krok 12.
- Rodič poskytne kontaktní údaje nového Patrona poté, co původní Patron žádost nedokončil / ji
  odmítl → odkaz je odeslán novému Patronovi (stav `waiting_for_patron` je (znovu) vstoupen) —
  SC-2C, SC-2D krok 9, SC-6A krok 6.

---

## Příjemci

Pozvaná protistrana na žádosti — nikdy strana, která právě odeslala svou část:

| Scénář | Příjemce | Kanál |
|---|---|---|
| Rodič odeslal jako první | Patron (vč. nově nominovaného Patrona ve větvi změny patrona) | E-mail přes ES0006 (Mautic) |
| Patron odeslal jako první | Rodič/Žadatel | E-mail přes ES0006 (Mautic) |
| Nový Patron nominovaný po nedokončení/odmítnutí ze strany původního Patrona | Nový Patron | E-mail přes ES0006 (Mautic) |

Notifikace v účtu/zóně není pro tuto zprávu primárním kanálem: samotný funkční odkaz je doručen
e-mailem; odpovídající stav zóny („Čeká na patrona", „Dokončete žádost" atd.) je důsledkem
zobrazení stavu, nikoli kopií této zprávy, a je součástí stavem řízené sady notifikací, nikoli
této zprávy MSG.

CZ je primární doložená lokalita; u RO/MD se očekává doručení lokalizovaného ekvivalentu stejného
typu zprávy, v souladu s platformním rozlišováním šablon podle země (FN0019), avšak žádná
RO/MD specifická obsahová varianta této konkrétní zprávy nad rámec lokalizace není doložena.

---

## Obsah zprávy

Konceptuální informační prvky, které zpráva musí obsahovat (bez šablonového značení, bez znění
předmětu zprávy):

- Informaci o tom, kdo žádost inicioval a jménem koho je příjemce zván (např. že Rodič/Žadatel
  založil žádost pro dítě, nebo že Patron nabídl podporu dítěti, s uvedením jména dítěte tam, kde
  je to tokem doloženo).
- Jedinečný, funkční odkaz, který otevře vlastní část formuláře žádosti příjemce — realizovaný jako
  relace žádosti (ApplicationSession, EN0003) s rolí invited, vytvořená pro žádost (EN0001) v
  okamžiku odeslání (nebo vytvořená znovu pro nově nominovaného Patrona).
- Vyjádření toho, co se od příjemce očekává — dokončení jeho části žádosti/příběhu, aby žádost
  mohla pokračovat.
- Implicitní očekávání, že odkaz je vázán na tuto konkrétní pozvánku a později se stane neplatným
  (nahrazeným novým odkazem), pokud příjemce nebude jednat a protistrana bude změněna — viz chování
  invalidace relace ve větvi změny patrona (UC0002.2, hlavní tok, krok 7 (reakce invalidace relace),
  souběžně s alternativním tokem AF3 výmazu dat patrona), což je samostatná událost životního cyklu,
  nikoli součást obsahu této zprávy.

Žádné HTML, styly, detaily poskytovatele e-mailu/SMTP ani doslovný text předmětu zde nejsou
definovány; skutečné znění/rozlišování šablon patří do funkce zasílání zpráv (FN0019) a je mimo
rozsah této smluvní specifikace MSG.
