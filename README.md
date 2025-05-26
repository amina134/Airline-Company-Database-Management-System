# ✈️ Airline Company Database Management System

## 📝 Project Overview

This project consists of designing and implementing a **relational database** system for an airline company undergoing digital modernization. The goal is to manage flights, reservations, passengers, airports, personnel, and user access securely and efficiently using **Oracle Database**.

The system supports comprehensive data management, user role administration, and business logic automation to streamline airline operations.

---

## 📚 Database Schema

The database schema includes the following tables:

| Table Name           | Description                                  |
|---------------------|----------------------------------------------|
| **AVION**            | Stores airplane details (id, model, capacity, type) |
| **AEROPORT**         | Airport information (id, name, city, country) |
| **VOL**              | Flight details (id, departure date/time, arrival time, airplane, airports) |
| **PASSAGER**         | Passenger info (id, name, email, phone)       |
| **RESERVATION**      | Reservation info (id, passenger, flight, date, status) |
| **EMPLOYE**          | Employee details (id, name, position, email)  |
| **ASSIGNATION_EQUIPAGE** | Crew assignment for flights (flight id, employee id, role) |
| **BAGAGE**           | Baggage details (id, weight, reservation id) |
| **PRESENCE_VOL**     | Passenger presence on flight (passenger id, flight id, presence status) |
| **UTILISATEUR**      | System users (id, login, password, profile)   |

---

## 🎯 Project Objectives

- Create the relational schema with proper keys and constraints
- Insert sample data (at least 5 records per table)
- Implement user roles and access rights:
  - Administrator: full privileges
  - Reservation Agent: read/write on PASSAGER, RESERVATION, VOL
  - Flight Crew: read-only on assigned flights and passengers
- Write SQL and PL/SQL scripts for business queries and operations:
  - Search available flights between airports by date
  - Find passengers who booked but did not board
  - Calculate total baggage weight per reservation
  - List crew members per flight with roles
  - Identify the most used airplane
  - List canceled reservations
  - Compute flight occupancy rates
  - Calculate average baggage count per passenger
- Automate business rules:
  - Auto-create baggage records on reservation
  - Prevent employee assignment to overlapping flights
  - Prevent duplicate passenger bookings on the same flight
  - Secure user password storage
- Share data between schemas with appropriate privileges and synonyms

---


## ⚙️ Technologies Used

- Oracle Database (SQL, PL/SQL)
- User and role management in Oracle
- SQL scripting for relational data management

---

