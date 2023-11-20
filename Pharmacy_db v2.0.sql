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
	supplierID			INT(5) NOT NULL,
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
  medicine_id			INT(5)	NOT NULL,
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
    supplierID			INT(5) NOT NULL,
    date_ordered		DATE NOT NULL,
    medicineID			INT(5) NOT NULL,
    quantity			INT(5) NOT NULL,
    expiryDate			DATE NOT NULL,
    priceSold			FLOAT NOT NULL,
    order_status		ENUM("ordered", "sent"),
    
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
	employee_id		INT(5) NOT NULL,
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
    cashier             INT(5),
    pharmacist          INT(5),
    transactionDate     DATETIME,
    
    PRIMARY KEY (transactionID),
    FOREIGN KEY (cashier) REFERENCES employees(employee_id),
    FOREIGN KEY (pharmacist) REFERENCES employees(employee_id)
);

-- -----------------------------------------------------
-- Table medicine_stock
-- -----------------------------------------------------
DROP TABLE IF EXISTS medicine_stock;
CREATE TABLE IF NOT EXISTS medicine_stock (
  stock_id		BIGINT(12) NOT NULL,
  medicine_id	INT(5) NOT NULL,
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
	symptom_id				INT(5) NOT NULL,
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
            (00004, "MedArcher Distributors", "Distributor for Reckitt Benckiser", "2309, Don Chino Roces Ave Ext, Makati", 639152185710);

INSERT INTO medicine_info
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
			(0016, "Omeprazole", "Prilosec", 20, NULL, TRUE, "Antacids", 25, "Prescription-strength acid reducer", 1),
			(0017, "Sertraline", "Zoloft", NULL, 50, TRUE, "Psychotropic Medications", 30, "Antidepressant", 4),
			(0018, "Rosuvastatin", "Crestor", NULL, 10, TRUE, "Hormones", 40, "For managing cholesterol levels", 2);

CALL InsertMedicineStock(3, 1, '2023-11-20', '2024-01-15', 5.5);
CALL InsertMedicineStock(2, 2, '2023-11-20', '2023-12-10', 3.0);
CALL InsertMedicineStock(4, 3, '2023-11-20', '2024-03-01', 100.0);
CALL InsertMedicineStock(5, 4, '2023-11-20', '2024-02-28', 5.0);
CALL InsertMedicineStock(3, 5, '2023-11-20', '2024-06-15', 7.0);
CALL InsertMedicineStock(2, 6, '2023-11-20', '2023-12-31', 6.5);
CALL InsertMedicineStock(4, 7, '2023-11-20', '2024-05-20', 15.0);
CALL InsertMedicineStock(3, 8, '2023-11-20', '2024-04-10', 4.0);
CALL InsertMedicineStock(2, 9, '2023-11-20', '2024-02-01', 3.5);
CALL InsertMedicineStock(5, 10, '2023-11-20', '2024-07-01', 8.0);            

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
			(0017, 0007, "Supports mental health by addressing allergy-related symptoms"),
			(0018, 0005, "Supports cholesterol management with anti-inflammatory properties");
            
INSERT INTO positions
	VALUES ("Pharmacist", 45000),
		   ("Cashier", 30000),
           ("Inventory Clerk", 30000),
           ("Security Guard", 22000),
           ("Janitor", 19000),
           ("Delivery Driver", 20000);

INSERT INTO employees
	VALUES (1, "Pharmacist", "Juan", "Dela Cruz", "639171234567", "12345", "100 Sinigang St, Tramo, Pasay"),
		   (2, "Pharmacist", "Maria", "Santos", "639189543210", "75232", "3004 Kamagong St, Sta. Cruz, Makati"),
           (3, "Cashier", "Jose", "Lopez", "639185551234", "IloveMyChildren", "123 Main St, Mandaluyong"),
           (4, "Cashier", "Anna", "Reyes", "639181112233", "IloveMyWife", "456 Oak St, Quezon City"),
           (5, "Inventory Clerk", "Daniel", "Gonzales", "639189998877", "LogisticsMan", "789 Pine St, Taguig"),
           (6, "Security Guard", "Sofia", "Santiago", "639184445555", "IloveMyHusband", "101 Elm St, Pasig"),
           (7, "Janitor", "Oliver", "Villanueva", "639187776666", "ImissYouSoMuch", "202 Maple St, Makati"),
           (8, "Delivery Driver", "Ava", "Torres", "639183334444", "IloveMyCar", "303 Cedar St, Manila");



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


-- Record Number 1 - Medicine Recommendations By Symptoms
FROM symptom s JOIN symptom_and_medicine sm
				ON s.symptom_ID = sm.symptom_ID
                JOIN medicine_info m
                ON sm.medicine_ID = m.medicine_ID
WHERE s.symptom_name = "Heartburn";

-- Record Number 2 - Monthly and Yearly Sales and Expenses Report
