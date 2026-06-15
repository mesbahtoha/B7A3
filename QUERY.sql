-- =========================================================================
-- SYSTEM: Football Ticket Booking System
-- AUTHOR: Md. Mesbahul Alam
-- =========================================================================

DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL,
    phone_number VARCHAR(20),

    CONSTRAINT pk_users PRIMARY KEY (user_id),
    CONSTRAINT uk_users_email UNIQUE (email),

    CONSTRAINT chk_users_role
    CHECK (role IN ('Ticket Manager', 'Football Fan'))
);

-- =========================================================================
-- MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id INT NOT NULL,
    fixture VARCHAR(100) NOT NULL,
    tournament_category VARCHAR(50) NOT NULL,
    base_ticket_price DECIMAL(10,2) NOT NULL,
    match_status VARCHAR(20) NOT NULL,

    CONSTRAINT pk_matches PRIMARY KEY (match_id),

    CONSTRAINT chk_matches_price
    CHECK (base_ticket_price >= 0),

    CONSTRAINT chk_matches_status
    CHECK (
        match_status IN (
            'Available',
            'Selling Fast',
            'Sold Out',
            'Postponed'
        )
    )
);

-- =========================================================================
-- BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id INT NOT NULL,
    user_id INT NOT NULL,
    match_id INT NOT NULL,
    seat_number VARCHAR(10),
    payment_status VARCHAR(20),
    total_cost DECIMAL(10,2) NOT NULL,

    CONSTRAINT pk_bookings PRIMARY KEY (booking_id),

    CONSTRAINT fk_bookings_user
    FOREIGN KEY (user_id)
    REFERENCES Users(user_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT fk_bookings_match
    FOREIGN KEY (match_id)
    REFERENCES Matches(match_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,

    CONSTRAINT chk_bookings_cost
    CHECK (total_cost >= 0),

    CONSTRAINT chk_bookings_status
    CHECK (
        payment_status IN (
            'Pending',
            'Confirmed',
            'Cancelled',
            'Refunded'
        )
        OR payment_status IS NULL
    )
);

-- =========================================================================
-- SAMPLE DATA: USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- SAMPLE DATA: MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- SAMPLE DATA: BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);

-- =========================================================================
-- QUERY 1
-- =========================================================================
SELECT
    match_id,
    fixture,
    ROUND(base_ticket_price) AS base_ticket_price
FROM Matches
WHERE tournament_category = 'Champions League'
AND match_status = 'Available';

-- =========================================================================
-- QUERY 2
-- =========================================================================
SELECT
    user_id,
    full_name,
    email
FROM Users
WHERE full_name ILIKE 'Tanvir%'
OR full_name ILIKE '%Haque%';

-- =========================================================================
-- QUERY 3
-- =========================================================================
SELECT
    booking_id,
    user_id,
    match_id,
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings
WHERE payment_status IS NULL;

-- =========================================================================
-- QUERY 4
-- =========================================================================
SELECT
    b.booking_id,
    u.full_name,
    m.fixture,
    ROUND(b.total_cost) AS total_cost
FROM Bookings b
INNER JOIN Users u
ON b.user_id = u.user_id
INNER JOIN Matches m
ON b.match_id = m.match_id;

-- =========================================================================
-- QUERY 5
-- =========================================================================
SELECT
    u.user_id,
    u.full_name,
    b.booking_id
FROM Users u
LEFT JOIN Bookings b
ON u.user_id = b.user_id
ORDER BY u.user_id;

-- =========================================================================
-- QUERY 6
-- =========================================================================
SELECT
    booking_id,
    match_id,
    ROUND(total_cost) AS total_cost
FROM Bookings
WHERE total_cost >
(
    SELECT AVG(total_cost)
    FROM Bookings
);

-- =========================================================================
-- QUERY 7
-- =========================================================================
SELECT
    match_id,
    fixture,
    ROUND(base_ticket_price) AS base_ticket_price
FROM Matches
ORDER BY base_ticket_price DESC
LIMIT 2
OFFSET 1;