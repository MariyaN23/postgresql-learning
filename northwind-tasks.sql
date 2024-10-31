--1. Выбрать все записи заказов в которых наименование страны отгрузки начинается с 'U'
SELECT *
FROM orders
WHERE ship_country LIKE 'U%'

--2. Выбрать записи заказов (включить колонки идентификатора заказа, идентификатора заказчика, веса и страны отгузки),
-- которые должны быть отгружены в страны имя которых начинается с 'N', отсортировать по весу (по убыванию)
-- и вывести только первые 10 записей.
SELECT order_id, customer_id, freight, ship_country
FROM orders
WHERE ship_country LIKE 'N%'
ORDER BY freight DESC
LIMIT 10

--3. Выбрать записи работников (включить колонки имени, фамилии, телефона, региона) в которых регион неизвестен
SELECT first_name, last_name, home_phone, region
FROM employees
WHERE region IS NULL

--4. Подсчитать кол-во заказчиков регион которых известен
SELECT COUNT(company_name)
FROM customers
WHERE region IS NULL

--5. Подсчитать кол-во поставщиков в каждой из стран и отсортировать результаты группировки по убыванию кол-ва
SELECT country, COUNT(*)
FROM suppliers
GROUP BY country
ORDER BY COUNT(*) DESC

--6. Подсчитать суммарный вес заказов (в которых известен регион) по странам, затем отфильтровать по суммарному весу
-- (вывести только те записи где суммарный вес больше 2750) и отсортировать по убыванию суммарного веса.
SELECT SUM(freight)
FROM orders
WHERE ship_region IS NOT NULL
GROUP BY ship_country
HAVING SUM(freight) > 2750
ORDER BY SUM(freight) DESC

--7. Выбрать все уникальные страны заказчиков и поставщиков и отсортировать страны по возрастанию
SELECT country
FROM customers
UNION
SELECT country
FROM suppliers
ORDER BY country

--8. Выбрать такие страны в которых "зарегистированы" одновременно и заказчики и поставщики и работники.
SELECT country
FROM customers
INTERSECT
SELECT country
FROM suppliers
INTERSECT
SELECT country
FROM employees
ORDER BY country

--9. Выбрать такие страны в которых "зарегистированы" одновременно заказчики и поставщики,
-- но при этом в них не "зарегистрированы" работники.
-- 1. Выбрать все записи заказов в которых
-- наименование страны отгрузки начинается с 'U'
SELECT *
FROM orders
WHERE ship_country LIKE 'U%'

-- 2. Выбрать записи заказов (включить колонки идентификатора заказа,
-- идентификатора заказчика, веса и страны отгрузки),
-- которые должны быть отгружены в страны имя которых начинается с 'N',
-- отсортировать по весу (по убыванию) и вывести только первые 10 записей.
SELECT order_id, customer_id, freight, ship_country
FROM orders
WHERE ship_country LIKE 'N%'
ORDER BY freight DESC
    LIMIT 10

-- 3. Выбрать записи работников (включить колонки имени, фамилии,
-- телефона, региона) в которых регион неизвестен
SELECT first_name, last_name, home_phone, region
FROM employees
WHERE region IS NULL

-- 4. Подсчитать кол-во заказчиков регион которых известен
SELECT COUNT(*)
FROM customers
WHERE region IS NOT NULL

-- 5. Подсчитать кол-во поставщиков в каждой из стран и отсортировать
-- результаты группировки по убыванию кол-ва
SELECT country, COUNT(*)
FROM suppliers
GROUP BY country
ORDER BY COUNT(*) DESC

-- 6. Подсчитать суммарный вес заказов (в которых известен регион) по странам,
-- затем отфильтровать по суммарному весу (вывести только те записи
-- где суммарный вес больше 2750) и отсортировать по убыванию суммарного веса.
SELECT ship_country, SUM(freight)
FROM orders
WHERE ship_region IS NOT NULL
GROUP BY ship_country
HAVING SUM(freight) > 2750
ORDER BY SUM(freight) DESC

-- 7. Выбрать все уникальные страны заказчиков и поставщиков и отсортировать
-- страны по возрастанию
SELECT country
FROM customers
UNION
SELECT country
FROM suppliers
ORDER BY country

-- 8. Выбрать такие страны в которых "зарегистированы" одновременно
-- и заказчики и поставщики и работники.
SELECT country
FROM customers
INTERSECT
SELECT country
FROM suppliers
INTERSECT
SELECT country
FROM employees
ORDER BY country

-- 9. Выбрать такие страны в которых "зарегистированы" одновременно заказчики
-- и поставщики, но при этом в них не "зарегистрированы" работники.
SELECT country
FROM customers
INTERSECT
SELECT country
FROM suppliers
EXCEPT
SELECT country
FROM employees
ORDER BY country

-- JOIN
-- 1. Найти заказчиков и обслуживающих их заказы сотрудников таких, что и заказчики и сотрудники из города London,
-- а доставка идёт компанией Speedy Express. Вывести компанию заказчика и ФИО сотрудника.
SELECT customers.company_name, (employees.first_name, employees.last_name) AS employees_full_name
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN employees ON orders.employee_id = employees.employee_id
JOIN shippers ON orders.ship_via = shippers.shipper_id
WHERE customers.city = 'London' AND employees.city = 'London' AND shippers.company_name = 'Speedy Express'

--2. Найти активные (см. поле discontinued) продукты из категории Beverages и Seafood, которых в продаже менее
-- 20 единиц. Вывести наименование продуктов, кол-во единиц в продаже, имя контакта поставщика и его телефонный номер.
SELECT product_name, units_in_stock, contact_name, phone
FROM products
JOIN categories USING(category_id)
JOIN suppliers USING(supplier_id)
WHERE category_name IN ('Beverages', 'Seafood') AND discontinued != 1 AND units_in_stock < 20

--3. Найти заказчиков, не сделавших ни одного заказа. Вывести имя заказчика и order_id.
SELECT contact_name, order_id
FROM customers
LEFT JOIN orders USING(customer_id)
WHERE order_id IS NULL

--4. Переписать предыдущий запрос, использовав симметричный вид джойна (подсказка: речь о LEFT и RIGHT).
SELECT contact_name, order_id
FROM orders
RIGHT JOIN customers USING(customer_id)
WHERE order_id IS NULL

--Подзапросы
--1. Вывести продукты количество которых в продаже меньше самого малого среднего количества продуктов в деталях
-- заказов (группировка по product_id). Результирующая таблица должна иметь колонки product_name и units_in_stock.
SELECT product_name, units_in_stock
FROM products
WHERE units_in_stock < ALL(
    SELECT AVG(quantity)
    FROM order_details
    GROUP BY product_id
    )


--2. Напишите запрос, который выводит общую сумму фрахтов заказов для компаний-заказчиков для заказов, стоимость
-- фрахта которых больше или равна средней величине стоимости фрахта всех заказов, а также дата отгрузки заказа должна
-- находится во второй половине июля 1996 года. Результирующая таблица должна иметь колонки customer_id и freight_sum,
-- строки которой должны быть отсортированы по сумме фрахтов заказов.
SELECT customer_id, SUM(freight) AS freight_sum
FROM orders
WHERE freight >= (
    SELECT AVG(freight)
    FROM orders
)
  AND shipped_date BETWEEN '1996-07-16' AND '1996-07-31'
GROUP BY customer_id
ORDER BY freight_sum

--3. Напишите запрос, который выводит 3 заказа с наибольшей стоимостью, которые были созданы после 1 сентября 1997 года
-- включительно и были доставлены в страны Южной Америки. Общая стоимость рассчитывается как сумма стоимости деталей
-- заказа с учетом дисконта. Результирующая таблица должна иметь колонки customer_id, ship_country и order_price,
-- строки которой должны быть отсортированы по стоимости заказа в обратном порядке.
SELECT customer_id, ship_country, SUM(order_details.unit_price * order_details.quantity * (1 - order_details.discount)) AS order_price
FROM orders
JOIN order_details ON orders.order_id = order_details.order_id
WHERE orders.order_date >= '1997-09-01' AND orders.ship_country IN ('Argentina', 'Brazil', 'Venezuela')
GROUP BY orders.customer_id, orders.ship_country, orders.order_id
ORDER BY order_price DESC
LIMIT 3

--4. Вывести все товары (уникальные названия продуктов), которых заказано ровно 10 единиц
-- (конечно же, это можно решить и без подзапроса).
SELECT product_name
FROM products
WHERE product_id = ANY (
    SELECT product_id
    FROM order_details
    WHERE quantity = 10
)

SELECT DISTINCT product_name
FROM products
LEFT JOIN order_details USING(product_id)
WHERE order_details.quantity = 10