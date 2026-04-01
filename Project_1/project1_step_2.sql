SET statement_timeout = 0;

CREATE TABLE Agency(
    agency_code int PRIMARY KEY,
    agency_name TEXT,
    agency_abbr TEXT
);
INSERT INTO Agency (agency_code, agency_name, agency_abbr)
SELECT DISTINCT agency_code::INT, agency_name, agency_abbr
FROM Preliminary
WHERE agency_code != '';

CREATE TABLE LoanType(
    loan_type INT PRIMARY KEY,
    loan_type_name TEXT
);
INSERT INTO LoanType (loan_type, loan_type_name)
SELECT DISTINCT loan_type::INT, loan_type_name
FROM Preliminary
WHERE loan_type != '';

CREATE TABLE PropertyType(
    property_type INT PRIMARY KEY,
    property_type_name TEXT
);
INSERT INTO PropertyType(property_type, property_type_name)
SELECT DISTINCT property_type::INT, property_type_name
FROM Preliminary
WHERE property_type != '';

CREATE TABLE LoanPurpose(
    loan_purpose INT PRIMARY KEY,
    loan_purpose_name TEXT
);
INSERT INTO LoanPurpose(loan_purpose, loan_purpose_name)
SELECT DISTINCT loan_purpose::INT, loan_purpose_name
FROM Preliminary
WHERE loan_purpose != '';

CREATE TABLE OwnerOccupancy(
    owner_occupancy INT PRIMARY KEY,
    owner_occupancy_name TEXT
);
INSERT INTO OwnerOccupancy(owner_occupancy,owner_occupancy_name)
SELECT DISTINCT owner_occupancy::INT, owner_occupancy_name
FROM Preliminary
WHERE owner_occupancy != '';

CREATE TABLE Preapproval(
    preapproval INT PRIMARY KEY,
    preapproval_name TEXT
);
INSERT INTO Preapproval(preapproval, preapproval_name)
SELECT DISTINCT preapproval::INT, preapproval_name
FROM Preliminary
WHERE preapproval != '';

CREATE TABLE ActionTaken(
    action_taken INT PRIMARY KEY,
    action_taken_name TEXT
);
INSERT INTO ActionTaken(action_taken, action_taken_name)
SELECT DISTINCT action_taken::INT, action_taken_name
FROM Preliminary
WHERE action_taken != '';

CREATE TABLE PurchaserType(
    purchaser_type INT PRIMARY KEY,
    purchaser_type_name TEXT
);
INSERT INTO PurchaserType(purchaser_type, purchaser_type_name)
SELECT DISTINCT purchaser_type::INT, purchaser_type_name
FROM Preliminary
WHERE purchaser_type != '';

CREATE TABLE HOEPAStatus(
    hoepa_status INT PRIMARY KEY,
    hoepa_status_name TEXT
);
INSERT INTO HOEPAStatus(hoepa_status, hoepa_status_name)
SELECT DISTINCT hoepa_status::INT, hoepa_status_name
FROM Preliminary
WHERE hoepa_status != '';

CREATE TABLE LienStatus(
    lien_status INT PRIMARY KEY,
    lien_status_name TEXT
);
INSERT INTO LienStatus(lien_status, lien_status_name)
SELECT DISTINCT lien_status::INT, lien_status_name
FROM Preliminary
WHERE lien_status != '';

CREATE TABLE EditStatus(
    edit_status INT PRIMARY KEY,
    edit_status_name TEXT
);
INSERT INTO EditStatus(edit_status, edit_status_name)
SELECT DISTINCT edit_status::INT, edit_status_name
FROM Preliminary
WHERE edit_status != '';

CREATE TABLE MSAMD(
    msamd INT PRIMARY KEY,
    msamd_name TEXT
);
INSERT INTO MSAMD(msamd, msamd_name)
SELECT DISTINCT msamd::INT, msamd_name
FROM Preliminary
WHERE msamd != '';

CREATE TABLE State(
    state_code INT PRIMARY KEY,
    state_name TEXT,
    state_abbr TEXT
);
INSERT INTO State(state_code, state_name, state_abbr)
SELECT DISTINCT state_code::INT, state_name, state_abbr
FROM Preliminary
WHERE state_code != '';

CREATE Table County(
    county_code INT PRIMARY KEY,
    county_name TEXT
);
INSERT INTO County(county_code, county_name)
SELECT DISTINCT county_code::INT, county_name
FROM Preliminary
WHERE county_code != '';

CREATE TABLE ApplicantEthnicity(
    applicant_ethnicity INT PRIMARY KEY,
    applicant_ethnicity_name TEXT
);
INSERT INTO ApplicantEthnicity(applicant_ethnicity, applicant_ethnicity_name)
SELECT DISTINCT applicant_ethnicity::INT, applicant_ethnicity_name
FROM Preliminary
WHERE applicant_ethnicity != '';

CREATE TABLE CoApplicantEthnicity(
    co_applicant_ethnicity INT PRIMARY KEY,
    co_applicant_ethnicity_name TEXT
);
INSERT INTO CoApplicantEthnicity(co_applicant_ethnicity, co_applicant_ethnicity_name)
SELECT DISTINCT co_applicant_ethnicity::INT, co_applicant_ethnicity_name
FROM Preliminary
WHERE co_applicant_ethnicity != '';

CREATE TABLE ApplicantRace1(
    applicant_race_1 INT PRIMARY KEY,
    applicant_race_name_1 TEXT
);
INSERT INTO ApplicantRace1(applicant_race_1, applicant_race_name_1)
SELECT DISTINCT applicant_race_1::INT, applicant_race_name_1
FROM Preliminary
WHERE applicant_race_1 != '';

CREATE TABLE ApplicantRace2(
    applicant_race_2 INT PRIMARY KEY,
    applicant_race_name_2 TEXT
);
INSERT INTO ApplicantRace2(applicant_race_2, applicant_race_name_2)
SELECT DISTINCT applicant_race_2::INT, applicant_race_name_2
FROM Preliminary
WHERE applicant_race_2 != '';

CREATE TABLE ApplicantRace3(
    applicant_race_3 INT PRIMARY KEY,
    applicant_race_name_3 TEXT
);
INSERT INTO ApplicantRace3(applicant_race_3, applicant_race_name_3)
SELECT DISTINCT applicant_race_3::INT, applicant_race_name_3
FROM Preliminary
WHERE applicant_race_3 != '';

CREATE TABLE ApplicantRace4(
    applicant_race_4 INT PRIMARY KEY,
    applicant_race_name_4 TEXT
);
INSERT INTO ApplicantRace4(applicant_race_4, applicant_race_name_4)
SELECT DISTINCT applicant_race_4::INT, applicant_race_name_4
FROM Preliminary
WHERE applicant_race_4 != '';

CREATE TABLE ApplicantRace5(
    applicant_race_5 INT PRIMARY KEY,
    applicant_race_name_5 TEXT
);
INSERT INTO ApplicantRace5(applicant_race_5, applicant_race_name_5)
SELECT DISTINCT applicant_race_5::INT, applicant_race_name_5
FROM Preliminary
WHERE applicant_race_5 != '';

CREATE TABLE CoApplicantRace1(
    co_applicant_race_1 INT PRIMARY KEY,
    co_applicant_race_name_1 TEXT   
);
INSERT INTO CoApplicantRace1(co_applicant_race_1, co_applicant_race_name_1)
SELECT DISTINCT co_applicant_race_1::INT, co_applicant_race_name_1
FROM Preliminary
WHERE co_applicant_race_1 != '';

CREATE TABLE CoApplicantRace2(
    co_applicant_race_2 INT PRIMARY KEY,
    co_applicant_race_name_2 TEXT   
);
INSERT INTO CoApplicantRace2(co_applicant_race_2, co_applicant_race_name_2)
SELECT DISTINCT co_applicant_race_2::INT, co_applicant_race_name_2
FROM Preliminary
WHERE co_applicant_race_2 != '';

CREATE TABLE CoApplicantRace3(
    co_applicant_race_3 INT PRIMARY KEY,
    co_applicant_race_name_3 TEXT   
);
INSERT INTO CoApplicantRace3(co_applicant_race_3, co_applicant_race_name_3)
SELECT DISTINCT co_applicant_race_3::INT, co_applicant_race_name_3
FROM Preliminary
WHERE co_applicant_race_3 != '';

CREATE TABLE CoApplicantRace4(
    co_applicant_race_4 INT PRIMARY KEY,
    co_applicant_race_name_4 TEXT   
);
INSERT INTO CoApplicantRace4(co_applicant_race_4, co_applicant_race_name_4)
SELECT DISTINCT co_applicant_race_4::INT, co_applicant_race_name_4
FROM Preliminary
WHERE co_applicant_race_4 != '';

CREATE TABLE CoApplicantRace5(
    co_applicant_race_5 INT PRIMARY KEY,
    co_applicant_race_name_5 TEXT   
);
INSERT INTO CoApplicantRace5(co_applicant_race_5, co_applicant_race_name_5)
SELECT DISTINCT co_applicant_race_5::INT, co_applicant_race_name_5
FROM Preliminary
WHERE co_applicant_race_5 != '';

CREATE TABLE ApplicantSex(
    applicant_sex INT PRIMARY KEY,
    applicant_sex_name TEXT
);
INSERT INTO ApplicantSex(applicant_sex, applicant_sex_name)
SELECT DISTINCT applicant_sex::INT, applicant_sex_name
FROM Preliminary
WHERE applicant_sex != '';

CREATE TABLE CoApplicantSex(
    co_applicant_sex INT PRIMARY KEY,
    co_applicant_sex_name TEXT
);
INSERT INTO CoApplicantSex(co_applicant_sex, co_applicant_sex_name)
SELECT DISTINCT co_applicant_sex::INT, co_applicant_sex_name
FROM Preliminary
WHERE co_applicant_sex != '';

CREATE TABLE DenialReason1(
    denial_reason_1 INT PRIMARY KEY,
    denial_reason_name_1 TEXT
);
INSERT INTO DenialReason1(denial_reason_1, denial_reason_name_1)
SELECT DISTINCT denial_reason_1::INT, denial_reason_name_1
FROM Preliminary
WHERE denial_reason_1 != '';

CREATE TABLE DenialReason2(
    denial_reason_2 INT PRIMARY KEY,
    denial_reason_name_2 TEXT
);
INSERT INTO DenialReason2(denial_reason_2, denial_reason_name_2)
SELECT DISTINCT denial_reason_2::INT, denial_reason_name_2
FROM Preliminary
WHERE denial_reason_2 != '';

CREATE TABLE DenialReason3(
    denial_reason_3 INT PRIMARY KEY,
    denial_reason_name_3 TEXT
);
INSERT INTO DenialReason3(denial_reason_3, denial_reason_name_3)
SELECT DISTINCT denial_reason_3::INT, denial_reason_name_3
FROM Preliminary
WHERE denial_reason_3 != '';

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
INSERT INTO CensusTract(census_tract_number, county_code, population, minority_population, hud_median_family_income, tract_to_msamd_income, number_of_owner_occupied_units, number_of_1_to_4_family_units)
SELECT DISTINCT 
    census_tract_number::NUMERIC,
    county_code::INT,
    NULLIF(population, '')::INT,
    NULLIF(minority_population, '')::NUMERIC,
    NULLIF(hud_median_family_income, '')::INT,
    NULLIF(tract_to_msamd_income, '')::NUMERIC,
    NULLIF(number_of_owner_occupied_units, '')::INT,
    NULLIF(number_of_1_to_4_family_units, '')::INT
FROM Preliminary
WHERE census_tract_number != '';

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

INSERT INTO LoanApplication(
    id,
    as_of_year,
    respondent_id,
    agency_code,
    loan_type,
    property_type,
    loan_purpose,
    owner_occupancy,
    preapproval,
    action_taken,
    msamd,
    state_code,
    county_code,
    census_tract_number,
    applicant_ethnicity,
    co_applicant_ethnicity,
    applicant_race_1,
    applicant_race_2,
    applicant_race_3,
    applicant_race_4,
    applicant_race_5,
    co_applicant_race_1,
    co_applicant_race_2,
    co_applicant_race_3,
    co_applicant_race_4,
    co_applicant_race_5,
    applicant_sex,
    co_applicant_sex,
    purchaser_type,
    denial_reason_1,
    denial_reason_2,
    denial_reason_3,
    loan_amount_000s,
    applicant_income_000s,
    rate_spread,
    sequence_number,
    application_date_indicator,
    hoepa_status,
    lien_status,
    edit_status
)
SELECT
    id,
    NULLIF(as_of_year,'')::INT,
    NULLIF(respondent_id, '')::TEXT,
    NULLIF(agency_code,'')::INT,
    NULLIF(loan_type,'')::INT,
    NULLIF(property_type,'')::INT,
    NULLIF(loan_purpose,'')::INT,
    NULLIF(owner_occupancy,'')::INT,
    NULLIF(preapproval,'')::INT,
    NULLIF(action_taken,'')::INT,
    NULLIF(msamd,'')::INT,
    NULLIF(state_code,'')::INT,
    NULLIF(county_code,'')::INT,
    NULLIF(census_tract_number,'')::NUMERIC,
    NULLIF(applicant_ethnicity,'')::INT,
    NULLIF(co_applicant_ethnicity,'')::INT,
    NULLIF(applicant_race_1,'')::INT,
    NULLIF(applicant_race_2,'')::INT,
    NULLIF(applicant_race_3,'')::INT,    
    NULLIF(applicant_race_4,'')::INT,
    NULLIF(applicant_race_5,'')::INT,
    NULLIF(co_applicant_race_1,'')::INT,
    NULLIF(co_applicant_race_2,'')::INT,
    NULLIF(co_applicant_race_3,'')::INT,    
    NULLIF(co_applicant_race_4,'')::INT,
    NULLIF(co_applicant_race_5,'')::INT,
    NULLIF(applicant_sex,'')::INT,
    NULLIF(co_applicant_sex,'')::INT,
    NULLIF(purchaser_type,'')::INT,
    NULLIF(denial_reason_1,'')::INT,
    NULLIF(denial_reason_2,'')::INT,
    NULLIF(denial_reason_3,'')::INT,
    NULLIF(loan_amount_000s,'')::INT,
    NULLIF(applicant_income_000s,'')::NUMERIC,
    NULLIF(rate_spread,'')::NUMERIC,
    NULLIF(sequence_number,'')::INT,
    NULLIF(application_date_indicator,'')::INT,    
    NULLIF(hoepa_status,'')::INT,
    NULLIF(lien_status,'')::INT,
    NULLIF(edit_status,'')::INT

FROM Preliminary;

