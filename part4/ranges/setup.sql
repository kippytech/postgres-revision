DROP TABLE IF EXISTS appointments;

CREATE TABLE appointments (
    id BIGSERIAL PRIMARY KEY,
    doctor_id BIGINT NOT NULL,
    appointment_time TSTZRANGE NOT NULL
);

INSERT INTO appointments (doctor_id, appointment_time)
VALUES
(
    1,
    '[2026-10-12 09:00+03,2026-10-12 10:00+03)'
),
(
    1,
    '[2026-10-12 10:00+03,2026-10-12 11:00+03)'
),
(
    2,
    '[2026-10-12 09:30+03,2026-10-12 10:30+03)'
);

CREATE INDEX idx_appointments_time
ON appointments
USING GIST (appointment_time);