
-- START OF STEP 3 SQL CODE

SET statement_timeout = 0;

-- name lookup tables same as Step 2

CREATE TABLE Agency(
    agency_code INT PRIMARY KEY,
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
INSERT INTO OwnerOccupancy(owner_occupancy, owner_occupancy_name)
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

CREATE TABLE County(
    county_code INT PRIMARY KEY,
    county_name TEXT
);
INSERT INTO County(county_code, county_name)
SELECT DISTINCT county_code::INT, county_name
FROM Preliminary
WHERE county_code != '';

CREATE TABLE Ethnicity(
    ethnicity_code INT PRIMARY KEY,
    ethnicity_name TEXT
);
INSERT INTO Ethnicity(ethnicity_code, ethnicity_name)
SELECT DISTINCT code, name FROM (
    SELECT applicant_ethnicity::INT AS code, applicant_ethnicity_name AS name FROM Preliminary WHERE applicant_ethnicity != ''
    UNION
    SELECT co_applicant_ethnicity::INT, co_applicant_ethnicity_name FROM Preliminary WHERE co_applicant_ethnicity != ''
) AS all_ethnicities;

CREATE TABLE Sex(
    sex_code INT PRIMARY KEY,
    sex_name TEXT
);
INSERT INTO Sex(sex_code, sex_name)
SELECT DISTINCT code, name FROM (
    SELECT applicant_sex::INT AS code, applicant_sex_name AS name FROM Preliminary WHERE applicant_sex != ''
    UNION
    SELECT co_applicant_sex::INT, co_applicant_sex_name FROM Preliminary WHERE co_applicant_sex != ''
) AS all_sexes;

-- Race: single lookup table replacing ApplicantRace1-5 and CoApplicantRace1-5
-- All race slots share the same code->name mapping.

CREATE TABLE Race(
    race_code INT PRIMARY KEY,
    race_name TEXT
);
INSERT INTO Race(race_code, race_name)
SELECT DISTINCT code, name FROM (
    SELECT applicant_race_1::INT    AS code, applicant_race_name_1    AS name FROM Preliminary WHERE applicant_race_1    != ''
    UNION
    SELECT applicant_race_2::INT,           applicant_race_name_2           FROM Preliminary WHERE applicant_race_2    != ''
    UNION
    SELECT applicant_race_3::INT,           applicant_race_name_3           FROM Preliminary WHERE applicant_race_3    != ''
    UNION
    SELECT applicant_race_4::INT,           applicant_race_name_4           FROM Preliminary WHERE applicant_race_4    != ''
    UNION
    SELECT applicant_race_5::INT,           applicant_race_name_5           FROM Preliminary WHERE applicant_race_5    != ''
    UNION
    SELECT co_applicant_race_1::INT,        co_applicant_race_name_1        FROM Preliminary WHERE co_applicant_race_1 != ''
    UNION
    SELECT co_applicant_race_2::INT,        co_applicant_race_name_2        FROM Preliminary WHERE co_applicant_race_2 != ''
    UNION
    SELECT co_applicant_race_3::INT,        co_applicant_race_name_3        FROM Preliminary WHERE co_applicant_race_3 != ''
    UNION
    SELECT co_applicant_race_4::INT,        co_applicant_race_name_4        FROM Preliminary WHERE co_applicant_race_4 != ''
    UNION
    SELECT co_applicant_race_5::INT,        co_applicant_race_name_5        FROM Preliminary WHERE co_applicant_race_5 != ''
) AS all_races;

-- DenialReason: single lookup table replacing DenialReason1-3

CREATE TABLE DenialReason(
    denial_reason_code INT PRIMARY KEY,
    denial_reason_name TEXT
);
INSERT INTO DenialReason(denial_reason_code, denial_reason_name)
SELECT DISTINCT code, name FROM (
    SELECT denial_reason_1::INT AS code, denial_reason_name_1 AS name FROM Preliminary WHERE denial_reason_1 != ''
    UNION
    SELECT denial_reason_2::INT,         denial_reason_name_2         FROM Preliminary WHERE denial_reason_2 != ''
    UNION
    SELECT denial_reason_3::INT,         denial_reason_name_3         FROM Preliminary WHERE denial_reason_3 != ''
) AS all_denial_reasons;

-- Location: one row per unique combination of location attributes.
-- The composite of all 10 location columns is the natural key;
-- location_id is a surrogate serial PK.


CREATE TABLE Location(
    location_id              SERIAL PRIMARY KEY,
    county_code              INT,
    msamd                    INT,
    state_code               INT,
    census_tract_number      NUMERIC,
    population               INT,
    minority_population      NUMERIC,
    hud_median_family_income INT,
    tract_to_msamd_income    NUMERIC,
    number_of_owner_occupied_units INT,
    number_of_1_to_4_family_units  INT,

    FOREIGN KEY (county_code)  REFERENCES County(county_code),
    FOREIGN KEY (msamd)        REFERENCES MSAMD(msamd),
    FOREIGN KEY (state_code)   REFERENCES State(state_code)
);

-- Unique index using COALESCE so NULL values are treated as equal (standard
-- UNIQUE constraints treat NULLs as distinct, which would allow logical duplicates).
CREATE UNIQUE INDEX location_natural_key ON Location(
    COALESCE(county_code, -1),
    COALESCE(msamd, -1),
    COALESCE(state_code, -1),
    COALESCE(census_tract_number, -1),
    COALESCE(population, -1),
    COALESCE(minority_population, -1),
    COALESCE(hud_median_family_income, -1),
    COALESCE(tract_to_msamd_income, -1),
    COALESCE(number_of_owner_occupied_units, -1),
    COALESCE(number_of_1_to_4_family_units, -1)
);

INSERT INTO Location(
    county_code, msamd, state_code, census_tract_number,
    population, minority_population, hud_median_family_income,
    tract_to_msamd_income, number_of_owner_occupied_units,
    number_of_1_to_4_family_units
)
SELECT DISTINCT
    NULLIF(county_code, '')::INT,
    NULLIF(msamd, '')::INT,
    NULLIF(state_code, '')::INT,
    NULLIF(census_tract_number, '')::NUMERIC,
    NULLIF(population, '')::INT,
    NULLIF(minority_population, '')::NUMERIC,
    NULLIF(hud_median_family_income, '')::INT,
    NULLIF(tract_to_msamd_income, '')::NUMERIC,
    NULLIF(number_of_owner_occupied_units, '')::INT,
    NULLIF(number_of_1_to_4_family_units, '')::INT
FROM Preliminary;


-- LoanApplication: location columns replaced by location_id;
-- race and denial reason columns removed (moved to join tables).

CREATE TABLE LoanApplication(
    id                       INT PRIMARY KEY,
    as_of_year               INT,
    respondent_id            TEXT,
    agency_code              INT,
    loan_type                INT,
    property_type            INT,
    loan_purpose             INT,
    owner_occupancy          INT,
    preapproval              INT,
    action_taken             INT,
    location_id              INT,
    applicant_ethnicity      INT,
    co_applicant_ethnicity   INT,
    applicant_sex            INT,
    co_applicant_sex         INT,
    purchaser_type           INT,
    loan_amount_000s         INT,
    applicant_income_000s    NUMERIC,
    rate_spread              NUMERIC,
    sequence_number          INT,
    application_date_indicator INT,
    hoepa_status             INT,
    lien_status              INT,
    edit_status              INT,

    FOREIGN KEY (agency_code)            REFERENCES Agency(agency_code),
    FOREIGN KEY (loan_type)              REFERENCES LoanType(loan_type),
    FOREIGN KEY (property_type)          REFERENCES PropertyType(property_type),
    FOREIGN KEY (loan_purpose)           REFERENCES LoanPurpose(loan_purpose),
    FOREIGN KEY (owner_occupancy)        REFERENCES OwnerOccupancy(owner_occupancy),
    FOREIGN KEY (preapproval)            REFERENCES Preapproval(preapproval),
    FOREIGN KEY (action_taken)           REFERENCES ActionTaken(action_taken),
    FOREIGN KEY (purchaser_type)         REFERENCES PurchaserType(purchaser_type),
    FOREIGN KEY (hoepa_status)           REFERENCES HOEPAStatus(hoepa_status),
    FOREIGN KEY (lien_status)            REFERENCES LienStatus(lien_status),
    FOREIGN KEY (edit_status)            REFERENCES EditStatus(edit_status),
    FOREIGN KEY (applicant_ethnicity)    REFERENCES Ethnicity(ethnicity_code),
    FOREIGN KEY (co_applicant_ethnicity) REFERENCES Ethnicity(ethnicity_code),
    FOREIGN KEY (applicant_sex)          REFERENCES Sex(sex_code),
    FOREIGN KEY (co_applicant_sex)       REFERENCES Sex(sex_code),
    FOREIGN KEY (location_id)            REFERENCES Location(location_id)
);

INSERT INTO LoanApplication(
    id, as_of_year, respondent_id, agency_code, loan_type, property_type,
    loan_purpose, owner_occupancy, preapproval, action_taken, location_id,
    applicant_ethnicity, co_applicant_ethnicity, applicant_sex, co_applicant_sex,
    purchaser_type, loan_amount_000s, applicant_income_000s, rate_spread,
    sequence_number, application_date_indicator, hoepa_status, lien_status, edit_status
)
SELECT
    p.id,
    NULLIF(p.as_of_year, '')::INT,
    NULLIF(p.respondent_id, '')::TEXT,
    NULLIF(p.agency_code, '')::INT,
    NULLIF(p.loan_type, '')::INT,
    NULLIF(p.property_type, '')::INT,
    NULLIF(p.loan_purpose, '')::INT,
    NULLIF(p.owner_occupancy, '')::INT,
    NULLIF(p.preapproval, '')::INT,
    NULLIF(p.action_taken, '')::INT,
    l.location_id,
    NULLIF(p.applicant_ethnicity, '')::INT,
    NULLIF(p.co_applicant_ethnicity, '')::INT,
    NULLIF(p.applicant_sex, '')::INT,
    NULLIF(p.co_applicant_sex, '')::INT,
    NULLIF(p.purchaser_type, '')::INT,
    NULLIF(p.loan_amount_000s, '')::INT,
    NULLIF(p.applicant_income_000s, '')::NUMERIC,
    NULLIF(p.rate_spread, '')::NUMERIC,
    NULLIF(p.sequence_number, '')::INT,
    NULLIF(p.application_date_indicator, '')::INT,
    NULLIF(p.hoepa_status, '')::INT,
    NULLIF(p.lien_status, '')::INT,
    NULLIF(p.edit_status, '')::INT
FROM Preliminary p
JOIN Location l ON
    l.county_code              IS NOT DISTINCT FROM NULLIF(p.county_code, '')::INT
    AND l.msamd                IS NOT DISTINCT FROM NULLIF(p.msamd, '')::INT
    AND l.state_code           IS NOT DISTINCT FROM NULLIF(p.state_code, '')::INT
    AND l.census_tract_number  IS NOT DISTINCT FROM NULLIF(p.census_tract_number, '')::NUMERIC
    AND l.population           IS NOT DISTINCT FROM NULLIF(p.population, '')::INT
    AND l.minority_population  IS NOT DISTINCT FROM NULLIF(p.minority_population, '')::NUMERIC
    AND l.hud_median_family_income       IS NOT DISTINCT FROM NULLIF(p.hud_median_family_income, '')::INT
    AND l.tract_to_msamd_income          IS NOT DISTINCT FROM NULLIF(p.tract_to_msamd_income, '')::NUMERIC
    AND l.number_of_owner_occupied_units IS NOT DISTINCT FROM NULLIF(p.number_of_owner_occupied_units, '')::INT
    AND l.number_of_1_to_4_family_units  IS NOT DISTINCT FROM NULLIF(p.number_of_1_to_4_family_units, '')::INT;

-- ApplicantRace: 1NF join table replacing applicant_race_1..5
-- Columns: application_id, race_code, race_number (1-5)

CREATE TABLE ApplicantRace(
    application_id INT,
    race_code      INT,
    race_number    INT,
    PRIMARY KEY (application_id, race_number),
    FOREIGN KEY (application_id) REFERENCES LoanApplication(id),
    FOREIGN KEY (race_code)      REFERENCES Race(race_code)
);

INSERT INTO ApplicantRace(application_id, race_code, race_number)
SELECT id, applicant_race_1::INT, 1 FROM Preliminary WHERE applicant_race_1 != ''
UNION ALL
SELECT id, applicant_race_2::INT, 2 FROM Preliminary WHERE applicant_race_2 != ''
UNION ALL
SELECT id, applicant_race_3::INT, 3 FROM Preliminary WHERE applicant_race_3 != ''
UNION ALL
SELECT id, applicant_race_4::INT, 4 FROM Preliminary WHERE applicant_race_4 != ''
UNION ALL
SELECT id, applicant_race_5::INT, 5 FROM Preliminary WHERE applicant_race_5 != '';

-- CoApplicantRace: 1NF join table replacing co_applicant_race_1..5

CREATE TABLE CoApplicantRace(
    application_id INT,
    race_code      INT,
    race_number    INT,
    PRIMARY KEY (application_id, race_number),
    FOREIGN KEY (application_id) REFERENCES LoanApplication(id),
    FOREIGN KEY (race_code)      REFERENCES Race(race_code)
);

INSERT INTO CoApplicantRace(application_id, race_code, race_number)
SELECT id, co_applicant_race_1::INT, 1 FROM Preliminary WHERE co_applicant_race_1 != ''
UNION ALL
SELECT id, co_applicant_race_2::INT, 2 FROM Preliminary WHERE co_applicant_race_2 != ''
UNION ALL
SELECT id, co_applicant_race_3::INT, 3 FROM Preliminary WHERE co_applicant_race_3 != ''
UNION ALL
SELECT id, co_applicant_race_4::INT, 4 FROM Preliminary WHERE co_applicant_race_4 != ''
UNION ALL
SELECT id, co_applicant_race_5::INT, 5 FROM Preliminary WHERE co_applicant_race_5 != '';

-- ApplicationDenialReason: 1NF join table replacing denial_reason_1..3
-- Columns: application_id, denial_reason_code, reason_number (1-3)

CREATE TABLE ApplicationDenialReason(
    application_id     INT,
    denial_reason_code INT,
    reason_number      INT,
    PRIMARY KEY (application_id, reason_number),
    FOREIGN KEY (application_id)     REFERENCES LoanApplication(id),
    FOREIGN KEY (denial_reason_code) REFERENCES DenialReason(denial_reason_code)
);

INSERT INTO ApplicationDenialReason(application_id, denial_reason_code, reason_number)
SELECT id, denial_reason_1::INT, 1 FROM Preliminary WHERE denial_reason_1 != ''
UNION ALL
SELECT id, denial_reason_2::INT, 2 FROM Preliminary WHERE denial_reason_2 != ''
UNION ALL
SELECT id, denial_reason_3::INT, 3 FROM Preliminary WHERE denial_reason_3 != '';

--code for video step do not run if setting up this step

-- Show all normalized tables from Step 3
-- Use \q or q to exit each table's output early
-- use \pset pager off to disable paging and show all results at once
SELECT * FROM Agency;
SELECT * FROM LoanType;
SELECT * FROM PropertyType;
SELECT * FROM LoanPurpose;
SELECT * FROM OwnerOccupancy;
SELECT * FROM Preapproval;
SELECT * FROM ActionTaken;
SELECT * FROM PurchaserType;
SELECT * FROM HOEPAStatus;
SELECT * FROM LienStatus;
SELECT * FROM EditStatus;
SELECT * FROM MSAMD;
SELECT * FROM State;
SELECT * FROM County;
SELECT * FROM Ethnicity;
SELECT * FROM Sex;
SELECT * FROM Race;
SELECT * FROM DenialReason;
--these tables have more than 100 rows, so we will only show the first 10 rows for each
--LIMIT 20
SELECT * FROM Location;
SELECT * FROM LoanApplication;
SELECT * FROM ApplicantRace;
SELECT * FROM CoApplicantRace;
SELECT * FROM ApplicationDenialReason;

