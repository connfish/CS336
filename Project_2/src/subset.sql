 
Subset · SQL
Copy

-- Subset schema for LLM context (CREATE TABLE statements only)
 
CREATE TABLE Agency(
    agency_code INT PRIMARY KEY,
    agency_name TEXT,
    agency_abbr TEXT
);
INSERT INTO Agency (agency_code, agency_name, agency_abbr) VALUES
(5, 'National Credit Union Administration', 'NCUA'),
(7, 'Department of Housing and Urban Development', 'HUD'),
(3, 'Federal Deposit Insurance Corporation', 'FDIC');
 
 
CREATE TABLE LoanType(
    loan_type INT PRIMARY KEY,
    loan_type_name TEXT
);
INSERT INTO LoanType (loan_type, loan_type_name) VALUES
(1, 'Conventional'),
(2, 'FHA-insured'),
(3, 'VA-guaranteed');
 
CREATE TABLE PropertyType(
    property_type INT PRIMARY KEY,
    property_type_name TEXT
);
INSERT INTO PropertyType (property_type, property_type_name) VALUES
(1, 'One-to-four family dwelling (other than manufactured housing)'),
(2, 'Manufactured housing'),
(3, 'Multifamily dwelling');
 
CREATE TABLE LoanPurpose(
    loan_purpose INT PRIMARY KEY,
    loan_purpose_name TEXT
);
INSERT INTO LoanPurpose (loan_purpose, loan_purpose_name) VALUES
(1, 'Home purchase'),
(2, 'Home improvement'),
(3, 'Refinancing');
 
CREATE TABLE OwnerOccupancy(
    owner_occupancy INT PRIMARY KEY,
    owner_occupancy_name TEXT
);
INSERT INTO OwnerOccupancy (owner_occupancy, owner_occupancy_name) VALUES
(1, 'Owner-occupied as a principal dwelling'),
(2, 'Not owner-occupied'),
(3, 'Not applicable');
 
 
CREATE TABLE Preapproval(
    preapproval INT PRIMARY KEY,
    preapproval_name TEXT
);
INSERT INTO Preapproval (preapproval, preapproval_name) VALUES
(1, 'Preapproval was requested'),
(2, 'Preapproval was not requested'),
(3, 'Not applicable');

CREATE TABLE ActionTaken(
    action_taken INT PRIMARY KEY,
    action_taken_name TEXT
);
INSERT INTO ActionTaken (action_taken, action_taken_name) VALUES
(1, 'Loan originated'),
(2, 'Application approved but not accepted'),
(3, 'Application denied by financial institution');
 
CREATE TABLE PurchaserType(
    purchaser_type INT PRIMARY KEY,
    purchaser_type_name TEXT
);
INSERT INTO PurchaserType (purchaser_type, purchaser_type_name) VALUES
(0, 'Loan was not originated or was not sold in calendar year covered by register'),
(1, 'Fannie Mae (FNMA)'),
(2, 'Ginnie Mae (GNMA)');
 
CREATE TABLE HOEPAStatus(
    hoepa_status INT PRIMARY KEY,
    hoepa_status_name TEXT
);
INSERT INTO HOEPAStatus (hoepa_status, hoepa_status_name) VALUES
(1, 'HOEPA loan'),
(2, 'Not a HOEPA loan');
CREATE TABLE LienStatus(
    lien_status INT PRIMARY KEY,
    lien_status_name TEXT
);
INSERT INTO LienStatus (lien_status, lien_status_name) VALUES
(1, 'Secured by a first lien'),
(4, 'Not applicable'),
(3, 'Not secured by a lien');
CREATE TABLE EditStatus(
    edit_status INT PRIMARY KEY,
    edit_status_name TEXT
);
 

CREATE TABLE MSAMD(
    msamd INT PRIMARY KEY,
    msamd_name TEXT
);
INSERT INTO MSAMD (msamd, msamd_name) VALUES
(36140, 'Newark, NJ-PA'),
(15804, 'Camden, NJ');
 
CREATE TABLE State(
    state_code INT PRIMARY KEY,
    state_name TEXT,
    state_abbr TEXT
);
INSERT INTO State (state_code, state_name, state_abbr) VALUES
(34, 'New Jersey', 'NJ');

CREATE TABLE County(
    county_code INT PRIMARY KEY,
    county_name TEXT
);
INSERT INTO County (county_code, county_name) VALUES
(39, 'Union County'),
(17, 'Hudson County');
 
CREATE TABLE ApplicantEthnicity(
    applicant_ethnicity INT PRIMARY KEY,
    applicant_ethnicity_name TEXT
);
INSERT INTO ApplicantEthnicity (applicant_ethnicity, applicant_ethnicity_name) VALUES
(1, 'Hispanic or Latino'),
(2, 'Not Hispanic or Latino');
CREATE TABLE CoApplicantEthnicity(
    co_applicant_ethnicity INT PRIMARY KEY,
    co_applicant_ethnicity_name TEXT
);
INSERT INTO CoApplicantEthnicity (co_applicant_ethnicity, co_applicant_ethnicity_name) VALUES
(1, 'Hispanic or Latino'),
(2, 'Not Hispanic or Latino'),
(5, 'No co-applicant');

CREATE TABLE ApplicantRace1(
    applicant_race_1 INT PRIMARY KEY,
    applicant_race_name_1 TEXT
);
INSERT INTO ApplicantRace1 (applicant_race_1, applicant_race_name_1) VALUES
(3, 'Black or African American'),
(5, 'White');
 
CREATE TABLE ApplicantRace2(
    applicant_race_2 INT PRIMARY KEY,
    applicant_race_name_2 TEXT
);
INSERT INTO ApplicantRace2 (applicant_race_2, applicant_race_name_2) VALUES
(3, 'Black or African American'),
(5, 'White');
 
CREATE TABLE ApplicantRace3(
    applicant_race_3 INT PRIMARY KEY,
    applicant_race_name_3 TEXT
);
INSERT INTO ApplicantRace3 (applicant_race_3, applicant_race_name_3) VALUES
(4, 'Native Hawaiian or Other Pacific Islander'),
(5, 'White');
CREATE TABLE ApplicantRace4(
    applicant_race_4 INT PRIMARY KEY,
    applicant_race_name_4 TEXT
);
INSERT INTO ApplicantRace4 (applicant_race_4, applicant_race_name_4) VALUES
(4, 'Native Hawaiian or Other Pacific Islander'),
(5, 'White');
CREATE TABLE ApplicantRace5(
    applicant_race_5 INT PRIMARY KEY,
    applicant_race_name_5 TEXT
);
INSERT INTO ApplicantRace5 (applicant_race_5, applicant_race_name_5) VALUES
(4, 'Native Hawaiian or Other Pacific Islander'),
(5, 'White');
CREATE TABLE CoApplicantRace1(
    co_applicant_race_1 INT PRIMARY KEY,
    co_applicant_race_name_1 TEXT
);
INSERT INTO CoApplicantRace1 (co_applicant_race_1, co_applicant_race_name_1) VALUES
(4, 'Native Hawaiian or Other Pacific Islander'),
(5, 'White');
CREATE TABLE CoApplicantRace2(
    co_applicant_race_2 INT PRIMARY KEY,
    co_applicant_race_name_2 TEXT
);
INSERT INTO CoApplicantRace2 (co_applicant_race_2, co_applicant_race_name_2) VALUES
(4, 'Native Hawaiian or Other Pacific Islander'),
(5, 'White');
CREATE TABLE CoApplicantRace3(
    co_applicant_race_3 INT PRIMARY KEY,
    co_applicant_race_name_3 TEXT
);
INSERT INTO CoApplicantRace3 (co_applicant_race_3, co_applicant_race_name_3) VALUES
(4, 'Native Hawaiian or Other Pacific Islander'),
(5, 'White');
CREATE TABLE CoApplicantRace4(
    co_applicant_race_4 INT PRIMARY KEY,
    co_applicant_race_name_4 TEXT
);
INSERT INTO CoApplicantRace4 (co_applicant_race_4, co_applicant_race_name_4) VALUES
(4, 'Native Hawaiian or Other Pacific Islander'),
(5, 'White');
CREATE TABLE CoApplicantRace5(
    co_applicant_race_5 INT PRIMARY KEY,
    co_applicant_race_name_5 TEXT
);
INSERT INTO CoApplicantRace5 (co_applicant_race_5, co_applicant_race_name_5) VALUES
(3, 'Black or African American'),
(5, 'White');
CREATE TABLE ApplicantSex(
    applicant_sex INT PRIMARY KEY,
    applicant_sex_name TEXT
);
INSERT INTO ApplicantSex (applicant_sex, applicant_sex_name) VALUES
(1, 'Male'),
(2, 'Female'),
(3, 'Information not provided by applicant in mail, Internet, or telephone application');

CREATE TABLE CoApplicantSex(
    co_applicant_sex INT PRIMARY KEY,
    co_applicant_sex_name TEXT
);
INSERT INTO CoApplicantSex (co_applicant_sex, co_applicant_sex_name) VALUES
(1, 'Male'),
(2, 'Female'),
(5, 'No co-applicant');
CREATE TABLE DenialReason1(
    denial_reason_1 INT PRIMARY KEY,
    denial_reason_name_1 TEXT
);
INSERT INTO DenialReason1 (denial_reason_1, denial_reason_name_1) VALUES
(1, 'Debt-to-income ratio'),
(2, 'Employment history'),
(3, 'Credit history');
  
CREATE TABLE DenialReason2(
    denial_reason_2 INT PRIMARY KEY,
    denial_reason_name_2 TEXT
);
INSERT INTO DenialReason2 (denial_reason_2, denial_reason_name_2) VALUES
(1, 'Debt-to-income ratio'),
(2, 'Employment history'),
(3, 'Credit history');
CREATE TABLE DenialReason3(
    denial_reason_3 INT PRIMARY KEY,
    denial_reason_name_3 TEXT
);
INSERT INTO DenialReason3 (denial_reason_3, denial_reason_name_3) VALUES
(1, 'Debt-to-income ratio'),
(2, 'Employment history'),
(3, 'Credit history');
CREATE TABLE CensusTract(
    census_tract_number NUMERIC,
    county_code INT,
    population INT,
    minority_population NUMERIC,
    hud_median_family_income INT,
    tract_to_msamd_income NUMERIC,
    number_of_owner_occupied_units INT,
    number_of_1_to_4_family_units INT,
    PRIMARY KEY (census_tract_number, county_code),
    FOREIGN KEY (county_code) REFERENCES County(county_code)
);
INSERT INTO CensusTract (census_tract_number, county_code, population, minority_population, hud_median_family_income, tract_to_msamd_income, number_of_owner_occupied_units, number_of_1_to_4_family_units) VALUES
(31, 17, 4488, 72.63999939, 73700, 76.36000061, 395, 663),
(111, 17, 4680, 47.20000076, 47.20000076, 56.84999847, 302, 1241);
 
CREATE TABLE LoanApplication(
    id INT PRIMARY KEY,
    as_of_year INT,
    respondent_id TEXT,
    agency_code INT,
    loan_type INT,
    property_type INT,
    loan_purpose INT,
    owner_occupancy INT,
    preapproval INT,
    action_taken INT,
    msamd INT,
    state_code INT,
    county_code INT,
    census_tract_number NUMERIC,
    applicant_ethnicity INT,
    co_applicant_ethnicity INT,
    applicant_race_1 INT,
    applicant_race_2 INT,
    applicant_race_3 INT,
    applicant_race_4 INT,
    applicant_race_5 INT,
    co_applicant_race_1 INT,
    co_applicant_race_2 INT,
    co_applicant_race_3 INT,
    co_applicant_race_4 INT,
    co_applicant_race_5 INT,
    applicant_sex INT,
    co_applicant_sex INT,
    purchaser_type INT,
    denial_reason_1 INT,
    denial_reason_2 INT,
    denial_reason_3 INT,
    loan_amount_000s INT,
    applicant_income_000s NUMERIC,
    rate_spread NUMERIC,
    sequence_number INT,
    application_date_indicator INT,
    hoepa_status INT,
    lien_status INT,
    edit_status INT,
    FOREIGN KEY (agency_code) REFERENCES Agency(agency_code),
    FOREIGN KEY (loan_type) REFERENCES LoanType(loan_type),
    FOREIGN KEY (property_type) REFERENCES PropertyType(property_type),
    FOREIGN KEY (loan_purpose) REFERENCES LoanPurpose(loan_purpose),
    FOREIGN KEY (owner_occupancy) REFERENCES OwnerOccupancy(owner_occupancy),
    FOREIGN KEY (preapproval) REFERENCES Preapproval(preapproval),
    FOREIGN KEY (action_taken) REFERENCES ActionTaken(action_taken),
    FOREIGN KEY (purchaser_type) REFERENCES PurchaserType(purchaser_type),
    FOREIGN KEY (hoepa_status) REFERENCES HOEPAStatus(hoepa_status),
    FOREIGN KEY (lien_status) REFERENCES LienStatus(lien_status),
    FOREIGN KEY (edit_status) REFERENCES EditStatus(edit_status),
    FOREIGN KEY (msamd) REFERENCES MSAMD(msamd),
    FOREIGN KEY (state_code) REFERENCES State(state_code),
    FOREIGN KEY (county_code) REFERENCES County(county_code),
    FOREIGN KEY (applicant_ethnicity) REFERENCES ApplicantEthnicity(applicant_ethnicity),
    FOREIGN KEY (co_applicant_ethnicity) REFERENCES CoApplicantEthnicity(co_applicant_ethnicity),
    FOREIGN KEY (applicant_race_1) REFERENCES ApplicantRace1(applicant_race_1),
    FOREIGN KEY (applicant_race_2) REFERENCES ApplicantRace2(applicant_race_2),
    FOREIGN KEY (applicant_race_3) REFERENCES ApplicantRace3(applicant_race_3),
    FOREIGN KEY (applicant_race_4) REFERENCES ApplicantRace4(applicant_race_4),
    FOREIGN KEY (applicant_race_5) REFERENCES ApplicantRace5(applicant_race_5),
    FOREIGN KEY (co_applicant_race_1) REFERENCES CoApplicantRace1(co_applicant_race_1),
    FOREIGN KEY (co_applicant_race_2) REFERENCES CoApplicantRace2(co_applicant_race_2),
    FOREIGN KEY (co_applicant_race_3) REFERENCES CoApplicantRace3(co_applicant_race_3),
    FOREIGN KEY (co_applicant_race_4) REFERENCES CoApplicantRace4(co_applicant_race_4),
    FOREIGN KEY (co_applicant_race_5) REFERENCES CoApplicantRace5(co_applicant_race_5),
    FOREIGN KEY (applicant_sex) REFERENCES ApplicantSex(applicant_sex),
    FOREIGN KEY (co_applicant_sex) REFERENCES CoApplicantSex(co_applicant_sex),
    FOREIGN KEY (denial_reason_1) REFERENCES DenialReason1(denial_reason_1),
    FOREIGN KEY (denial_reason_2) REFERENCES DenialReason2(denial_reason_2),
    FOREIGN KEY (denial_reason_3) REFERENCES DenialReason3(denial_reason_3),
    FOREIGN KEY (census_tract_number, county_code) REFERENCES CensusTract(census_tract_number, county_code)
);
 
INSERT INTO LoanApplication (id, as_of_year, respondent_id, agency_code, loan_type, property_type, loan_purpose, owner_occupancy, preapproval, action_taken, msamd, state_code, county_code, census_tract_number, applicant_ethnicity, co_applicant_ethnicity, applicant_race_1, applicant_race_2, applicant_race_3, applicant_race_4, applicant_race_5, co_applicant_race_1, co_applicant_race_2, co_applicant_race_3, co_applicant_race_4, co_applicant_race_5, applicant_sex, co_applicant_sex, purchaser_type, denial_reason_1, denial_reason_2, denial_reason_3, loan_amount_000s, applicant_income_000s, rate_spread, sequence_number, application_date_indicator, hoepa_status, lien_status, edit_status) VALUES
(1, 2017, '58652', 3, 1, 1, 1, 1, 2, 1, 35614, 34, 3, 102.00, 2, 5, 5, NULL, NULL, NULL, NULL, 8, NULL, NULL, NULL, NULL, 1, 5, 1, NULL, NULL, NULL, 280, 95.0, NULL, 1, 0, 2, 1, NULL),
(2, 2017, '58673', 3, 1, 1, 3, 1, 2, 3, 35614, 34, 1, 101.00, 2, 2, 5, NULL, NULL, NULL, NULL, 5, NULL, NULL, NULL, NULL, 2, 1, 0, 1, NULL, NULL, 150, 62.0, NULL, 2, 0, 2, 1, NULL);