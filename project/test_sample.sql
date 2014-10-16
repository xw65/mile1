--1. Find all judges who work at DC

SELECT j.name
FROM Judge j, Court c
WHERE j.court_id=c.court_id AND c.city='Washington DC';

--2. Find all the cases that parties from New York have involved
CREATE VIEW NYPartyInvolved AS
SELECT I.serial AS serial, I.party_id AS party_id, I.status AS status
FROM Involved AS I, Party AS P
WHERE P.location = 'NY' AND P.party_id = I.party_id;

SELECT * 
FROM NYPartyInvolved;

--3. Find all the cases that parties from New York have involved and won
CREATE VIEW NYPartyWin AS
SELECT NY.serial AS serial, NY.party_id AS party_id, NY.status AS status
FROM Cases AS C, NYPartyInvolved AS NY
WHERE C.serial = NY.serial AND C.result = NY.status;

SELECT *
FROM NYPartyWin;

--4. For what percentage of all times has the court favored parties from NY?

SELECT (100*COUNT(*)/(SELECT COUNT(*) FROM NYPartyInvolved)) AS percent
FROM NYPartyWin;

DROP VIEW NYPartyWin;
DROP VIEW NYPartyInvolved;

--5. Find all specific area(bio-related) cases that a specific(Alan Lourie) has favored the defendant

SELECT C.serial AS serial
FROM Judge AS J, Cases AS C, Rules AS R
WHERE J.name = 'Alan Lourie' AND J.judge_id = R.judge_id
AND r.serial = C.serial AND C.technical_area = 'bio' AND R.decision = 'def';

--5. Find all specific area(bio-related) cases that a specific(Alan Lourie) has favored the plaintiff

SELECT C.serial AS serial
FROM Judge AS J, Cases AS C, Rules AS R
WHERE J.name = 'Alan Lourie' AND J.judge_id = R.judge_id
AND r.serial = C.serial AND C.technical_area = 'bio' AND R.decision = 'plt';

--7. Does Judge Alan Lourie favor defendant or plaintiff more in bio-related cases? 

CREATE VIEW ALFavorDef AS
SELECT C.serial AS serial
FROM Judge AS J, Cases AS C, Rules AS R
WHERE J.name = 'Alan Lourie' AND J.judge_id = R.judge_id
AND r.serial = C.serial AND C.technical_area = 'bio' AND R.decision = 'def';

CREATE VIEW ALFavorPlt AS
SELECT C.serial AS serial
FROM Judge AS J, Cases AS C, Rules AS R
WHERE J.name = 'Alan Lourie' AND J.judge_id = R.judge_id
AND r.serial = C.serial AND C.technical_area = 'bio' AND R.decision = 'plt';

SELECT (COUNT(*) - (SELECT COUNT(*) FROM ALFavorPlt)) AS cnt
FROM ALFavorDef;

DROP VIEW ALFavorDef;
DROP VIEW ALFavorPlt;

--8. For every judge who has ever supported a plaintiff on cases of "utility" issue, find the number of the cases

SELECT R.judge_id AS judge_id, COUNT(*) AS cnt
FROM Cases AS C, Rules AS R 
WHERE C.issue = 'utility' AND C.serial = R.serial AND R.decision = 'plt'
GROUP BY R.judge_id;

--9. The current client is the plaintiff, the issue of the case is "utility," which judge will most likely support the client's position? 

CREATE VIEW Potential AS
SELECT R.judge_id AS judge_id, COUNT(*) AS cnt
FROM Cases AS C, Rules AS R 
WHERE C.issue = 'utility' AND C.serial = R.serial AND R.decision = 'plt'
GROUP BY R.judge_id;

SELECT J.name
FROM Potential AS P1, Judge AS J
WHERE P1.judge_id = J.judge_id
AND (P1.cnt >= (SELECT MAX(P2.cnt) FROM Potential AS P2));
                     
DROP VIEW Potential;

--10. Is being a female a disadvantage litigating in the Federal Circuit? 

SELECT (100*count(*)/(select count(*) from Party p1, Involved i1 where p1.gender='female' AND i1.party_id=p1.party_id)) AS percent
FROM Party p, Involved i, Cases c
WHERE p.gender='female' AND i.serial=c.serial AND i.party_id=p.party_id AND c.result=i.status;
