-- Chambres d'un type donné disponibles entre deux dates.
SELECT 
    r.room_number,
    r.floor,
    r.room_type,
    r.max_capacity,
    r.base_price,
    r.operational_status
FROM rooms r
WHERE r.room_type = 'double'                         
  AND r.operational_status != 'out of service'       
  AND r.room_number NOT IN (
      SELECT rr.room_number
      FROM reserved_rooms rr
      JOIN reservations res ON rr.reservation_id = res.reservation_id
      WHERE res.status != 'cancelled'                
        AND res.check_in_date  < '2026-11-10'        
        AND res.check_out_date > '2026-11-01'        
  )
ORDER BY r.room_number ASC;

-- ============================================================================
SELECT
    DATE_FORMAT(r.check_in_date, '%Y-%m')                       AS mois,
    COUNT(DISTINCT rr.room_number)                              AS nb_chambres_occupees,
    SUM(DATEDIFF(r.check_out_date, r.check_in_date))            AS nuits_vendues,
    (SELECT COUNT(*) FROM rooms WHERE operational_status != 'out of service')
        * DAY(LAST_DAY(r.check_in_date))                        AS nuits_disponibles,
    ROUND(
        (SUM(DATEDIFF(r.check_out_date, r.check_in_date)) /
        (
            (SELECT COUNT(*) FROM rooms WHERE operational_status != 'out of service')
            * DAY(LAST_DAY(r.check_in_date))
        )) * 100, 2
    )                                                           AS taux_occupation_pct
FROM reservations r
JOIN reserved_rooms rr ON r.reservation_id = rr.reservation_id
WHERE r.status = 'completed'                                   
GROUP BY DATE_FORMAT(r.check_in_date, '%Y-%m'), LAST_DAY(r.check_in_date)
ORDER BY mois ASC;

-- ============================================================================
SELECT
    DATE_FORMAT(r.check_in_date, '%Y-%m')                       AS mois,
    COUNT(DISTINCT rr.room_number)                              AS nb_chambres_occupees,
    SUM(DATEDIFF(r.check_out_date, r.check_in_date))            AS nuits_vendues,
    -- Calcul dynamique du total de nuits disponibles dans le mois :
    (SELECT COUNT(*) FROM rooms WHERE operational_status != 'out of service')
        * DAY(LAST_DAY(r.check_in_date))                        AS nuits_disponibles,
    -- Ratio d'occupation en pourcentage arrondi à 2 décimales :
    ROUND(
        (SUM(DATEDIFF(r.check_out_date, r.check_in_date)) /
        (
            (SELECT COUNT(*) FROM rooms WHERE operational_status != 'out of service')
            * DAY(LAST_DAY(r.check_in_date))
        )) * 100, 2
    )                                                           AS taux_occupation_pct
FROM reservations r
JOIN reserved_rooms rr ON r.reservation_id = rr.reservation_id
WHERE r.status = 'completed'                                   
GROUP BY DATE_FORMAT(r.check_in_date, '%Y-%m'), LAST_DAY(r.check_in_date)
ORDER BY mois ASC;

SELECT
    i.invoice_id,
    i.reservation_id,
    c.last_name,
    c.first_name,
    c.phone_number,
    r.check_in_date,
    r.check_out_date,
    i.total_amount                                      AS montant_facture,
    COALESCE(SUM(p.amount), 0.00)                       AS total_deja_regle,
    (i.total_amount - COALESCE(SUM(p.amount), 0.00))    AS solde_restant_du,
    i.status                                            AS statut_facture,
    r.creation_date                                     AS date_creation_reservation
FROM invoices i
JOIN reservations r  ON i.reservation_id = r.reservation_id
JOIN clients c       ON r.client_id = c.client_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
WHERE i.status IN ('due', 'partially paid')            
GROUP BY
    i.invoice_id, i.reservation_id, c.last_name, c.first_name, c.phone_number,
    r.check_in_date, r.check_out_date, i.total_amount, i.status, r.creation_date
ORDER BY r.creation_date ASC;                           


-- RÈGLES APPLIQUÉES :
-- - BR-16, BR-17 : Association des avis aux types de chambres réservées
-- - Calcul de la moyenne (AVG) et comptage (COUNT)
-- ============================================================================
SELECT
    ro.room_type                AS type_de_chambre,
    COUNT(cr.review_id)         AS nombre_avis,
    ROUND(AVG(cr.rating), 2)    AS note_moyenne_sur_5
FROM client_reviews cr
JOIN reservations r    ON cr.reservation_id = r.reservation_id
JOIN reserved_rooms rr ON r.reservation_id  = rr.reservation_id
JOIN rooms ro          ON rr.room_number    = ro.room_number
GROUP BY ro.room_type
ORDER BY note_moyenne_sur_5 DESC;

-- - Dépenses réelles = Somme des paiements effectifs (table payments)
-- - Nombre de séjours = Nombre de réservations complétées distinctes (BR-10)
-- - Classement décroissant avec LIMIT 5
-- ============================================================================
SELECT
    c.client_id,
    c.last_name,
    c.first_name,
    c.email,
    COUNT(DISTINCT r.reservation_id)    AS nombre_de_sejours,
    COALESCE(SUM(p.amount), 0.00)       AS montant_total_depense
FROM clients c
JOIN reservations r  ON c.client_id = r.client_id
JOIN invoices i      ON r.reservation_id = i.reservation_id
LEFT JOIN payments p ON i.invoice_id = p.invoice_id
WHERE r.status = 'completed'            -- Uniquement les séjours effectués
GROUP BY c.client_id, c.last_name, c.first_name, c.email
ORDER BY montant_total_depense DESC
LIMIT 5;

