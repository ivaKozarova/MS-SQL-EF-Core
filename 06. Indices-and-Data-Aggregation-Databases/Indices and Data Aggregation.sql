USE Gringotts

SELECT * FROM WizzardDeposits

-- 1. Records’ Count

SELECT COUNT(*) AS [Count]
	FROM WizzardDeposits

-- 2.  Longest Magic Wand

SELECT MAX(MagicWandSize) AS [LongestMagicWand]
	FROM WizzardDeposits

-- 3. Longest Magic Wand per Deposit Groups

SELECT DepositGroup , MAX(MagicWandSize) AS [LongestMagicWand]
	FROM WizzardDeposits
	GROUP BY DepositGroup
	
-- 4. Smallest Deposit Group per Magic Wand Size

SELECT  TOP(2) DepositGroup
	FROM WizzardDeposits
	GROUP BY DepositGroup	
	ORDER BY AVG(MagicWandSize)

-- 5. Deposits Sum 

SELECT DepositGroup, Sum(DepositAmount) AS [TotalSum]
	FROM WizzardDeposits
	GROUP BY DepositGroup

-- 6. Deposits Sum for Ollivander Family

SELECT DepositGroup,  Sum(DepositAmount) AS [TotalSum] 
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup

-- 7. Deposits Filter

SELECT DepositGroup,  Sum(DepositAmount) AS [TotalSum] 
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup
	HAVING Sum(DepositAmount) < 150000
	ORDER BY TotalSum DESC

-- 8. Deposit Charge

SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS [MinDepositCharge]
	FROM WizzardDeposits
	GROUP BY DepositGroup, MagicWandCreator
	ORDER BY MagicWandCreator , DepositGroup
	
--9. Age Groups 


SELECT AgeGroup , COUNT(*) AS [WizzardsCount]
	FROM 
		(
			SELECT 
				CASE
					WHEN Age < 10 THEN '[0-10]'
					WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
					WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
					WHEN AGE BETWEEN 31 AND 40 THEN '[31-40]'
					WHEN AGE BETWEEN 41 AND 50 THEN '[41-50]'
					WHEN AGE BETWEEN 51 AND 60 THEN '[51-60]'
					ELSE '[61+]'
				END AS AgeGroup  		 
			FROM WizzardDeposits
		) AS [AgeGroupingQuery]
	GROUP BY AgeGroup

-- 10. First Letter

SELECT LEFT(FirstName,1)  AS  FirstLetter 
	FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
GROUP BY LEFT(FirstName,1)  
ORDER BY FirstLetter
			
--11. Average Interest

SELECT DepositGroup, IsDepositExpired , AVG(DepositInterest) 
	FROM WizzardDeposits
		WHERE DepositStartDate > '1985 - 01 - 01'
		GROUP BY DepositGroup , IsDepositExpired
	ORDER BY DepositGroup DESC, IsDepositExpired ASC

--12. Rich Wizard, Poor Wizard

SELECT SUM([Difference]) AS SumDifference
	FROM 
	(	
	SELECT *, [Host Wizard Deposit] -[Guest Wizard Deposit] AS [Difference]
		FROM (
					SELECT FirstName AS [HostWizzard] , 
					DepositAmount AS [Host Wizard Deposit],
					LEAD(FirstName , 1) OVER(ORDER BY Id) AS [Guest Wizard],
					LEAD(DepositAmount , 1) OVER(ORDER BY Id) AS [Guest Wizard Deposit]
					FROM WizzardDeposits				
			 ) AS [HostGuestWizzardQuety]
			 WHERE [Guest Wizard Deposit] IS NOT NULL
	)AS [DepositDifference]

-- 13. Departments Total Salaries

USE SoftUni

SELECT DepartmentID , SUM(Salary)
	FROM Employees
		GROUP BY DepartmentID
		ORDER BY DepartmentID

--14. Employees Minimum Salaries

SELECT DepartmentID , MIN(Salary)
	FROM Employees
	WHERE DepartmentID IN (2,5,7)
		AND HireDate > '2000 - 01 - 01'
		GROUP BY DepartmentID

-- 15. Employees Average Salaries

SELECT * INTO [EmployeesWithHighSalary]
	FROM Employees
		WHERE Salary > 30000;

DELETE FROM [EmployeesWithHighSalary]
	WHERE ManagerID = 42;

UPDATE [EmployeesWithHighSalary]
	SET SALARY += 5000
	WHERE DepartmentID  = 1 ;

SELECT DepartmentID, AVG(Salary)
	FROM [EmployeesWithHighSalary]
		GROUP BY DepartmentID;

-- 16. Employees Maximum Salaries

SELECT DepartmentID, MAX(Salary) AS [MaxSalary]
	FROM Employees
		GROUP BY DepartmentID
		HAVING MAX(Salary) < 30000 OR MAX(Salary) > 70000


--17. Employees Count Salaries

SELECT COUNT(*) AS [Count]
	FROM Employees
	WHERE ManagerID IS NULL;

-- 18. 3rd Highest Salary

SELECT DISTINCT DepartmentID , Salary AS [ThirdHighestSalary]
	FROM	(
				SELECT DepartmentID, Salary,
					DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS [RankSalary]							
					FROM Employees
			)AS [RankSalaryQuery]
	WHERE [RankSalary] = 3;

-- 19. Salary Challenge

SELECT TOP(10) e1.FirstName, e1.LastName, e1.DepartmentID 
	FROM Employees AS e1
	WHERE e1.Salary >(	
						SELECT  AVG(Salary) AS Salary
						FROM Employees AS e2
						WHERE e2.DepartmentID = e1.DepartmentID
						GROUP BY DepartmentID
					  )
	ORDER BY DepartmentID;
		
	
	

	 




	

