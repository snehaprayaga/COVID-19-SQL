Select continent ,Max(cast(total_deaths as int)) as MAXDEATHS
From [Portfolio Project]..['COVID Deaths]
-- where location like '%states%'
Where continent is not null
Group by continent
order by MAXDEATHS desc


Select date, sum(new_cases)as totalcases, sum(cast(new_deaths as int)) as Totaldeaths, (sum(cast(new_deaths as int))/sum(cast(new_cases as int)))*100 as Deathpercentage
From [Portfolio Project]..['COVID Deaths]
-- where location like '%states%'
Where continent is not null
Group by date
order by 1,2

With PopVSVac( continent,location,date,population,new_vaccinations,rollingpeoplevaccinated)
as
(
Select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from [Portfolio Project]..['COVID Deaths] dea
Join [Portfolio Project]..['COVID DATA-VACCINATION$'] vac 
      on dea.location=vac.location 
      and dea.date = vac.date
WHERE dea.continent is not null
-- order by 2,3
)
select * ,(rollingpeoplevaccinated/population)*100
from PopVSVac;

drop table if exists #populationVaccinated
create table #populationVaccinated
(
  Continent nvarchar(255),
  Location nvarchar(255),
  Date datetime,
  Population numeric,
  New_vaccinations numeric,
  Rollingpeoplevaccinated numeric
  )

Insert into #populationVaccinated
Select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from [Portfolio Project]..['COVID Deaths] dea
Join [Portfolio Project]..['COVID DATA-VACCINATION$'] vac 
      on dea.location=vac.location 
      and dea.date = vac.date
-- WHERE dea.continent is not null

select *, (Rollingpeoplevaccinated/Population)*100
from #populationVaccinated


Create view PercentPolulationVaccinated as 
Select dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations,
SUM (Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location,dea.date) as rollingpeoplevaccinated
from [Portfolio Project]..['COVID Deaths] dea
Join [Portfolio Project]..['COVID DATA-VACCINATION$'] vac 
      on dea.location=vac.location 
      and dea.date = vac.date
WHERE dea.continent is not null