-- p1
USE pandemic;
select count(1)
FROM infectious_cases ic

SHOW TABLES IN pandemic;


-- p2
DROP TABLE IF EXISTS Countries;

CREATE TABLE Countries (
    CountryID INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    Entity VARCHAR(255) UNIQUE,
    Code VARCHAR(10) NULL
);

INSERT INTO Countries (Entity, Code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;

CREATE TABLE Diseases (
    DiseaseID INT PRIMARY KEY AUTO_INCREMENT,
    CountryID INT,
    Year INT,
    Disease VARCHAR(255),
    Cases FLOAT,
    FOREIGN KEY (CountryID) REFERENCES Countries(CountryID)
);


INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'Number_yaws', ic.Number_yaws
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.Number_yaws IS NOT NULL;

INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'polio_cases', ic.polio_cases
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.polio_cases IS NOT NULL;

INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'cases_guinea_worm', ic.cases_guinea_worm
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.cases_guinea_worm IS NOT NULL;

INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'Number_rabies', ic.Number_rabies
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.Number_rabies IS NOT NULL;

INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'Number_malaria', ic.Number_malaria
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.Number_malaria IS NOT NULL;

INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'Number_hiv', ic.Number_hiv
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.Number_hiv IS NOT NULL;

INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'Number_tuberculosis', ic.Number_tuberculosis
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.Number_tuberculosis IS NOT NULL;

INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'Number_smallpox', ic.Number_smallpox
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.Number_smallpox IS NOT NULL;

INSERT INTO Diseases (CountryID, Year, Disease, Cases)
SELECT c.CountryID, ic.Year, 'Number_cholera_cases', ic.Number_cholera_cases
FROM infectious_cases ic
JOIN Countries c ON ic.Entity = c.Entity AND ic.Code = c.Code
WHERE ic.Number_cholera_cases IS NOT NULL;

-- p3
SELECT 
    CountryID,
    AVG(Cases) AS Average_Number_rabies,
    MIN(Cases) AS Min_Number_rabies,
    MAX(Cases) AS Max_Number_rabies,
    SUM(Cases) AS Total_Number_rabies
FROM 
    Diseases
WHERE 
    Disease = 'Number_rabies' AND
    Cases IS NOT NULL  
GROUP BY 
    CountryID
ORDER BY 
    Average_Number_rabies DESC
LIMIT 10;

-- p4
ALTER TABLE Diseases
ADD COLUMN First_January_Date DATE;

UPDATE Diseases
SET First_January_Date = STR_TO_DATE(CONCAT(Year, '-01-01'), '%Y-%m-%d');


ALTER TABLE Diseases
ADD COLUMN Curr_Date DATE;

UPDATE Diseases
SET Curr_Date = CURDATE();


ALTER TABLE Diseases
ADD COLUMN Years_Difference INT;

UPDATE Diseases
SET Years_Difference = YEAR(Curr_Date) - Year;

SELECT  First_January_Date, Curr_Date DATE, Years_Difference
FROM Diseases;

-- p5
DELIMITER //

CREATE FUNCTION YearDifference(input_year INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE first_january_date DATE;
    DECLARE years_difference INT;

    SET first_january_date = STR_TO_DATE(CONCAT(input_year, '-01-01'), '%Y-%m-%d');
    SET years_difference = YEAR(CURDATE()) - input_year;

    RETURN years_difference;
end//

DELIMITER ;


SELECT  Year, Years_Difference,  YearDifference(Year)
FROM Diseases;

	

