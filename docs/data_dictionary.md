-- 1. Clients Table (BR-09, BR-10)
CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(30) NOT NULL UNIQUE, -- BR-09: Unicité du téléphone
    email VARCHAR(150) NOT NULL UNIQUE        -- BR-09: Unicité de l'email
) ENGINE=InnoDB;

-- 2. Rooms Table (BR-01, BR-03)
CREATE TABLE rooms (
    room_number INT PRIMARY KEY,
    floor INT NOT NULL,
    room_type ENUM('single', 'double', 'suite') NOT NULL,
    max_capacity INT NOT NULL CHECK (max_capacity > 0),
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price >= 0), -- BR-15: DECIMAL, jamais FLOAT
    operational_status ENUM('available', 'occupied', 'being cleaned', 'out of service') NOT NULL DEFAULT 'available'
) ENGINE=InnoDB;

-- 3. Amenities Lookup Table (BR-02)
CREATE TABLE amenities (
    amenity_id INT AUTO_INCREMENT PRIMARY KEY,
    amenity_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
) ENGINE=InnoDB;

-- 4. Room Amenities Junction Table (BR-02)
CREATE TABLE room_amenities (
    room_number INT,
    amenity_id INT,
    PRIMARY KEY (room_number, amenity_id),
    -- Justification CASCADE : si une chambre ou un équipement est supprimé, la liaison est supprimée automatiquement
    FOREIGN KEY (room_number) REFERENCES rooms(room_number) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Services Table (BR-11)
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0)
) ENGINE=InnoDB;

-- 5b. Service Schedule Table (BR-11, BR-12)
CREATE TABLE service_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    service_id INT NOT NULL,
    day_of_week ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
    opening_time TIME NOT NULL,
    closing_time TIME NOT NULL,
    capacity_per_slot INT NOT NULL CHECK (capacity_per_slot > 0),
    CHECK (closing_time > opening_time),
    UNIQUE (service_id, day_of_week),
    -- Justification CASCADE : si le service est supprimé, son planning l'est aussi
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Reservations Table (BR-04, BR-05, BR-06)
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    num_guests INT NOT NULL CHECK (num_guests > 0),
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') NOT NULL DEFAULT 'pending',
    creation_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    cancellation_date DATETIME DEFAULT NULL,
    CHECK (check_out_date > check_in_date), -- BR-05
    -- Justification RESTRICT : on ne peut pas supprimer un client s'il a un historique de réservation
    FOREIGN KEY (client_id) REFERENCES clients(client_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 7. Reserved Rooms Table (BR-04, BR-08)
CREATE TABLE reserved_rooms (
    reservation_id INT,
    room_number INT,
    nightly_price DECIMAL(10, 2) NOT NULL CHECK (nightly_price >= 0), -- BR-08: Prix gelé à la réservation
    PRIMARY KEY (reservation_id, room_number),
    -- Justification CASCADE : si la réservation est annulée/supprimée, les lignes de réservation de chambres associées disparaissent
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    -- Justification RESTRICT : on ne peut pas supprimer une chambre physique si elle figure dans une réservation
    FOREIGN KEY (room_number) REFERENCES rooms(room_number) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Service Bookings Table (BR-12)
CREATE TABLE service_bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    service_id INT NOT NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    -- Justification CASCADE : si la réservation s'annule, les réservations de services associées sautent
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    -- Justification RESTRICT : on ne peut pas supprimer un service s'il a des réservations clients actives
    FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. Invoices Table (BR-13, BR-15)
CREATE TABLE invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE, -- BR-13: Une seule facture par réservation
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0), -- BR-15
    tax_rate DECIMAL(5, 2) NOT NULL CHECK (tax_rate >= 0),
    status ENUM('due', 'partially paid', 'paid') NOT NULL DEFAULT 'due',
    -- Justification RESTRICT : interdiction légale et comptable de supprimer une réservation déjà facturée
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. Invoice Lines Table (BR-13)
CREATE TABLE invoice_lines (
    line_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    line_type ENUM('night', 'service', 'miscellaneous') NOT NULL,
    description VARCHAR(255) NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL CHECK (unit_price >= 0),
    -- Justification CASCADE : supprimer une facture supprime automatiquement le détail de ses lignes
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 11. Payments Table (BR-14, BR-15)
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    invoice_id INT NOT NULL,
    payment_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL CHECK (amount > 0), -- BR-14: Montant strictement positif
    payment_method ENUM('cash', 'card', 'mobile money', 'bank transfer') NOT NULL,
    -- Justification RESTRICT : interdiction comptable de supprimer une facture qui a déjà des règlements enregistrés
    FOREIGN KEY (invoice_id) REFERENCES invoices(invoice_id) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 12. Client Reviews Table (BR-16, BR-17)
CREATE TABLE client_reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL UNIQUE, -- BR-16: Au plus un avis par réservation
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5), -- BR-17
    comment TEXT DEFAULT NULL,
    review_date DATE NOT NULL,
    -- Justification CASCADE : si la réservation est supprimée, l'avis associé est supprimé
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;