# Raag Billing SaaS Backend (Node.js + Express + MySQL)

Enterprise multi-tenant backend server for **Raag Billing** SaaS application.

---

## 🛠️ Tech Stack

- **Runtime:** Node.js
- **Framework:** Express.js
- **Database:** MySQL
- **Authentication:** JWT (JSON Web Tokens) & `bcryptjs` password hashing
- **Security:** `helmet`, `cors`, SQL injection safety via parameterized queries

---

## 📂 Project Structure

```text
raag_billing_server/
├── package.json
├── .env
├── .env.example
├── .gitignore
├── README.md
└── src/
    ├── config/
    │   ├── database.js          # MySQL Connection Pool
    │   └── jwt.js               # JWT Sign & Verify Utilities
    ├── controllers/
    │   └── auth.controller.js   # Register, Login, Logout, Me
    ├── database/
    │   ├── schema.sql           # Complete MySQL Database Schema
    │   └── init_db.js           # Database Auto-Initialization Script
    ├── middleware/
    │   ├── auth.middleware.js   # JWT Auth Verification Middleware
    │   └── error.middleware.js  # Global Error Handler
    ├── models/
    │   └── user.model.js        # User SQL Queries & Data Access
    ├── routes/
    │   └── auth.routes.js       # Auth Endpoint Routes
    ├── app.js                   # Express App Configuration
    └── server.js                # Server Entry Point
```

---

## ⚡ Quick Start (Phase 1)

1. **Install Dependencies:**
   ```bash
   cd raag_billing_server
   npm install
   ```

2. **Configure Database & Environment:**
   Update `.env` with your local MySQL credentials:
   ```env
   PORT=5000
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=root
   DB_PASSWORD=root
   DB_NAME=raag_billing_db
   JWT_SECRET=your_jwt_secret_key
   ```

3. **Start Database & Backend Server:**
   ```bash
   npm run dev
   ```

---

## 🔑 Phase 1 Authentication Endpoints

| Method | Endpoint | Description | Protected |
| :--- | :--- | :--- | :--- |
| `GET` | `/api/health` | API Health & Status check | No |
| `POST` | `/api/auth/register` | Register new user + default business profile | No |
| `POST` | `/api/auth/login` | Login with email/phone & password | No |
| `POST` | `/api/auth/logout` | Logout user | No |
| `GET` | `/api/auth/me` | Get current user & business profile | **Yes (Bearer JWT)** |
