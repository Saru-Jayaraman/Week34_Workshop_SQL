# SQL Join exercise
#
use world;
#
# 1: Get the cities with a name starting with ping sorted by their population with the least populated cities first
select Name from city where name like "ping%" and population order by population;

#
# 2: Get the cities with a name starting with ran sorted by their population with the most populated cities first
select Name from city where name like "ran%" and population order by population desc;

#
# 3: Count all cities
select count(*) from city;

#
# 4: Get the average population of all cities
select avg(population) from city;

#
# 5: Get the biggest population found in any of the cities
select max(population) from city;

#
# 6: Get the smallest population found in any of the cities
select min(population) from city;

#
# 7: Sum the population of all cities with a population below 10000
select sum(population) from city where population < 10000;

#
# 8: Count the cities with the countrycodes MOZ and VNM
select count(*) from city where countrycode in ("MOZ","VNM");

#
# 9: Get individual count of cities for the countrycodes MOZ and VNM
select countrycode, count(*) from city where countrycode in ("MOZ","VNM") group by countrycode;

#
# 10: Get average population of cities in MOZ and VNM
select countrycode, avg(population) from city where countrycode in ("MOZ","VNM") group by countrycode;

#
# 11: Get the countrycodes with more than 200 cities
select countrycode, count(name) citiescount from city group by countrycode having citiescount > 200;

#
# 12: Get the countrycodes with more than 200 cities ordered by city count
select countrycode, count(name) citiescount from city group by countrycode having citiescount > 200 order by citiescount;

#
# 13: What language(s) is spoken in the city with a population between 400 and 500 ?
select t1.language from countrylanguage t1 inner join city t2 on t1.countrycode = t2.countrycode and t2.population between 400 and 500;
-- (OR)
select language from countrylanguage inner join city using(countrycode) where population between 400 and 500;

#
# 14: What are the name(s) of the cities with a population between 500 and 600 people and the language(s) spoken in them
select t2.name, t1.language from countrylanguage t1 inner join city t2 on t1.countrycode = t2.countrycode and t2.population between 500 and 600;
-- (OR)
select name, language from countrylanguage inner join city using(countrycode) where population between 500 and 600;

#
# 15: What names of the cities are in the same country as the city with a population of 122199 (including the that city itself)
select * from city where population = 122199;-- NorrkÃ¶ping
select name from city where countrycode in (select countrycode from city where population = 122199);
-- (OR)
select t2.name from city t1, city t2 where t1.population = 122199 and t1.countrycode = t2.countrycode;

#
# 16: What names of the cities are in the same country as the city with a population of 122199 (excluding the that city itself)
select name from city where countrycode in (select countrycode from city where population = 122199) and 
name not in (select name from city where population = 122199);
-- (OR)
select t2.name from city t1, city t2 where t1.population = 122199 and t1.countrycode = t2.countrycode and t1.name != t2.name;
-- (OR)
select t2.name from city t1, city t2 where t1.population = 122199 and t1.countrycode = t2.countrycode and t2.population <> 122199;

#
# 17: What are the city names in the country where Luanda is capital?
select name from city where countrycode in (select code from country where capital in (select id from city where name = "Luanda"));
-- (OR) 
select t3.name from city t1, country t2, city t3 where t1.name = "Luanda" and t1.id = t2.capital and t2.code = t3.countrycode;

#
# 18: What are the names of the capital cities in countries in the same region as the city named Yaren
select name from city where id in (select capital from country where region in (select region from country where capital in 
(select id from city where name = "Yaren")));
-- (OR)
select t4.name from city t1, country t2, country t3, city t4 where t1.name = "Yaren" and t1.id = t2.capital and t2.region = t3.region and t3.capital = t4.id;

#
# 19: What unique languages are spoken in the countries in the same region as the city named Riga
select distinct(language) from countrylanguage where countrycode in (select code from country where region in 
(select region from country where code in (select countrycode from city where name = "Riga")));
-- (OR)
select distinct(t4.language) from city t1, country t2, country t3, countrylanguage t4 where t1.name = "Riga" and 
t1.countrycode = t2.code and t2.region = t3.region and t3.code = t4.countrycode;

#
# 20: Get the name of the most populous city
select name, population from city where population in (select max(population) from city);