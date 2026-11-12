# Hospital / Clinic System — SQL queries

## 1. Show related appointment, patient, clinician records (up to 20).

```sql
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
```

| appointment_id | appointment_starts_at | patient_id | patient_synthetic_patient_no | clinician_id | clinician_license_no |
| --- | --- | --- | --- | --- | --- |
| 400 | 2026-11-13T09:00:00+00:00 | 200 | SYN-P-200 | 300 | SYN-L-300 |

## 2. Find appointment records where starts_at matches "2026-11-13T09:00:00Z" (up to 20).

```sql
SELECT * FROM portfolio."appointment"
WHERE "starts_at" IS NOT DISTINCT FROM '2026-11-13T09:00:00Z'
ORDER BY "id"
LIMIT 20;
```

| id | patient_id | clinician_id | clinic_id | starts_at | ends_at | status | reason |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 400 | 200 | 300 | 100 | 2026-11-13T09:00:00+00:00 | 2026-11-13T09:30:00+00:00 | booked | Routine checkup |

## 3. Count appointment records for each patient_id (up to 20 groups).

```sql
SELECT "patient_id", count(*) AS record_count
FROM portfolio."appointment"
GROUP BY "patient_id"
ORDER BY record_count DESC, "patient_id" NULLS LAST
LIMIT 20;
```

| patient_id | record_count |
| --- | --- |
| 200 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 1.013 | 1.013, 1.104, 0.998 | Sort → Seq Scan | 112 |
| After index | 0.21 | 0.263, 0.172, 0.21 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 25 |

The median execution time changed from 1.013 ms to 0.21 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=0.984..0.985 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.017..0.949 rows=20 loops=1)
Planning Time: 0.328 ms
Execution Time: 1.013 ms
```

### Before index, run 2

```text
Sort (actual time=0.969..0.971 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.017..0.931 rows=20 loops=1)
Planning Time: 0.326 ms
Execution Time: 1.104 ms
```

### Before index, run 3

```text
Sort (actual time=0.969..0.97 rows=20 loops=1)
  Seq Scan on appointment (actual time=0.018..0.933 rows=20 loops=1)
Planning Time: 0.341 ms
Execution Time: 0.998 ms
```

### After index, run 1

```text
Sort (actual time=0.162..0.164 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.041..0.113 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.019..0.019 rows=20 loops=1)
Planning Time: 0.733 ms
Execution Time: 0.263 ms
```

### After index, run 2

```text
Sort (actual time=0.119..0.121 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.028..0.084 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.013..0.013 rows=20 loops=1)
Planning Time: 0.647 ms
Execution Time: 0.172 ms
```

### After index, run 3

```text
Sort (actual time=0.127..0.129 rows=20 loops=1)
  Bitmap Heap Scan on appointment (actual time=0.032..0.09 rows=20 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.015..0.015 rows=20 loops=1)
Planning Time: 0.553 ms
Execution Time: 0.21 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run Egbewale_Jesujuwon_301897346_P2_Queries.sql, then Egbewale_Jesujuwon_301897346_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/Egbewale_Jesujuwon_301897346_P2_QueryResults.png) · [Index comparison](screenshots/Egbewale_Jesujuwon_301897346_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

