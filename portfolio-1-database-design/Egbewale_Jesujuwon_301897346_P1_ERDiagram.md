# Hospital / Clinic System — ER diagram

```mermaid
erDiagram
    direction LR
    clinic {
        bigint id PK
        text name
        text city
    }
    patient {
        bigint id PK
        text synthetic_patient_no UK
        text full_name
        date date_of_birth
    }
    clinician {
        bigint id PK
        text license_no UK
        text full_name
        text specialty
    }
    appointment {
        bigint id PK
        bigint patient_id FK
        bigint clinician_id FK
        bigint clinic_id FK
        timestamptz starts_at
        timestamptz ends_at
        text status
        text reason "Optional"
    }
    patient ||--o{ appointment : "patient_id"
    clinician ||--o{ appointment : "clinician_id"
    clinic ||--o{ appointment : "clinic_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Egbewale_Jesujuwon_301897346_ERDiagram.png)
