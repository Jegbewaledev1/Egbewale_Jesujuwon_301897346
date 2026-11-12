-- Show related appointment, patient, clinician records (up to 20).
SELECT t0."id" AS "appointment_id",
       t0."starts_at" AS "appointment_starts_at",
       t1."id" AS "patient_id",
       t1."synthetic_patient_no" AS "patient_synthetic_patient_no",
       t2."id" AS "clinician_id",
       t2."license_no" AS "clinician_license_no"
FROM portfolio."appointment" t0
JOIN portfolio."patient" t1 ON t0."patient_id" = t1."id"
JOIN portfolio."clinician" t2 ON t0."clinician_id" = t2."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."id" AS "appointment_id",
       t0."starts_at" AS "appointment_starts_at",
       t1."id" AS "patient_id",
       t1."synthetic_patient_no" AS "patient_synthetic_patient_no",
       t2."id" AS "clinician_id",
       t2."license_no" AS "clinician_license_no"
FROM portfolio."appointment" t0
JOIN portfolio."patient" t1 ON t0."patient_id" = t1."id"
JOIN portfolio."clinician" t2 ON t0."clinician_id" = t2."id"
ORDER BY t0."id", t1."id", t2."id"
LIMIT 20;

-- Find appointment records where starts_at matches "2026-11-13T09:00:00Z" (up to 20).
SELECT * FROM portfolio."appointment"
WHERE "starts_at" IS NOT DISTINCT FROM '2026-11-13T09:00:00Z'
ORDER BY "id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."appointment"
WHERE "starts_at" IS NOT DISTINCT FROM '2026-11-13T09:00:00Z'
ORDER BY "id"
LIMIT 20;

-- Count appointment records for each patient_id (up to 20 groups).
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;
