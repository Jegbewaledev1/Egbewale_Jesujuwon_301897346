-- Hospital / Clinic System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."clinic" (
  "id" bigint NOT NULL,
  "name" text NOT NULL,
  "city" text NOT NULL,
  CONSTRAINT "pk_clinic" PRIMARY KEY ("id")
);
CREATE TABLE portfolio."patient" (
  "id" bigint NOT NULL,
  "synthetic_patient_no" text NOT NULL,
  "full_name" text NOT NULL,
  "date_of_birth" date NOT NULL,
  CONSTRAINT "pk_patient" PRIMARY KEY ("id"),
  CONSTRAINT "uq_patient_0" UNIQUE ("synthetic_patient_no")
);
CREATE TABLE portfolio."clinician" (
  "id" bigint NOT NULL,
  "license_no" text NOT NULL,
  "full_name" text NOT NULL,
  "specialty" text NOT NULL,
  CONSTRAINT "pk_clinician" PRIMARY KEY ("id"),
  CONSTRAINT "uq_clinician_0" UNIQUE ("license_no")
);
CREATE TABLE portfolio."appointment" (
  "id" bigint NOT NULL,
  "patient_id" bigint NOT NULL,
  "clinician_id" bigint NOT NULL,
  "clinic_id" bigint NOT NULL,
  "starts_at" timestamptz NOT NULL,
  "ends_at" timestamptz NOT NULL,
  "status" text NOT NULL,
  "reason" text,
  CONSTRAINT "pk_appointment" PRIMARY KEY ("id")
);
ALTER TABLE portfolio."appointment" ADD CONSTRAINT "fk_appointment_0" FOREIGN KEY ("patient_id") REFERENCES portfolio."patient" ("id");
ALTER TABLE portfolio."appointment" ADD CONSTRAINT "fk_appointment_1" FOREIGN KEY ("clinician_id") REFERENCES portfolio."clinician" ("id");
ALTER TABLE portfolio."appointment" ADD CONSTRAINT "fk_appointment_2" FOREIGN KEY ("clinic_id") REFERENCES portfolio."clinic" ("id");
ALTER TABLE portfolio."appointment" ADD CONSTRAINT "appointment_time_order" CHECK ("ends_at" > "starts_at");
ALTER TABLE portfolio."appointment" ADD CONSTRAINT "appointment_status_values" CHECK (("status" = 'booked') OR (("status" = 'cancelled') OR ("status" = 'completed')));
CREATE UNIQUE INDEX "booked_clinician_slot" ON portfolio."appointment" ("clinician_id", "starts_at") WHERE ("status" = 'booked');
COMMIT;
