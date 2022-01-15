CREATE TABLE Caretaker (
    cid NUMERIC ,
    cname VARCHAR(15) NOT NULL,
    csurname VARCHAR(15) NOT NULL,
    birthDate DATE NOT NULL,
    sex CHAR(1) NOT NULL,
    telno NUMERIC(10) NOT NULL,
    salary NUMERIC NOT NULL,
    address VARCHAR(50) NOT NULL,
    CONSTRAINT pk_caretaker PRIMARY KEY (cid)
);

CREATE SEQUENCE cseq 
START WITH 1
NO MAXVALUE
INCREMENT BY 1;

CREATE TABLE Room (
    rno NUMERIC(2) PRIMARY KEY,
    capacity NUMERIC(1) NOT NULL,
    rfloor NUMERIC(1) NOT NULL,
	rcount NUMERIC(1) DEFAULT 0
);

CREATE SEQUENCE rseq 
START WITH 1
MAXVALUE 50
INCREMENT BY 1;

CREATE TABLE Medicine (
    mid NUMERIC PRIMARY KEY,
    mname VARCHAR(15) NOT NULL,
    dose NUMERIC(4) NOT NULL,
    mtype VARCHAR(15) NOT NULL,
    expdate DATE NOT NULL,
    freq NUMERIC(1) NOT NULL
);
    
CREATE SEQUENCE mseq 
START WITH 1
NO MAXVALUE
INCREMENT BY 1;

CREATE TABLE Relativep (
    rid NUMERIC,
    rname VARCHAR(15) NOT NULL,
    rsurname VARCHAR(15) NOT NULL,
    birthDate DATE,
    sex CHAR(1),
    telno NUMERIC(10) NOT NULL,
    email VARCHAR(35),
    address VARCHAR(50),
    CONSTRAINT pk_relative PRIMARY KEY (rid)
);

CREATE SEQUENCE reseq 
START WITH 1
NO MAXVALUE
INCREMENT BY 1;  

CREATE TABLE Patient (
    pid NUMERIC,
    pname VARCHAR(15) NOT NULL,
    psurname VARCHAR(15) NOT NULL,
    birthDate DATE NOT NULL,
    sex CHAR(1) NOT NULL,
	cid NUMERIC NOT NULL,
	rid NUMERIC,
	rno NUMERIC(2) NOT NULL,
    CONSTRAINT pk_pid PRIMARY KEY (pid),
	CONSTRAINT fk_cid FOREIGN KEY (cid) REFERENCES Caretaker(cid) ON DELETE CASCADE,
	CONSTRAINT fk_rid FOREIGN KEY (rid) REFERENCES Relativep(rid) ON DELETE CASCADE,
	CONSTRAINT fk_rno FOREIGN KEY (rno) REFERENCES Room(rno) ON DELETE CASCADE
);

CREATE SEQUENCE pseq 
START WITH 1
NO MAXVALUE
INCREMENT BY 1;

CREATE TABLE Patient_Medicine (
    pid NUMERIC,
    mid NUMERIC,
    CONSTRAINT fk_pid FOREIGN KEY (pid) REFERENCES Patient(pid) ON DELETE CASCADE,
    CONSTRAINT fk_mid FOREIGN KEY (mid) REFERENCES Medicine(mid) ON DELETE CASCADE
);

--Trigger Function for Caretaker
--Does not allow to insert/update a Caretaker with more than 10000 salary
CREATE OR REPLACE FUNCTION trig_func_Caretaker()
RETURNS TRIGGER AS $$
BEGIN 
    IF new.salary > 10000 THEN
		RAISE EXCEPTION 'Can not add/update Caretaker. Salary is too much.';
		RETURN old;
	ELSE
		RAISE INFO 'Succesfully added/updated Caretaker.';
		RETURN new;
	END IF;
END;
$$ LANGUAGE 'plpgsql';

--Trigger for Caretaker Insert/Update
CREATE OR REPLACE TRIGGER t_caretaker
AFTER INSERT OR UPDATE
ON Caretaker
FOR EACH ROW EXECUTE PROCEDURE trig_func_Caretaker();

--Trigger Function for Inserting Patient
--Increases the count of room that they stay
CREATE OR REPLACE FUNCTION trig_func_insertPatient()
RETURNS TRIGGER AS $$
DECLARE
room_capacity NUMERIC(1);
room_count NUMERIC(1);
BEGIN 
    SELECT r.capacity, r.rcount INTO room_capacity, room_count
    FROM Room r
    WHERE new.rno = r.rno;
    IF room_count + 1 > room_capacity THEN
        RAISE EXCEPTION 'Room is full.' ;
        RETURN old;
    ELSE
        UPDATE Room 
        SET rcount = room_count + 1
        WHERE new.rno = rno;
		RAISE INFO 'Successfully added.';
        RETURN new;
    END IF;
END;
$$ LANGUAGE 'plpgsql';

--Trigger for Inserting Patient
CREATE OR REPLACE TRIGGER t_patient
AFTER INSERT
ON Patient
FOR EACH ROW EXECUTE PROCEDURE trig_func_insertPatient();

--Trigger Function for Deleting Patient
--Decreases the count of room that they've stayed
CREATE OR REPLACE FUNCTION trig_func_deletePatient()
RETURNS TRIGGER AS $$
BEGIN 
    UPDATE Room 
    SET rcount = rcount - 1
    WHERE rno = old.rno;
    RAISE INFO 'Patient has been deleted!';
    RETURN new;
END;
$$ LANGUAGE 'plpgsql';

--Trigger for Deleting Patient
CREATE OR REPLACE TRIGGER t_patientDelete
AFTER DELETE
ON Patient
FOR EACH ROW EXECUTE PROCEDURE trig_func_deletePatient();

INSERT INTO Caretaker VALUES(nextval('cseq'), 'Ahmet', 'YAZICI', '1988-02-15','M', '5444323453', '5000','Sinop');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Yaşar', 'USLU', '1979-04-25','M', '5310492314', '3500', 'Kars');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Fatma', 'ÇİÇEK', '1991-07-21','F', '5456841236', '7000', 'İstanbul');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Selma', 'YAŞAR', '1977-03-01','F', '5645853215', '6500', 'İstanbul');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Sami', 'UZUN', '1998-10-25','M', '5463257896', '9000', 'Erzurum');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Ayşe', 'OT', '1986-06-22','M', '5462354812', '8000', 'Manisa');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Betül', 'DEMİR', '1989-07-10','M', '5403625632', '5000', 'İzmir');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Recep', 'SEMİZ', '1990-03-28','M', '5551124423', '1000', 'Antalya');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Serkan', 'BEKTAŞ', '1992-12-06','M', '5902135065', '2500', 'İstanbul');
INSERT INTO Caretaker VALUES(nextval('cseq'), 'Elif', 'ÇİMEN', '1991-05-05','M', '5662457811', '6000', 'Trabzon');

INSERT INTO Room VALUES(nextval('rseq'), '3', '0');
INSERT INTO Room VALUES(nextval('rseq'), '4', '0');
INSERT INTO Room VALUES(nextval('rseq'), '2', '0');
INSERT INTO Room VALUES(nextval('rseq'), '3', '1');
INSERT INTO Room VALUES(nextval('rseq'), '3', '1');
INSERT INTO Room VALUES(nextval('rseq'), '2', '1');
INSERT INTO Room VALUES(nextval('rseq'), '4', '2');
INSERT INTO Room VALUES(nextval('rseq'), '4', '2');
INSERT INTO Room VALUES(nextval('rseq'), '3', '2');
INSERT INTO Room VALUES(nextval('rseq'), '1', '3');

INSERT INTO Medicine VALUES(nextval('mseq'), 'Painkiller', '10', 'Injection', '2023-09-08', '5');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Parol', '100', 'Pill', '2023-09-25', '3');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Aspirin', '20', 'Tablet', '2024-10-08', '2');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Aferin', '25', 'Syrup', '2028-07-26', '4');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Poison', '1', 'Liquid', '199-09-09', '1');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Aferin', '25', 'Syrup', '2028-07-26', '4');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Penicillin', '250', 'Injection', '2025-01-04', '2');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Procrit ', '10', 'Pill', '2029-11-12', '3');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Procrit ', '100', 'Pill', '2029-11-12', '2');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Plavix', '100', 'Pill', '2022-10-30', '2');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Zoloft', '25', 'Pill', '2024-05-18', '1');
INSERT INTO Medicine VALUES(nextval('mseq'), 'Zoloft', '150', 'Syrup', '2024-05-18', '3');

INSERT INTO Relativep (rid, rname, rsurname, sex, telno, email)VALUES(nextval('reseq'), 'Ayşe', 'KORKMAZ', 'F', '5689641235', 'aysekorkmaz@gmail.com');
INSERT INTO Relativep (rid, rname, rsurname, telno, address)VALUES(nextval('reseq'), 'Fatıma', 'ARSLAN', '5963241102', 'Samsun');
INSERT INTO Relativep (rid, rname, rsurname, birthDate, sex, telno, email, address)VALUES(nextval('reseq'), 'Hamza', 'GÜÇLÜ', '1967-06-26', 'M','5696548531', 'hamza99@hotmail.com', 'Van');
INSERT INTO Relativep (rid, rname, rsurname, telno)VALUES(nextval('reseq'), 'Emir', 'TENİT', '5055642358');
INSERT INTO Relativep (rid, rname, rsurname, sex, telno, email)VALUES(nextval('reseq'), 'Sadık', 'ÇAĞLAR', 'M', '5461238464', 'sadikcag@gmail.com');
INSERT INTO Relativep (rid, rname, rsurname, birthDate, telno)VALUES(nextval('reseq'), 'İsmail', 'FINDIK', '1975-11-12', '5324562310');
INSERT INTO Relativep (rid, rname, rsurname, telno)VALUES(nextval('reseq'), 'Sevim', 'SAĞLAM', '5235468596');
INSERT INTO Relativep (rid, rname, rsurname, telno, email, address)VALUES(nextval('reseq'), 'Çağlar', 'DEMİR', '5646451231', 'cagli9_9@gmail.com', 'Berlin');
INSERT INTO Relativep (rid, rname, rsurname, sex, telno)VALUES(nextval('reseq'), 'Hatice', 'ÇİÇEK', 'F', '5465836545');
INSERT INTO Relativep (rid, rname, rsurname, birthDate, telno, email)VALUES(nextval('reseq'), 'Muhammet', 'DAĞ', '1999-09-09', '5012350110', 'Hakkari');

INSERT INTO Patient VALUES(nextval('pseq'), 'Hasan', 'BAŞ', '1956-10-13','M', '1', '1', '1');
INSERT INTO Patient VALUES(nextval('pseq'), 'Onur', 'ALKAN', '1960-07-02','M', '3', '2', '1');
INSERT INTO Patient VALUES(nextval('pseq'), 'Burak', 'ERDİLLİ', '1963-01-23','M', '1', '7', '1');
INSERT INTO Patient VALUES(nextval('pseq'), 'Mehmet Celal', 'KELEŞ', '1967-05-24','M', '4', '9', '2');
INSERT INTO Patient VALUES(nextval('pseq'), 'Nilda', 'TAYHAN', '1946-01-27','F', '4', NULL, '3');
INSERT INTO Patient VALUES(nextval('pseq'), 'Dilek', 'TAÇ', '1945-10-15','F', '9', '6', '3');
INSERT INTO Patient VALUES(nextval('pseq'), 'Fadime', 'YUMRUK', '1952-12-17','F', '10', '5', '6');
INSERT INTO Patient VALUES(nextval('pseq'), 'Hakan', 'KAPI', '1940-02-05','M', '7', NULL, '2');
INSERT INTO Patient VALUES(nextval('pseq'), 'Damla', 'İSMAİLOĞLU', '1938-07-23','F', '5', NULL, '8');
INSERT INTO Patient VALUES(nextval('pseq'), 'Emre', 'KARACA', '1957-05-21','M', '5', '10', '7');

INSERT INTO Patient_Medicine VALUES('1','2');
INSERT INTO Patient_Medicine VALUES('7','7');
INSERT INTO Patient_Medicine VALUES('3','4');
INSERT INTO Patient_Medicine VALUES('8','1');
INSERT INTO Patient_Medicine VALUES('1','3');
INSERT INTO Patient_Medicine VALUES('9','6');
INSERT INTO Patient_Medicine VALUES('4','1');
INSERT INTO Patient_Medicine VALUES('1','1');
INSERT INTO Patient_Medicine VALUES('10','5');
INSERT INTO Patient_Medicine VALUES('2','8');

--Caretakers who have more than one patient
SELECT cname, csurname
FROM Caretaker
WHERE cid in (SELECT cid
FROM Patient 
GROUP BY cid
HAVING count(*) > 1);

--Shows patients that says in a specific room
SELECT pname, psurname
FROM Patient
WHERE rno = '1'

--Gets Patient data who has relative with address
SELECT pname, psurname
FROM Patient
WHERE rid IN (SELECT rid FROM Patient
WHERE rid IS NOT NULL
EXCEPT
SELECT rid FROM Relativep
WHERE address IS NULL)

--Create View for Salaries Above Average
CREATE VIEW getSalariesAboveAVG
AS
SELECT cname, csurname, salary
FROM Caretaker
WHERE salary > (SELECT avg(salary)
			   FROM Caretaker);			   
		
--20% increase on the salary for Caretakers who have been born before 1990
UPDATE Caretaker SET salary = salary * 1.20 WHERE EXTRACT(YEAR FROM birthdate) < 1990;

--Deletes expired medicines from Medicine
CREATE OR REPLACE FUNCTION deleteExpriedMedicines(p_name Patient.pname%TYPE, p_surname Patient.pname%TYPE)
RETURNS VOID AS $$
DECLARE
	curs CURSOR FOR SELECT DISTINCT mid FROM Patient_Medicine WHERE pid IN (SELECT pid
																		   FROM Patient
																		   WHERE p_name = pname AND
																		   p_surname = psurname);
	m_date DATE;
BEGIN
	FOR satir IN curs LOOP
		SELECT expdate INTO m_date
		FROM Medicine
		WHERE mid = satir.mid;
		IF m_date < now() THEN
			DELETE FROM Medicine WHERE mid = satir.mid;
			RAISE INFO 'Medicine with % id successfully deleted', satir.mid;
		END IF;
	END LOOP;
END;
$$ LANGUAGE 'plpgsql';

--SELECT deleteExpriedMedicines('Onur', 'ALKAN')

--Type for Rooms Data
CREATE TYPE rooms_record AS (rno NUMERIC(2), rcount NUMERIC(1), rfloor NUMERIC(1));

--Gets Room Data with Caretaker ID
CREATE OR REPLACE FUNCTION get_room_through_caretaker(caid Caretaker.cid%TYPE)
RETURNS rooms_record[] AS $$
DECLARE
	bilgi rooms_record[];
	tmp rooms_record;
	rcursor CURSOR FOR SELECT DISTINCT rno FROM Patient WHERE cid = caid;
	i INTEGER;
BEGIN
	i = 1;
	FOR satir IN rcursor LOOP
		SELECT rno, rcount, rfloor INTO tmp
		FROM Room WHERE satir.rno = rno;
		RAISE INFO 'Room no: %, Count: %, Floor: %', tmp.rno, tmp.rcount, tmp.rfloor;
		bilgi[i] = tmp;
		i = i + 1;
	END LOOP;
	RETURN bilgi;
END;
$$ LANGUAGE 'plpgsql';

--SELECT get_room_through_caretaker('4');

--Type for Patient Data
CREATE TYPE patient_data AS (pname VARCHAR(15), psurname VARCHAR(15));

--Gets Patient Data with Floor
CREATE OR REPLACE FUNCTION getPatientsWithFloor(r_floor Room.rfloor%TYPE, OUT bilgi patient_data[])
AS $$
DECLARE
	rcursor CURSOR FOR SELECT pname, psurname
						FROM Patient p, Room r
						WHERE r.rfloor = r_floor AND p.rno = r.rno;
	i INTEGER;
BEGIN
	i = 1;
	FOR satir IN rcursor LOOP
		RAISE INFO '% %', satir.pname, satir.psurname;
		bilgi[i].pname = satir.pname;
		bilgi[i].psurname = satir.psurname;
		i = i + 1;
	END LOOP;
END;
$$ LANGUAGE 'plpgsql';

--SELECT getPatientsWithFloor('0')
