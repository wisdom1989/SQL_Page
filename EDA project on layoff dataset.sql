# EXPLORATORY DATA ANALYSIS

-- Maximum amount of employee laid off and the percentage of lay offs 
select max(total_laid_off), max(percentage_laid_off)
from layoffs2;

-- Companies that laid off all their employees
select *
from layoffs2
where percentage_laid_off = 1
order by company;

-- Top 5 companies with their total laid off
select company, sum(total_laid_off) as total_off
from layoffs2
group by company
order by total_off desc
limit 5;

-- Date ranges between company layoffs
select company, 
min(`date`) as min_date,
max(`date`) as max_date,
datediff(max(`date`), min(`date`)) as Days_of_layoff
from layoffs2
group by company
order by Days_of_layoff desc;

-- Industries with the most layoffs
select industry, sum(total_laid_off) as layoff_total
from layoffs2
group by industry
order by layoff_total desc;

-- Country with the highest employee laidoff
select country, sum(total_laid_off) as Total_laidoff
from layoffs2
group by country
order by 2 desc;

-- Year with the highest layoffs 
select year(`date`) as layoff_year, 
		sum(total_laid_off) as layoff_total
from layoffs2
where year(`date`) is not null
group by year(`date`)
order by 2 desc;

-- Stage of company layoffs 
select company, stage, sum(total_laid_off) as total_off
from layoffs2
group by company, stage
order by 3 desc;

-- Months of the year with the total employee layoffs
select year(`date`) as Years, substring(monthname(`date`),1,3)  as Months,
sum(total_laid_off) as Total_off
from layoffs2
where substring(monthname(`date`),1,3) is not null
group by Months, Years
order by Total_off desc;

-- Rolling sum of layoffs 
with Rolling_total as
(
select year(`date`) as Years, monthname(`date`) as Months,
sum(total_laid_off) as Total_off
from layoffs2
where monthname(`date`) is not null
group by Years, Months
order by Total_off desc
)
select Years, Months, sum(Total_off) as total_off,
sum(Total_off) over(order by Months) as rolling_total
from Rolling_total
group by Years, Months
order by Years asc;

-- Layoffs by each company per year
select company, year(`date`) as `Year`, 
sum(total_laid_off) as Total_off
from layoffs2
group by company, year(`date`)
order by Total_off desc;

-- Rank years with the most company layoffs
with company_year as
(
select company, year(`date`) as `Year`, 
sum(total_laid_off) as Total_off
from layoffs2
group by company, year(`date`)
order by Total_off desc
), 
company_year_rank as
(
select *, 
dense_rank() over(partition by `Year` order by Total_off desc) as Ranking
from company_year
where `Year` is not null
)
select *
from company_year_rank
where ranking <= 5;

-- Rank months with the most industry layoffs
with industry_month as
(
select industry, monthname(`date`) as `Month`, 
sum(total_laid_off) as Total_off
from layoffs2
group by industry, monthname(`date`)
order by Total_off desc
), 
industry_month_rank as
(
select *, 
dense_rank() over(partition by `Month` order by Total_off desc) as Ranking
from industry_month
where `Month` is not null
)
select *
from industry_month_rank
where ranking <= 5;