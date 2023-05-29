/*Branch table creation*/

CREATE TABLE Branch (
   Branch_Location VARCHAR2(500) PRIMARY KEY NOT NULL,
   Branch_Name VARCHAR2(150) NOT NULL,
   Branch_Warecapacity NUMBER(6,3) NOT NULL,
   Branch_Phone_Number NUMBER(12,0) NOT NULL,
   Branch_Employee_Number NUMBER(30,0) NOT NULL,
   Branch_Tax_Number NUMBER(10,0) NOT NULL,
   CONSTRAINT tel_no_branch UNIQUE (Branch_Phone_Number));

   /*Shipper table creation with subtypes*/

CREATE TABLE Shipper(
  Shipper_ID NUMBER(10) PRIMARY KEY NOT NULL,
  Name VARCHAR2(80) NOT NULL,
  Address VARCHAR2(500) NOT NULL,
  Phone_Number VARCHAR2(20) UNIQUE NOT NULL,
  Email VARCHAR2(20) UNIQUE,
  Corporate_ID NUMBER(10),
  Individual_ID NUMBER(10),
  discount NUMBER(3),
  discount_period TIMESTAMP,
  Gender VARCHAR2(8) CHECK (Gender IN ('Male','Female')),
  Surname VARCHAR2(80),
  Shipper_Type VARCHAR2(20) CHECK (Shipper_Type IN ('Corporate', 'Individual')) NOT NULL,
  CONSTRAINT control CHECK ((Corporate_ID is NOT NULL AND Individual_ID is NULL)
  OR (Corporate_ID is NULL AND Individual_ID is NOT NULL))
);

CREATE TABLE Corporate(
  Corporate_ID NUMBER(10) PRIMARY KEY,
  Name VARCHAR2(80) NOT NULL,
  discount NUMBER(3) NOT NULL,
  discount_period TIMESTAMP,
  Shipper_Type VARCHAR2(20) CHECK (Shipper_Type IN ('Corporate', 'Individual')),
  Address VARCHAR2(500) NOT NULL,
  Phone_Number VARCHAR2(20) UNIQUE NOT NULL,
  Email VARCHAR2(20) UNIQUE,
  CONSTRAINT corp_fk FOREIGN KEY (Corporate_ID) REFERENCES Shipper(Shipper_ID),
  CONSTRAINT corp_fk_chk CHECK (Shipper_Type = 'Corporate')
);

CREATE TABLE Individual (
  Individual_ID NUMBER(10) PRIMARY KEY,
  Name VARCHAR2(80) NOT NULL,
  Gender VARCHAR2(8) CHECK (Gender IN ('Male','Female')),
  Surname VARCHAR2(80) NOT NULL,
  Shipper_Type VARCHAR2(20) CHECK (Shipper_Type IN ('Corporate', 'Individual')),
  Address VARCHAR2(500) NOT NULL,
  Phone_Number VARCHAR2(20) UNIQUE NOT NULL,
  Email VARCHAR2(20) UNIQUE,
  CONSTRAINT ind_fk FOREIGN KEY (Individual_ID) REFERENCES Shipper(Shipper_ID),
  CONSTRAINT ind_fk_chk CHECK (Shipper_Type = 'Individual')
);

ALTER TABLE Shipper ADD Branch_Location VARCHAR2(500);
ALTER TABLE Shipper ADD CONSTRAINT breach_fk FOREIGN KEY (Branch_Location) REFERENCES Branch(Branch_Location);
   


/*Vehicle table creation with subtypes*/

CREATE TABLE Vehicle (
    Plate_Number VARCHAR(9) NOT NULL,
    Age NUMBER(2,0) NOT NULL,
    Vehicle_Licence VARCHAR(3) NOT NULL,
    Model VARCHAR(30) NOT NULL,
    Capacity NUMBER(10) NOT NULL,
    Branch_Location VARCHAR2(500),
    Motorcycle_id NUMBER(4,0),
    Car_id NUMBER(4,0),
    Motorcycle_Equipments VARCHAR(50),
    Car_Amount_of_Driver NUMBER(10),
    Vehicle_Type VARCHAR2(10) CHECK (Vehicle_Type IN ('Car', 'Motorcycle')),
    PRIMARY KEY (Plate_Number),
    FOREIGN KEY (Branch_Location) REFERENCES TR_A477_SQL_S92.BRANCH(Branch_Location)
    CHECK (Car_id IS NOT NULL AND Motorcycle_id IS NULL) OR (Car_id IS NULL AND Motorcycle_id IS NOT NULL)
);

CREATE TABLE Car (
  Plate_Number VARCHAR(9) PRIMARY KEY,
  Car_id NUMBER(4,0),
  Car_Amount_of_Driver NUMBER(10),
  Vehicle_Type VARCHAR2(10) CHECK (Vehicle_Type IN ('Car', 'Motorcycle')),
  CONSTRAINT car_fk FOREIGN KEY (Plate_Number) REFERENCES Vehicle(Plate_Number),
  CONSTRAINT car_fk_chk CHECK (Vehicle_Type = 'Car')
);

CREATE TABLE Motorcycle (
  Plate_Number VARCHAR(9) PRIMARY KEY,
  Mototrcycle_id NUMBER(4,0),
  Motorcycle_Equipments VARCHAR2(50),
  Vehicle_Type VARCHAR2(10) CHECK (Vehicle_Type IN ('Car', 'Motorcycle')),
  CONSTRAINT motorcycle_fk FOREIGN KEY (Plate_Number) REFERENCES Vehicle(Plate_Number),
  CONSTRAINT motorcycle_type_chk CHECK (Vehicle_Type = 'Motorcycle')
);



/*Expense table creation with subtypes*/

CREATE TABLE Expense (
    Code NUMBER(10) NOT NULL,
    Expense_Type VARCHAR(50) CHECK (Expense_Type IN ('Fuel_Expense', 'Driver_Salary_Expense', 'Cargo_Package_Expense','Vehicle_Inspection_Expense', 'Branch_Rent')),
    Cost NUMBER(12) NOT NULL,
    Expense_Time TIMESTAMP NOT NULL,
    Payment_Type VARCHAR(6) NOT NULL,
    Amount NUMBER(12) NOT NULL, 
    Branch_Location VARCHAR2(500) NOT NULL,
    Driver_ID VARCHAR2(500),
    Fuel_Expense_ID NUMBER(4,0),
    Driver_Salary_Expense_ID NUMBER(4,0),
    Cargo_Package_Expense_ID NUMBER(4,0),
    Vehicle_Inspection_Expense_ID NUMBER(4,0),
    Branch_Rent_ID NUMBER(4,0),
    Fuel_Type VARCHAR(10),
    Price_Per_Unit_of_Fuel NUMBER(10),
    Cargo_Package_Material VARCHAR(30),
    Vehicle_Inspection_type VARCHAR(50),
    Branch_Rent_Period DATE,
    Driver_Work_Hours NUMBER(4),
    PRIMARY KEY (Code),
    FOREIGN KEY (Branch_Location) REFERENCES TR_A477_SQL_S92.BRANCH(Branch_Location),
    FOREIGN KEY (Driver_Id) REFERENCES TR_A477_SQL_S65.DRIVER(Driver_Id),
    CONSTRAINT expense_subtype_chk CHECK (
        (Expense_Type = 'Fuel_Expense' AND Fuel_Expense_ID IS NOT NULL) OR
        (Expense_Type = 'Driver_Salary_Expense' AND Driver_Salary_Expense_ID IS NOT NULL) OR
        (Expense_Type = 'Cargo_Package_Expense' AND Cargo_Package_Expense_ID IS NOT NULL) OR
        (Expense_Type = 'Vehicle_Inspection_Expense' AND Vehicle_Inspection_Expense_ID IS NOT NULL) OR
        (Expense_Type = 'Branch_Rent' AND Branch_Rent_ID IS NOT NULL)
    )
);

CREATE TABLE Fuel_Expense (
  Code NUMBER(10)  PRIMARY KEY,
  Fuel_Expense_ID NUMBER(4,0),
  Fuel_Type VARCHAR(10),
  Price_Per_Unit_of_Fuel NUMBER(10),
  Expense_Type VARCHAR(50) CHECK (Expense_Type IN ('Fuel_Expense', 'Driver_Salary_Expense', 'Cargo_Package_Expense','Vehicle_Inspection_Expense', 'Branch_Rent')), 
  CONSTRAINT fuel_fk FOREIGN KEY (Code) REFERENCES Expense(Code),
  CONSTRAINT fuel_fk_chk CHECK (Expense_Type = 'Fuel_Expense')
);

CREATE TABLE Driver_Salary_Expense (
  Code NUMBER(10) PRIMARY KEY,
  Driver_Salary_Expense_ID NUMBER(4,0),
  Expense_Type VARCHAR(50) CHECK (Expense_Type IN ('Fuel_Expense', 'Driver_Salary_Expense', 'Cargo_Package_Expense','Vehicle_Inspection_Expense', 'Branch_Rent')),
  Driver_Work_Hours NUMBER(4),
  CONSTRAINT driver_salary_fk FOREIGN KEY (Code) REFERENCES Expense(Code),
  CONSTRAINT driver_salary_fk_chk CHECK (Expense_Type = 'Driver_Salary_Expense')
);

CREATE TABLE Cargo_Package_Expense (
  Code NUMBER(10) PRIMARY KEY,
  Cargo_Package_Expense_ID NUMBER(4,0),
  Cargo_Package_Material VARCHAR(30),
  Expense_Type VARCHAR(50) CHECK (Expense_Type IN ('Fuel_Expense', 'Driver_Salary_Expense', 'Cargo_Package_Expense','Vehicle_Inspection_Expense', 'Branch_Rent')),
  CONSTRAINT cargo_package_fk FOREIGN KEY (Code) REFERENCES Expense(Code),
  CONSTRAINT cargo_package_fk_chk CHECK (Expense_Type = 'Cargo_Package_Expense')
  
);

CREATE TABLE Vehicle_Inspection_Expense (
  Code NUMBER(10) PRIMARY KEY,
  Vehicle_Inspection_Expense_ID NUMBER(4,0),
  Vehicle_Inspection_type VARCHAR(50),
  Expense_Type VARCHAR(50) CHECK (Expense_Type IN ('Fuel_Expense', 'Driver_Salary_Expense', 'Cargo_Package_Expense','Vehicle_Inspection_Expense', 'Branch_Rent')),
  CONSTRAINT vehicle_inspection_fk FOREIGN KEY (Code) REFERENCES Expense(Code),
  CONSTRAINT vehicle_inspection_fk_chk CHECK (Expense_Type = 'Vehicle_Inspection_Expense')
);

CREATE TABLE Branch_Rent (
  Code NUMBER(10) PRIMARY KEY,
  Branch_Rent_ID NUMBER(4,0),
  Branch_Rent_Period DATE,
  Expense_Type VARCHAR(50) CHECK (Expense_Type IN ('Fuel_Expense', 'Driver_Salary_Expense', 'Cargo_Package_Expense','Vehicle_Inspection_Expense', 'Branch_Rent')),
  CONSTRAINT branch_rent_fk FOREIGN KEY (Code) REFERENCES Expense(Code),
  CONSTRAINT branch_rent_fk_chk CHECK (Expense_Type = 'Branch_Rent')
);

/* Cargo table creation*/

CREATE TABLE CARGO(
CARGOID NUMBER(8) PRIMARY KEY NOT NULL,
Price NUMBER(12) NOT NULL,
Weight NUMBER(5) NOT NULL,
Deliver_Date DATE NOT NULL,
Product_Type VARCHAR2(50) NOT NULL,
Driver_ID VARCHAR2(500),
Plate_Number VARCHAR(9),
Branch_Location VARCHAR2(500),
ID VARCHAR2(500),
CONSTRAINT driver_fk FOREIGN KEY(Driver_ID) REFERENCES TR_A477_SQL_S65.Driver(Driver_ID),
CONSTRAINT vehicleplatenumber_fk FOREIGN KEY(Plate_Number) REFERENCES TR_A478_SQL_S73.Vehicle(Plate_Number),
CONSTRAINT branchlocation_fk FOREIGN KEY(Branch_Location) REFERENCES TR_A477_SQL_S92.Branch(Branch_Location),
CONSTRAINT receiverıd_fk FOREIGN KEY(ID) REFERENCES TR_A477_SQL_S65.Receiver(ID)
);

/*Income Table Creation*/
CREATE TABLE INCOME (
Code NUMBER(8) PRIMARY KEY NOT NULL,
IncomeType VARCHAR2(30) NOT NULL,
Cost NUMBER(5) NOT NULL,
IncomeTime TIMESTAMP NOT NULL,
Income_Payment_Type VARCHAR2(20) NOT NULL,
Total_Budget NUMBER(5) NOT NULL,
ID VARCHAR2(500),
Branch_Location VARCHAR2(500),
Shipper_ID NUMBER(10),
CONSTRAINT receiver_id_fk FOREIGN KEY (ID) REFERENCES TR_A477_SQL_S65.Receiver(ID),
CONSTRAINT branch_location_fk FOREIGN KEY (Branch_Location) REFERENCES TR_A477_SQL_S92.Branch(Branch_Location),
CONSTRAINT shipper_id_fk FOREIGN KEY (Shipper_ID) REFERENCES TR_A477_SQL_S92.Shipper(Shipper_ID)
);

/*Driver Table Creation*/
CREATE TABLE Driver (
   Driver_ID VARCHAR2(500) PRIMARY KEY NOT NULL,
   Driver_Name VARCHAR2(150) NOT NULL,
   Driver_Surname VARCHAR2(60) NOT NULL, 
   Driver_Phone_Number NUMBER(12) NOT NULL,
   Driver_Work_Time DATE NOT NULL,
   Driver_Age NUMBER(10) NOT NULL,
   Branch_Location VARCHAR(500) NOT NULL,
   Plate_Number VARCHAR(9) NOT NULL,
   Driver_Licence_Type VARCHAR2(3) NOT NULL, 
   FOREIGN KEY (Plate_Number) REFERENCES TR_A478_SQL_S73.VEHICLE(Plate_Number),
   FOREIGN KEY (Branch_Location) REFERENCES TR_A477_SQL_S92.BRANCH(Branch_Location),
   CONSTRAINT tel_no_Driver UNIQUE (Driver_Phone_Number)
);

/*Receiver  Table Creation*/
CREATE TABLE Receiver (
   ID VARCHAR2(500) UNIQUE NOT NULL,
   Full_Name VARCHAR2(150) NOT NULL,
   Address VARCHAR2(150) NOT NULL, 
   Phone_Number NUMBER(11) NOT NULL,
   Email VARCHAR2(25),
   Personal_ID VARCHAR2(500),
   Corporate_ID VARCHAR2(500),
   Gender VARCHAR2(8) CHECK (Gender IN ('Male','Female')),
   Personal_Birth_Date DATE,
   Corporate_Cnct_Prs_Name VARCHAR2(75),
   Corporate_Tx_Ident_Number NUMBER(10),
   Corporate_Business_Type VARCHAR2(75),
   Receiver_Type VARCHAR2(20) CHECK (Receiver_Type IN ('Personal', 'Corporate')),
   PRIMARY KEY (ID),
   CHECK ((Personal_ID IS NOT NULL AND Corporate_ID IS NULL) OR (Personal_ID IS NULL AND Corporate_ID IS NOT NULL))
);

CREATE TABLE Personal (
   ID VARCHAR2(500) PRIMARY KEY,
   Personal_ID VARCHAR2(500) NOT NULL,
   Gender VARCHAR2(8) CHECK (Gender IN ('Male','Female')),
   Personal_Birth_Date DATE,
   Receiver_Type VARCHAR2(20) CHECK (Receiver_Type IN ('Personal', 'Corporate')),
   CONSTRAINT personal_fk FOREIGN KEY (ID) REFERENCES Receiver(ID),
   CONSTRAINT personal_fk_chk CHECK (Receiver_Type = 'Personal')
);

CREATE TABLE Corporate (
   ID VARCHAR2(500) PRIMARY KEY,
   Corporate_ID VARCHAR2(500) NOT NULL,
   Corporate_Cnct_Prs_Name VARCHAR2(75) NOT NULL,
   Corporate_Tx_Ident_Number NUMBER(10) NOT NULL,
   Corporate_Business_Type VARCHAR2(75),
   Receiver_Type VARCHAR2(20) CHECK (Receiver_Type IN ('Personal', 'Corporate')),
   CONSTRAINT corporate_fk FOREIGN KEY (ID) REFERENCES Receiver(ID),
   CONSTRAINT corporate_fk_chk CHECK (Receiver_Type = 'Corporate')
);

/* The Connection Table Creation of Driver and Receiver*/
CREATE TABLE Connection_Chart (
  Driver_ID VARCHAR2(500),
  ID VARCHAR2(500),
  PRIMARY KEY (Driver_ID,ID),
  FOREIGN KEY (Driver_ID) REFERENCES Driver(Driver_ID),
  FOREIGN KEY (ID) REFERENCES Receiver(ID)
);


