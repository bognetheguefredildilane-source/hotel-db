-- 1. CLIENTS (Sans les ID en dur pour éviter les doublons)
INSERT INTO clients (last_name, first_name, phone_number, email) VALUES
('Smith',    'John',    '+1-555-0101', 'john.smith@email.com'),
('Dupont',   'Marie',   '+33-600-0102','marie.dupont@email.com'),
('Johnson',  'Bob',     '+1-555-0103', 'bob.johnson@email.com'),
('Martin',   'Claire',  '+33-600-0104','claire.martin@email.com'),
('Williams', 'Tom',     '+1-555-0105', 'tom.williams@email.com'),
('Bernard',  'Alice',   '+33-600-0106','alice.bernard@email.com'),
('Taylor',   'James',   '+1-555-0107', 'james.taylor@email.com'),
('Moreau',   'Sophie',  '+33-600-0108','sophie.moreau@email.com'),
('Anderson', 'Peter',   '+1-555-0109', 'peter.anderson@email.com'),
('Leroy',    'Emma',    '+33-600-0110','emma.leroy@email.com');

-- 2. ROOMS (Min 15) — BR-01, BR-03
-- -------------------------------------------------------------
INSERT INTO rooms (room_number, floor, room_type, max_capacity, base_price, operational_status) VALUES
-- 1er étage : Single
(101, 1, 'single', 1, 80.00,  'available'),
(102, 1, 'single', 1, 80.00,  'available'),
(103, 1, 'single', 2, 90.00,  'available'),
(104, 1, 'single', 2, 90.00,  'available'),
(105, 1, 'single', 1, 75.00,  'out of service'),
-- 2ème étage : Double
(201, 2, 'double', 2, 120.00, 'available'),
(202, 2, 'double', 2, 120.00, 'available'),
(203, 2, 'double', 3, 140.00, 'available'),
(204, 2, 'double', 3, 140.00, 'available'),
(205, 2, 'double', 2, 130.00, 'available'),
-- 3ème étage : Suite
(301, 3, 'suite',  4, 250.00, 'available'),
(302, 3, 'suite',  4, 250.00, 'available'),
(303, 3, 'suite',  6, 320.00, 'available'),
(304, 3, 'suite',  4, 280.00, 'available'),
(305, 3, 'suite',  2, 200.00, 'available');

-- 3. AMENITIES & ROOM_AMENITIES — BR-02
-- -------------------------------------------------------------
INSERT INTO amenities (amenity_id, amenity_name, description) VALUES
(1, 'Sea View',         'Vue directe sur l océan'),
(2, 'Balcony',          'Balcon privatif'),
(3, 'Bathtub',          'Baignoire de luxe'),
(4, 'WiFi',             'Connexion haut débit sans fil'),
(5, 'Air Conditioning', 'Climatisation réversible');

INSERT INTO room_amenities (room_number, amenity_id) VALUES
(101, 4), (101, 5),
(102, 4), (102, 5),
(103, 2), (103, 4), (103, 5),
(201, 1), (201, 4), (201, 5),
(202, 4), (202, 5),
(203, 1), (203, 2), (203, 4),
(301, 1), (301, 2), (301, 3), (301, 4), (301, 5),
(302, 1), (302, 3), (302, 4), (302, 5),
(303, 1), (303, 2), (303, 3), (303, 4), (303, 5);
 
TRUNCATE TABLE room_amenities;
INSERT INTO room_amenities (room_number, amenity_id) VALUES
(101, 4), (101, 5),
(102, 4), (102, 5),
(103, 2), (103, 4), (103, 5),
(201, 1), (201, 4), (201, 5),
(202, 4), (202, 5),
(203, 1), (203, 2), (203, 4),
(301, 1), (301, 2), (301, 3), (301, 4), (301, 5),
(302, 1), (302, 3), (302, 4), (302, 5),
(303, 1), (303, 2), (303, 3), (303, 4), (303, 5);
-- -------------------------------------------------------------
-- 4. SERVICES (Min 4) — BR-11
-- -------------------------------------------------------------
INSERT INTO services (service_id, service_name, description, price) VALUES
(1, 'Spa',        'Soins bien-être et relaxation', 60.00),
(2, 'Restaurant', 'Restaurant gastronomique',       35.00),
(3, 'Gym',        'Salle de sport équipée',         20.00),
(4, 'Pool',       'Piscine chauffée',               15.00);
-- Horaires variables selon le jour de la semaine (BR-11)
INSERT INTO service_schedule (service_id, day_of_week, opening_time, closing_time, capacity_per_slot) VALUES
-- Spa : Lundi à Samedi (fermé le Dimanche)
(1, 'Monday',    '09:00', '20:00', 10),
(1, 'Tuesday',   '09:00', '20:00', 10),
(1, 'Wednesday', '09:00', '20:00', 10),
(1, 'Thursday',  '09:00', '20:00', 10),
(1, 'Friday',    '09:00', '21:00', 15),
(1, 'Saturday',  '08:00', '21:00', 15),
-- Restaurant : 7j/7 avec horaires élargis le week-end
(2, 'Monday',    '07:00', '22:00', 50),
(2, 'Tuesday',   '07:00', '22:00', 50),
(2, 'Wednesday', '07:00', '22:00', 50),
(2, 'Thursday',  '07:00', '22:00', 50),
(2, 'Friday',    '07:00', '22:00', 50),
(2, 'Saturday',  '08:00', '23:00', 60),
(2, 'Sunday',    '08:00', '23:00', 60),
-- Gym : Lundi à Samedi
(3, 'Monday',    '06:00', '21:00', 30),
(3, 'Tuesday',   '06:00', '21:00', 30),
(3, 'Wednesday', '06:00', '21:00', 30),
(3, 'Thursday',  '06:00', '21:00', 30),
(3, 'Friday',    '06:00', '21:00', 30),
(3, 'Saturday',  '07:00', '20:00', 25),
-- Pool : 7j/7
(4, 'Monday',    '08:00', '19:00', 40),
(4, 'Tuesday',   '08:00', '19:00', 40),
(4, 'Wednesday', '08:00', '19:00', 40),
(4, 'Thursday',  '08:00', '19:00', 40),
(4, 'Friday',    '08:00', '19:00', 40),
(4, 'Saturday',  '08:00', '19:00', 50),
(4, 'Sunday',    '09:00', '18:00', 35);

-- 5. RESERVATIONS (Min 20) — BR-04, BR-06
-- Completed, cancelled, confirmed, pending + multi-chambres
-- -------------------------------------------------------------
INSERT INTO reservations
    (reservation_id, client_id, check_in_date, check_out_date, num_guests, status, creation_date, cancellation_date)
VALUES
-- Séjours terminés (Completed)
(1,  1, '2026-01-10', '2026-01-15', 1, 'completed', '2025-12-20 10:00:00', NULL),
(2,  2, '2026-01-20', '2026-01-25', 4, 'completed', '2025-12-22 14:00:00', NULL), 
(3,  3, '2026-02-01', '2026-02-08', 3, 'completed', '2026-01-05 09:00:00', NULL),
(4,  4, '2026-02-15', '2026-02-17', 1, 'completed', '2026-01-10 11:00:00', NULL),
(5,  5, '2026-03-01', '2026-03-05', 2, 'completed', '2026-02-01 10:00:00', NULL),
(6,  6, '2026-03-10', '2026-03-15', 4, 'completed', '2026-02-15 08:00:00', NULL),
(7,  7, '2026-04-01', '2026-04-04', 1, 'completed', '2026-03-01 12:00:00', NULL),
(8,  8, '2026-04-20', '2026-04-25', 2, 'completed', '2026-03-20 09:00:00', NULL),
(9,  1, '2026-05-01', '2026-05-03', 2, 'completed', '2026-04-10 10:00:00', NULL), 
(10, 2, '2026-05-10', '2026-05-15', 4, 'completed', '2026-04-15 11:00:00', NULL),
-- Annulées (Cancelled) — libèrent immédiatement les chambres
(11, 3, '2026-06-01', '2026-06-05', 1, 'cancelled', '2026-05-01 10:00:00', '2026-05-20 14:00:00'),
(12, 4, '2026-06-10', '2026-06-12', 2, 'cancelled', '2026-05-10 09:00:00', '2026-05-25 16:00:00'),
-- Confirmées futures (Confirmed)
(13, 5, '2026-11-01', '2026-11-05', 3, 'confirmed', '2026-09-01 10:00:00', NULL),
(14, 6, '2026-11-10', '2026-11-15', 1, 'confirmed', '2026-09-10 14:00:00', NULL),
(15, 7, '2026-11-20', '2026-11-25', 2, 'confirmed', '2026-09-15 09:00:00', NULL),
(16, 8, '2026-12-01', '2026-12-05', 4, 'confirmed', '2026-10-01 10:00:00', NULL),
-- En attente (Pending)
(17, 9, '2026-12-10', '2026-12-14', 2, 'pending',   '2026-10-15 08:00:00', NULL),
(18, 1, '2026-12-20', '2026-12-25', 1, 'pending',   '2026-10-15 09:00:00', NULL),
(19, 2, '2026-12-28', '2027-01-02', 3, 'pending',   '2026-10-16 11:00:00', NULL),
(20, 3, '2027-01-10', '2027-01-15', 4, 'pending',   '2026-10-17 10:00:00', NULL);

- -------------------------------------------------------------
-- 6. RESERVED_ROOMS — BR-04, BR-08 (Prix fixé à la réservation)
-- -------------------------------------------------------------
INSERT INTO reserved_rooms (reservation_id, room_number, nightly_price) VALUES
(1,  101, 80.00),
(2,  201, 120.00), 
(2,  202, 120.00),
(3,  301, 250.00),
(4,  102, 80.00),
(5,  203, 140.00),
(6,  302, 250.00),
(7,  103, 90.00),
(8,  204, 140.00),
(9,  104, 90.00),
(10, 303, 320.00),
-- Chambres de réservations annulées (doivent pouvoir être re-réservées)
(11, 102, 80.00),
(12, 201, 120.00),
-- Réservations futures
(13, 301, 260.00),
(14, 101, 85.00),
(15, 202, 125.00),
(16, 304, 280.00),
(17, 205, 130.00),
(18, 104, 92.00),
(19, 103, 92.00),
(20, 203, 145.00),
(20, 305, 205.00);
-- -------------------------------------------------------------
-- 7. SERVICE_BOOKINGS — BR-12 (Pendant le séjour et dans les horaires)
-- -------------------------------------------------------------
INSERT INTO service_bookings (reservation_id, service_id, booking_date, booking_time, quantity) VALUES
(1, 1, '2026-01-12', '10:00', 1), 
(1, 2, '2026-01-13', '19:00', 1), 
(2, 4, '2026-01-21', '09:00', 2), 
(3, 3, '2026-02-02', '07:00', 1), 
(3, 1, '2026-02-05', '14:00', 2), 
(5, 2, '2026-03-03', '12:00', 2), 
(6, 1, '2026-03-11', '11:00', 4), 
(8, 4, '2026-04-22', '10:00', 2); 
-- -------------------------------------------------------------
-- 8. INVOICES (Min 10) — BR-13, BR-15
-- Cas obligatoires : 1 paid, 1 partially paid, 1 due
-- -------------------------------------------------------------
INSERT INTO invoices (invoice_id, reservation_id, total_amount, tax_rate, status) VALUES
(1,  1,  484.00,  10.00, 'paid'),           
(2,  2,  1386.00, 10.00, 'partially paid'), 
(3,  3,  1942.00, 10.00, 'paid'),           
(4,  4,  176.00,  10.00, 'due'),            
(5,  5,  679.70,  10.00, 'paid'),           
(6,  6,  1430.00, 10.00, 'partially paid'), 
(7,  7,  297.00,  10.00, 'paid'),           
(8,  8,  792.00,  10.00, 'due'),            
(9,  9,  207.90,  10.00, 'due'),            
(10, 10, 1804.00, 10.00, 'due');    
-- -------------------------------------------------------------
-- 9. INVOICE_LINES — BR-13 (Nuits, services, divers)
-- -------------------------------------------------------------
INSERT INTO invoice_lines (invoice_id, line_type, description, quantity, unit_price) VALUES
(1, 'night',   'Chambre 101 - 5 nuits',  5, 80.00),
(1, 'service', 'Seance Spa',             1, 60.00),
(1, 'service', 'Diner Restaurant',       1, 35.00),
(2, 'night',   'Chambre 201 - 5 nuits',  5, 120.00),
(2, 'night',   'Chambre 202 - 5 nuits',  5, 120.00),
(2, 'service', 'Acces Piscine x2',       2, 15.00),
(3, 'night',   'Chambre 301 - 7 nuits',  7, 250.00),
(3, 'service', 'Acces Gym',              1, 20.00),
(3, 'service', 'Seance Spa x2',          2, 60.00),
(4, 'night',   'Chambre 102 - 2 nuits',  2, 80.00),
(5, 'night',   'Chambre 203 - 4 nuits',  4, 140.00),
(5, 'service', 'Dejeuner Restaurant x2', 2, 35.00),
(6, 'night',   'Chambre 302 - 5 nuits',  5, 250.00),
(6, 'service', 'Seance Spa x4',          4, 60.00),
(7, 'night',   'Chambre 103 - 3 nuits',  3, 90.00),
(8, 'night',   'Chambre 204 - 5 nuits',  5, 140.00),
(8, 'service', 'Acces Piscine x2',       2, 15.00),
(9, 'night',   'Chambre 104 - 2 nuits',  2, 90.00),
(10, 'night',  'Chambre 303 - 5 nuits',  5, 320.00);
-- -------------------------------------------------------------
-- 10. PAYMENTS — BR-14, BR-15
-- -------------------------------------------------------------
INSERT INTO payments (invoice_id, payment_date, amount, payment_method) VALUES
(1, '2026-01-16 10:00:00', 484.00,  'card'),          
(2, '2026-01-26 14:00:00', 700.00,  'mobile money'),  
(3, '2026-02-09 09:00:00', 1000.00, 'bank transfer'), 
(3, '2026-02-09 09:30:00', 942.00,  'bank transfer'),
(5, '2026-03-06 11:00:00', 679.70,  'cash'),          
(6, '2026-03-16 09:00:00', 500.00,  'cash'),          
(7, '2026-04-05 10:00:00', 297.00,  'card');
-- -------------------------------------------------------- 
-- 11. CLIENT_REVIEWS (Min 6) — BR-16, BR-17
-- Uniquement réservations 'completed', notes de 1 à 5
INSERT INTO client_reviews (reservation_id, rating, comment, review_date) VALUES
(1, 5, 'Super sejour ! Chambre propre et excellent accueil.', '2026-01-16'),
(2, 4, 'Tres belles chambres, la piscine etait parfaite.',   '2026-01-26'),
(3, 3, 'Bon sejour dans l ensemble, spa agreable.',           '2026-02-09'),
(4, 2, 'Chambre correcte mais service un peu lent.',          '2026-02-18'),
(5, 1, 'Mauvaise experience, chambre bruyante.',             '2026-03-06'),
(7, 5, 'Week-end parfait, nous reviendrons vite !',          '2026-04-05');
