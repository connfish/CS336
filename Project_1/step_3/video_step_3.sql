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
SELECT * FROM ApplicantEthnicity;
SELECT * FROM CoApplicantEthnicity;
SELECT * FROM ApplicantSex;
SELECT * FROM CoApplicantSex;
SELECT * FROM Race;
SELECT * FROM DenialReason;
--these tables have more than 100 rows, so we will only show the first 10 rows for each
--LIMIT 20
SELECT * FROM Location;
SELECT * FROM LoanApplication;
SELECT * FROM ApplicantRace;
SELECT * FROM CoApplicantRace;
SELECT * FROM ApplicationDenialReason;
