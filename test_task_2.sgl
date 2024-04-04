-- Что из этого датасета получим путём выполнения запроса:

select trade_name from 
(select trade_name,qty,row_number() over (order by qty desc) ov from 
(select p.trade_name,sum(qty) as qty from dw_fact f
inner join dw_product p on f.product_key = p.product_key
where substring(date_key,5,2)='09'
group by 1
order by 2 desc)) where ov >2 and ov<6

-- Необходимо объяснить результат и бизнес-значение этого запроса. Как его можно оптимизировать?

-- первый запрос - возвращает список продаж по каждому препарату за сентябрь по убыванию

select p.trade_name, sum(qty) as qty from fact f
inner join product p on f.product_key = p.product_key
where substring(date_key, 5, 2)='09'
group by 1
order by 2 desc

-- второй запрос - возвращает таблицу со добавлением столбца рейтинга в предыдущую таблицу

select trade_name, qty, row_number() over(order by qty desc) as ov
from (select p.trade_name, sum(qty) as qty 
from fact f inner join product p on
f.product_key = p.product_key 
where substring(date_key, 5, 2) = '09'
group by 1
order by 2) as subq_1

-- общий запрос возвращает список препаратов с 3 по 5 место в рейтинге продаж за сентябрь 

select trade_name 
from (select trade_name, qty, row_number() over (order by qty desc) ov 
from (select p.trade_name, sum(qty) as qty from fact f
inner join product p on f.product_key = p.product_key
where substring(date_key, 5, 2)='09'
group by 1
order by 2 desc) as subq_1) as subs_2 where ov >2 and ov<6

-- оптимизировать скрипт можно за счет уменьшения количества вложенных запросов:

select trade_name
from (select p.trade_name, sum(qty), row_number() over(order by sum(qty) desc) as rating
from fact f inner join product p on f.product_key = p.product_key 
where substring(date_key, 5, 2) = '09'
group by p.trade_name) as subq
where rating between 3 and 5

-- бизнес-цель вывода препаратов занимающих места с 3-5 в продажах за сентябрь мне не понятна
