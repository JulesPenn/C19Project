


#1
SELECT * 
FROM ProjectDatabase.CovidDeaths
order by 3,4; 

#2
SELECT * 
FROM ProjectDatabase.CovidVaccinations
order by 3,4; 

#3 
-- select data we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM ProjectDatabase.CovidDeaths
order by 1,2; 

#4
-- looking at total Cases vs Total Deaths 
-- shows the likelihood of dying if you're infected 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRate 
FROM ProjectDatabase.CovidDeaths
WHERE location like '%states%' 
order by 1,2; 

#5 
-- looking at total cases as a % of population
SELECT location, date,population, total_cases, (total_cases/population)*100 as CaseRate 
FROM ProjectDatabase.CovidDeaths
WHERE location like '%states%' 
order by 1,2; 

#6 
-- which countries have the highest infection rates as a % of population?

SELECT location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as TotalCaseRate
FROM ProjectDatabase.CovidDeaths
-- WHERE
group by  population, location
order by TotalCaseRate desc; 


#7 
-- which countries have the highest total deaths 
SELECT location, population, MAX(cast(total_deaths AS DECIMAL)) as TotalDeathCount
FROM ProjectDatabase.CovidDeaths
WHERE continent is NOT NULL
group by location, population
order by TotalDeathCount desc; 

#Error Code: 1055. Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'projectdatabase.CovidDeaths.population' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

-- Organized by continent 
SELECT continent, MAX(cast(total_deaths AS DECIMAL)) as TotalDeathCount
FROM ProjectDatabase.CovidDeaths
WHERE continent is NOT NULL
group by continent
order by TotalDeathCount desc
limit 1,10; 

-- 

SELECT location, MAX(cast(total_deaths AS DECIMAL)) as TotalDeathCount
FROM ProjectDatabase.CovidDeaths
WHERE continent is null
group by location
order by TotalDeathCount desc
; 

#8 
-- which countries have the highest death rates as a % of population 

#SELECT location, population, MAX(total_deaths) as TotalDeathCount, Max((total_deaths/population))*100 as TotalDeathRate
SELECT location, population, MAX(cast(total_deaths AS DECIMAL)) as TotalDeathCount, Max((total_deaths/population))*100 as TotalDeathRate
FROM ProjectDatabase.CovidDeaths
WHERE continent IS NOT NULL
group by  population, location
order by TotalDeathRate desc; 

#Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'int)) as HighestDeathCount, Max((total_deaths/population))*100 as TotalDeathRate' at line 1

#9
-- showing continents with the highest death count per population

SELECT continent, population, Max((total_deaths/population))*100 as TotalDeathRate
FROM ProjectDatabase.CovidDeaths
WHERE continent IS NOT NULL
group by  continent, population
order by TotalDeathRate desc; 

# Error Code: 1055. Expression #2 of SELECT list is not in GROUP BY clause and contains nonaggregated column 'projectdatabase.CovidDeaths.population' which is not functionally dependent on columns in GROUP BY clause; this is incompatible with sql_mode=only_full_group_by

#10 

-- global numbers 

SELECT date, SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 -- total_deaths, #(total_deaths/total_cases)*100 as DeathPercentage
From ProjectDatabase.CovidDeaths
where continent is not null 
group by date
order by 1,2; 







