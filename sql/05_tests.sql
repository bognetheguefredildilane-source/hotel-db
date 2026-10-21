SELECT '>>> TEST 1 : BR-05 Check-out <= Check-in (DOIT ECHOUER) <<<' AS execution_test;
INSERT INTO reservations (client_id, check_in_date, check_out_date, num_guests, status)
VALUES (1, '2026-11-15', '2026-11-15', 1, 'pending');
       
SELECT '>>> TEST 2 : BR-07 Double réservation de chambre (DOIT ECHOUER) <<<' AS execution_test;
-- Création de la réservation temporaire
INSERT INTO reservations (reservation_id, client_id, check_in_date, check_out_date, num_guests, status)
VALUES (999, 3, '2026-01-12', '2026-01-18', 1, 'confirmed');

-- Tentative d'affectation de la chambre 101 déjà occupée sur cette période
INSERT INTO reserved_rooms (reservation_id, room_number, nightly_price)
VALUES (999, 101, 80.00);

-- Nettoyage de la réservation temporaire
DELETE FROM reservations WHERE reservation_id = 999;

-- TEST 3 : BR-16 — Avis déposé sur une réservation NON complétée
-- =============================================================
SELECT '>>> TEST 3 : BR-16 Avis sur séjour non terminé (DOIT ECHOUER) <<<' AS execution_test;
INSERT INTO client_reviews (reservation_id, rating, comment, review_date)
VALUES (13, 5, 'Super séjour futur !', '2026-11-06');

-- TEST 4 : BR-12 — Réservation de service HORS des dates de séjour
SELECT '>>> TEST 4 : BR-12 Service hors séjour (DOIT ECHOUER) <<<' AS execution_test;
INSERT INTO service_bookings (reservation_id, service_id, booking_date, booking_time, quantity)
VALUES (7, 1, '2026-04-10', '10:00', 1);

SELECT '>>> VERIFICATION : Répartition des statuts de factures <<<' AS test;
SELECT status, COUNT(*) AS nombre_factures, SUM(total_amount) AS total_facture
FROM invoices
GROUP BY status;

SELECT '>>> VERIFICATION : Cas limite client sans réservation (Emma Leroy) <<<' AS test;
SELECT c.client_id, c.last_name, c.first_name, COUNT(r.reservation_id) AS nb_reservations
FROM clients c
LEFT JOIN reservations r ON c.client_id = r.client_id
GROUP BY c.client_id, c.last_name, c.first_name
HAVING nb_reservations = 0;
