-- -----------------------------------------------------
-- Schema pharmacy_db
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS pharmacy_db;
CREATE SCHEMA IF NOT EXISTS pharmacy_db;
USE pharmacy_db;

-- -----------------------------------------------------------
-- Table supplier_info
-- -----------------------------------------------------------
DROP TABLE IF EXISTS supplier_info;
CREATE TABLE IF NOT EXISTS supplier_info (
	supplierID			INT(5) NOT NULL AUTO_INCREMENT,
    supp_name			VARCHAR(40) NOT NULL,
    supp_description	VARCHAR(240) NOT NULL,
    address				VARCHAR(100) NOT NULL,
    contact_number		BIGINT(12) NOT NULL,
    
    PRIMARY KEY (supplierID)

);

-- -----------------------------------------------------
-- Table medicine_info
-- -----------------------------------------------------
DROP TABLE IF EXISTS medicine_info;
CREATE TABLE IF NOT EXISTS medicine_info (
  medicine_id			INT(5) NOT NULL AUTO_INCREMENT,
  generic_name			VARCHAR(70)	NOT NULL,
  brand_name			VARCHAR(70)	NOT NULL,
  volume_ml				FLOAT,
  dosage_mg				FLOAT,
  isPrescription		BOOLEAN NOT NULL,
  category				ENUM("Pain Reliever", "Antibiotics", "Antifungals", "Antivirals", "Antihistamines", "Anti-inflammatory", "Antiseptics", "Antacids", "Laxatives", "Hormones", "Gastrointestinal Medications", "Psychotropic Medications", "Muscle Relaxants", "Topical Medications") NOT NULL,
  sellingPrice			FLOAT NOT NULL,
  description			VARCHAR(240) NOT NULL,
  supplierID			INT(5),
  
  PRIMARY KEY	(medicine_id),
  FOREIGN KEY	(supplierID)
	REFERENCES	supplier_info(supplierID)
);

-- --------------------------------------------------------
-- Table orders
-- --------------------------------------------------------
DROP TABLE IF EXISTS orders;
CREATE TABLE IF NOT EXISTS orders (
	orderID				INT(5) NOT NULL AUTO_INCREMENT,
    supplierID			INT(5),
    date_ordered		DATE NOT NULL,
    medicineID			INT(5) NOT NULL,
    quantity			INT(5) NOT NULL,
    expiryDate			DATE NOT NULL,
    priceSold			FLOAT NOT NULL,
    order_status		ENUM("ordered", "sent"),
    -- ordered is 


    
    PRIMARY KEY	(orderID),
    FOREIGN KEY (supplierID)
		REFERENCES supplier_info(supplierID),
	FOREIGN KEY (medicineID)
		REFERENCES medicine_info(medicine_id)	
    
);

-- ------------------------------------------------------
-- Table positions
-- ------------------------------------------------------
DROP TABLE IF EXISTS positions;
CREATE TABLE IF NOT EXISTS positions (
	position_name	VARCHAR(30) NOT NULL,
    salary			FLOAT NOT NULL,
    
    PRIMARY KEY(position_name)
);


-- ------------------------------------------------------
-- Table employees
-- ------------------------------------------------------
DROP TABLE IF EXISTS employees;
CREATE TABLE IF NOT EXISTS employees (
	employee_id		INT(5) NOT NULL AUTO_INCREMENT,
    position_name	VARCHAR(30) NOT NULL,
    first_name		VARCHAR(20) NOT NULL,
    last_name		VARCHAR(20) NOT NULL,
    contact_no		BIGINT(12) NOT NULL,
    pw				VARCHAR(30) NOT NULL,
    address			VARCHAR(100) NOT NULL,
    
    PRIMARY KEY (employee_id),
    FOREIGN KEY (position_name)
		REFERENCES positions(position_name)

);


-- -----------------------------------------------------
-- Table transactions
-- -----------------------------------------------------
DROP TABLE IF EXISTS transactions;
CREATE TABLE IF NOT EXISTS transactions (
    transactionID       INT(5) NOT NULL AUTO_INCREMENT,
    priceBought			FLOAT NOT NULL,
    cashier             INT(5) ,
    pharmacist          INT(5) ,
    transactionDate     DATETIME,
    
    PRIMARY KEY (transactionID),
    FOREIGN KEY (cashier) REFERENCES employees(employee_id) ON DELETE SET NULL,
    FOREIGN KEY (pharmacist) REFERENCES employees(employee_id) ON DELETE SET NULL
);

-- -----------------------------------------------------
-- Table medicine_stock
-- -----------------------------------------------------
DROP TABLE IF EXISTS medicine_stock;
CREATE TABLE IF NOT EXISTS medicine_stock (
  stock_id		BIGINT(12) NOT NULL AUTO_INCREMENT,
  medicine_id	INT(5),
  dateReceived	DATE NOT NULL,
  dateExpire	DATE NOT NULL,
  priceBought	FLOAT NOT NULL,
  transactionID INT(5) DEFAULT NULL,
  
  PRIMARY KEY	(stock_id),
  FOREIGN KEY	(medicine_id)
	REFERENCES	medicine_info(medicine_id),
  FOREIGN KEY	(transactionID)
	REFERENCES	transactions(transactionID)
);

-- -----------------------------------------------------
-- Table symptom
-- -----------------------------------------------------
DROP TABLE IF EXISTS symptom;
CREATE TABLE IF NOT EXISTS symptom (
	symptom_id				INT(5) NOT NULL AUTO_INCREMENT,
    symptom_name			VARCHAR(30) NOT NULL,
    symptom_description		VARCHAR(240) NOT NULL,
    
    PRIMARY KEY(symptom_id)
);

-- -----------------------------------------------------
-- Table symptom_and_medicine
-- -----------------------------------------------------
DROP TABLE IF EXISTS symptom_and_medicine;
CREATE TABLE IF NOT EXISTS symptom_and_medicine (
	symptom_id				INT(5) NOT NULL,
    medicine_id				INT(5) NOT NULL,
    relation_description	VARCHAR(240) NOT NULL,
    
    PRIMARY KEY (symptom_id, medicine_id),
    FOREIGN KEY (symptom_id)
		REFERENCES symptom(symptom_id),
	FOREIGN KEY (medicine_id)
		REFERENCES medicine_info(medicine_id)
);

-- ----------------------------------------------
-- Table payout
-- ----------------------------------------------
DROP TABLE IF EXISTS payout;
CREATE TABLE IF NOT EXISTS payout (
    payout_id       INT(5) NOT NULL AUTO_INCREMENT,
    employee_id     INT(5),
    date_given      DATE NOT NULL,
    payout_amount   FLOAT NOT NULL,
    position_name   VARCHAR(30),

    PRIMARY KEY(payout_id),
    FOREIGN KEY(employee_id)
        REFERENCES employees(employee_id) ON DELETE SET NULL,

    FOREIGN KEY(position_name)
        REFERENCES  positions(position_name)

);

-- ----------------------------------------------
-- Procedure InsertMedicineStock
-- ----------------------------------------------
DROP PROCEDURE IF EXISTS InsertMedicineStock;
DELIMITER //
CREATE PROCEDURE InsertMedicineStock(
    IN numRecords INT,
    IN medicineID INT,
    IN Received DATE,
    IN expired DATE,
    IN priceBought FLOAT
)
BEGIN
    DECLARE counter INT DEFAULT 1;
    DECLARE lastStockID INT DEFAULT 0;
    -- Find the last stock_id
		SET lastStockID = (SELECT coalesce(MAX(stock_id), 0) FROM medicine_stock);
    -- Set counter to the next stock_id
    SET counter := lastStockID + 1;
    -- Start loop
    WHILE counter <= (lastStockID + numRecords) DO
        -- Insert record into medicine_stock
        INSERT INTO medicine_stock (stock_id, medicine_id, dateReceived, dateExpire, priceBought)
        VALUES (counter, medicineID, received, expired, priceBought);

        -- Increment counter
        SET counter := counter + 1;
    END WHILE;
END //



DELIMITER ;



INSERT INTO supplier_info
	VALUES 	(00001, "PharManila Inc.", "Unilab Distributor", "1002, Espana Blvd, Sampaloc, Manila", 639172180341),
			(00002, "AnimoMeds Inc.", "Pfizer Distributor", "2401, Taft Ave, Malate, Manila", 639952180351),
            (00003, "MedLink Logistics", "Generics Distributor", "2402, Roxas Blvd, Ermita, Manila", 639174321234),
            (00004, "MedArcher  Distributors", "Distributor for Reckitt Benckiser", "2309, Don Chino Roces Ave Ext, Makati", 639152185710);

INSERT INTO medicine_info (medicine_id, generic_name, brand_name, volume_ml, dosage_mg, isPrescription, category, sellingPrice, description,supplierID)
	VALUES 	(0001, "Sodium Alginate Sodium Bicarbonate Calcium Carbonate", "Gaviscon", 10, NULL, FALSE, "Antacids", 30, "for acid reflux", 4),
			(0002, "Paracetamol", "Biogesic", NULL, 500, FALSE, "Pain Reliever", 3, "General Pain Reliever Drug", 1),
            (0003, "Clindamycin", "Cleocin", NULL, 300, TRUE, "Antibiotics", 140, "Strong Antibiotic for Acne", 2),
            (0004, "Phenylephrine HCI Chlorphenamine Maleate Paracetamol", "Neozep", NULL, 500, FALSE, "Pain Reliever", 7, "Leading cold medicine, trusted for more than 60 years.", 1),
            (0005, "Advil", "Ibuprofen", NULL, 500, FALSE, "Anti-inflammatory", 9, "Effective OTC Anti-inflammatory drug.", 2),
            (0006, "Loperamide", "Diatabs", NULL, 2, FALSE, "Gastrointestinal Medications", 8, "Trusted Antidiarrheal medication.", 1),
            (0007, "Cetirizine", "RiteMed Cetirizine", 60, NULL, FALSE, "Antihistamines", 210, "For allergies.", 3),
            (0008, "Loratadine", "Allerta", NULL, 10, FALSE, "Antihistamines", 5, "For sneezing and runny nose", 1),
            (0009, "Ibuprofen", "Advil Junior", NULL, 100, FALSE, "Anti-inflammatory", 5, "Children's pain reliever", 2),
			(0010, "Diphenhydramine", "SleepEase", 50, NULL, FALSE, "Antihistamines", 12, "Sleep aid for adults", 3),
			(0011, "Famotidine", "HeartGuard", NULL, 20, FALSE, "Antacids", 8, "For heartburn relief", 1),
			(0012, "Loratadine", "AllerEase", NULL, 10, FALSE, "Antihistamines", 7, "Non-drowsy allergy relief", 3),
			(0013, "Simethicone", "GasX", NULL, 125, FALSE, "Antacids", 15, "Relief from gas and bloating", 1),
            (0014, "Amoxicillin", "Amoxil", NULL, 500, TRUE, "Antibiotics", 120, "Common antibiotic for bacterial infections", 2),
			(0015, "Lisinopril", "Zestril", NULL, 10, TRUE, "Hormones", 18, "For high blood pressure", 1),
			(0016, "Omeprazole", "Prilosec", 20, NULL, TRUE, "Antacids", 25, "Prescription-strength acid reducer",1),
			(0017, "Sertraline", "Zoloft", NULL, 50, TRUE, "Psychotropic Medications", 30, "Antidepressant", 4),
			(0018, "Rosuvastatin", "Crestor", NULL, 10, TRUE, "Hormones", 40, "For managing cholesterol levels", 2);

INSERT INTO orders (supplierID, date_ordered, medicineID, quantity, expiryDate, priceSold, order_status)
    VALUES (00003, '2023-11-19', 0002, 100, '2026-11-18', 2, 'ordered'),
            (00001, '2023-10-24', 0017, 5, '2025-10-23', 24, 'sent'),
            (00001, '2023-10-25', 0002, 10, '2025-10-24', 2, 'ordered'),
            (00003, '2023-11-08', 0010, 4, '2025-11-07', 8, 'sent'),
            (00002, '2023-10-25', 0001, 5, '2026-10-24', 20, 'ordered'),
            (00004, '2023-10-26', 0003, 10, '2026-10-25', 100, 'ordered');

CALL InsertMedicineStock(100, 0002, '2023-11-29', '2026-11-18', 2);
CALL InsertMedicineStock(10, 0002, '2023-10-25', '2025-10-24', 2);
CALL InsertMedicineStock(5, 0001, '2023-10-25', '2026-10-24', 20);
CALL InsertMedicineStock(10, 0003,  '2023-10-26', '2026-10-25', 100);   

INSERT INTO symptom
	VALUES 	(0001, "Heartburn", "Burning sensation in the chest"),
			(0002, "Fever", "Elevated body temperature"),
			(0003, "Acne", "Skin condition with pimples and blemishes"),
			(0004, "Cold", "Upper respiratory infection with congestion and runny nose"),
			(0005, "Pain", "General discomfort or distress"),
			(0006, "Diarrhea", "Frequent bowel movements with loose or watery stools"),
			(0007, "Allergies", "Immune system response to allergens"),
			(0008, "Runny Nose", "Excessive nasal discharge"),
			(0009, "Children's Pain", "Pain relief for children"),
			(0010, "Sleep Disturbance", "Difficulty falling or staying asleep"),
			(0012, "Allergies", "Immune system response to allergens"),
			(0013, "Gas and Bloating", "Discomfort due to trapped gas in the digestive system"),
			(0014, "Bacterial Infections", "Infections caused by bacteria"),
			(0015, "High Blood Pressure", "Elevated blood pressure"),
			(0016, "Acid Reflux", "Backward flow of stomach acid into the esophagus"),
			(0017, "Depression", "Persistent feelings of sadness and hopelessness"),
			(0018, "High Cholesterol", "Elevated levels of cholesterol in the blood");
            
INSERT INTO symptom_and_medicine
	VALUES 	(0001, 0001, "Relieves heartburn symptoms"),
			(0001, 0011, "Relieves heartburn symptoms"),
			(0002, 0002, "Reduces fever and provides pain relief"),
			(0003, 0003, "Treats acne and bacterial skin infections"),
			(0004, 0004, "Relieves symptoms of cold, congestion, and runny nose"),
			(0005, 0002, "Provides general pain relief"),
			(0005, 0004, "Alleviates pain associated with cold symptoms"),
			(0006, 0006, "Controls and prevents diarrhea"),
			(0007, 0007, "Provides relief from allergy symptoms"),
			(0008, 0008, "Addresses runny nose and sneezing due to allergies"),
			(0009, 0005, "Children's pain reliever for various discomforts"),
			(0010, 0010, "Induces sleep and aids in sleep-related issues"),
			(0012, 0008, "Addresses runny nose and sneezing due to allergies"),
			(0013, 0013, "Relieves symptoms of gas and bloating"),
			(0015, 0015, "Lowers high blood pressure"),
			(0016, 0016, "Reduces acid reflux symptoms"),
			(0017, 0017, "Treats symptoms of depression"),
			(0018, 0018, "Lowers high cholesterol levels"),
			(0009, 0004, "Alleviates pain associated with cold symptoms in children"),
			(0009, 0001, "Provides relief from stomach discomfort in children"),
			(0010, 0007, "Reduces symptoms of allergies contributing to sleep disturbance"),
			(0012, 0007, "Relieves symptoms of allergies in the respiratory system"),
			(0013, 0011, "Relieves heartburn symptoms caused by gas"),
			(0014, 0003, "Effective against bacterial skin infections"),
			(0015, 0010, "Supports blood pressure management with sleep aid"),
			(0017, 0007, "Supports mental health by addressing allergy-related symptoms");
            
INSERT INTO positions
	VALUES ("Pharmacist", 30000),
		   ("Cashier", 20000),
           ("Inventory Clerk", 20000),
           ("Security Guard", 22000),
           ("Janitor", 15000),
           ("Delivery Driver", 20000);

INSERT INTO employees
	VALUES (1, "Pharmacist", "Juan", "Dela Cruz", "639171234567", "12345", "100 Sinigang St, Tramo, Pasay"),
		   (2, "Cashier", "Jose", "Lopez", "639185551234", "IloveMyChildren", "123 Main St, Mandaluyong"),
           (3, "Security Guard", "Sofia", "Santiago", "639184445555", "IloveMyHusband", "101 Elm St, Pasig"),
           (4, "Janitor", "Oliver", "Villanueva", "639187776666", "ImissYouSoMuch", "202 Maple St, Makati");
           
INSERT INTO payout (payout_id, employee_id, date_given, payout_amount, position_name)
    VALUES  (1, 1, '2023-10-30', 30000, 'Pharmacist'),     
            (2, 2, '2023-10-30', 20000, 'Cashier'),       
            (3, 3, '2023-10-30', 22000, 'Security Guard'),
            (4, 4, '2023-10-30', 15000, 'Janitor');

INSERT INTO transactions (priceBought, cashier, pharmacist,transactionDate)
	VALUES	(140, 2, 1, NOW()),
			(140, 2, 1, NOW()),
            (30, 2, 1, NOW());

UPDATE medicine_stock
SET transactionID = 00001
WHERE stock_id = 121;

UPDATE medicine_stock
SET transactionID = 00002
WHERE stock_id = 122;

UPDATE medicine_stock
SET transactionID = 00003
WHERE stock_id = 111;


SELECT *
FROM supplier_info;

SELECT *
FROM medicine_info
WHERE brand_name = 'Gaviscon';

SELECT s.symptom_name, m.brand_name
FROM symptom_and_medicine sm JOIN medicine_info m 
						ON sm.medicine_id = m.medicine_id
                        JOIN symptom s
                        ON sm.symptom_id = s.symptom_id;


-- REPORT 1
SELECT s.symptom_name, s.symptom_description, m.generic_name, m.brand_name, sm.relation_description
FROM symptom s JOIN symptom_and_medicine sm
				ON s.symptom_ID = sm.symptom_ID
                JOIN medicine_info m
                ON sm.medicine_ID = m.medicine_ID
WHERE s.symptom_name = "Heartburn";

-- Record Number 2
SELECT
    report_year,
    report_month,
    SUM(total_sales) AS total_sales,
    SUM(total_costs) AS total_costs,
    SUM(total_salary) AS total_salary,
    SUM(total_sales) - SUM(total_salary) - SUM(total_costs) AS total_profits
FROM (
    -- Get Monthly Sales
    SELECT
        YEAR(t.transactionDate) AS report_year,
        MONTH(t.transactionDate) AS report_month,
        SUM(t.priceBought) AS total_sales,
        0 AS total_salary,
        0 AS total_costs
    FROM
        medicine_stock ms JOIN transactions t
        ON ms.transactionID = t.transactionID
    WHERE 
        ms.transactionID IS NOT NULL
    GROUP BY
        report_year, report_month

    UNION

    -- Get Monthly Salary Report
    SELECT
        YEAR(date_given) AS report_year,
        MONTH(date_given) AS report_month,
        0 AS total_sales,
        SUM(payout_amount) AS total_salary,
        0 AS total_costs
    FROM
        payout
    GROUP BY
        report_year, report_month

    UNION

    -- Get Monthly Drug Cost Report
    SELECT
        YEAR(date_ordered) AS report_year,
        MONTH(date_ordered) AS report_month,
        0 AS total_sales,
        0 AS total_salary,
        SUM(priceSold * quantity) AS total_costs
    FROM
        orders
    GROUP BY
        report_year, report_month
) AS combined_data
GROUP BY
    report_year, report_month
ORDER BY
    report_year, report_month;

-- Report 3 : Monthly stock Report By Medicine.
-- Stock In
SELECT i.medicine_id, i.brand_name, YEAR(s.dateReceived) AS 'year_report', MONTH(s.dateReceived) AS 'month_report', COUNT(s.stock_id) AS 'Amount Received'
FROM medicine_stock s LEFT JOIN medicine_info i
					ON i.medicine_id = s.medicine_id
GROUP BY i.medicine_id, year_report, month_report
ORDER BY year_report, month_report;


-- Stock Out
SELECT i.medicine_id, i.brand_name, YEAR(t.transactionDate) AS 'year_report', MONTH(t.transactionDate) AS 'month_report', COUNT(s.stock_id) AS 'Amount Sold'
FROM transactions t LEFT JOIN medicine_stock s
                      ON s.transactionID = t.transactionID
                      LEFT JOIN medicine_info i
                      ON s.medicine_id = i.medicine_id
GROUP BY i.medicine_id, year_report, month_report
ORDER BY year_report, month_report;

-- expiring report
SELECT s.medicine_id, i.brand_name, YEAR(s.dateExpire) AS 'year_report', MONTH(s.dateExpire) AS 'month_report', COUNT(s.stock_id) AS 'Amount Expiring'
FROM medicine_stock s LEFT JOIN medicine_info i
					  ON s.medicine_id = i.medicine_id
WHERE s.transactionID IS NULL
GROUP BY s.medicine_id, year_report, month_report
ORDER BY year_report, month_report;


-- Core Data Records (add, search and view, filter and listing, update, delete)  --


-- Prescription and Over-the-counter Medicines --
-- Add medecine type ✅ 
INSERT INTO medicine_info (generic_name, brand_name, volume_ml, dosage_mg, isPrescription, category, sellingPrice, description, supplierID)
    VALUES ('Paracetamol', 'Biogesic', NULL, 500, FALSE, 'Pain Reliever', 3, 'General Pain Reliever Drug', 1);  

-- Search and View ✅ (Change the column and value to look for)
SELECT * FROM medicine_info WHERE medicine_id = 1;
SELECT * FROM medicine_info WHERE brand_name = 'Biogesic';

-- Filter and Listing ✅ (Just change the category and the value)
SELECT * FROM medicine_info WHERE category = 'Pain Reliever';

-- Update ✅ (change column to change)
UPDATE medicine_info
SET brand_name = 'Biogesic Extra Strength'
WHERE medicine_id = 1;

-- TODO: Delete medicine_info
-- TODO: Should I do CRUD for medine_stock

-- Employees
-- Add ✅
INSERT INTO employees (position_name, first_name, last_name, contact_no, pw, address)
    VALUES ('Cashier', 'Juana', 'Lopez', '639185551234', 'Idontlikechikdren', '123 Main St, Mandaluyong');

-- Search and View ✅
SELECT * FROM employees WHERE employee_id = 2;

-- Filter and Listing ✅ (change the column and value to look for)
SELECT * FROM employees WHERE position_name = 'Cashier';

-- Update ✅ (change column)
UPDATE employees
SET pw = 'IloveMyWife'
WHERE employee_id = 2;

-- Delete ✅
DELETE FROM employees WHERE employee_id = 5;

-- UPDATE payout
-- SET employee_id = NULL
-- WHERE employee_id = 2;

-- TODO : Add payout and possitions?

-- Suppliers --
-- Add ✅
INSERT INTO supplier_info (supp_name, supp_description, address, contact_number)
    VALUES ('PharManila Inc.', 'Unilab Distributor', '1002, Espana Blvd, Sampaloc, Manila', 639172180341);

-- Search and View ✅
SELECT * FROM supplier_info WHERE supplierID = 1;

-- Filter and Listing ✅
SELECT * FROM supplier_info WHERE address LIKE '%Manila';
SELECT * FROM supplier_info WHERE supp_name LIKE '%Inc.';

-- Update ✅ (change column)
UPDATE supplier_info
SET supp_description = 'Unilab Distributor for the Philippines'
WHERE supplierID = 5;

-- Delete ✅
DELETE FROM supplier_info WHERE supplierID = 5;

UPDATE orders 
SET supplierID = NULL
WHERE supplierID = 5;

UPDATE medicine_info
SET supplierID = NULL
WHERE supplierID = 5;


-- symptoms --
-- Add ✅
INSERT INTO symptom (symptom_name, symptom_description)
    VALUES ('Heartburn', 'Burning sensation in the chest');

-- Search and View ✅
SELECT * FROM symptom WHERE symptom_id = 1;

-- Filter and Listing ✅
SELECT * FROM symptom WHERE LOWER(symptom_name) LIKE 'heart%';

-- Update ✅
UPDATE symptom
SET symptom_description = 'Burning sensation in the chest and throat'
WHERE symptom_id = 1;

-- Delete ✅
-- DELETE FROM symptom WHERE symptom_id = 1;
-- DELETE FROM symptom_and_medicine WHERE symptom_id = 1;


-- symptom_and_medicine --
-- Add ✅
INSERT INTO symptom_and_medicine (symptom_id, medicine_id, relation_description)
    VALUES (0002, 0005, "I have no idea how it works");

-- Search and View ✅
SELECT * FROM symptom_and_medicine WHERE symptom_id = 0002 AND medicine_id = 0005;

-- Filter and Listing ✅
SELECT * FROM symptom_and_medicine WHERE symptom_id = 0002;

-- Update ✅
UPDATE symptom_and_medicine
SET relation_description = "Supports cholesterol management with anti-inflammatory properties and anti-oxidants"
WHERE symptom_id = 0002 AND medicine_id = 0005;

-- Delete ✅
-- DELETE FROM symptom_and_medicine WHERE symptom_id = 0018 AND medicine_id = 0005;