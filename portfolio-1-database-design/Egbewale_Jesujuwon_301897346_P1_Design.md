# Hospital / Clinic System — database design

My case study records clinic, patient, clinician, appointment.

## Users

- Clinic schedulers manage appointments.
- Clinic managers review appointment summaries.

## Main operations

- Create and update appointments while enforcing valid time ranges and slot uniqueness.
- Review appointments with patient and clinician details, filter appointments by date and status, and summarize appointment counts by clinic.
- Benchmark the appointment date filter on the same 20000 synthetic appointments with and without a B-tree index on starts_at; compare query plans without assuming a result.

## Entities

| Entity | Information stored |
| --- | --- |
| clinic | A clinic location where appointments take place. |
| patient | A synthetic patient record referenced by appointments. |
| clinician | A clinician record with a fabricated license identifier and specialty. |
| appointment | A scheduled or completed visit linking one patient, clinician, and clinic. |

## clinic

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| name | TEXT |  | Yes |
| city | TEXT |  | Yes |


## patient

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| synthetic_patient_no | TEXT | Unique | Yes |
| full_name | TEXT |  | Yes |
| date_of_birth | DATE |  | Yes |
- Unique key: (synthetic_patient_no).

## clinician

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| license_no | TEXT | Unique | Yes |
| full_name | TEXT |  | Yes |
| specialty | TEXT |  | Yes |
- Unique key: (license_no).

## appointment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| id | BIGINT | PK | Yes |
| patient_id | BIGINT | FK | Yes |
| clinician_id | BIGINT | FK | Yes |
| clinic_id | BIGINT | FK | Yes |
| starts_at | TIMESTAMPTZ |  | Yes |
| ends_at | TIMESTAMPTZ |  | Yes |
| status | TEXT |  | Yes |
| reason | TEXT |  | No |
- patient_id → patient.id
- clinician_id → clinician.id
- clinic_id → clinic.id

## Relationships and business rules

- Each appointment must end later than it starts.
- Appointment status is limited to booked, cancelled, or completed.
- A clinician can have at most one appointment with booked status at an exact start time.
- Every appointment patient_id must refer to an existing patient.
- Every appointment clinician_id must refer to an existing clinician.
- Every appointment clinic_id must refer to an existing clinic.

## Assumptions

- Each appointment belongs to exactly one patient, one clinician, and one clinic.
- Appointment times use a consistent timezone, and ends_at must be later than starts_at.
- A clinician may have at most one booked appointment at an exact start time; this rule does not attempt to detect overlapping time ranges.
- All entity IDs are synthetic and globally unique across the entity tables.
- Names, license numbers, appointment reasons, and all benchmark records are fabricated.

