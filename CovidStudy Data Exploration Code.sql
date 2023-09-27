select*
From PortfolioProject..CovidDeaths$

---------

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
order by 1,2

---------

Select Location, date, total_cases, total_deaths, ((NULLIF(CONVERT(float, total_deaths), 0)) / (NULLIF(CONVERT(float, total_cases), 0)))*100 as DeathPercentaje
From PortfolioProject..CovidDeaths$
order by 1,2

---------

Select Location, date, total_cases, total_deaths, ((NULLIF(CONVERT(float, total_deaths), 0)) / (NULLIF(CONVERT(float, total_cases), 0)))*100 as DeathPercentaje
From PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1,2

---------

-- Looking at Total Cases vs Population
Select Location, date, total_cases, total_deaths, population, ((NULLIF(CONVERT(float, total_cases), 0)) / (NULLIF(CONVERT(float, population), 0)))*100 as CasesPercentaje
From PortfolioProject..CovidDeaths$
Where location like '%states%'
order by 1,2

---------

Select location, MAX((NULLIF(CONVERT(float,total_cases),0))) as HightestInfectionCount, population, ((MAX((NULLIF(CONVERT(float,total_cases),0))))/(MAX(population)))*100 as PercentPopulationInfected, MAX((NULLIF(CONVERT(float,total_cases),0))), MAX(population)
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by Location, population
Order by PercentPopulationInfected desc

---------

-- Showing Countries with Highest Death Count per Population

Select location, MAX((NULLIF(CONVERT(float,total_deaths),0))) as HightestDeathlyCount, population, ((MAX((NULLIF(CONVERT(float,total_deaths),0))))/(MAX(population)))*100 as PercentPopulationDeath
From PortfolioProject..CovidDeaths$
--Where location like '%states%'
Group by Location, population
Order by PercentPopulationDeath desc

---------

-- Showing Countries with Highest Death Count per Population

Select Location, continent, MAX(cast(Total_deaths as float)) as TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '$states$'
Where continent is not null
Group by Location, continent
order by TotalDeathCount desc

---------

-- Looking at Total Population vs Vaccinations
With PopvsVac (Continent, Location, Date, Population, New_Vaccionations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as RollingvsPopulation
From PopvsVac

----------

-- TEMP TABLE

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100 as RollingvsPopulation
From #PercentPopulationVaccinated

----------

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(float, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3


----------

Select*
From PercentPopulationVaccinated