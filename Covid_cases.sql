CREATE TABLE covidvaccines (
iso_code text,
	continent text,
	location text,
	date date,
	new_tests float,
	total_tests float,
	total_tests_per_thousand float,
	new_tests_per_thousand float,
	new_tests_smoothed float,
	new_tests_smoothed_per_thousand float,
	positive_rate float,
	tests_per_case float,
	tests_units text,
	total_vaccinations float,
	people_vaccinated float,
	people_fully_vaccinated float,
	total_boosters float,
	new_vaccinations float,
	new_vaccinations_smoothed float,
	total_vaccinations_per_hundred float,
	people_vaccinated_per_hundred float,
	people_fully_vaccinated_per_hundred float,
	total_boosters_per_hundred float,
	new_vaccinations_smoothed_per_million float,
	new_people_vaccinated_smoothed float,
	new_people_vaccinated_smoothed_per_hundred float,
	stringency_index float,
	population_density float,
	median_age float,
	aged_65_older float,
	aged_70_older float,
	gdp_per_capita float,
	extreme_poverty float,
	cardiovasc_death_rate float,
	diabetes_prevalence float,
	female_smokers float,
	male_smokers float,
	handwashing_facilities float,
	hospital_beds_per_thousand float,
	life_expectancy float,
	human_development_index float,
	excess_mortality_cumulative_absolute float,
	excess_mortality_cumulative float,
	excess_mortality float,
	excess_mortality_cumulative_per_million float
);

COPY covidvaccines
FROM '\Users\Public\SQL FILES\Covidvaccines.csv'
DELIMITER ',' csv
HEADER;

CREATE TABLE coviddeaths(
iso_code text,
	continent text,
	location text,
	date date,
	population float,
	total_cases float,
	new_cases float,
	new_cases_smoothed float,
	total_deaths float,
	new_deaths float,
	new_deaths_smoothed float,
	total_cases_per_million float,
	new_cases_per_million float,
	new_cases_smoothed_per_million float,
	total_deaths_per_million float,
	new_deaths_per_million float,
	new_deaths_smoothed_per_million float,
	reproduction_rate float,
	icu_patients float,
	icu_patients_per_million float,
	hosp_patients float,
	hosp_patients_per_million float,
	weekly_icu_admissions float,
	weekly_icu_admissions_per_million float,
	weekly_hosp_admissions float,
	weekly_hosp_admissions_per_million float
);

COPY coviddeaths
FROM '\Users\Public\SQL FILES\Coviddeaths.csv'
DELIMITER ',' csv
HEADER;

--total_cases vs total_deaths by location

SELECT location, date, total_cases AS total_cases, total_deaths AS total_deaths,
ROUND(CAST((total_deaths/total_cases)*100 AS NUMERIC),2) AS death_percentage
FROM coviddeaths
ORDER BY 1,2;

-- we can find continents in our results above to filter that, we need to specify of WHERE Claus

SELECT location, date, total_cases AS total_cases, total_deaths AS total_deaths,
ROUND(CAST((total_deaths/total_cases)*100 AS NUMERIC),2) AS death_percentage
FROM coviddeaths
WHERE continent is NOT NULL
ORDER BY 1,2;

--total_cases vs population

SELECT location, date, total_cases, population, 
ROUND(CAST((total_cases/population)*100 AS NUMERIC),2) AS perentage_of_population_infected
FROM coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;

--what country has the highest infection rate compared to population

SELECT location, population, MAX(total_cases)AS cases, 
ROUND(CAST(MAX(total_cases/population)*100 AS NUMERIC),2) AS infection_rate
FROM coviddeaths
WHERE continent IS NOT NULL AND location IS NOT NULL
GROUP BY 1,2
ORDER BY 3 DESC;

--death rate per population

SELECT location, population, MAX(total_deaths)AS deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1,2
ORDER BY 3 DESC;

--continents with the highest death counts

SELECT continent, MAX(population)AS total_population, MAX(total_deaths)AS deaths
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY 1
ORDER BY 3 DESC;

--world cases

SELECT *
FROM coviddeaths
JOIN covidvaccines
ON coviddeaths.location = covidvaccines.location
AND coviddeaths.date = covidvaccines.date;

--total population vaccinated

SELECT coviddeaths.location, coviddeaths.date, coviddeaths.population, 
covidvaccines.total_vaccinations
FROM coviddeaths
JOIN covidvaccines
ON coviddeaths.location = covidvaccines.location
AND coviddeaths.date = covidvaccines.date
WHERE coviddeaths.continent IS NOT NULL
ORDER BY 1;

--focus on Nigeria
--total cases vs death rate 

SELECT location, population, MAX(total_cases)AS cases, MAX(total_deaths) AS deaths,
ROUND(CAST((MAX(total_deaths)/MAX(total_cases))*100 AS NUMERIC),2) AS death_percentage
FROM coviddeaths
WHERE location = 'Nigeria'
GROUP BY 1,2;

--total_cases vs population

SELECT location, population, MAX(total_cases),
ROUND(CAST((MAX(total_cases)/population)*100 AS NUMERIC),2) AS perentage_of_population_infected
FROM coviddeaths
WHERE location = 'Nigeria'
GROUP BY 1,2;

--total population vaccinated

SELECT coviddeaths.location, coviddeaths.date, coviddeaths.population, 
covidvaccines.total_vaccinations
FROM coviddeaths
JOIN covidvaccines
ON coviddeaths.location = covidvaccines.location
AND coviddeaths.date = covidvaccines.date
WHERE coviddeaths.location = 'Nigeria';