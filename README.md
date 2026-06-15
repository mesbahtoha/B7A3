# 🎫 Football Ticket Booking System
### Database Design & SQL Queries Assignment

**Author:** Md. Mesbahul Alam  
**Database:** PostgreSQL  

---

## 📋 Project Overview

This project implements a **Football Ticket Booking System** database that manages:
- Football fans and administrative staff (Users)
- Tournament match schedules and availability (Matches)
- Individual ticket purchase records (Bookings)

---

## 🗂️ Repository Structure

```
├── README.md          → Project documentation (this file)
├── QUERY.sql          → Full DDL, sample data, and all SQL queries
└── ERD.png            → draw.io ERD diagram screenshot
```

---

## 🗄️ Database Schema

### Users Table
| Column | Type | Constraints |
|---|---|---|
| user_id | INT | PRIMARY KEY, NOT NULL |
| full_name | VARCHAR(100) | NOT NULL |
| email | VARCHAR(100) | NOT NULL, UNIQUE |
| role | VARCHAR(20) | NOT NULL, CHECK ('Ticket Manager', 'Football Fan') |
| phone_number | VARCHAR(20) | NULLABLE |

### Matches Table
| Column | Type | Constraints |
|---|---|---|
| match_id | INT | PRIMARY KEY, NOT NULL |
| fixture | VARCHAR(100) | NOT NULL |
| tournament_category | VARCHAR(50) | NOT NULL |
| base_ticket_price | DECIMAL(10,2) | NOT NULL, CHECK (>= 0) |
| match_status | VARCHAR(20) | NOT NULL, CHECK ('Available', 'Selling Fast', 'Sold Out', 'Postponed') |

### Bookings Table
| Column | Type | Constraints |
|---|---|---|
| booking_id | INT | PRIMARY KEY, NOT NULL |
| user_id | INT | FOREIGN KEY → Users(user_id) |
| match_id | INT | FOREIGN KEY → Matches(match_id) |
| seat_number | VARCHAR(10) | NULLABLE |
| payment_status | VARCHAR(20) | CHECK ('Pending', 'Confirmed', 'Cancelled', 'Refunded') or NULL |
| total_cost | DECIMAL(10,2) | NOT NULL, CHECK (>= 0) |

---

## 🔗 Entity Relationship Diagram (ERD)

> **ERD Link:** [Click here to view the ERD on draw.io](https://drive.google.com/file/d/1i89Jvld4A-R0iPniZ5a9n1dvybFrfomK/view?usp=sharing)

### Relationships:
- **One User → Many Bookings** (A fan can buy tickets for multiple matches)
- **One Match → Many Bookings** (A match can have thousands of bookings)
- **One Booking → One User** (Each booking belongs to exactly one user)
- **One Booking → One Match** (Each booking is for exactly one match)

---

## 📝 SQL Queries Summary

| Query | Description | Concepts Used |
|---|---|---|
| Query 1 | Champions League matches with 'Available' status | WHERE, AND |
| Query 2 | Users whose name starts with 'Tanvir' or contains 'Haque' | ILIKE |
| Query 3 | Bookings with missing payment status | IS NULL, COALESCE |
| Query 4 | Booking details with user name and match fixture | INNER JOIN |
| Query 5 | All users with bookings, including fans with no tickets | LEFT JOIN |
| Query 6 | Bookings with total cost above average | Subquery, AVG() |
| Query 7 | Top 2 matches by price, skipping the most expensive | ORDER BY, LIMIT, OFFSET |

---

## 🚀 How to Run

### Prerequisites
- PostgreSQL installed and running

### Steps

**1. Clone the repository:**
```bash
git clone <your-github-repo-link>
cd football-ticket-booking-system
```

**2. Connect to PostgreSQL:**
```bash
psql -U postgres
```

**3. Create a new database:**
```sql
CREATE DATABASE football_ticket_db;
\c football_ticket_db
```

**4. Run the SQL file:**
```bash
psql -U postgres -d football_ticket_db -f QUERY.sql
```

**5. Verify the data:**
```sql
SELECT * FROM Users;
SELECT * FROM Matches;
SELECT * FROM Bookings;
```

---

## 📊 Sample Data

### Users
| user_id | full_name | role |
|---|---|---|
| 1 | Tanvir Rahman | Football Fan |
| 2 | Asif Haque | Football Fan |
| 3 | Sajjad Rahman | Ticket Manager |
| 4 | Jannat Ara | Football Fan |

### Matches
| match_id | fixture | tournament_category | price | status |
|---|---|---|---|---|
| 101 | Real Madrid vs Barcelona | Champions League | 150.00 | Available |
| 102 | Man City vs Liverpool | Premier League | 120.00 | Selling Fast |
| 103 | Bayern Munich vs PSG | Champions League | 130.00 | Available |
| 104 | AC Milan vs Inter Milan | Serie A | 90.00 | Sold Out |
| 105 | Juventus vs Roma | Serie A | 80.00 | Available |

---

## 🎯 Key Design Decisions

- **Referential Integrity:** Both FK constraints use `ON DELETE CASCADE` and `ON UPDATE CASCADE` to keep data consistent when a user or match is removed.
- **NULL Handling:** `phone_number` and `seat_number` are intentionally nullable since some users may not provide a phone number, and some bookings may not yet have an assigned seat.
- **CHECK Constraints:** All status fields are restricted to predefined allowed values to prevent invalid data entry.
- **UNIQUE Email:** Each user must have a distinct email address to prevent duplicate account registration.

---

## 📹 Theory Video (Viva Practice)

> **Video Link:** [Click here](https://drive.google.com/file/d/12ePuGY2I9pvkl990xytgSbaXqX7XGMAJ/view?usp=sharing)

---

*Submitted as part of the Database Design & SQL Queries Assignment.*
