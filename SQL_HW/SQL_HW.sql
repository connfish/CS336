-- Question 1
-- DB SCHEMA
-- Cheese(cid, name, color, age, price)
--(price is price per pound)
--Store(sid, address, open time, close time)
--item(cid, sid, weight)

-- 1.1 - Find a store open at least 5 hours a day that sells a cheese named cheddar.
SELECT S.id, S.address FROM Store S
JOIN item I ON I.sid = S.sid
JOIN Cheese C ON C.cid = I.cid
WHERE C.name = 'cheddar'
    AND EXTRACT (EPOCH FROM (S.close_time - S.open_time)) >= 5*60*60;

--1.2 - Compute the total value of the cheese at every store.
SELECT S.id, 
    SUM(I.weight * C.price)
FROM Store S
JOIN item I   ON I.sid = S.sid
JOIN Cheese C ON C.cid = I.cid
GROUP BY S.sid;

-- 1.3- What does the following query do in English?
With values AS
(SELECT weight * Price AS Value, sid, cid
FROM Store S
INNER JOIN item I ON I.sid = S.sid
INNER JOIN Cheese C ON I.cid = C.cid)
SELECT Value, cid, sid
FROM values
ORDER BY Value DESC
LIMIT 1;
/*
It finds the single (store, cheese) item with the highest total value  across all stores, 
and returns that value along with the cheese id and store id
*/

-- Question 2
/*
DB Schema
Patient(pid, admitDate, dischargeDate, did, hid)
Doctor(did, name, salary, hid)
Hospital(hid, address, salaryBudget)
*/

--2.1 - Find all hospitals that are overbudget. (the total salary of the doctors who work
--there is greater than the hospital’s budget for salaries)
SELECT H.hid, H.address
FROM Hospital H
JOIN Doctor D ON D.hid = H.hid
GROUP BY H.hid, H.address, H.salaryBudget
HAVING SUM(D.salary) > H.salaryBudget;

--2.2 -Find all Doctors who have patients in a hospital they don’t work in.
SELECT DISTINCT D.did, D.name
FROM Doctor D
JOIN Patient P ON P.did = D.did
WHERE P.hid <> D.hid;

--2.3 - Find the average salary for doctors with more than 3 patients.
SELECT AVG(t.salary) AS avg_salary
FROM (
  SELECT D.did, D.salary
  FROM Doctor D
  JOIN Patient P ON P.did = D.did
  GROUP BY D.did, D.salary
  HAVING COUNT(*) > 3
) t;

--2.4 - Compute the average cost per a patient in doctor salary for each hospital.
WITH doc_totals AS (
  SELECT hid, SUM(salary) AS total_salary
  FROM Doctor
  GROUP BY hid
),
patient_counts AS (
  SELECT hid, COUNT(*) AS num_patients
  FROM Patient
  GROUP BY hid
)
SELECT H.hid,
       H.address,
       (DT.total_salary * 1.0) / PC.num_patients AS avg_cost_per_patient
FROM Hospital H
JOIN doc_totals DT     ON DT.hid = H.hid
JOIN patient_counts PC ON PC.hid = H.hid;