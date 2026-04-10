-- ============================================================
--  SMART PLACEMENT SYSTEM — Complete Database Setup
--  DB:  smartplacement
--  URL: jdbc:mysql://localhost:3306/smartplacement
--  Run: mysql -u root -pRoot@123 < setup_db.sql
-- ============================================================

DROP DATABASE IF EXISTS smartplacement;
CREATE DATABASE smartplacement CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smartplacement;

-- ============================================================
--  TABLE: admin
-- ============================================================
CREATE TABLE admin (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50)  UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    name     VARCHAR(100) DEFAULT 'System Administrator',
    email    VARCHAR(100)
);

-- ============================================================
--  TABLE: company
-- ============================================================
CREATE TABLE company (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    company_name   VARCHAR(100) NOT NULL,
    email          VARCHAR(100) UNIQUE NOT NULL,
    password       VARCHAR(100) NOT NULL,
    website        VARCHAR(200),
    description    TEXT,
    contact_number VARCHAR(20),
    status         VARCHAR(20) DEFAULT 'ACTIVE',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
--  TABLE: students
-- ============================================================
CREATE TABLE students (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    email          VARCHAR(100) UNIQUE NOT NULL,
    password       VARCHAR(100) NOT NULL,
    branch         VARCHAR(50)  NOT NULL,
    cgpa           DECIMAL(4,2) NOT NULL,
    resume_path    VARCHAR(255),
    contact_number VARCHAR(20),
    status         VARCHAR(20) DEFAULT 'ACTIVE',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
--  TABLE: job_drive
-- ============================================================
CREATE TABLE job_drive (
    id                INT AUTO_INCREMENT PRIMARY KEY,
    company_id        INT NOT NULL,
    job_role          VARCHAR(100) NOT NULL,
    description       TEXT,
    eligibility_cgpa  DECIMAL(4,2) DEFAULT 6.00,
    eligible_branches VARCHAR(255),
    last_date         DATE,
    drive_date        DATE,
    salary_package    VARCHAR(50),
    location          VARCHAR(100),
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (company_id) REFERENCES company(id) ON DELETE CASCADE
);

-- ============================================================
--  TABLE: application
-- ============================================================
CREATE TABLE application (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id  INT NOT NULL,
    drive_id    INT NOT NULL,
    status      VARCHAR(20) DEFAULT 'APPLIED',
    apply_date  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (drive_id)   REFERENCES job_drive(id) ON DELETE CASCADE,
    UNIQUE KEY unique_application (student_id, drive_id)
);

-- ============================================================
--  TABLE: feedback
-- ============================================================
CREATE TABLE feedback (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id  INT NOT NULL,
    subject     VARCHAR(100) NOT NULL,
    message     TEXT NOT NULL,
    submit_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- ============================================================
--  TABLE: notification
-- ============================================================
CREATE TABLE notification (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    student_id  INT NOT NULL,
    message     TEXT NOT NULL,
    is_read     TINYINT(1) DEFAULT 0,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- ============================================================
--  TABLE: saved_jobs
-- ============================================================
CREATE TABLE saved_jobs (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    drive_id   INT NOT NULL,
    saved_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (drive_id)   REFERENCES job_drive(id) ON DELETE CASCADE,
    UNIQUE KEY unique_saved (student_id, drive_id)
);

-- ============================================================
--  SAMPLE DATA: Admin
-- ============================================================
INSERT INTO admin (username, password, name, email)
VALUES ('admin', 'admin123', 'System Administrator', 'admin@smartplacement.com');

-- ============================================================
--  SAMPLE DATA: Companies
-- ============================================================
INSERT INTO company (company_name, email, password, website, description, contact_number) VALUES
('Infosys Technologies',      'hr@infosys.com',      'infosys123',   'https://www.infosys.com',
 'Global leader in technology services and consulting.',                      '080-22229999'),
('TCS - Tata Consultancy',    'recruit@tcs.com',     'tcs123',       'https://www.tcs.com',
 'One of the largest IT services companies in the world.',                    '022-67789999'),
('Wipro Limited',             'campus@wipro.com',    'wipro123',     'https://www.wipro.com',
 'Information technology, consulting and business solutions.',                '080-28440011'),
('Cognizant Technology',      'talent@cognizant.com','cognizant123', 'https://www.cognizant.com',
 'Professional services company, transforming clients global business.',      '044-42090000'),
('HCL Technologies',          'careers@hcl.com',     'hcl123',       'https://www.hcltech.com',
 'Global technology company delivering IT and engineering services.',         '0120-6125000');

-- ============================================================
--  SAMPLE DATA: Students (passwords: student123)
-- ============================================================
INSERT INTO students (name, email, password, branch, cgpa, contact_number) VALUES
('Arjun Sharma',     'arjun@student.com',    'student123', 'CSE',  8.9, '9876543210'),
('Priya Patel',      'priya@student.com',    'student123', 'IT',   8.4, '9876543211'),
('Rahul Kumar',      'rahul@student.com',    'student123', 'ECE',  7.8, '9876543212'),
('Sneha Reddy',      'sneha@student.com',    'student123', 'CSE',  9.2, '9876543213'),
('Vikram Singh',     'vikram@student.com',   'student123', 'MECH', 7.1, '9876543214'),
('Ananya Iyer',      'ananya@student.com',   'student123', 'IT',   8.7, '9876543215'),
('Dev Malhotra',     'dev@student.com',      'student123', 'CSE',  7.5, '9876543216'),
('Kavya Nair',       'kavya@student.com',    'student123', 'ECE',  8.1, '9876543217'),
('Rohan Gupta',      'rohan@student.com',    'student123', 'CIVIL',6.8, '9876543218'),
('Meera Krishnan',   'meera@student.com',    'student123', 'CSE',  9.5, '9876543219');

-- ============================================================
--  SAMPLE DATA: Job Drives
-- ============================================================
INSERT INTO job_drive (company_id, job_role, description, eligibility_cgpa, eligible_branches, last_date, drive_date, salary_package, location) VALUES
(1, 'Software Engineer',
 'Work on enterprise-level Java and Spring Boot applications. Responsibilities include design, development, and unit testing of software components.',
 6.5, 'CSE,IT,ECE', '2026-05-01', '2026-05-15', '6.5 LPA', 'Bangalore / Hybrid'),

(2, 'Systems Engineer',
 'Develop and maintain mission-critical systems for global clients. Exposure to DevOps, Cloud (AWS/Azure), and microservices architecture.',
 6.0, 'CSE,IT,ECE,EEE', '2026-05-05', '2026-05-20', '7.0 LPA', 'Mumbai / On-site'),

(3, 'Project Engineer',
 'Contribute to Agile software development projects. Work with senior engineers on UI and API development.',
 6.5, 'CSE,IT', '2026-05-10', '2026-05-25', '6.0 LPA', 'Hyderabad / Hybrid'),

(4, 'Associate - Software',
 'Develop and enhance digital solutions across domains like healthcare, finance, and retail.',
 7.0, 'CSE,IT,ECE', '2026-05-12', '2026-06-01', '7.5 LPA', 'Chennai / On-site'),

(5, 'Graduate Engineer Trainee',
 'Intensive 12-month training program covering cloud, AI, and full-stack development before project placement.',
 7.0, 'CSE,IT,ECE,EEE,MECH', '2026-05-20', '2026-06-10', '8.0 LPA', 'Noida / Hybrid');

-- ============================================================
--  SAMPLE DATA: Applications
-- ============================================================
INSERT INTO application (student_id, drive_id, status) VALUES
(1, 1, 'APPLIED'),
(1, 2, 'SHORTLISTED'),
(2, 1, 'APPLIED'),
(2, 4, 'SELECTED'),
(3, 2, 'APPLIED'),
(3, 5, 'SHORTLISTED'),
(4, 1, 'SELECTED'),
(4, 3, 'APPLIED'),
(5, 5, 'APPLIED'),
(6, 1, 'APPLIED'),
(6, 4, 'SHORTLISTED'),
(7, 2, 'APPLIED'),
(8, 3, 'APPLIED'),
(9, 5, 'APPLIED'),
(10, 1, 'SELECTED');

-- ============================================================
--  SAMPLE DATA: Notifications
-- ============================================================
INSERT INTO notification (student_id, message) VALUES
(1, 'Welcome to SmartPlacement! Complete your profile to get started.'),
(1, 'Your application to TCS has been Shortlisted. Stay tuned!'),
(2, 'Congratulations! You have been Selected by Cognizant Technology!'),
(3, 'New drive posted by HCL Technologies matching your profile.'),
(4, 'Congratulations! You have been Selected by Infosys Technologies!'),
(6, 'Your Cognizant application has been Shortlisted.'),
(10,'Congratulations! You have been Selected by Infosys Technologies!');

-- ============================================================
--  Verify
-- ============================================================
SELECT 'Setup complete.' AS Status;
SELECT COUNT(*) AS companies   FROM company;
SELECT COUNT(*) AS students    FROM students;
SELECT COUNT(*) AS drives      FROM job_drive;
SELECT COUNT(*) AS applications FROM application;
