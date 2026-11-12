# Hospital / Clinic System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| patient_id | appointment records (list) |
| --- | --- |
| 200 | [400] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| appointment.id | appointment.patient_id | appointment.clinician_id | appointment.clinic_id | appointment.status | patient.id | patient.synthetic_patient_no | clinician.id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 400 | 200 | 300 | 100 | booked | 200 | SYN-P-200 | 300 |

Key: id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## appointment_example

| appointment.id | appointment.patient_id | appointment.clinician_id | appointment.clinic_id | appointment.status | patient.id | patient.synthetic_patient_no | clinician.id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 400 | 200 | 300 | 100 | booked | 200 | SYN-P-200 | 300 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## clinic

| id | name | city |
| --- | --- | --- |
| 100 | Northside Clinic | Portland |

## patient

| id | synthetic_patient_no | full_name | date_of_birth |
| --- | --- | --- | --- |
| 200 | SYN-P-200 | Avery Morgan | 1988-04-12 |

## clinician

| id | license_no | full_name | specialty |
| --- | --- | --- | --- |
| 300 | SYN-L-300 | Jordan Lee | Family Medicine |

## appointment

| id | patient_id | clinician_id | clinic_id | starts_at | ends_at | status | reason |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 400 | 200 | 300 | 100 | 2026-11-13T09:00:00+00:00 | 2026-11-13T09:30:00+00:00 | booked | Routine checkup |

## Dependencies

- clinic: (id) → name, city
- patient: (id) → synthetic_patient_no, full_name, date_of_birth
- clinician: (id) → license_no, full_name, specialty
- appointment: (id) → patient_id, clinician_id, clinic_id, starts_at, ends_at, status, reason

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
