SELECT *
FROM Accident_Info AI
JOIN Vehicle_Info VI
ON AI.Accident_Index= VI.Accident_Index


select year, sum(number_of_casualties)summ
from Accident_Info
group by year
order by summ desc


select sum(number_of_casualties)summ
from Accident_Info
order by summ desc ---1154972

--How many people are killed or injured on our roads?

select road_class, sum(number_of_casualties)summ
from Accident_Information$
group by road_class
order by summ desc


select  Age_Band_of_Driver, Sex_of_Driver,sum(number_of_casualties)summ
from Accident_Information$ AI
JOIN Vehicle_Information$ VI
ON AI.Accident_Index= VI.Accident_Index
group by  Age_Band_of_Driver, Sex_of_Driver
order by summ desc


select sum(summ) su
from(
	select  distinct Sex_of_Driver, sum(number_of_casualties)summ
	from Accident_Info AI
	JOIN Vehicle_Info VI
	ON AI.Accident_Index= VI.Accident_Index
	group by Sex_of_Driver) sub ---8081553


--What are the fatality and casualty numbers by age and sex?

select distinct Sex_of_Driver, Age_Band_of_Driver, sum(number_of_casualties) over (partition by  Sex_of_Driver, Age_Band_of_Driver)cnt
from Accident_Info AI
JOIN Vehicle_Info VI
ON AI.Accident_Index= VI.Accident_Index
order by Sex_of_Driver, Age_Band_of_Driver



with T1 as
(select distinct Sex_of_Driver, Age_Band_of_Driver, sum(number_of_casualties) over (partition by  Sex_of_Driver, Age_Band_of_Driver)cnt
from Accident_Info AI
JOIN Vehicle_Info VI
ON AI.Accident_Index= VI.Accident_Index)
select sum(cnt)
from T1 ---8081553
order by Sex_of_Driver, Age_Band_of_Driver


--What are the reported road casualties by car brand?

select distinct make, count(Number_of_Casualties) cnt
from Accident_Info AI
JOIN Vehicle_Info VI
ON AI.Accident_Index= VI.Accident_Index
group by make
order by cnt desc

---Fetch the number of car models registered for each car brand

select distinct make, count(model)models
from Vehicle_Info
group by make
order by models desc


--On what types of roads do casualties mostly occur?

select *
from(
	select *, rank() over (order by Casualties desc) rnk
	from(
		select Road_Type, sum(Number_of_Casualties)Casualties
		from Accident_Info
		group by Road_Type)sub)sub2
where rnk=1

--What are the major contributory factors to accidents and how can the risk on these roads be reduced?

select Accident_Severity, count(Accident_Index) accident_count
from Accident_Info
where Road_Type= 'Single carriageway'
group by Accident_Severity
order by accident_count desc

select Day_of_Week, count(Accident_Index) accident_count
from Accident_Info
where Road_Type= 'Single carriageway'
group by Day_of_Week
order by accident_count desc ---Accidents happen mstly on Fridays

select Junction_Control, count(Accident_Index) accident_count
from Accident_Info
where Road_Type= 'Single carriageway'
group by Junction_Control
order by accident_count desc --traffic/junction controls are needed more on the roads

select [Pedestrian_Crossing-Physical_Facilities], count(Accident_Index) accident_count
from Accident_Info
where Road_Type= 'Single carriageway'
group by [Pedestrian_Crossing-Physical_Facilities]
order by accident_count desc
----more pedestrian crossing facilities should be constructed as it is indicated

select Road_Surface_Conditions, count(Accident_Index) accident_count
from Accident_Info
where Road_Type= 'Single carriageway'
group by Road_Surface_Conditions
order by accident_count desc
-----The highest number of accidents occur on dry roads
-----condition indication little care is taken when the surface condition is pleasant.


--How many people driving a vehicle for work purposes are involved in road crashes?

select Journey_Purpose_of_Driver ,count(AI.Accident_Index) accident_count
from Accident_Info AI
JOIN Vehicle_Info VI
ON AI.Accident_Index= VI.Accident_Index
where Journey_Purpose_of_Driver like '%work%'
group by Journey_Purpose_of_Driver
order by accident_count desc


--Do young drivers have a high accident rate?

select  distinct Age_Band_of_Driver, count(AI.Accident_Index)cnt
from Accident_Info AI
JOIN Vehicle_Info VI
ON AI.Accident_Index= VI.Accident_Index
group by  Age_Band_of_Driver order by cnt desc



--Which areas have the highest young car driver accident compared to the proportion of all car driver accident?


select age_group, Urban_or_Rural_Area, sum(cnt) summ
from(
	select Age_Band_of_Driver, Urban_or_Rural_Area, count(AI.accident_index) cnt,
		case when Age_Band_of_Driver in('0 - 5', '16 - 20', '21 - 25','26 - 35') then 'Young'
		when Age_Band_of_Driver in('36 - 45', '46 - 55', '56 - 65','66 - 75', 'over 75') then 'Old'
		end as age_group
	from Accident_Info AI
	JOIN Vehicle_Info VI
	ON AI.Accident_Index= VI.Accident_Index
	where Age_Band_of_Driver NOT IN ('unallocated', 'Data missing or out of range', '42309', '44840') and Urban_or_Rural_Area <> 'Unallocated'
	group by Age_Band_of_Driver, Urban_or_Rural_Area)sub
group by age_group, Urban_or_Rural_Area
order by age_group, Urban_or_Rural_Area




select Age_Band_of_Driver, Urban_or_Rural_Area, COUNT(AI.accident_index)cnt
from Accident_Info AI
JOIN Vehicle_Info VI
ON AI.Accident_Index= VI.Accident_Index
where Age_Band_of_Driver NOT IN ('unallocated', 'Data missing or out of range', '42309', '44840') and Urban_or_Rural_Area <> 'Unallocated'
group by Age_Band_of_Driver, Urban_or_Rural_Area
order by Age_Band_of_Driver, Urban_or_Rural_Area

--What can be done to reduce the number of accidents involving young drivers?
--Do older drivers have a higher collision rate compared to middle-aged drivers?
--Why do older drivers have collisions? And how do these contributory factors compare to all car drivers?
