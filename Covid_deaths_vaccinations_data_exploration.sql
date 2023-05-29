select * from Project_Portfolio..CovidDeaths$ where continent is not null;
Select * from Project_Portfolio..CovidVaccinations$;

select location,date,total_cases,new_cases,total_deaths,population from Project_Portfolio..CovidDeaths$ where continent is not null
order by 1,2;

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as 'Death_Percentage' from Project_Portfolio..CovidDeaths$ 
 where location='India' order by 1,2;

 Select location,date,population,total_cases, (total_cases/population)*100 as 'Infected_Population_Percent' from Project_Portfolio..CovidDeaths$ 
 where continent is not null order by 1,2;
 
 select location,population,max(total_cases) as 'Highest_Infection_count', max((total_cases/population)*100) as 'Infected_Population_Percent'
 from Project_Portfolio..CovidDeaths$ where continent is not null group by location,population order by Infected_Population_Percent desc;

  select location,max(cast(total_deaths as int)) as 'Total_death_count' from Project_Portfolio..CovidDeaths$   where continent is not null group by location
 order by Total_death_count desc;

 select d.continent,d.location,d.date,d.population,v.new_vaccinations from Project_Portfolio..CovidDeaths$ d join Project_Portfolio..CovidVaccinations$ v
 on d.location=v.location and d.date=v.date where d.continent is not null order by 2,3;

 select d.continent,d.location,d.date,d.population,v.new_vaccinations, 
 sum(cast(v.new_vaccinations as int)) over (partition by d.location order by d.location,d.date) as 'Rolling_vaccinated'
 from Project_Portfolio..CovidDeaths$ d join Project_Portfolio..CovidVaccinations$ v
 on d.location=v.location and d.date=v.date where d.continent is not null order by 2,3;

 With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, Rolling_vaccinated)
as
(
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as Rolling_vaccinated

From Project_Portfolio..CovidDeaths$ d
Join Project_Portfolio..CovidVaccinations$ v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 
--order by 2,3
)
Select *, (Rolling_vaccinated/Population)*100
From PopvsVac

DROP Table if exists PopulationVaccinatedPercent
Create Table PopulationVaccinatedPercent
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
Rolling_vaccinated numeric
)

Insert into PopulationVaccinatedPercent
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as Rolling_vaccinated

From Project_Portfolio..CovidDeaths$ d
Join Project_Portfolio..CovidVaccinations$ v
	On d.location = v.location
	and d.date = v.date


Select *, (Rolling_vaccinated/Population)*100
From PopulationVaccinatedPercent


Create View PercentPopulationVaccinated as
Select d.continent, d.location, d.date, d.population, v.new_vaccinations
, SUM(CONVERT(int,v.new_vaccinations)) OVER (Partition by d.Location Order by d.location, d.Date) as RollingPeopleVaccinated
From Project_Portfolio..CovidDeaths$ d
Join Project_Portfolio..CovidVaccinations$ v
	On d.location = v.location
	and d.date = v.date
where d.continent is not null 

select * from PercentPopulationVaccinated;