-- Fictional sample records for Hospital / Clinic System.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."clinic" ("id", "name", "city") VALUES (100, 'Northside Clinic', 'Portland');
INSERT INTO portfolio."patient" ("id", "synthetic_patient_no", "full_name", "date_of_birth") VALUES (200, 'SYN-P-200', 'Avery Morgan', '1988-04-12');
INSERT INTO portfolio."clinician" ("id", "license_no", "full_name", "specialty") VALUES (300, 'SYN-L-300', 'Jordan Lee', 'Family Medicine');
INSERT INTO portfolio."appointment" ("id", "patient_id", "clinician_id", "clinic_id", "starts_at", "ends_at", "status", "reason") VALUES (400, 200, 300, 100, '2026-11-13T09:00:00Z', '2026-11-13T09:30:00Z', 'booked', 'Routine checkup');
COMMIT;
