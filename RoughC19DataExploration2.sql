SELECT * FROM ProjectDatabase.CovidVaccinations; 


# Looking at Total Population vs Vaccinations 

With PopVsVax (continent, location, date, population, new_vaccinations, RollingVaxNumber)
as ( 
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER (Partition by deaths.location order by deaths.location, deaths.date) as RollingVaxNumber
FROM ProjectDatabase.CovidVaccinations vax
JOIN ProjectDatabase.CovidDeaths deaths
	ON deaths.location = vax.location
   AND deaths.date = vax.date
WHERE deaths.continent != ''  
# order by 2,3
)
SELECT * , (RollingVaxNumber/population)*100
FROM PopVsVax; 
-- USE CTE ^^^^ 


-- TEMP TABLE 
DROP TABLE PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
( 
continent nvarchar(255), 
location nvarchar(255), 
Date datetime, 
population numeric, 
new_vaccinations numeric, 
RollingVaxNumber numeric
)
INSERT INTO PercentPopulationVaccinated 
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER (Partition by deaths.location order by deaths.location, deaths.date) as RollingVaxNumber
FROM ProjectDatabase.CovidVaccinations vax
JOIN ProjectDatabase.CovidDeaths deaths
	ON deaths.location = vax.location
   AND deaths.date = vax.date
WHERE deaths.continent != ''  
# order by 2,3
)
SELECT * , (RollingVaxNumber/population)*100
FROM PopVsVax; 


-- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS
USE ProjectDatabase; 
CREATE VIEW PercentPopulationVaccinated AS 
SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vax.new_vaccinations, 
SUM(vax.new_vaccinations) OVER (Partition by deaths.location order by deaths.location, deaths.date) as RollingVaxNumber
FROM ProjectDatabase.CovidVaccinations vax
JOIN ProjectDatabase.CovidDeaths deaths
	ON deaths.location = vax.location
   AND deaths.date = vax.date
WHERE deaths.continent != ''  
# order by 2,3
; 
