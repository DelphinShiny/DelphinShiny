select * from project.velib;
select * from project.velib_nocle;

 -------- count of stations based on status
 select status, count(station_id) from project.velib_nocle group by status;

------count of stations in city and commune
select city, count(station_id) as no_stations,count(total_terminals) as capacity 
from project.velib_nocle where city is not null
group by city order by 2 desc;
select commune, count(station_id) as no_stations,count(total_terminals) as capacity 
from project.velib_nocle where commune is not null
group by commune order by 2 desc;

-------selecting date,mechanical bikes and electrical bikes
select year(opening_date) as ,count(mechanical_bikes_available) as mechanic_velib,
count(electric_bikes_available) as electric_velib from project.velib
group by year order by year asc;

------
with velib_france 
(station_id,Station_name,opening_date,status,total_bikes_available,city,commune) as
(select vn.station_id,vn.Station_name,v.opening_date,
Vn.status,(v.mechanical_bikes_available+v.electric_bikes_available) 
as total_bikes_available,vn.city,vn.commune
from velib_nocle vn join velib v 
on vn.station_id=v.station_id
where vn.status is not null)
select *,(total_terminals-total_bikes_available) 
as Wired_unavailable from Velib_france


--creating stored procedures to check the no of digits in station id and 
--the starting digits of the id to pass and segregate the city and commune
--instead of writing a long code...passing inputs and segregating it with stored procedure saves memory

delimiter $$
create procedure project.update_city(in no_digits int, in starts_with int, in update_with varchar(30))
begin 
update project.velib
set city = update_with
where left(stationcode,2) = starts_with and length(stationcode) = no_digits;
end $$

delimiter $$
create procedure project.update_commune(in starts_with int, in update_with varchar(30))
begin 
update project.velib
set commune = update_with
where left(stationcode,2) = starts_with and length(stationcode) = no_digits;
end $$