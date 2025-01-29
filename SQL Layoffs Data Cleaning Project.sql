# PROJECT
/* Remove duplicates
Standardize the data
Work on null or blank values
Remove unwanted columns or rows*/


-- Call the table
Select * from layoffs;

-- Create duplicate table
create table layoff_raw as
select * from layoffs;

-- Insert row number to check for duplicate values 
select *, 
row_number() over(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) as Row_num
from layoffs;

-- create cte to check for duplicates
with duplicate_cte as(
select *, 
row_number() over(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) as Row_num
from layoffs)

select * 
from duplicate_cte 
where row_num > 1;

/* To Remove duplicates */
CREATE TABLE `layoffs2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `Row_Num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into `layoffs2`
select *, 
row_number() over(partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`, 
stage, country, funds_raised_millions) as Row_num
from layoffs;

select * from `layoffs2`
where row_num > 1;

Delete from `layoffs2`
where row_num > 1;

select * from `layoffs2`;

/* Standadizing data */
-- Remove extra spaces from the company column
select distinct company, trim(company)
from `layoffs2`;

update `layoffs2`
set company =  trim(company);

-- Correct spellings in the location names
select distinct location
from `layoffs2`;

update `layoffs2`
set location = 'Dusseldorf'
where location = 'DÃ¼sseldorf';

update `layoffs2`
set location = 'Malmo'
where location = 'MalmÃ¶';

update `layoffs2`
set location = 'Florianopolis'
where location = 'FlorianÃ³polis';

-- Update the crypto rows in the industry table
select *
from `layoffs2`
where industry like 'crypto%';

update `layoffs2`
set industry = 'crypto'
where industry like 'crypto%';

select *
from `layoffs2`
where industry = '' or industry is null;

-- change the date format
select `date`, str_to_date(`date`, '%m/%d/%Y')
from `layoffs2`;

update `layoffs2`
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table `layoffs2`
modify column `date` date;

-- Change the spelling in the country column for United States
select distinct country, trim(trailing '.' from country)
from `layoffs2`;

update `layoffs2`
set country = trim(trailing '.' from country)
where country like 'United States%';

/* Filling blanks */
select *
from `layoffs2`
where industry is null;

update `layoffs2`
set industry = null
where industry = '';

select * 
from `layoffs2` l1 
join `layoffs2` l2
	on l1.company = l2.company
    and l1.location = l2.location
where l1.industry is null
and l2.industry is not null;

update `layoffs2` l1  
join `layoffs2` l2
	on l1.company = l2.company
set l1.industry = l2.industry
where l1.industry is null
and l2.industry is not null;

/* Remove unwanted column */
select * 
from `layoffs2`
where total_laid_off is null
and percentage_laid_off is null;

delete
from `layoffs2`
where total_laid_off is null
and percentage_laid_off is null;


alter table `layoffs2`
drop column Row_Num;

select * from `layoffs2`;

