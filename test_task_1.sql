-- В таблицах в скрытых ячейках преведены данные по одному из срезу рыночного аудита ЛП.
-- Необходимо написать запросы на любом SQL языке и вывести результаты, которые помогут ...

-- 1. Определить Топ 3 EphMra4 категории на рынке CMC_Total по объёму в 2023 году в розничном сегменте 
-- 2. Вывести список продуктов Oncology_Total, объём которых привысил 7000уп за 2023 год
-- 3. Определить месяц пиковых продаж в рублях в 2023 году в ретейл сегменте продукта TENORIC

-- 1. Для вывода топ-3 категорий можно использовать такой запрос:
-- по количеству препаратов в категории:	

select eph_mra_4, count(p.product_key) as total	
from product p join	
(select product_key from fact f 	
join channel c on f.channel_key = c.channel_key  	
where c.group_channel = 'Retail') as sub_1 	
on sub_1.product_key = p.product_key	
join market_product mp on p.product_key = mp.product_key 	
join market m on mp.market_key = m.market_key 	
where market_name = 'CMC_Total'	
group by eph_mra_4	
order by total desc	
limit 3	
	
-- по объему продаж категории:	

select eph_mra_4, sum(subq.sales) as total	
from product p join	
(select f.product_key, sum(qty) as sales from fact f 	
join channel c on f.channel_key = c.channel_key  	
where c.group_channel = 'Non-retail'	
group by f.product_key) as subq	
on subq.product_key = p.product_key	
join market_product mp on p.product_key = mp.product_key 	
join market m on mp.market_key = m.market_key 	
where market_name = 'CMC_Total'	
group by eph_mra_4	
order by total desc	
limit 3	
	
-- Из ваших данных оба запроса ничего не возвращает, так как в таблице fact отсутствуют channel_keys - 7, 17 и 19, которые соответсвуют категории – Retail.	
-- Если выбрать Non-retail, то запрос возвращает топ-3 категорий по количеству препаратов	
--            eph_mra4	                total
-- C09A0 - ACE INHIBITORS PLAIN	         207
-- C07A0 - BETA BLOCKING AGENT PLAIN	 193
-- C08A0 - CALCIUM ANTAGONISTS PLAIN	 133
	
-- И по по объему продаж	
--            eph_mra4	                total
-- C09A0 - ACE INHIBITORS PLAIN	        142635
-- C07A0 - BETA BLOCKING AGENT PLAIN    104246
-- A10J1 - BIGUANIDE A-DIABS PLAIN	44362
	
-- 2. Для вывода топ-позиций можно использовать такой запрос:	

select trade_name	
from (select p.trade_name, sum(qty) as total from fact f	
join product p on f.product_key = p.product_key	
join market_product mp on p.product_key = mp.product_key	
join market m on mp.market_key = m.market_key	
where m.market_name = 'Oncology_Total'	
group by p.trade_name	
order by total desc) as sub_1	
where total > 7000	
	
-- Вывод:	
--    trade_name	
-- METHOTREXATE-EBEWE	
	
-- 3) Для определения месяца пиковых продаж препарата Тенорик можно использовать такой запрос:	

select substring(date_key, 5, 2) as month, sum(trd_lc) as total	
from fact f 	
join product p on f.product_key = p.product_key 	
where trade_name = 'TENORIC'	
group by month	
order by total desc	
limit 1	
	
-- Вывод:	
-- month	   total
--   3	         1174118.13
