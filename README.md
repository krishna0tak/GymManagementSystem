# 🏋️‍♂️ PowerFit Gym Management System

![Java](https://img.shields.io/badge/Java-25.0.2-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)
![JSP/Servlet](https://img.shields.io/badge/JSP%2FServlet-3.1-007396?style=for-the-badge&logo=java&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Tomcat](https://img.shields.io/badge/Apache%20Tomcat-11.0.23-F8DC75?style=for-the-badge&logo=apache-tomcat&logoColor=black)
![Security](https://img.shields.io/badge/Security-AES--128-green?style=for-the-badge&logo=key&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)

A full-stack, enterprise-grade web application built to digitize and automate fitness center operations. **PowerFit** replaces traditional paper-based record-keeping with a centralized, secure, and interactive digital platform accessible via any web browser.

---

## 📌 Table of Contents
- [📸 Application Screenshots](#-application-screenshots)
- [Features](#-features)
  - [🛡️ Admin Portal](#️-admin-portal)
  - [👤 Member Portal](#-member-portal)
  - [🔒 Security & Authentication](#-security--authentication)
- [🏛️ System Architecture](#️-system-architecture)
- [🛠️ Technology Stack](#️-technology-stack)
- [🗄️ Database Schema](#️-database-schema)
- [🚀 Quick Start & Installation](#-quick-start--installation)
- [📄 Interactive Documentation & Presentation](#-interactive-documentation--presentation)
- [💼 LinkedIn Post](#-linkedin-post)
- [📝 License](#-license)

---

## 📸 Application Screenshots

| Landing Page (Hero) | Admin Analytics Dashboard |
| :---: | :---: |
| ![Landing Page](images/landing_hero.png) | ![Admin Dashboard](images/admin_dashboard.png) |

| Member Login Portal |
| :---: |
| ![Member Login](images/member_login.png) |

---

## ✨ Features

### 🛡️ Admin Portal
- **Real-Time Analytics Dashboard**: Live metrics tracking total members, active memberships, expired plans, and gym status.
- **Member Management**: Add, view, edit, search, and manage member profiles and plan renewals.
- **Membership Plan Control**: Manage pricing, duration (1, 3, 6, 12 months), and plan tiers.
- **Attendance Monitoring**: Access full check-in history logs across all gym members.

### 👤 Member Portal
- **Personalized Dashboard**: Real-time view of active membership details, plan expiry countdown, and health stats.
- **BMI Calculator & Health Gauge**: Interactive BMI calculator with visual classification, healthy weight range indicators, and personalized fitness advice.
- **Custom Workout Routines**: Dynamic workout recommendations tailored specifically to the member's calculated BMI category.
- **1-Click Attendance Tracker**: Daily digital check-in system with monthly consistency percentage tracking.
- **Profile Self-Management**: Update personal details (address, mobile, height, weight) independently.

### 🔒 Security & Authentication
- **AES-128 Encryption**: Sensitive credentials (passwords) are encrypted using Java `Cipher` (AES/ECB/PKCS5Padding) before storage in MySQL.
- **SQL Injection Defense**: All database queries utilize JDBC `PreparedStatement` with parameterized queries.
- **Session-Based Access Control**: HTTP Session validation on every servlet/page protects protected routes from unauthorized access.
- **Automated Password Reset**: Forgot-password pipeline generates temporary passwords and delivers them via JavaMail SMTP API.

---

## 🏛️ System Architecture

The application follows the classic **3-Tier Web Architecture**:

```
+-------------------------------------------------------------------+
|                   TIER 1: PRESENTATION LAYER                      |
|           HTML5 · CSS3 · JavaScript (Vanilla) · FontAwesome       |
+-------------------------------------------------------------------+
                                 │
                            HTTP / HTTPS
                                 ▼
+-------------------------------------------------------------------+
|                    TIER 2: APPLICATION LAYER                      |
|         Apache Tomcat 11.0.23 · JavaServlets & JSP 3.1            |
|       AES Encryption · JavaMail SMTP · Business Logic Controls    |
+-------------------------------------------------------------------+
                                 │
                               JDBC
                                 ▼
+-------------------------------------------------------------------+
|                        TIER 3: DATA LAYER                         |
|                     MySQL 8.0 Relational DB                       |
|           (members, membership_plan, attendance, admin)           |
+-------------------------------------------------------------------+
```

---

## 🛠️ Technology Stack

| Layer | Technology | Version / Specification | Purpose |
| :--- | :--- | :--- | :--- |
| **Frontend** | HTML5, CSS3, JavaScript | ES6+ | Responsive UI, client-side validation, theme styling |
| **Backend** | Java (JSP & Servlets) | JSP 3.1 / Java 25 | Server-side routing, request handling, business logic |
| **Server** | Apache Tomcat | 11.0.23 | Servlet container & Web Application Server |
| **Database** | MySQL Server | 8.0 | Relational database storage |
| **Connectivity** | MySQL Connector/J | 9.7.0 | JDBC database driver |
| **Security** | Java Cipher API | AES/ECB/PKCS5 | Password encryption & decryption |
| **Email** | JavaMail API | 1.6 (javax.mail) | Automated SMTP email password recovery |
| **IDE** | Apache NetBeans | 30 | Integrated Development Environment |

---

## 🗄️ Database Schema

The database schema `gym_management` consists of 4 main tables:

```sql
CREATE DATABASE IF NOT EXISTS gym_management;
USE gym_management;

-- 1. Admin Table
CREATE TABLE admin (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- 2. Membership Plans Table
CREATE TABLE membership_plan (
    plan_id INT PRIMARY KEY AUTO_INCREMENT,
    plan_name VARCHAR(50) NOT NULL,
    duration_months INT NOT NULL,
    price DECIMAL(10,2) NOT NULL
);

-- 3. Members Table
CREATE TABLE members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    mobile VARCHAR(15),
    gender VARCHAR(10),
    age INT,
    height DOUBLE,
    weight DOUBLE,
    bmi DOUBLE,
    plan_id INT,
    join_date DATE,
    expiry_date DATE,
    FOREIGN KEY (plan_id) REFERENCES membership_plan(plan_id)
);

-- 4. Attendance Table
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_in_time TIME NOT NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);
```

---

## 🚀 Quick Start & Installation

### Prerequisites
- **JDK**: Java SE 21 or Java SE 25
- **IDE**: Apache NetBeans 19+ (or NetBeans 30)
- **Application Server**: Apache Tomcat 11.0.x
- **Database**: MySQL Server 8.0+

### Step-by-Step Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/GymManagementSystem.git
   cd GymManagementSystem
   ```

2. **Configure the Database**
   - Open MySQL Workbench or MySQL CLI.
   - Execute the SQL schema script above to create `gym_management` database and required tables.
   - Update database credentials in `src/java/p1/dbcon.java` if necessary:
     ```java
     String url = "jdbc:mysql://localhost:3306/gym_management";
     String user = "root";
     String pass = "your_mysql_password";
     ```

3. **Open in NetBeans**
   - File -> Open Project -> Select `GymManagementSystem`.
   - Ensure Apache Tomcat 11 is linked as the target Web Server in Project Properties.

4. **Build & Run**
   - Right-click the project -> **Clean and Build**.
   - Right-click -> **Run** (or `Shift + F6`).
   - Access the web application at `http://localhost:8080/GymManagementSystem/index.jsp`.

---

## 📄 Interactive Documentation & Presentation

This repository includes self-contained, interactive HTML assets:
- **`documentation.html`**: Complete technical SRS documentation, DFD diagrams (Level 0, 1, 2), ER Diagrams, and file descriptions.
- **`presentation.html`**: A slide deck presentation built right into the repository. Open in any browser and press `Ctrl + P` to export as a LinkedIn Carousel PDF!

---

## 💼 LinkedIn Post

Here is the post template tailored for sharing this project on LinkedIn:

```text
🚀 Exciting Project Update: Building a Full-Stack Web Application for Gym Operations! 🏋️‍♂️💻

Managing gym memberships, member attendance, and personalized fitness tracking manually can be chaotic. To solve this, I built PowerFit Gym Management System — a full-stack web application designed to digitize and streamline fitness center operations!

Here is a breakdown of what I built and the tech stack behind it:

⚡ Key Features:
🔹 Dual-Portal Architecture: Dedicated & session-protected interfaces for both Admins and Members.
🔹 Real-Time Analytics Dashboard: Real-time tracking of active vs. expired memberships, total revenue, and member registration stats.
🔹 Member Self-Service Hub: Live BMI calculation with health category gauges and dynamic workout routines tailored to individual BMI metrics.
🔹 1-Click Attendance Tracker: Attendance logging with monthly consistency percentages.
🔹 Automated Password Recovery: Integrated SMTP email delivery via JavaMail API with temporary credential generation.

🛡️ Security & Performance Highlights:
🔒 Password Protection: AES-128 Cipher Encryption for secure user credentials.
🔒 Database Security: Parameterized JDBC PreparedStatement queries to prevent SQL Injection attacks.
🔒 Session Control: Robust server-side session management & access control.

🛠️ Tech Stack:
• Backend: Java (JSP / Servlets 3.1) on Apache Tomcat 11
• Database: MySQL 8.0 with JDBC (Connector/J 9.7.0)
• Frontend: HTML5, CSS3, JavaScript (Vanilla), Font Awesome 6.5
• Security: Java Cipher API (AES-128) & JavaMail API

Building this gave me hands-on experience in 3-tier enterprise application design, database relationship mapping, and web security best practices.

📁 Check out the repository: https://github.com/your-username/GymManagementSystem

I’d love to hear your feedback or suggestions for future enhancements! 👇

#Java #WebDevelopment #FullStack #SoftwareEngineering #MySQL #JSP #Tomcat #Coding #BackendDevelopment #Portfolio #TechCommunity
```

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
