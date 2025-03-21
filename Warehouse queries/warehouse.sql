USE BookingManagementDW

CREATE TABLE ClientDT(
	Client_ID INT IDENTITY(1,1) PRIMARY KEY,
	PESEL CHAR(11) CHECK (LEN(PESEL) = 11 AND ISNUMERIC(PESEL) = 1),
	Name_and_surname VARCHAR(50) NOT NULL,
	Phone_number VARCHAR(15) CHECK(ISNUMERIC(Phone_number) = 1)NOT NULL,
	Email VARCHAR(50) CHECK (CHARINDEX('@', Email) > 0),
	Is_current BIT
);

CREATE TABLE ProcedureDT(
	Procedure_ID INT IDENTITY(1,1) PRIMARY KEY,
	Procedure_type VARCHAR(30) NOT NULL,
	Duration_category VARCHAR(30) CHECK(Duration_category IN 
	( 'Under 30 minutes',
	'Between 30 minutes and 1 hour',
	'Between 1 and 2 hours',
	'More than 2 hours'
	)) NOT NULL
);

CREATE TABLE DateDT(
	Date_ID INT IDENTITY(1,1) PRIMARY KEY,
	Date DATE NOT NULL,
	Year INT NOT NULL,
	Month VARCHAR(10) NOT NULL CHECK(Month IN (
	'January', 'February', 'March', 'April', 'May', 
	'June', 'July', 'August', 'September', 'October', 
	'November', 'December'
	)),
	Month_number INT NOT NULL CHECK(Month_number < 13 AND Month_number > 0),
	Day_number INT NOT NULL CHECK(Day_number < 32 AND Day_number > 0),
	Day_of_week VARCHAR(10) NOT NULL CHECK(Day_of_week IN (
	'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
	)),
	Holiday VARCHAR(3) NOT NULL CHECK(Holiday IN(
	'Yes', 'No'
	))
);

CREATE TABLE Staff_memberDT(
	Staff_ID INT IDENTITY(1,1) PRIMARY KEY,
	PESEL CHAR(11) CHECK (LEN(PESEL) = 11 AND ISNUMERIC(PESEL) = 1),
	Name_and_surname VARCHAR(50) NOT NULL,
	Phone_number VARCHAR(15) CHECK(ISNUMERIC(Phone_number) = 1)NOT NULL,
	Email VARCHAR(50) CHECK (CHARINDEX('@', Email) > 0),
	Qualification VARCHAR(50) CHECK(Qualification IN(
		'Haircutting and Styling Certificate', 
		'Esthetician License', 
		'Nail Technician License',
		'Cosmetology License',
		'Massage Therapy License',
		'Hair Color Specialist Certification'
	)),
	Experience_years_category VARCHAR(30) CHECK( Experience_years_category IN(
		'Under 1 year', 
		'Between 1 and 3 years', 
		'Between 3 and 5 years', 'More than 5 years'
	)),
	Education VARCHAR(30),
	Salary_category VARCHAR(30) CHECK(Salary_category IN (
		'Under 1000 USD', 'Between 1000 and 2000 USD', 
		'Between 2000 and 5000 USD', 'More than 5000 USD'
	)),
	Is_current BIT
);

CREATE TABLE TimeDT(
	Time_ID INT IDENTITY(1,1) PRIMARY KEY,
	Hour INT NOT NULL CHECK(Hour > -1 AND Hour < 24),
	Minute INT NOT NULL CHECK(Minute > -1 AND Minute < 60),
	Time_of_day VARCHAR(20) CHECK(Time_of_day IN (
		'Between 0 and 8', 'Between 9 and 12', 
		'Between 13 and 15', 'Between 16 and 20', 'Between 21 and 23'
	))
);

CREATE TABLE ProductDT(
	Product_ID INT IDENTITY(1,1) PRIMARY KEY,
	Product_name VARCHAR(20) NOT NULL,
	Product_type VARCHAR(30) NOT NULL,
	Producer VARCHAR(30) NOT NULL
);

CREATE TABLE JunkDT(
	Junk_ID INT IDENTITY(1,1) PRIMARY KEY,
	Confirmation_type VARCHAR(20) CHECK(Confirmation_type IN (
		'Phone call', 'Email', 'SMS'
	))NOT NULL,
	Referral_flag VARCHAR(3) CHECK(Referral_flag IN (
		'Yes', 'No'
	))NOT NULL,

);


CREATE TABLE AppointmentFT(
	Client_ID INT FOREIGN KEY REFERENCES ClientDT,
	Procedure_ID INT FOREIGN KEY REFERENCES ProcedureDT,
	Creation_date_ID INT FOREIGN KEY REFERENCES DateDT,
	Appointment_date_ID INT FOREIGN KEY REFERENCES DateDT,
	Staff_member_ID INT FOREIGN KEY REFERENCES Staff_memberDT,
	Time_ID INT FOREIGN KEY REFERENCES TimeDT,
	Product_ID INT FOREIGN KEY REFERENCES ProductDT,
	Rating INT CHECK(Rating < 6 AND Rating > 0),
	Product_quantity INT CHECK(Product_quantity > 0)NOT NULL,
	Procedure_price MONEY NOT NULL,
	Junk_ID INT FOREIGN KEY REFERENCES JunkDT,
	PRIMARY KEY (Client_ID,Procedure_ID, Creation_date_ID, Appointment_date_ID,
	Staff_member_ID,Time_ID,Product_ID,  Junk_ID )
);