use bank_loan;

select * from financial_loan;

/*_________________________________________________________________________________________________*/

-- Total Loan Applications
select COUNT(id) as Total_loan_applications 
from financial_loan;

-- Month-To-Date (MTD) Loan Applications
select COUNT(id) as MTD_loan_applications 
from financial_loan
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021;

-- Previous-Month-Date (PMTD) Loan Applications
select COUNT(id) as PMTD_loan_applications 
from financial_loan
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021;


-- Total funds disbursed
select SUM(loan_amount) as Total_funded_amount
from financial_loan;

-- MTD Total funds disbursed
select SUM(loan_amount) as MTD_Total_funded_amount
from financial_loan
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021;

-- PMTD Total funds disbursed
select SUM(loan_amount) as PMTD_Total_funded_amount
from financial_loan
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021;


--
select SUM(total_payment) as Total_Amount_Received from financial_loan;

-- 
select SUM(total_payment) as MTD_Total_Amount_Received 
from financial_loan
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021;

--
select SUM(total_payment) as PMTD_Total_Amount_Received 
from financial_loan
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021;

--
select round(AVG(int_rate), 4) * 100 as Avg_Interest_Rate 
from financial_loan;

--
select round(AVG(int_rate), 4) * 100 as MTD_Avg_Interest_Rate 
from financial_loan
where MONTH(issue_date) = 12 and YEAR(issue_date) = 2021;

--
select round(AVG(int_rate), 4) * 100 as PMTD_Avg_Interest_Rate 
from financial_loan
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021;

--
select round(AVG(dti),4) * 100 as Avg_Debt_To_Income
from financial_loan;

--
select round(AVG(dti),4) * 100 as PMTD_Avg_Debt_To_Income
from financial_loan
where MONTH(issue_date) = 11 and YEAR(issue_date) = 2021;



-- Good Loan Application Percentage
select (COUNT(case when loan_status = 'Fully Paid' or loan_status = 'Current' then id end) * 100)
	/ COUNT(id) as Good_loan_percentage
from financial_loan;

-- Good Loan Applications
select COUNT(id) as Good_loan_applications
from financial_loan
where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Good loan funded amount
select SUM(loan_amount) as Good_loan_funded_amount
from financial_loan
where loan_status = 'Fully Paid' or loan_status = 'Current';

-- Good loan total received amount
select SUM(total_payment) as Good_loan_total_received_amount
from financial_loan
where loan_status = 'Fully Paid' or loan_status = 'Current';



-- Bad Loan Application Percentage
select (COUNT(case when loan_status = 'Charged Off' then id end) * 100)
	/ COUNT(id) as Bad_loan_percentage
from financial_loan;

-- Bad Loan Applications
select COUNT(id) as Bad_loan_applications
from financial_loan
where loan_status = 'Charged Off';

-- Bad loan funded amount
select SUM(loan_amount) as Bad_loan_funded_amount
from financial_loan
where loan_status = 'Charged Off';

-- Bad loan total received amount
select SUM(total_payment) as Bad_loan_total_received_amount
from financial_loan
where loan_status = 'Charged Off';



-- Loan status 1
select 
loan_status,
COUNT(id) as Total_loan_applications,
SUM(total_payment) as Total_amount_received,
SUM(loan_amount) as Total_funded_amount,
round(AVG(int_rate * 100),2) as Interest_rate,
round(AVG(dti * 100),2) as DTI
from financial_loan
group by loan_status;

-- Loan Status 2
select
loan_status,
SUM(total_payment) as MTD_total_amount_received,
SUM(loan_amount) as MTD_total_funded_amount
from financial_loan
where MONTH(issue_date) = 12
group by loan_status;

/*_________________________________________________________________________________________________*/

select * from financial_loan;

--  Monthly trends by issue date
select 
MONTH(issue_date) as Month_number,
DATENAME(MONTH, issue_date) as Month_name,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_received_amount
from financial_loan
group by MONTH(issue_date), DATENAME(MONTH, issue_date)
order by MONTH(issue_date);

-- Regional analysis by state
 
 select 
address_state,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_received_amount
from financial_loan
group by address_state
order by sum(loan_amount) desc;

-- Loan tern analysis
 select 
term,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_received_amount
from financial_loan
group by term
order by term desc;

-- Employee length analysis
 select 
emp_length,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_received_amount
from financial_loan
group by emp_length
order by count(id) desc;

-- Loan purpose breakdown
 select 
purpose,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_received_amount
from financial_loan
group by purpose
order by count(id) desc;

-- Home ownership analysis
 select 
home_ownership,
count(id) as Total_loan_applications,
sum(loan_amount) as Total_funded_amount,
sum(total_payment) as Total_received_amount
from financial_loan
group by home_ownership
order by count(id) desc;

/*_________________________________________________________________________________________________*/
