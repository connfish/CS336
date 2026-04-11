/*
You should use the given CSV to figure out which columns can be null and which cannot. Assume that any column that is never null in the real data can never be null.

You also need to be able to generate a csv report which is identical to the origional csv (except for order of the rows which can be different). This proves that your decomposition was lossless (since you can still recover the origional report). You may not use the preliminary table in any way when generating the report.

TO TURN IN:
1. An SQL script which takes your normalized database and puts it into a CSV
2. A video showing the incorrect attempts 
   Your video should show an attempt to run 3 incorrect insertion commands which the database rejects, it should show at least 3 different attempts rejected for different reasons as before no video should be more than 1 minute in lenght
   NOTE: we may try a different incorrect attempt in addition to watching your video.
3. A screenshot of the csv opened in a spreadsheet program showing it is identical to the origional csv (except for order of the rows which can be different)*/

--NOTHING THE USER CAN DO SHOULD EVER PUT THE DATABASE IN AN INCONSISTENT STATE, they should get an immediate rejection if they, for example, try to select a code of 4 for property type. This can be done with foreign keys.
ALTER TABLE LoanApplication ALTER COLUMN location_id SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN as_of_year SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN respondent_id SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN agency_code SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN loan_type SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN property_type SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN loan_purpose SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN owner_occupancy SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN preapproval SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN action_taken SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN applicant_ethnicity SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN co_applicant_ethnicity SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN applicant_sex SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN co_applicant_sex SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN purchaser_type SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN hoepa_status SET NOT NULL;
ALTER TABLE LoanApplication ALTER COLUMN lien_status SET NOT NULL;

/* Test commands: 

INSERT INTO LoanApplication (id, as_of_year, respondent_id, agency_code, loan_type, property_type, loan_purpose, owner_occupancy, preapproval, action_taken, location_id, applicant_ethnicity, co_applicant_ethnicity, applicant_sex, co_applicant_sex, purchaser_type, loan_amount_000s, hoepa_status, lien_status) VALUES (888888888, 2017, '58652', 1, 1, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 3640, 1, 1);
INSERT INTO LoanApplication (id, as_of_year, respondent_id, agency_code, loan_type, property_type, loan_purpose, owner_occupancy, preapproval, action_taken, location_id, applicant_ethnicity, co_applicant_ethnicity, applicant_sex, co_applicant_sex, purchaser_type, loan_amount_000s, hoepa_status, lien_status) VALUES (1, 2017, '58652', 1, 1, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5000, 1, 1);
INSERT INTO LoanApplication (id, as_of_year, respondent_id, agency_code, loan_type, property_type, loan_purpose, owner_occupancy, preapproval, action_taken, location_id, applicant_ethnicity, co_applicant_ethnicity, applicant_sex, co_applicant_sex, purchaser_type, loan_amount_000s, hoepa_status, lien_status) VALUES (87000, 2017, '58653', 1, 1, NULL , 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5000, 1, 1);
*/

