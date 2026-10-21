USE hotel_db;
DELIMITER $$
-- 1. TRIGGER BR-07 
-- Empêche deux réservations non-annulées de réserver la même chambre
-- Table : reserved_rooms (BEFORE INSERT)
CREATE TRIGGER trg_no_double_booking
BEFORE INSERT ON reserved_rooms
FOR EACH ROW
BEGIN
    DECLARE v_conflict_count INT DEFAULT 0;
    DECLARE v_new_checkin    DATE;
    DECLARE v_new_checkout   DATE;
    -- Recuperer les dates d'arrivée et depart de la réservation en cours d'insertion
    SELECT check_in_date, check_out_date
    INTO v_new_checkin, v_new_checkout
    FROM reservations
    WHERE reservation_id = NEW.reservation_id;
    -- Verifier s'il existe une réservation NON annulee sur la même chambre
    -- dont les dates se chevauchent avec les nouvelles dates :
    SELECT COUNT(*) INTO v_conflict_count
    FROM reserved_rooms rr
    JOIN reservations r ON rr.reservation_id = r.reservation_id
    WHERE rr.room_number = NEW.room_number
      AND r.status != 'cancelled'                   -- BR-07: une réservation annulée libère la chambre
      AND r.reservation_id != NEW.reservation_id    -- Ne pas comparer avec soi-même
      AND r.check_in_date  < v_new_checkout
      AND r.check_out_date > v_new_checkin;
    -- Si conflit détecté, on annule l'insertion avec un message d'erreur
    IF v_conflict_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'BR-07 VIOLATION: Cette chambre est deja reservee sur ces dates par une autre reservation active.';
    END IF;
END$$
