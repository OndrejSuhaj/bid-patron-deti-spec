---
doc_id: EN0002
title: ApplicationProfile
canonical_layer: EN
spec_type: entity
status: canonical
modules: []
references:
  - EN0001 (Application)
  - EN0006 (Contact)
  - EN0008 (User)
  - EN0018 (Organisation)
  - EN0019 (Supplier)
  - BR-ApplicationStatusGovernance
  - BR-ScoringAndRiskGating
  - BR-PartyIdentityAndDeduplication
  - UC0001 (Submit Application)
  - UC0003 (Assess Applicant Risk)
---

# EN0002 — Profil žádosti

## Účel

ApplicationProfile je nejbohatší entita v doméně — rozsáhlý dotazník zachycující vše, co je známo o žádosti
(EN0001) z pohledu jedné strany: identitu žadatele/fundraisera, domácí příjmy a dluhy, dítě, patrona,
požadovaný dar/příspěvek, narativ příběhu a souhlasy. Žádost obsahuje nejvýše dva profily ApplicationProfile
— jeden profil fundraisera a jeden profil patrona — s diskriminátorem role profilu, přičemž profil je
postupně vyplňován v průběhu, jak žadatel prochází vícekrokovým formulářem žádosti.

---

## Životní cyklus

- Open (rozpracovaný) — vytvořen pro žádost a vyplňován krok po kroku; nemá vlastní doménový slovník stavů.
- Finished (dokončený) — žadatel profil dokončil a potvrdil.

Hypothesis — Not evidenced in current sources: žádný dossier nesleduje zápisovou cestu profilu od začátku
do konce, takže přesný okamžik, kdy je profil považován za dokončený (na rozdíl od stále editovatelného),
není potvrzen.

---

## Přechody stavů

(žádný) → Open  
trigger: UC0001 (Podání žádosti) — profil fundraisera nebo patrona je vytvořen pro nově založenou žádost.

Open → Finished  
trigger: Hypothesis — Not evidenced in current sources: přechod do stavu Finished je odvozen ze sledování
postupu (progress) na profilu; žádný dossier případu užití nepotvrzuje ukládací cestu, která jej nastavuje.

---

## Atributy

### Systémem spravované atributy

- profile_type (enum; povinný; fundraiser / patron — určuje, čí perspektivu profil představuje)
- source (enum; volitelný; vstupní kanál, kterým byl profil vytvořen; výchozí web)
- traffic_source, traffic_source_other (enum / text; volitelné; marketingová atribuční data zachycená při
  vstupu)
- ip_address, user_agent (text; systémově zaznamenávané; needitovatelné uživatelem)
- progress, progress_steps_completed (text / číslo; volitelné; sleduje, jak daleko byl vícekrokový formulář
  dokončen)
- finished, finished_timestamp (boolean / timestamp; volitelné; označuje a časově razítkuje dokončení
  profilu)

### Uživatelem zadávané atributy

- fundraiser, fundraiser_address2, fundraiser_employer (odkaz na EN0006 Kontakt; volitelné; identita
  žadatele a související strany adresy/zaměstnavatele)
- fundraiser_first_name, fundraiser_last_name, fundraiser_email, fundraiser_phone, fundraiser_rc,
  fundraiser_op_id, fundraiser_address (pole), fundraiser_id_series, fundraiser_id_number (text; volitelné;
  identita žadatele a údaje o adrese/dokladu totožnosti; fundraiser_id_number nese omezení délky specifické
  pro danou zemi)
- fundraiser_housing_type, fundraiser_income_type (odkaz na termíny referenčních dat; volitelné, vícenásobné;
  klasifikace bydlení a příjmu domácnosti)
- employed_status, receiving_social_benefits (enum / boolean; volitelné; stav zaměstnání/pobírání dávek
  žadatele)
- fundraiser_household_income, fundraiser_household_expenses (číslo; volitelné; deklarace příjmů/výdajů
  domácnosti)
- fundraiser_household_execution, fundraiser_household_insolvency, fundraiser_debts (pole) (boolean / text;
  volitelné; deklarace zadlužení/insolvence domácnosti)
- child (odkaz na EN0006 Kontakt; volitelné; obdarované dítě)
- school (odkaz na EN0006 Kontakt; volitelné; škola dítěte)
- child_first_name, child_last_name, child_rc, child_date_of_birth (text / datum; child_rc podmíněně
  povinný — viz Otevřené otázky; identita dítěte)
- child_unschoold (boolean; povinný; zda je dítě mimo školní docházku)
- child_dont_disclose_name, child_dont_disclose_photo, child_handicapped (boolean; volitelné; preference
  zveřejnění/souhlasu u dítěte a příznak zdravotního postižení)
- child_address (pole) (text; volitelné; adresa dítěte)
- patron (odkaz na EN0006 Kontakt; volitelné; strana patrona)
- patron_employer_id (odkaz na EN0018 Organizace; volitelné; zaměstnavatel patrona)
- patron_first_name, patron_last_name, patron_email, patron_phone (text; volitelné; identita patrona)
- patron_occupation_list (enum; volitelné; klasifikace povolání patrona)
- patron_photo (soubor; volitelné)
- patron_approve, patron_source, patron_reject, patron_reject_reason (boolean / enum / text; volitelné;
  rozhodnutí o přijetí patrona a důvod zamítnutí)
- gift_supplier (odkaz na EN0019 Dodavatel; volitelné; dodavatel plnící požadovaný dar)
- gift_category, gift_subcategory, gift_proof (odkaz na termíny referenčních dat; volitelné; klasifikace a
  požadovaný doklad pro požadovaný dar; gift_category je odvozena z gift_subcategory, pokud není nastavena
  explicitně)
- gift_payment_type (enum; volitelné; jakým způsobem má být dar/příspěvek uhrazen)
- gift_price (text; volitelné; požadovaná částka, podléhající omezení minimální ceny — viz Invarianty)
- gift_price_offer, gift_price_attachment (soubor / text; volitelné; podpůrná cenová nabídka a příloha)
- gift_author, gift_author_ico (text; volitelné; identita strany vystavující nabídku daru)
- gift_item, gift_note (text; volitelné; volný text popisující požadovaný dar)
- story_background, story_problems, story_solution (dlouhý text; volitelné; narativ popisující situaci
  rodiny, problém a požadované řešení)
- agreement_truthfulness (boolean; povinný; prohlášení, že uvedené informace jsou pravdivé)
- agreement_personal_data, agreement_rules (boolean; volitelné; souhlas se zpracováním osobních údajů a s
  pravidly platformy)
- attachement_child_photo, attachement_id_copy, attachement_documents, attachments_residence_permit,
  attachments_employment_registration, attachment_1..attachment_6, custom_attachment (soubor; volitelné,
  vícenásobné; podpůrné dokumenty a fotografie nahrané v průběhu žádosti)

---

## Invarianty

- Žádost (EN0001) obsahuje nejvýše jeden profil fundraisera a nejvýše jeden profil patrona — viz
  BR-ApplicationStatusGovernance.
- Požadovaná částka daru (gift_price) podléhá spodní hranici minimální ceny — viz BR-ScoringAndRiskGating,
  jak požadovaný dar vstupuje do rizikové brány.
- Rizikový scoring čte vstupy o povolání a způsobu úhrady daru z profilu fundraisera bez ohledu na to, ke
  které straně vstup logicky náleží — zaznamenaná vada provázání vlastnictví (owner-coupling); viz
  BR-ScoringAndRiskGating.
- Při sloučení (deduplikaci) kontaktu (EN0006) je každý závislý odkaz na profil přesměrován na přežívající
  kontakt — viz BR-PartyIdentityAndDeduplication.
- Při sloučení leadů (lead pairing/merge) se na přežívající žádost přenáší pouze profil patrona z duplicitní
  žádosti; existující profil patrona, který již přežívající žádost má, je tiše přepsán (osiřen), namísto
  sloučení — viz BR-PartyIdentityAndDeduplication.

---

## Vztahy

- EN0001 — Žádost (je držena; žádost odkazuje na svůj profil fundraisera a profil patrona ApplicationProfile)
- EN0006 — Kontakt (fundraiser, fundraiser_address2, fundraiser_employer, child, school, patron)
- EN0008 — Uživatel (vlastnící uživatel profilu)
- EN0018 — Organizace (patron_employer_id)
- EN0019 — Dodavatel (gift_supplier)

---

## Otevřené otázky

- Je child_rc skutečně vždy povinný, vzhledem k tomu, že profily vytvořené před zavedením tohoto omezení jej
  mohou postrádat?
- Existuje duplicitní definice pole pro atribut příjmu/pracovního oddělení žadatele — která definice je
  autoritativní, není potvrzeno.
- Mají atributy patronského klastru existovat na profilu fundraisera i patrona ApplicationProfile, nebo jen
  na profilu patrona? Aktuální zdroje ukazují jejich přítomnost bez ohledu na profile_type.
- Přeložitelnost (translatability) profilu je napříč zdroji evidence nekonzistentní — Conflict, requires
  clarification; zde neřešeno.
- Přesný spouštěč, který nastavuje stav Finished (dokončení profilu), není potvrzen žádným dossierem případu
  užití — Missing evidence.
