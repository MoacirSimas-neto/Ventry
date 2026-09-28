# Ventry

Ventry is an event ticketing platform currently under development, focused on database design, transactional purchases, stock control and backend architecture.

The project started as a database learning project and is being progressively refactored into a complete ticketing system.

> Current status: database core completed through Phase 3.

---

## About

Ventry simulates the main business rules of an event ticketing platform.

The system is being designed to manage:

- Events
- Organizers
- Venues
- Ticket types
- Ticket batches
- Customers
- Purchases
- Stock availability
- Individual tickets
- Payments
- Event check-in

The current focus is building a reliable database foundation before moving to the API and frontend.

---

## Current progress

### Phase 1 — V1 Analysis
Completed

The original database was reviewed to identify modeling issues, naming inconsistencies, missing constraints and weaknesses in stock control.

### Phase 2 — Database Refactoring
Completed

Ventry V2 was rebuilt with:

- Standardized table and column names
- Primary and foreign keys
- `NOT NULL` constraints
- `UNIQUE` constraints
- `CHECK` constraints
- Improved relational modeling
- Explicit stock availability

### Phase 3 — Stock and Transactions
Completed

The transactional purchase flow currently includes:

- Atomic stock updates
- Stock validation
- `START TRANSACTION`
- `COMMIT`
- `ROLLBACK`
- `ROW_COUNT()`
- `LAST_INSERT_ID()`
- Stored procedures
- Automatic rollback on SQL errors
- Validation for invalid customer, ticket batch and quantity
- Protection against overselling
- Concurrency testing using two database sessions

The stock system was tested to ensure that two simultaneous transactions cannot sell the same last ticket.

### Phase 4 — Ticketing Model
Next

The next phase will introduce:

- Individual tickets
- Unique ticket codes
- Payments
- Ticket status
- Check-in
- Duplicate check-in prevention

---

## Technologies

Currently used:

- MySQL
- MySQL Workbench
- SQL
- Stored Procedures
- Transactions
- Git
- GitHub

Planned:

- Python
- FastAPI
- REST API
- Authentication
- React
- Docker

---

## Repository structure

```text
Ventry/
├── database/
│   ├── schema.sql
│   ├── procedures.sql
│   ├── seed.sql
│   └── tests.sql
└── README.md
Roadmap
Phase 1  ██████████ 100%  V1 analysis
Phase 2  ██████████ 100%  Database refactoring
Phase 3  ██████████ 100%  Stock and transactions
Phase 4  ░░░░░░░░░░   0%  Ticketing model
Phase 5  ░░░░░░░░░░   0%  API
Phase 6  ░░░░░░░░░░   0%  Authentication
Phase 7  ░░░░░░░░░░   0%  Testing and documentation
Phase 8  ░░░░░░░░░░   0%  Frontend
Phase 9  ░░░░░░░░░░   0%  Deployment
Project goals
Ventry is being developed to improve practical knowledge in:
- Relational database design
- SQL
- Transactions
- Concurrency control
- Backend development
- API development
- Software architecture
- Git and version control
Status
Ventry is currently a work in progress.
The database foundation and transactional stock system are functional. Development will continue with individual ticket generation, payment modeling and event check-in.
