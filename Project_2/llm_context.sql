-- Actual database schema (Step 3 normalized form)
-- All table and column names are lowercase as stored in PostgreSQL.

CREATE TABLE agency(
    agency_code INT PRIMARY KEY,
    agency_name TEXT,
    agency_abbr TEXT
);

CREATE TABLE loantype(
    loan_type INT PRIMARY KEY,
    loan_type_name TEXT
);

CREATE TABLE propertytype(
    property_type INT PRIMARY KEY,
    property_type_name TEXT
);

CREATE TABLE loanpurpose(
    loan_purpose INT PRIMARY KEY,
    loan_purpose_name TEXT
);

CREATE TABLE owneroccupancy(
    owner_occupancy INT PRIMARY KEY,
    owner_occupancy_name TEXT
);
-- Values: 1='Owner-occupied as a principal dwelling', 2='Not owner-occupied', 3='Not applicable'

CREATE TABLE preapproval(
    preapproval INT PRIMARY KEY,
    preapproval_name TEXT
);

CREATE TABLE actiontaken(
    action_taken INT PRIMARY KEY,
    action_taken_name TEXT
);
-- Values: 1='Loan originated', 2='Application approved but not accepted',
--         3='Application denied by financial institution', 4='Application withdrawn',
--         5='File closed for incompleteness', 6='Loan purchased by institution'

CREATE TABLE purchasertype(
    purchaser_type INT PRIMARY KEY,
    purchaser_type_name TEXT
);

CREATE TABLE hoepastatus(
    hoepa_status INT PRIMARY KEY,
    hoepa_status_name TEXT
);

CREATE TABLE lienstatus(
    lien_status INT PRIMARY KEY,
    lien_status_name TEXT
);

CREATE TABLE editstatus(
    edit_status INT PRIMARY KEY,
    edit_status_name TEXT
);

CREATE TABLE msamd(
    msamd INT PRIMARY KEY,
    msamd_name TEXT
);

CREATE TABLE state(
    state_code INT PRIMARY KEY,
    state_name TEXT,
    state_abbr TEXT
);

CREATE TABLE county(
    county_code INT PRIMARY KEY,
    county_name TEXT
);

CREATE TABLE applicantethnicity(
    applicant_ethnicity INT PRIMARY KEY,
    applicant_ethnicity_name TEXT
);

CREATE TABLE coapplicantethnicity(
    co_applicant_ethnicity INT PRIMARY KEY,
    co_applicant_ethnicity_name TEXT
);

CREATE TABLE applicantsex(
    applicant_sex INT PRIMARY KEY,
    applicant_sex_name TEXT
);

CREATE TABLE coapplicantsex(
    co_applicant_sex INT PRIMARY KEY,
    co_applicant_sex_name TEXT
);

-- Single unified race lookup used by both applicantrace and coapplicantrace
CREATE TABLE race(
    race_code INT PRIMARY KEY,
    race_name TEXT
);
-- Values: 1=American Indian/Alaska Native, 2=Asian,
--         3=Black or African American, 4=Native Hawaiian/Other Pacific Islander,
--         5=White, 6=Information not provided, 7=Not applicable, 8=No co-applicant

-- Single unified denial reason lookup
CREATE TABLE denialreason(
    denial_reason_code INT PRIMARY KEY,
    denial_reason_name TEXT
);
-- Values: 1=Debt-to-income ratio, 2=Employment history, 3=Credit history,
--         4=Collateral, 5=Insufficient cash, 6=Unverifiable information,
--         7=Credit application incomplete, 8=Mortgage insurance denied, 9=Other

-- location groups geographic/census attributes. Has no name columns —
-- join to county, state, or msamd to get names.
CREATE TABLE location(
    location_id              SERIAL PRIMARY KEY,
    county_code              INT REFERENCES county(county_code),
    msamd                    INT REFERENCES msamd(msamd),
    state_code               INT REFERENCES state(state_code),
    census_tract_number      NUMERIC,
    population               INT,
    minority_population      NUMERIC,
    hud_median_family_income INT,
    tract_to_msamd_income    NUMERIC,
    number_of_owner_occupied_units INT,
    number_of_1_to_4_family_units  INT
);

-- Main fact table. Race, denial reason, and location columns have been removed.
-- Use join tables for race and denial reason; use location table for geography.
CREATE TABLE loanapplication(
    id                       INT PRIMARY KEY,
    as_of_year               INT,
    respondent_id            TEXT,
    agency_code              INT REFERENCES agency(agency_code),
    loan_type                INT REFERENCES loantype(loan_type),
    property_type            INT REFERENCES propertytype(property_type),
    loan_purpose             INT REFERENCES loanpurpose(loan_purpose),
    owner_occupancy          INT REFERENCES owneroccupancy(owner_occupancy),
    preapproval              INT REFERENCES preapproval(preapproval),
    action_taken             INT REFERENCES actiontaken(action_taken),
    location_id              INT REFERENCES location(location_id),
    applicant_ethnicity      INT REFERENCES applicantethnicity(applicant_ethnicity),
    co_applicant_ethnicity   INT REFERENCES coapplicantethnicity(co_applicant_ethnicity),
    applicant_sex            INT REFERENCES applicantsex(applicant_sex),
    co_applicant_sex         INT REFERENCES coapplicantsex(co_applicant_sex),
    purchaser_type           INT REFERENCES purchasertype(purchaser_type),
    loan_amount_000s         INT,
    applicant_income_000s    NUMERIC,
    rate_spread              NUMERIC,
    sequence_number          INT,
    application_date_indicator INT,
    hoepa_status             INT REFERENCES hoepastatus(hoepa_status),
    lien_status              INT REFERENCES lienstatus(lien_status),
    edit_status              INT REFERENCES editstatus(edit_status)
);

-- Join table for applicant race (replaces applicant_race_1..5 columns on loanapplication).
-- To query by race: JOIN loanapplication -> applicantrace -> race
CREATE TABLE applicantrace(
    application_id INT REFERENCES loanapplication(id),
    race_code      INT REFERENCES race(race_code),
    race_number    INT,
    PRIMARY KEY (application_id, race_number)
);

-- Join table for co-applicant race (replaces co_applicant_race_1..5 columns).
CREATE TABLE coapplicantrace(
    application_id INT REFERENCES loanapplication(id),
    race_code      INT REFERENCES race(race_code),
    race_number    INT,
    PRIMARY KEY (application_id, race_number)
);

-- Join table for denial reasons (replaces denial_reason_1..3 columns on loanapplication).
CREATE TABLE applicationdenialreason(
    application_id     INT REFERENCES loanapplication(id),
    denial_reason_code INT REFERENCES denialreason(denial_reason_code),
    reason_number      INT,
    PRIMARY KEY (application_id, reason_number)
);
