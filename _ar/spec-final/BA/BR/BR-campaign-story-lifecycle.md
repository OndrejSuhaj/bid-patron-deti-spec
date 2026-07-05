---
doc_id: BR-CampaignStoryLifecycle
title: Campaign / Story Lifecycle & Funding
layer: BR
spec_type: business-rule
status: imported
modules: []
affects:
  - EN0004
  - EN0001
  - EN0005
  - EN0009
  - SYSTEM
references:
  - EN0004
  - EN0001
  - EN0005
  - EN0009
  - UC0011
---

# BR – Životní cyklus a financování příběhu (Campaign / Story)

## Účel

Upravuje veřejný fundraisingový příběh (Campaign / Story, `EN0004`): jeho odvozenou vybranou částku,
podmínku připravenosti k publikaci, automatické dokončení po naplnění cíle, deadlinem řízené
nedokončení a rumunské pravidlo pracovního dne pro deadline.

---

## Odvozená vybraná částka

- Průběžná vybraná částka příběhu MUSÍ být odvozená hodnota rovná součtu částek jeho *uhrazených*
  darů, přepočítávaná při každém přepočtu příběhu.
- Částky darů ve stavu čekající, zrušené a vrácené NESMÍ přispívat do vybrané částky příběhu.
- Postup příběhu vyjádřený jako procento cíle MUSÍ být odvozen z jeho vybrané částky vůči cílové
  částce a NESMÍ být udržován jako samostatný údaj.

---

## Podmínka připravenosti k publikaci

- Příběh SMÍ být publikovatelný pouze tehdy, jsou-li splněny všechny následující podmínky: má
  navázanou žádost (`EN0001`), obsahuje veřejný profil patrona (`EN0005`), jeho cílová částka je větší
  než nula, jeho deadline leží v budoucnosti a jsou přítomny požadované obrázky.
- Příběh SMÍ obsahovat nejvýše jeden veřejný profil patrona (`EN0005`).
- Při úspěšné publikaci MUSÍ příběh i navázaná žádost přejít do svých aktivních stavů společně.
- Současný stav: u publikace se NEPŘEDPOKLÁDÁ transakční obalení — částečné selhání mezi přechodem na
  straně příběhu a přechodem na straně žádosti může ponechat příběh a navázanou žádost v nekonzistentním
  stavu (mezera v současném řešení; není vynucováno atomicky).

---

## Dokončení a nedokončení

- Příběh MUSÍ automaticky přejít do stavu dokončeno, je-li aktivní a jeho průběžná vybraná částka v
  okamžiku přepočtu dosáhne cílové částky nebo ji překročí.
- Dokončení příběhu MUSÍ v kaskádě převést navázanou žádost do stavu dokončeno.
- Příběh MUSÍ přejít do stavu nedokončeno, jakmile uplyne jeho deadline, zatímco je stále aktivní a
  jeho vybraná částka je nižší než cílová částka.
- Nedokončení příběhu MUSÍ převést navázanou žádost do statusu nedokončeno.
- Současný stav: dokončení se vyhodnocuje při přepočtu řízeném penězi (spouštěném zaznamenáním daru),
  nikoli podle pevného rozvrhu; deadlinem řízené nedokončení je plánovaná (naschedulovaná) větev tohoto
  pravidla.

---

## Pravidlo pracovního dne pro deadline

- Deadline příběhu na trhu Rumunsko MUSÍ připadat na pracovní den.
- Současný stav: kontrola pracovního dne je fail-open — pokud není dostupný kalendář státních svátků,
  je datum deadline považováno za pracovní den a pravidlo je obejito (za této chybové podmínky není
  vynucováno).

---

## Mimo rozsah

Tento dokument neupravuje:

- odmítnutí darů vůči již naplněnému příběhu (spravuje `BR-PaymentAndMoneyIntegrity`);
- konzistenci stavu žádosti a příběhu jako záležitost na straně žádosti (spravuje
  `BR-ApplicationStatusGovernance`);
- obsah nebo odesílání notifikací o úspěšném/nedokončeném příběhu (spravuje
  `BR-TransactionalMessaging`);
- pravidla kardinality profilu na vlastním agregátu navázané žádosti (spravuje
  `BR-ApplicationStatusGovernance`) — tento dokument uvádí pouze kardinalitu ≤1 veřejného profilu
  patrona na samotném příběhu.
