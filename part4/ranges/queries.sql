SELECT *
FROM appointments
WHERE appointment_time
      &&
      tstzrange(
          '2026-10-12 09:30+03',
          '2026-10-12 10:30+03',
          '[)'
      );

SELECT *
FROM appointments
WHERE appointment_time @>
      tstzrange(
          '2026-10-12 09:15+03',
          '2026-10-12 09:45+03',
          '[)'
      );

SELECT
    id,
    lower(appointment_time) AS starts_at,
    upper(appointment_time) AS ends_at
FROM appointments;