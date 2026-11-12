-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. clinic duplicate primary. Expected: pk_clinic, SQLSTATE 23505.
INSERT INTO portfolio."clinic" ("id", "name", "city")
VALUES (100, 'Eastside Clinic', 'Salem');

-- 2. patient duplicate primary. Expected: pk_patient, SQLSTATE 23505.
INSERT INTO portfolio."patient" ("id", "synthetic_patient_no", "full_name", "date_of_birth")
VALUES (200, 'SYN-P-1001', 'Casey Rivera', '1990-06-08');

-- 3. patient duplicate unique. Expected: uq_patient_0, SQLSTATE 23505.
INSERT INTO portfolio."patient" ("id", "synthetic_patient_no", "full_name", "date_of_birth")
VALUES (1001, 'SYN-P-200', 'Casey Rivera', '1990-06-08');

-- 4. clinician duplicate primary. Expected: pk_clinician, SQLSTATE 23505.
INSERT INTO portfolio."clinician" ("id", "license_no", "full_name", "specialty")
VALUES (300, 'SYN-L-1001', 'Taylor Quinn', 'Dermatology');

-- 5. clinician duplicate unique. Expected: uq_clinician_0, SQLSTATE 23505.
INSERT INTO portfolio."clinician" ("id", "license_no", "full_name", "specialty")
VALUES (1002, 'SYN-L-300', 'Taylor Quinn', 'Dermatology');

-- 6. appointment duplicate primary. Expected: pk_appointment, SQLSTATE 23505.
INSERT INTO portfolio."appointment" ("id", "patient_id", "clinician_id", "clinic_id", "starts_at", "ends_at", "status", "reason")
VALUES (400, 200, 300, 100, '2026-11-13T10:00:00Z', '2026-11-13T10:30:00Z', 'cancelled', 'Duplicate identifier test');

-- 7. appointment invalid patient. Expected: fk_appointment_0, SQLSTATE 23503.
INSERT INTO portfolio."appointment" ("id", "patient_id", "clinician_id", "clinic_id", "starts_at", "ends_at", "status", "reason")
VALUES (1003, 900001, 300, 100, '2026-11-13T11:00:00Z', '2026-11-13T11:30:00Z', 'cancelled', 'Reference test');

-- 8. appointment invalid clinician. Expected: fk_appointment_1, SQLSTATE 23503.
INSERT INTO portfolio."appointment" ("id", "patient_id", "clinician_id", "clinic_id", "starts_at", "ends_at", "status", "reason")
VALUES (1004, 200, 900002, 100, '2026-11-13T12:00:00Z', '2026-11-13T12:30:00Z', 'cancelled', 'Reference test');

-- 9. appointment invalid clinic. Expected: fk_appointment_2, SQLSTATE 23503.
INSERT INTO portfolio."appointment" ("id", "patient_id", "clinician_id", "clinic_id", "starts_at", "ends_at", "status", "reason")
VALUES (1005, 200, 300, 900003, '2026-11-13T13:00:00Z', '2026-11-13T13:30:00Z', 'cancelled', 'Reference test');

-- 10. clinic missing name. Expected: name, SQLSTATE 23502.
INSERT INTO portfolio."clinic" ("id", "name", "city")
VALUES (1006, NULL, 'Eugene');

-- 11. appointment invalid time order. Expected: appointment_time_order, SQLSTATE 23514.
INSERT INTO portfolio."appointment" ("id", "patient_id", "clinician_id", "clinic_id", "starts_at", "ends_at", "status", "reason")
VALUES (1007, 200, 300, 100, '2026-11-13T14:30:00Z', '2026-11-13T14:00:00Z', 'cancelled', 'Time order test');

-- 12. appointment invalid status. Expected: appointment_status_values, SQLSTATE 23514.
INSERT INTO portfolio."appointment" ("id", "patient_id", "clinician_id", "clinic_id", "starts_at", "ends_at", "status", "reason")
VALUES (1008, 200, 300, 100, '2026-11-13T15:00:00Z', '2026-11-13T15:30:00Z', 'pending', 'Status test');

-- 13. appointment duplicate booked slot. Expected: booked_clinician_slot, SQLSTATE 23505.
INSERT INTO portfolio."appointment" ("id", "patient_id", "clinician_id", "clinic_id", "starts_at", "ends_at", "status", "reason")
VALUES (1009, 200, 300, 100, '2026-11-13T09:00:00Z', '2026-11-13T10:00:00Z', 'booked', 'Slot uniqueness test');
