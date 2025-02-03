-- Enable foreign namevalue checks
SET FOREIGN_KEY_CHECKS = 1;

-- Create User Table
CREATE TABLE IF NOT EXISTS User (
    id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(255),
    country VARCHAR(255),
    gender ENUM('male', 'female') NOT NULL,
    role ENUM('admin', 'student', 'teacher') NOT NULL,
    status ENUM('active', 'inactive') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL
);

-- Create SchoolMosque Table
CREATE TABLE IF NOT EXISTS SchoolMosque (
    id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(255),
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL
);

-- Insert initial data into SchoolMosque
INSERT INTO SchoolMosque (name, address, type, teacher_id)
VALUES ('تعليم عن بعد', 'عبر مكالمات الفيديو', 'Virtual', 1);

-- Create CirclesCategory Table
CREATE TABLE IF NOT EXISTS CirclesCategory (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    namevalue VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);

-- Insert initial data into CirclesCategory
INSERT INTO CirclesCategory (`name`, `namevalue`) VALUES 
    ('حلقة حفظ', 'Listining'),
    ('حلقة مراجعة صغرى', 'MinorReview'),
    ('حلقة مراجعة كبرى', 'MajorReview'),
    ('حلقة إتقان', 'Mastery'),
    ('حلقة تجويد', 'Tajweed'),
    ('حلقة تلاوه', 'Telawah');


-- Create Circle Table
CREATE TABLE IF NOT EXISTS Circle (
    id INT PRIMARY KEY AUTO_INCREMENT,
    school_mosque_id INT,
    teacher_id INT,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    circle_category_id INT,
    circle_type VARCHAR(255),
    circle_time VARCHAR(255),
    jitsi_link TEXT,
    recording_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (school_mosque_id) REFERENCES SchoolMosque(id),
    FOREIGN KEY (circle_category_id) REFERENCES CirclesCategory(id)
);

-- Create Student Table
CREATE TABLE IF NOT EXISTS Student (
    id INT PRIMARY KEY AUTO_INCREMENT,
    teacher_id INT,
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES User(id)
);

-- Create CircleStudent Table
CREATE TABLE IF NOT EXISTS CircleStudent (
    id INT PRIMARY KEY AUTO_INCREMENT,
    circle_id INT,
    student_id INT,
    teacher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (circle_id) REFERENCES Circle(id),
    FOREIGN KEY (student_id) REFERENCES User(id)
);

-- Create StudentProgress Table
CREATE TABLE IF NOT EXISTS StudentProgress (
    id INT PRIMARY KEY AUTO_INCREMENT,
    circle_id INT,
    student_id INT,
    status ENUM('none', 'present', 'absent', 'absent_with_excuse', 'excused', 'not_listened', 'late') DEFAULT 'none',
    start_surah_number INT NOT NULL,
    end_surah_number INT NOT NULL,
    start_ayah_number INT NOT NULL,
    end_ayah_number INT NOT NULL,
    lesson_date DATETIME NOT NULL,
    reading_wrong INT DEFAULT 0,
    tajweed_wrong INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (circle_id) REFERENCES Circle(id),
    FOREIGN KEY (student_id) REFERENCES Student(id)
);

-- Create HomeWork Table
CREATE TABLE IF NOT EXISTS HomeWork (
    id INT PRIMARY KEY AUTO_INCREMENT,
    circle_id INT,
    student_id INT,
    start_surah_number INT NOT NULL,
    end_surah_number INT NOT NULL,
    start_ayah_number INT NOT NULL,
    end_ayah_number INT NOT NULL,
    lesson_date DATETIME NOT NULL,
    circle_category_id INT NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL,
    FOREIGN KEY (student_id) REFERENCES Student(id),
    FOREIGN KEY (circle_category_id) REFERENCES CirclesCategory(id),
    FOREIGN KEY (circle_id) REFERENCES Circle(id)
);

-- Create DigitalLibrary Table
CREATE TABLE IF NOT EXISTS DigitalLibrary (
    id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255),
    category VARCHAR(255),
    file_url TEXT NOT NULL,
    teacher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL
);

-- Create Settings Table
CREATE TABLE IF NOT EXISTS Settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    logo_url TEXT,
    address TEXT,
    phone VARCHAR(255),
    email VARCHAR(255),
    website_url TEXT,
    video_server_url TEXT,
    support_email VARCHAR(255),
    social_media_links TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ,
    deleted_at TIMESTAMP NULL
);