**Low Risk Evaluation Process Documentation**

**Document Version:** 1.0\
**Process Owner:** Risk Team\
**Last Updated:** May 2026\
**Approved By:**

**1. Purpose**

This document describes the Low Risk evaluation process used to assess
applications that may be approved directly by a Coordinator without a
full Risk Team review.

The purpose of this process is to automate the assessment of low-risk
applications using predefined scoring criteria and clear approval
responsibilities.

------------------------------------------------------------------------

**2. Scope**

This process applies to all applications evaluated under the Low Risk
workflow.

The system automatically assesses applications against predefined
criteria and determines whether approval authority belongs to the
Coordinator or the Risk Team.

------------------------------------------------------------------------

**3. Low Risk Evaluation Process**

The system evaluates applications using five criteria. Each criterion is
assigned a score according to predefined rules.

The total score determines whether the application falls within the
approval authority of the Coordinator or requires review by the Risk
Team.

A score of **-1** represents a **KO result (automatic failure)**.

If at least one criterion receives a score of **-1**, the overall result
automatically becomes **KO (-1)** regardless of other scores.

------------------------------------------------------------------------

**4. Scoring Criteria**

**4.1 Patron ≠ Applicant**

This criterion verifies whether the Applicant and Patron use different
email addresses.

| **Condition** | **Score** | **Description** |
|----|:--:|----|
| Email addresses do not match | 0 | Patron and Applicant have different email addresses |
| Email addresses match | -1 | Patron and Applicant use the same email address |

**4.2 Patron Status**

This criterion evaluates whether the Patron already exists in the system
and determines their status.

The criterion is maintained by a Risk Team member on the Patron Scoring
Card and remains linked to the Patron’s email address.

The most recently assigned value remains active and may be updated
during future applications associated with the same email address.

For newly created patrons, the default status is:

**N – Unknown**

| **Status** | **Score** | **Description**                            |
|------------|:---------:|--------------------------------------------|
| WL_Z       |    10     | Patron is known                            |
| WL_ZD      |    10     | Patron is known and trusted                |
| WL_N       |     0     | Patron is unknown                          |
| BL         |    -1     | Patron is listed on the internal blacklist |

**4.3 Applicant Status**

This criterion evaluates whether the Applicant already exists in the
system and determines their status.

The criterion is maintained by a Risk Team member on the Applicant
Scoring Card and remains linked to the Applicant’s email address.

The most recently assigned value remains active and may be updated
during future applications associated with the same email address.

For newly created applicants, the default status is:

**N – Unknown**

| **Status** | **Score** | **Description**                               |
|------------|:---------:|-----------------------------------------------|
| WL_Z       |    10     | Applicant is known                            |
| WL_ZD      |    10     | Applicant is known and trusted                |
| WL_N       |     0     | Applicant is unknown                          |
| BL         |    -1     | Applicant is listed on the internal blacklist |

------------------------------------------------------------------------

**4.4 Assistance Item Risk Level**

This criterion evaluates the risk associated with the requested
assistance item based on its value.

Configuration is maintained within the **Scoring Risks** section.

| **Risk Level** | **Score** |
|----------------|:---------:|
| Low            |    10     |
| Medium         |     0     |
| High           |    -1     |

**4.5 Payment Method**

This criterion evaluates the selected payment setup.

| **Payment Method** | **Score** | **Description** |
|----|:--:|----|
| Invoice to intermediary | 0 | Payment is processed through an intermediary invoice |
| Payment to Applicant's bank account | -1 | Payment is sent directly to the Applicant |

**5. Score Evaluation Rules**

The system sums all individual criterion scores.

Special rule:

- Any criterion with score **-1** immediately produces a **KO result**

- KO overrides all other scores

- No further score calculation affects the final result

------------------------------------------------------------------------

**6. Approval Decision Matrix**

Based on the final score, the approval responsibility is assigned as
follows:

| **Final Score** | **Approval Responsibility** |
|:---------------:|-----------------------------|
|      0–20       | Risk Team                   |
|       30        | Coordinator                 |
|     KO (-1)     | Risk Team                   |

**7. Coordinator Responsibilities**

When a Coordinator takes ownership of an application, the **Scoring-LR
(Low Risk Scoring)** tab must be reviewed.

The **Donation Payment Method** must be configured before the tab
becomes available.

The Coordinator must:

1.  Review the Low Risk scoring results

2.  Verify whether approval falls within their authority

3.  Perform a standard application review

4.  Validate all submitted documentation

5.  Assess any potentially suspicious or inconsistent information

If suspicious information or concerns regarding data accuracy are
identified, the application must be escalated to the Risk Team for
review.

If all required information and documentation are complete and valid,
the Coordinator may approve the application.

------------------------------------------------------------------------

**8. Change Management**

Changes to:

- scoring criteria

- score values

- evaluation logic

- final score thresholds

can only be implemented through an approved IT change request.

------------------------------------------------------------------------

**9. Definitions**

| **Term**     | **Definition**                                            |
|--------------|-----------------------------------------------------------|
| Applicant    | Person requesting assistance                              |
| Patron       | Person supporting or sponsoring the request               |
| Risk Team    | Team responsible for risk assessment and approvals        |
| Coordinator  | User authorized to process eligible Low Risk applications |
| KO           | Automatic failed evaluation result                        |
| Scoring Card | Configuration area where risk attributes are maintained   |
