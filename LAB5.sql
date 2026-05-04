-- ============================================================
-- ORACLE SQL/PL/SQL - BUOI 5
-- Tao Co So Du Lieu va Cac Doi Tuong
-- Dua theo tai lieu: HuongDan_Oracle_Buoi5.docx
-- ============================================================

-- ============================================================
-- PHAN 0: TAO CAC BANG CO SO (BASE TABLES)
-- ============================================================

-- 0.1 Bang STUDENT
CREATE TABLE student (
    studentid       NUMBER(8)       PRIMARY KEY,
    firstname       VARCHAR2(30),
    lastname        VARCHAR2(30)    NOT NULL,
    registrationdate DATE,
    createdby       VARCHAR2(30)    DEFAULT USER,
    createddate     DATE            DEFAULT SYSDATE,
    modifiedby      VARCHAR2(30)    DEFAULT USER,
    modifieddate    DATE            DEFAULT SYSDATE
);

-- 0.2 Bang INSTRUCTOR
CREATE TABLE instructor (
    instructorid    NUMBER(8)       PRIMARY KEY,
    firstname       VARCHAR2(30),
    lastname        VARCHAR2(30)    NOT NULL,
    createdby       VARCHAR2(30)    DEFAULT USER,
    createddate     DATE            DEFAULT SYSDATE,
    modifiedby      VARCHAR2(30)    DEFAULT USER,
    modifieddate    DATE            DEFAULT SYSDATE
);

-- 0.3 Bang COURSE
CREATE TABLE course (
    courseno        NUMBER(8)       PRIMARY KEY,
    description     VARCHAR2(50)    NOT NULL,
    cost            NUMBER(10,2),
    prerequisite    NUMBER(8)       REFERENCES course(courseno)
);

-- 0.4 Bang CLASS
CREATE TABLE class (
    classid         NUMBER(8)       PRIMARY KEY,
    courseno        NUMBER(8)       NOT NULL REFERENCES course(courseno),
    instructorid    NUMBER(8)       NOT NULL REFERENCES instructor(instructorid),
    capacity        NUMBER(3)       DEFAULT 30,
    startdate       DATE,
    enddate         DATE,
    so_sv           NUMBER          DEFAULT 0,  -- Them cho Compound Trigger (Cau 3.1)
    createdby       VARCHAR2(30)    DEFAULT USER,
    createddate     DATE            DEFAULT SYSDATE,
    modifiedby      VARCHAR2(30)    DEFAULT USER,
    modifieddate    DATE            DEFAULT SYSDATE
);

-- 0.5 Bang ENROLLMENT
CREATE TABLE enrollment (
    studentid       NUMBER(8)       NOT NULL REFERENCES student(studentid),
    classid         NUMBER(8)       NOT NULL REFERENCES class(classid),
    enrolldate      DATE            DEFAULT SYSDATE,
    finalgrade      NUMBER(5,2),
    createdby       VARCHAR2(30)    DEFAULT USER,
    createddate     DATE            DEFAULT SYSDATE,
    modifiedby      VARCHAR2(30)    DEFAULT USER,
    modifieddate    DATE            DEFAULT SYSDATE,
    CONSTRAINT pk_enrollment PRIMARY KEY (studentid, classid)
);

-- 0.6 Bang GRADE
CREATE TABLE grade (
    studentid       NUMBER(8)       NOT NULL REFERENCES student(studentid),
    classid         NUMBER(8)       NOT NULL REFERENCES class(classid),
    grade           NUMBER(5,2),
    createdby       VARCHAR2(30)    DEFAULT USER,
    createddate     DATE            DEFAULT SYSDATE,
    modifiedby      VARCHAR2(30)    DEFAULT USER,
    modifieddate    DATE            DEFAULT SYSDATE,
    CONSTRAINT pk_grade PRIMARY KEY (studentid, classid)
);

-- 0.7 Bang NOTIFICATION_LOG (Cau 2.8 - PRAGMA AUTONOMOUS_TRANSACTION)
CREATE TABLE notification_log (
    log_id      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nguoi_nhan  VARCHAR2(50),
    noi_dung    VARCHAR2(500),
    loai        VARCHAR2(20),
    thoi_gian   DATE        DEFAULT SYSDATE,
    trang_thai  VARCHAR2(10) DEFAULT 'SENT'
);

-- 0.8 Bang DDL_AUDIT_LOG (Cau 3.3 - DDL Trigger)
CREATE TABLE ddl_audit_log (
    log_id      NUMBER GENERATED ALWAYS AS IDENTITY,
    event_type  VARCHAR2(30),
    object_type VARCHAR2(30),
    object_name VARCHAR2(128),
    owner       VARCHAR2(30),
    event_time  DATE,
    current_usr VARCHAR2(30)
);

-- 0.9 Bang CERTIFICATE (Cau 3.5 - Trigger WHEN)
CREATE TABLE certificate (
    cert_id     NUMBER GENERATED ALWAYS AS IDENTITY,
    studentid   NUMBER(8),
    courseno    NUMBER(8),
    cap_cc      DATE,
    loai        VARCHAR2(20)
);


-- ============================================================
-- PHAN 1: DU LIEU MAU
-- ============================================================

-- Courses
INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (10, 'Introduction to Oracle', 1095, NULL);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (20, 'PL/SQL Programming', 1295, 10);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (25, 'Advanced Oracle Topics', 1095, 20);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (100, 'Technology Concepts', 1095, NULL);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (120, 'Java Programming I', 1195, 100);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (122, 'Java Programming II', 1195, 120);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (130, 'Intro to Unix', 1095, NULL);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (132, 'Basics of Unix Admin', 1095, 130);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (134, 'Advanced Unix Topics', 1095, 132);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (135, 'Unix Tips and Tricks', 1095, 134);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (140, 'Structured Query Language', 1095, NULL);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (142, 'Project Management', 1095, NULL);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (144, 'Project Management II', 1095, 142);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (145, 'Internet Protocols', 1095, NULL);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (146, 'e-Commerce Concepts', 995, NULL);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (147, 'Intro to Network Admin', 1095, NULL);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (148, 'Network Administration', 1095, 147);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (149, 'Network Administration II', 1095, 148);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (150, 'DB Programming in Java', 1195, 122);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (204, 'Operating Systems', 1095, 100);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (210, 'Oracle8i: New Features', 1095, 20);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (220, 'Intro to XML', 1095, 122);

INSERT INTO course(courseno, description, cost, prerequisite)
VALUES (230, 'Fundamentals of e-Commerce', 1095, 146);

-- Instructors
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (101, 'Fernand', 'Hanks');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (102, 'Tom', 'Wojick');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (103, 'Nina', 'Schorin');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (104, 'Gary', 'Pertez');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (105, 'Anita', 'Morris');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (106, 'Todd', 'Smythe');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (107, 'Marilyn', 'Frantzen');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (108, 'Charles', 'Lowry');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (109, 'Rick', 'Chow');
INSERT INTO instructor(instructorid, firstname, lastname)
VALUES (110, 'Irene', 'Elvira');

-- Classes
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (1, 10, 101, 15, DATE '2007-01-15', DATE '2007-01-18');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (2, 20, 102, 10, DATE '2007-02-05', DATE '2007-02-08');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (3, 25, 103, 12, DATE '2007-02-19', DATE '2007-02-22');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (4, 100, 104, 15, DATE '2007-03-05', DATE '2007-03-07');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (5, 120, 105, 15, DATE '2007-03-19', DATE '2007-03-22');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (6, 122, 106, 10, DATE '2007-04-02', DATE '2007-04-05');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (7, 130, 107, 15, DATE '2007-04-16', DATE '2007-04-18');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (8, 132, 108, 12, DATE '2007-04-30', DATE '2007-05-02');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (9, 140, 109, 15, DATE '2007-05-14', DATE '2007-05-16');
INSERT INTO class(classid, courseno, instructorid, capacity, startdate, enddate)
VALUES (10, 142, 110, 10, DATE '2007-05-28', DATE '2007-05-30');

-- Students
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (101, 'George', 'Eakheit', DATE '2007-01-22', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (102, 'Nina', 'Schorin', DATE '2007-01-22', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (103, 'Edgar', 'Moffat', DATE '2007-01-22', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (104, 'Yvonne', 'Quare', DATE '2007-02-14', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (105, 'Angel', 'Moskowitz', DATE '2007-02-14', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (106, 'Robert', 'Sherbein', DATE '2007-02-14', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (107, 'Judy', 'Sethi', DATE '2007-03-01', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (108, 'Joanne', 'Smythe', DATE '2007-03-01', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (109, 'Mardig', 'Abdou', DATE '2007-03-01', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (110, 'Rommel', 'Capodiece', DATE '2007-03-15', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (111, 'Carla', 'Sadumi', DATE '2007-03-15', USER, SYSDATE, USER, SYSDATE);
INSERT INTO student(studentid, firstname, lastname, registrationdate, createdby, createddate, modifiedby, modifieddate)
VALUES (112, 'Thomas', 'Boytonous', DATE '2007-03-15', USER, SYSDATE, USER, SYSDATE);

-- Enrollments
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (101, 1, DATE '2007-01-15', 85, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (102, 1, DATE '2007-01-15', 92, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (103, 1, DATE '2007-01-15', 78, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (104, 1, DATE '2007-01-15', 65, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (101, 2, DATE '2007-02-05', 88, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (102, 2, DATE '2007-02-05', 75, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (105, 2, DATE '2007-02-05', 91, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (103, 3, DATE '2007-02-19', 45, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (106, 3, DATE '2007-02-19', 70, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (107, 4, DATE '2007-03-05', 55, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (108, 4, DATE '2007-03-05', 80, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (109, 5, DATE '2007-03-19', 95, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (110, 5, DATE '2007-03-19', 60, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (111, 6, DATE '2007-04-02', 88, USER, SYSDATE, USER, SYSDATE);
INSERT INTO enrollment(studentid, classid, enrolldate, finalgrade, createdby, createddate, modifiedby, modifieddate)
VALUES (112, 6, DATE '2007-04-02', NULL, USER, SYSDATE, USER, SYSDATE);

-- Grades (mirror enrollment)
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (101, 1, 85, USER, SYSDATE, USER, SYSDATE);
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (102, 1, 92, USER, SYSDATE, USER, SYSDATE);
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (103, 1, 78, USER, SYSDATE, USER, SYSDATE);
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (104, 1, 65, USER, SYSDATE, USER, SYSDATE);
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (101, 2, 88, USER, SYSDATE, USER, SYSDATE);
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (102, 2, 75, USER, SYSDATE, USER, SYSDATE);
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (105, 2, 91, USER, SYSDATE, USER, SYSDATE);
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (103, 3, 45, USER, SYSDATE, USER, SYSDATE);
INSERT INTO grade(studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
VALUES (106, 3, 70, USER, SYSDATE, USER, SYSDATE);

COMMIT;

-- Cap nhat so_sv ban dau sau khi co du lieu
UPDATE class cl
SET so_sv = (SELECT COUNT(*) FROM enrollment e WHERE e.classid = cl.classid);
COMMIT;


-- ============================================================
-- PHAN 2: INDEX (Cau 4.2 - Toi uu hoa)
-- ============================================================

CREATE INDEX idx_enrollment_classid    ON enrollment(classid);
CREATE INDEX idx_enrollment_studentid  ON enrollment(studentid);
CREATE INDEX idx_class_courseno        ON class(courseno);
CREATE INDEX idx_class_instructorid    ON class(instructorid);


-- ============================================================
-- PHAN 3: STORED PROCEDURE HO TRO (log_notification)
-- Can tao truoc cac doi tuong khac su dung no
-- ============================================================

-- Cau 2.8: Thu tuc ghi log voi PRAGMA AUTONOMOUS_TRANSACTION
CREATE OR REPLACE PROCEDURE log_notification
    (p_nguoi_nhan VARCHAR2,
     p_noi_dung   VARCHAR2,
     p_loai       VARCHAR2 DEFAULT 'INFO')
IS
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO notification_log (nguoi_nhan, noi_dung, loai)
    VALUES (p_nguoi_nhan, SUBSTR(p_noi_dung,1,500), p_loai);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
END log_notification;
/


-- ============================================================
-- PHAN 4: BÀI 1 - VIEW NÂNG CAO
-- ============================================================

-- Cau 1.1: View kiem tra sinh vien hoc vuot (chua hoan thanh mon tien quyet)
CREATE OR REPLACE VIEW vw_prerequisite_check AS
SELECT s.studentid,
       s.firstname || ' ' || s.lastname AS ho_ten,
       co.description  AS ten_mon,
       co.courseno,
       tq.description  AS ten_mon_tq,
       tq.courseno     AS courseno_tq
FROM enrollment e
JOIN student s  ON e.studentid = s.studentid
JOIN class cl   ON e.classid   = cl.classid
JOIN course co  ON cl.courseno = co.courseno
JOIN course tq  ON co.prerequisite = tq.courseno
WHERE co.prerequisite IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM enrollment e2
    JOIN class cl2 ON e2.classid = cl2.classid
    WHERE e2.studentid = s.studentid
      AND cl2.courseno = co.prerequisite
      AND e2.finalgrade IS NOT NULL
  );

-- Cau 1.2: View phan tich hieu suat giang day voi RANK/DENSE_RANK
CREATE OR REPLACE VIEW vw_instructor_performance AS
SELECT instructorid, ho_ten, so_lop, tong_sv,
       sv_co_diem, diem_tb, diem_max, diem_min,
       ROUND(sv_dat * 100 / NULLIF(sv_co_diem,0), 1) AS ty_le_dat_pct,
       DENSE_RANK() OVER (ORDER BY diem_tb DESC NULLS LAST) AS hang_diem_tb,
       RANK()       OVER (ORDER BY tong_sv DESC)            AS hang_so_sv
FROM (
    SELECT i.instructorid,
           i.firstname || ' ' || i.lastname  AS ho_ten,
           COUNT(DISTINCT cl.classid)         AS so_lop,
           COUNT(e.studentid)                 AS tong_sv,
           COUNT(e.finalgrade)                AS sv_co_diem,
           ROUND(AVG(e.finalgrade),2)         AS diem_tb,
           MAX(e.finalgrade)                  AS diem_max,
           MIN(e.finalgrade)                  AS diem_min,
           SUM(CASE WHEN e.finalgrade >= 50 THEN 1 ELSE 0 END) AS sv_dat
    FROM instructor i
    LEFT JOIN class cl      ON i.instructorid = cl.instructorid
    LEFT JOIN enrollment e  ON cl.classid     = e.classid
    GROUP BY i.instructorid, i.firstname, i.lastname
);

-- Cau 1.3: View thong ke dang ky theo thang voi tong tich luy SUM() OVER
CREATE OR REPLACE VIEW vw_monthly_enrollment_stats AS
SELECT nam, thang, so_dang_ky, so_sv_moi, so_mon, diem_tb_thang,
       SUM(so_dang_ky) OVER (
           ORDER BY nam, thang
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS luy_ke_dang_ky
FROM (
    SELECT TO_CHAR(e.enrolldate,'YYYY') AS nam,
           TO_CHAR(e.enrolldate,'MM')   AS thang,
           COUNT(*)                     AS so_dang_ky,
           COUNT(DISTINCT e.studentid)  AS so_sv_moi,
           COUNT(DISTINCT cl.courseno)  AS so_mon,
           ROUND(AVG(e.finalgrade),2)   AS diem_tb_thang
    FROM enrollment e
    JOIN class cl ON e.classid = cl.classid
    GROUP BY TO_CHAR(e.enrolldate,'YYYY'), TO_CHAR(e.enrolldate,'MM')
)
ORDER BY nam DESC, thang ASC;

-- Cau 1.4: View INSTEAD OF - cho phep INSERT vao view 4 bang
CREATE OR REPLACE VIEW vw_enrollment_full AS
SELECT e.studentid, e.classid, e.enrolldate, e.finalgrade,
       s.firstname || ' ' || s.lastname AS ten_sv,
       co.description                   AS ten_mon,
       i.firstname  || ' ' || i.lastname AS ten_gv
FROM enrollment e
JOIN student s    ON e.studentid  = s.studentid
JOIN class cl     ON e.classid    = cl.classid
JOIN course co    ON cl.courseno  = co.courseno
JOIN instructor i ON cl.instructorid = i.instructorid;

CREATE OR REPLACE TRIGGER trg_iot_enrollment_full
    INSTEAD OF INSERT ON vw_enrollment_full
    FOR EACH ROW
DECLARE
    v_sv_check  NUMBER;
    v_cl_check  NUMBER;
    v_capacity  NUMBER;
    v_enrolled  NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_sv_check FROM student WHERE studentid = :NEW.studentid;
    IF v_sv_check = 0 THEN
        RAISE_APPLICATION_ERROR(-20050, 'Sinh vien khong ton tai!');
    END IF;

    SELECT COUNT(*) INTO v_cl_check FROM class WHERE classid = :NEW.classid;
    IF v_cl_check = 0 THEN
        RAISE_APPLICATION_ERROR(-20051, 'Lop hoc khong ton tai!');
    END IF;

    SELECT capacity INTO v_capacity FROM class WHERE classid = :NEW.classid;
    SELECT COUNT(*) INTO v_enrolled FROM enrollment WHERE classid = :NEW.classid;
    IF v_enrolled >= v_capacity THEN
        RAISE_APPLICATION_ERROR(-20052, 'Lop da day!');
    END IF;

    INSERT INTO enrollment
        (studentid, classid, enrolldate, createdby, createddate, modifiedby, modifieddate)
    VALUES
        (:NEW.studentid, :NEW.classid, NVL(:NEW.enrolldate, SYSDATE),
         USER, SYSDATE, USER, SYSDATE);

    DBMS_OUTPUT.PUT_LINE('[OK] Da dang ky: SV ' || :NEW.studentid || ' -> Lop ' || :NEW.classid);
END trg_iot_enrollment_full;
/

-- Cau 1.5: View phan tich phan vi voi PERCENTILE_CONT va STDDEV
CREATE OR REPLACE VIEW vw_grade_distribution AS
SELECT classid, courseno, description,
       sv_A, sv_B, sv_C, sv_D, sv_F, sv_chua_co,
       p25, p50_median, p75,
       ROUND(std_dev, 2)                                 AS do_lech_chuan,
       ROUND(std_dev / NULLIF(diem_tb,0) * 100, 2)      AS he_so_bt
FROM (
    SELECT cl.classid,
           cl.courseno,
           co.description,
           SUM(CASE WHEN e.finalgrade >= 90                            THEN 1 ELSE 0 END) AS sv_A,
           SUM(CASE WHEN e.finalgrade >= 80 AND e.finalgrade < 90      THEN 1 ELSE 0 END) AS sv_B,
           SUM(CASE WHEN e.finalgrade >= 70 AND e.finalgrade < 80      THEN 1 ELSE 0 END) AS sv_C,
           SUM(CASE WHEN e.finalgrade >= 50 AND e.finalgrade < 70      THEN 1 ELSE 0 END) AS sv_D,
           SUM(CASE WHEN e.finalgrade < 50  AND e.finalgrade IS NOT NULL THEN 1 ELSE 0 END) AS sv_F,
           SUM(CASE WHEN e.finalgrade IS NULL                          THEN 1 ELSE 0 END) AS sv_chua_co,
           PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY e.finalgrade)  AS p25,
           PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY e.finalgrade)  AS p50_median,
           PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY e.finalgrade)  AS p75,
           STDDEV(e.finalgrade)                                        AS std_dev,
           AVG(e.finalgrade)                                           AS diem_tb
    FROM class cl
    JOIN course co    ON cl.courseno = co.courseno
    LEFT JOIN enrollment e ON cl.classid = e.classid
    GROUP BY cl.classid, cl.courseno, co.description
);


-- ============================================================
-- PHAN 5: BÀI 2 - STORED PROCEDURE CHUYEN SAU
-- ============================================================

-- Cau 2.1: Thu tuc tra ve SYS_REFCURSOR
CREATE OR REPLACE PROCEDURE get_students_by_class
    (p_classid  IN  NUMBER,
     p_result   OUT SYS_REFCURSOR)
IS
BEGIN
    OPEN p_result FOR
        SELECT s.studentid,
               s.firstname || ' ' || s.lastname AS ho_ten,
               e.finalgrade,
               e.enrolldate
        FROM enrollment e
        JOIN student s ON e.studentid = s.studentid
        WHERE e.classid = p_classid
        ORDER BY s.lastname;
END get_students_by_class;
/

-- Cau 2.2: Thu tuc voi User-Defined Exception
CREATE OR REPLACE PROCEDURE enroll_student
    (p_studentid IN NUMBER,
     p_classid   IN NUMBER)
IS
    ex_sv_khong_ton   EXCEPTION;
    ex_lop_khong_ton  EXCEPTION;
    ex_lop_da_day     EXCEPTION;
    ex_da_dang_ky     EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_sv_khong_ton,  -20101);
    PRAGMA EXCEPTION_INIT(ex_lop_khong_ton, -20102);
    PRAGMA EXCEPTION_INIT(ex_lop_da_day,    -20103);
    PRAGMA EXCEPTION_INIT(ex_da_dang_ky,    -20104);
    v_sv_cnt   NUMBER;
    v_cl_cnt   NUMBER;
    v_cap      NUMBER;
    v_enr      NUMBER;
    v_dup      NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_sv_cnt FROM student WHERE studentid = p_studentid;
    IF v_sv_cnt = 0 THEN
        RAISE_APPLICATION_ERROR(-20101, 'Sinh vien ' || p_studentid || ' khong ton tai!');
    END IF;

    SELECT COUNT(*) INTO v_cl_cnt FROM class WHERE classid = p_classid;
    IF v_cl_cnt = 0 THEN
        RAISE_APPLICATION_ERROR(-20102, 'Lop ' || p_classid || ' khong ton tai!');
    END IF;

    SELECT capacity INTO v_cap FROM class WHERE classid = p_classid;
    SELECT COUNT(*) INTO v_enr FROM enrollment WHERE classid = p_classid;
    IF v_enr >= v_cap THEN
        RAISE_APPLICATION_ERROR(-20103, 'Lop ' || p_classid || ' da day (' || v_enr || '/' || v_cap || ')!');
    END IF;

    SELECT COUNT(*) INTO v_dup FROM enrollment
    WHERE studentid = p_studentid AND classid = p_classid;
    IF v_dup > 0 THEN
        RAISE_APPLICATION_ERROR(-20104, 'SV ' || p_studentid || ' da dang ky lop ' || p_classid || ' roi!');
    END IF;

    INSERT INTO enrollment(studentid, classid, enrolldate, createdby, createddate, modifiedby, modifieddate)
    VALUES (p_studentid, p_classid, SYSDATE, USER, SYSDATE, USER, SYSDATE);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('[OK] Dang ky thanh cong: SV ' || p_studentid || ' -> Lop ' || p_classid);

EXCEPTION
    WHEN ex_sv_khong_ton  THEN DBMS_OUTPUT.PUT_LINE('[LOI] ' || SQLERRM);
    WHEN ex_lop_khong_ton THEN DBMS_OUTPUT.PUT_LINE('[LOI] ' || SQLERRM);
    WHEN ex_lop_da_day    THEN DBMS_OUTPUT.PUT_LINE('[LOI] ' || SQLERRM);
    WHEN ex_da_dang_ky    THEN DBMS_OUTPUT.PUT_LINE('[LOI] ' || SQLERRM);
    WHEN OTHERS           THEN DBMS_OUTPUT.PUT_LINE('[LOI KHAC] ' || SQLERRM);
END enroll_student;
/

-- Cau 2.4: Package pkg_course_stats
CREATE OR REPLACE PACKAGE pkg_course_stats AS
    c_toan_phan_so_tin_chi NUMBER CONSTANT := 3;
    PROCEDURE print_course_summary(p_courseno IN NUMBER);
    FUNCTION  get_avg_grade(p_courseno IN NUMBER) RETURN NUMBER;
    FUNCTION  get_pass_rate(p_courseno IN NUMBER) RETURN NUMBER;
END pkg_course_stats;
/

CREATE OR REPLACE PACKAGE BODY pkg_course_stats AS

    g_call_count NUMBER := 0;

    FUNCTION get_avg_grade(p_courseno IN NUMBER) RETURN NUMBER IS
        v_avg NUMBER;
    BEGIN
        SELECT ROUND(AVG(e.finalgrade), 2) INTO v_avg
        FROM enrollment e
        JOIN class cl ON e.classid = cl.classid
        WHERE cl.courseno = p_courseno;
        RETURN v_avg;
    END get_avg_grade;

    FUNCTION get_pass_rate(p_courseno IN NUMBER) RETURN NUMBER IS
        v_total NUMBER;
        v_pass  NUMBER;
    BEGIN
        SELECT COUNT(*), SUM(CASE WHEN e.finalgrade >= 50 THEN 1 ELSE 0 END)
        INTO v_total, v_pass
        FROM enrollment e
        JOIN class cl ON e.classid = cl.classid
        WHERE cl.courseno = p_courseno AND e.finalgrade IS NOT NULL;
        RETURN ROUND(v_pass * 100 / NULLIF(v_total, 0), 1);
    END get_pass_rate;

    PROCEDURE print_course_summary(p_courseno IN NUMBER) IS
        v_desc VARCHAR2(50);
        v_cnt  NUMBER;
    BEGIN
        g_call_count := g_call_count + 1;
        SELECT description INTO v_desc FROM course WHERE courseno = p_courseno;
        SELECT COUNT(*) INTO v_cnt
        FROM enrollment e JOIN class cl ON e.classid = cl.classid
        WHERE cl.courseno = p_courseno;

        DBMS_OUTPUT.PUT_LINE('=== Mon: ' || v_desc || ' (No: ' || p_courseno || ')');
        DBMS_OUTPUT.PUT_LINE('Tong SV    : ' || v_cnt);
        DBMS_OUTPUT.PUT_LINE('Diem TB    : ' || NVL(TO_CHAR(get_avg_grade(p_courseno)), 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Ti le dat  : ' || NVL(TO_CHAR(get_pass_rate(p_courseno)), 'N/A') || '%');
        DBMS_OUTPUT.PUT_LINE('(Da goi ' || g_call_count || ' lan)');
    END print_course_summary;

END pkg_course_stats;
/

-- Cau 2.5: BULK COLLECT va FORALL xu ly hang loat
CREATE OR REPLACE PROCEDURE bulk_update_grades IS
    TYPE t_num IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_sids   t_num;
    v_cids   t_num;
    v_grades t_num;
    v_start  NUMBER;
    v_end    NUMBER;
    v_rows   NUMBER := 0;
BEGIN
    v_start := DBMS_UTILITY.GET_TIME;

    SELECT studentid, classid, finalgrade
    BULK COLLECT INTO v_sids, v_cids, v_grades
    FROM enrollment WHERE finalgrade IS NOT NULL;

    DBMS_OUTPUT.PUT_LINE('Doc duoc ' || v_sids.COUNT || ' ban ghi...');

    FORALL i IN 1..v_sids.COUNT SAVE EXCEPTIONS
        MERGE INTO grade g
        USING (SELECT v_sids(i) AS sid, v_cids(i) AS cid, v_grades(i) AS gr FROM DUAL) src
        ON (g.studentid = src.sid AND g.classid = src.cid)
        WHEN MATCHED THEN
            UPDATE SET g.grade = src.gr, g.modifiedby = USER, g.modifieddate = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
            VALUES (src.sid, src.cid, src.gr, USER, SYSDATE, USER, SYSDATE);

    v_rows := SQL%ROWCOUNT;
    COMMIT;

    v_end := DBMS_UTILITY.GET_TIME;
    DBMS_OUTPUT.PUT_LINE('Xu ly: ' || v_rows || ' hang | Thoi gian: '
        || ROUND((v_end - v_start)/100, 2) || ' giay');
EXCEPTION
    WHEN OTHERS THEN
        FOR j IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Loi hang ' || SQL%BULK_EXCEPTIONS(j).ERROR_INDEX
                || ': ' || SQLERRM(-SQL%BULK_EXCEPTIONS(j).ERROR_CODE));
        END LOOP;
        ROLLBACK;
END bulk_update_grades;
/

-- Cau 2.6: Thu tuc bao cao mon hoc voi dinh dang bang ASCII
CREATE OR REPLACE PROCEDURE generate_course_report
    (p_courseno IN NUMBER)
IS
    v_check  NUMBER; v_desc VARCHAR2(50);
    v_cost   NUMBER; v_prereq NUMBER;
    v_tong_sv NUMBER := 0; v_sum_d NUMBER := 0; v_co_d NUMBER := 0;
    v_sep  VARCHAR2(70) := RPAD('=', 60, '=');
    v_sep2 VARCHAR2(70) := RPAD('-', 60, '-');
BEGIN
    SELECT COUNT(*) INTO v_check FROM course WHERE courseno = p_courseno;
    IF v_check = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Mon hoc ' || p_courseno || ' khong ton tai!');
        RETURN;
    END IF;

    SELECT description, cost, prerequisite INTO v_desc, v_cost, v_prereq
    FROM course WHERE courseno = p_courseno;

    DBMS_OUTPUT.PUT_LINE(v_sep);
    DBMS_OUTPUT.PUT_LINE('BAO CAO MON HOC: ' || p_courseno);
    DBMS_OUTPUT.PUT_LINE(v_sep2);
    DBMS_OUTPUT.PUT_LINE('Ten mon  : ' || v_desc);
    DBMS_OUTPUT.PUT_LINE('Hoc phi  : ' || TO_CHAR(NVL(v_cost,0), '999,990.00') || ' VND');
    DBMS_OUTPUT.PUT_LINE('Mon tien q: ' || NVL(TO_CHAR(v_prereq), 'Khong co'));
    DBMS_OUTPUT.PUT_LINE(v_sep2);
    DBMS_OUTPUT.PUT_LINE(RPAD('Lop',5) || RPAD('Giao vien',20)
        || LPAD('SVDK',6) || LPAD('DTB',7) || ' Trang thai');
    DBMS_OUTPUT.PUT_LINE(v_sep2);

    FOR rec IN (
        SELECT cl.classid, cl.capacity,
               i.firstname || ' ' || i.lastname AS ten_gv,
               COUNT(e.studentid)               AS so_sv,
               ROUND(AVG(e.finalgrade), 1)       AS dtb
        FROM class cl
        JOIN instructor i   ON cl.instructorid = i.instructorid
        LEFT JOIN enrollment e ON cl.classid   = e.classid
        WHERE cl.courseno = p_courseno
        GROUP BY cl.classid, cl.capacity, i.firstname, i.lastname
        ORDER BY cl.classid
    ) LOOP
        v_tong_sv := v_tong_sv + rec.so_sv;
        IF rec.dtb IS NOT NULL THEN
            v_sum_d := v_sum_d + rec.dtb;
            v_co_d  := v_co_d  + 1;
        END IF;
        DBMS_OUTPUT.PUT_LINE(
            LPAD(rec.classid, 4) || ' ' || RPAD(rec.ten_gv, 20)
            || LPAD(rec.so_sv, 5) || LPAD(NVL(TO_CHAR(rec.dtb), '--'), 7)
            || ' ' || CASE WHEN rec.capacity - rec.so_sv > 0
                          THEN 'Con ' || (rec.capacity - rec.so_sv) || ' cho'
                          ELSE 'Het cho' END);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(v_sep2);
    DBMS_OUTPUT.PUT_LINE('Tong SV dang ky: ' || v_tong_sv);
    IF v_co_d > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Diem TB toan mon: ' || ROUND(v_sum_d/v_co_d, 2));
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_sep);
END generate_course_report;
/

-- Cau 2.7: Ham convert_to_gpa_40 va thu tuc print_gpa_report
CREATE OR REPLACE FUNCTION convert_to_gpa_40
    (p_studentid IN NUMBER) RETURN NUMBER
IS
    v_check NUMBER; v_gpa NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_check FROM student WHERE studentid = p_studentid;
    IF v_check = 0 THEN RETURN NULL; END IF;

    SELECT ROUND(
        SUM(CASE
            WHEN finalgrade >= 90 THEN 4.0
            WHEN finalgrade >= 85 THEN 3.7
            WHEN finalgrade >= 80 THEN 3.3
            WHEN finalgrade >= 75 THEN 3.0
            WHEN finalgrade >= 70 THEN 2.7
            WHEN finalgrade >= 65 THEN 2.3
            WHEN finalgrade >= 60 THEN 2.0
            WHEN finalgrade >= 50 THEN 1.0
            ELSE 0.0
        END * 3) /
        NULLIF(SUM(CASE WHEN finalgrade IS NOT NULL THEN 3 ELSE 0 END), 0)
    , 2) INTO v_gpa
    FROM enrollment WHERE studentid = p_studentid;

    RETURN v_gpa;
END convert_to_gpa_40;
/

CREATE OR REPLACE PROCEDURE print_gpa_report IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('StudentID',12) || RPAD('Ho Ten',25) || LPAD('GPA (4.0)',10));
    DBMS_OUTPUT.PUT_LINE(RPAD('-', 48, '-'));
    FOR rec IN (
        SELECT studentid, firstname || ' ' || lastname AS ho_ten
        FROM student ORDER BY studentid
    ) LOOP
        DECLARE v_gpa NUMBER;
        BEGIN
            v_gpa := convert_to_gpa_40(rec.studentid);
            IF v_gpa IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE(
                    LPAD(rec.studentid, 10) || ' ' || RPAD(rec.ho_ten, 25)
                    || LPAD(v_gpa, 9));
            END IF;
        END;
    END LOOP;
END print_gpa_report;
/


-- ============================================================
-- PHAN 6: BÀI 3 - TRIGGER NÂNG CAO
-- ============================================================

-- Cau 3.1: Compound Trigger giai quyet Mutating Table
CREATE OR REPLACE TRIGGER trg_update_class_count
    FOR INSERT OR UPDATE OR DELETE ON enrollment
    COMPOUND TRIGGER

    TYPE t_ids IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    v_ids t_ids;
    v_idx PLS_INTEGER := 0;

    BEFORE STATEMENT IS
    BEGIN
        v_idx := 0;
        v_ids.DELETE;
    END BEFORE STATEMENT;

    AFTER EACH ROW IS
    BEGIN
        v_idx := v_idx + 1;
        v_ids(v_idx) := CASE
            WHEN INSERTING OR UPDATING THEN :NEW.classid
            ELSE :OLD.classid
        END;
    END AFTER EACH ROW;

    AFTER STATEMENT IS
    BEGIN
        FOR i IN 1..v_idx LOOP
            UPDATE class
            SET so_sv = (SELECT COUNT(*) FROM enrollment WHERE classid = v_ids(i))
            WHERE classid = v_ids(i);
        END LOOP;
    END AFTER STATEMENT;

END trg_update_class_count;
/

-- Cau 3.2: INSTEAD OF UPDATE Trigger tren view 4 bang
CREATE OR REPLACE VIEW vw_class_enrollment_detail AS
SELECT e.classid, e.studentid,
       s.firstname || ' ' || s.lastname   AS ten_sv,
       co.description                     AS ten_mon,
       e.finalgrade,
       i.firstname || ' ' || i.lastname   AS ten_gv
FROM enrollment e
JOIN student s    ON e.studentid    = s.studentid
JOIN class cl     ON e.classid      = cl.classid
JOIN course co    ON cl.courseno    = co.courseno
JOIN instructor i ON cl.instructorid = i.instructorid;

CREATE OR REPLACE TRIGGER trg_iot_update_grade
    INSTEAD OF UPDATE ON vw_class_enrollment_detail
    FOR EACH ROW
DECLARE
    v_old_grade NUMBER;
BEGIN
    IF :NEW.finalgrade IS NOT NULL AND
       (:NEW.finalgrade < 0 OR :NEW.finalgrade > 100) THEN
        RAISE_APPLICATION_ERROR(-20060, 'Diem khong hop le (0-100)!');
    END IF;

    SELECT finalgrade INTO v_old_grade FROM enrollment
    WHERE studentid = :OLD.studentid AND classid = :OLD.classid;

    UPDATE enrollment
    SET finalgrade   = :NEW.finalgrade,
        modifiedby   = USER,
        modifieddate = SYSDATE
    WHERE studentid = :OLD.studentid AND classid = :OLD.classid;

    MERGE INTO grade g
    USING (SELECT :OLD.studentid AS sid, :OLD.classid AS cid FROM DUAL) src
    ON (g.studentid = src.sid AND g.classid = src.cid)
    WHEN MATCHED THEN
        UPDATE SET g.grade = :NEW.finalgrade, g.modifiedby = USER, g.modifieddate = SYSDATE
    WHEN NOT MATCHED THEN
        INSERT (studentid, classid, grade, createdby, createddate, modifiedby, modifieddate)
        VALUES (:OLD.studentid, :OLD.classid, :NEW.finalgrade, USER, SYSDATE, USER, SYSDATE);

    log_notification('System',
        'Cap nhat diem SV ' || :OLD.studentid || ' lop ' || :OLD.classid
        || ': ' || NVL(TO_CHAR(v_old_grade),'NULL') || '->' || :NEW.finalgrade,
        'GRADE');
END trg_iot_update_grade;
/

-- Cau 3.3: DDL Trigger ghi nhat ky moi thay doi cau truc
CREATE OR REPLACE TRIGGER trg_ddl_audit
    AFTER DDL ON SCHEMA
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    INSERT INTO ddl_audit_log
        (event_type, object_type, object_name, owner, event_time, current_usr)
    VALUES
        (ORA_SYSEVENT, ORA_DICT_OBJ_TYPE, ORA_DICT_OBJ_NAME,
         ORA_DICT_OBJ_OWNER, SYSDATE, ORA_LOGIN_USER);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN ROLLBACK;
END trg_ddl_audit;
/

-- Cau 3.4: Trigger chong Cascade khi xoa sinh vien
CREATE OR REPLACE TRIGGER trg_prevent_student_delete
    BEFORE DELETE ON student FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM enrollment WHERE studentid = :OLD.studentid;
    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20030,
            'Khong the xoa SV ' || :OLD.studentid ||
            ' dang co ' || v_count || ' lop dang ky! Huy dang ky truoc.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER trg_cascade_delete_grade
    AFTER DELETE ON student FOR EACH ROW
BEGIN
    DELETE FROM grade WHERE studentid = :OLD.studentid;
    DBMS_OUTPUT.PUT_LINE('Da xoa ' || SQL%ROWCOUNT || ' ban ghi GRADE cua SV ' || :OLD.studentid);
END;
/

-- Cau 3.5: Trigger voi WHEN - Tu dong cap chung chi khi dat diem
CREATE OR REPLACE TRIGGER trg_auto_certificate
    AFTER UPDATE OF finalgrade ON enrollment
    FOR EACH ROW
    WHEN (NEW.finalgrade >= 50)
DECLARE
    v_courseno NUMBER;
    v_check    NUMBER;
    v_loai     VARCHAR2(20);
    v_ten_sv   VARCHAR2(50);
    v_ten_mon  VARCHAR2(50);
BEGIN
    SELECT cl.courseno, co.description, s.firstname || ' ' || s.lastname
    INTO v_courseno, v_ten_mon, v_ten_sv
    FROM class cl
    JOIN course co ON cl.courseno = co.courseno
    JOIN student s ON s.studentid = :NEW.studentid
    WHERE cl.classid = :NEW.classid;

    SELECT COUNT(*) INTO v_check FROM certificate
    WHERE studentid = :NEW.studentid AND courseno = v_courseno;
    IF v_check > 0 THEN RETURN; END IF;

    v_loai := CASE
        WHEN :NEW.finalgrade >= 90 THEN 'HIGH_DISTINCTION'
        WHEN :NEW.finalgrade >= 75 THEN 'DISTINCTION'
        ELSE 'PASS'
    END;

    INSERT INTO certificate (studentid, courseno, cap_cc, loai)
    VALUES (:NEW.studentid, v_courseno, SYSDATE, v_loai);

    DBMS_OUTPUT.PUT_LINE('Chuc mung ' || v_ten_sv || ' da hoan thanh mon '
        || v_ten_mon || ' voi ' || v_loai || '!');
END trg_auto_certificate;
/


-- ============================================================
-- PHAN 7: BÀI 4 - TONG HOP
-- ============================================================

-- Cau 4.1: View dashboard tong quan
CREATE OR REPLACE VIEW vw_enrollment_dashboard AS
SELECT
    (SELECT COUNT(*) FROM class) AS so_lop_mo,
    (SELECT SUM(cl.capacity - NVL(ec.sv, 0))
     FROM class cl
     LEFT JOIN (SELECT classid, COUNT(*) sv FROM enrollment GROUP BY classid) ec
     ON cl.classid = ec.classid) AS tong_cho_trong,
    ROUND(
        (SELECT COUNT(*) FROM enrollment) * 100.0 /
        NULLIF((SELECT SUM(capacity) FROM class), 0)
    , 1) AS ty_le_lap_day_pct,
    (SELECT classid || ' (' || sv || ' SV)'
     FROM (SELECT classid, COUNT(*) sv FROM enrollment GROUP BY classid
           ORDER BY sv DESC FETCH FIRST 1 ROW ONLY)) AS lop_dong_nhat,
    (SELECT classid || ' (' || sv || ' SV)'
     FROM (SELECT classid, COUNT(*) sv FROM enrollment GROUP BY classid
           ORDER BY sv ASC FETCH FIRST 1 ROW ONLY)) AS lop_it_nhat
FROM DUAL;

-- Cau 4.1: Package pkg_enrollment_system
CREATE OR REPLACE PACKAGE pkg_enrollment_system AS
    FUNCTION  is_eligible(p_sid NUMBER, p_cid NUMBER) RETURN BOOLEAN;
    PROCEDURE do_enroll(p_sid NUMBER, p_cid NUMBER);
    PROCEDURE do_withdraw(p_sid NUMBER, p_cid NUMBER);
    FUNCTION  get_waitlist_position(p_sid NUMBER, p_cid NUMBER) RETURN NUMBER;
END pkg_enrollment_system;
/

CREATE OR REPLACE PACKAGE BODY pkg_enrollment_system AS

    FUNCTION is_eligible(p_sid NUMBER, p_cid NUMBER) RETURN BOOLEAN IS
        v_sv NUMBER; v_cl NUMBER; v_cap NUMBER; v_enr NUMBER; v_dup NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_sv FROM student WHERE studentid = p_sid;
        IF v_sv = 0 THEN RETURN FALSE; END IF;
        SELECT COUNT(*) INTO v_cl FROM class WHERE classid = p_cid;
        IF v_cl = 0 THEN RETURN FALSE; END IF;
        SELECT capacity INTO v_cap FROM class WHERE classid = p_cid;
        SELECT COUNT(*) INTO v_enr FROM enrollment WHERE classid = p_cid;
        IF v_enr >= v_cap THEN RETURN FALSE; END IF;
        SELECT COUNT(*) INTO v_dup FROM enrollment WHERE studentid = p_sid AND classid = p_cid;
        IF v_dup > 0 THEN RETURN FALSE; END IF;
        SELECT COUNT(*) INTO v_enr FROM enrollment WHERE studentid = p_sid;
        IF v_enr >= 3 THEN RETURN FALSE; END IF;
        RETURN TRUE;
    END is_eligible;

    PROCEDURE do_enroll(p_sid NUMBER, p_cid NUMBER) IS
    BEGIN
        IF NOT is_eligible(p_sid, p_cid) THEN
            DBMS_OUTPUT.PUT_LINE('[TU CHOI] Khong du dieu kien dang ky!');
            RETURN;
        END IF;
        INSERT INTO enrollment(studentid, classid, enrolldate, createdby, createddate, modifiedby, modifieddate)
        VALUES (p_sid, p_cid, SYSDATE, USER, SYSDATE, USER, SYSDATE);
        COMMIT;
        log_notification(USER, 'Dang ky: SV ' || p_sid || ' -> Lop ' || p_cid, 'ENROLL');
        DBMS_OUTPUT.PUT_LINE('[OK] Dang ky thanh cong!');
    END do_enroll;

    PROCEDURE do_withdraw(p_sid NUMBER, p_cid NUMBER) IS
        v_check NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_check FROM enrollment WHERE studentid = p_sid AND classid = p_cid;
        IF v_check = 0 THEN
            DBMS_OUTPUT.PUT_LINE('[LOI] SV chua dang ky lop nay!');
            RETURN;
        END IF;
        DELETE FROM enrollment WHERE studentid = p_sid AND classid = p_cid;
        COMMIT;
        log_notification(USER, 'Huy dk: SV ' || p_sid || ' khoi Lop ' || p_cid, 'WITHDRAW');
        DBMS_OUTPUT.PUT_LINE('[OK] Huy dang ky thanh cong!');
    END do_withdraw;

    FUNCTION get_waitlist_position(p_sid NUMBER, p_cid NUMBER) RETURN NUMBER IS
        v_cap NUMBER; v_enr NUMBER;
    BEGIN
        SELECT capacity INTO v_cap FROM class WHERE classid = p_cid;
        SELECT COUNT(*) INTO v_enr FROM enrollment WHERE classid = p_cid;
        IF v_enr < v_cap THEN RETURN 0; END IF;
        RETURN v_enr - v_cap + 1;
    END;

END pkg_enrollment_system;
/

-- Cau 4.2: Refactor bao cao bang BULK COLLECT
CREATE OR REPLACE PROCEDURE report_class_detail_v2
    (p_classid IN NUMBER)
IS
    TYPE t_rec IS RECORD (
        ho_ten     VARCHAR2(50),
        finalgrade NUMBER
    );
    TYPE t_recs IS TABLE OF t_rec INDEX BY PLS_INTEGER;
    v_data t_recs;
    v_stt  NUMBER := 0;
BEGIN
    SELECT s.firstname || ' ' || s.lastname, e.finalgrade
    BULK COLLECT INTO v_data
    FROM enrollment e
    JOIN student s ON e.studentid = s.studentid
    WHERE e.classid = p_classid
    ORDER BY s.lastname;

    DBMS_OUTPUT.PUT_LINE('So SV: ' || v_data.COUNT);
    FOR i IN 1..v_data.COUNT LOOP
        v_stt := v_stt + 1;
        DBMS_OUTPUT.PUT_LINE(LPAD(v_stt, 3) || ' ' || RPAD(v_data(i).ho_ten, 22)
            || LPAD(NVL(TO_CHAR(v_data(i).finalgrade), '--'), 6));
    END LOOP;
END report_class_detail_v2;
/


-- ============================================================
-- KIEM TRA NHANH
-- ============================================================

-- Kiem tra cac bang da co du lieu
SELECT 'STUDENT'    AS bang, COUNT(*) AS so_dong FROM student     UNION ALL
SELECT 'INSTRUCTOR' AS bang, COUNT(*) AS so_dong FROM instructor  UNION ALL
SELECT 'COURSE'     AS bang, COUNT(*) AS so_dong FROM course      UNION ALL
SELECT 'CLASS'      AS bang, COUNT(*) AS so_dong FROM class       UNION ALL
SELECT 'ENROLLMENT' AS bang, COUNT(*) AS so_dong FROM enrollment  UNION ALL
SELECT 'GRADE'      AS bang, COUNT(*) AS so_dong FROM grade;

-- Xem dashboard
SELECT * FROM vw_enrollment_dashboard;

-- Goi bao cao mon hoc so 10
BEGIN generate_course_report(10); END;
/

-- Goi bao cao GPA
BEGIN print_gpa_report; END;
/

-- Thu package dang ky
BEGIN
    pkg_enrollment_system.do_enroll(107, 1);
    pkg_enrollment_system.do_enroll(999, 1); -- SV khong ton tai -> bao loi
END;
/
