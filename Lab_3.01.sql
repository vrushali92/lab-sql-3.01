use sakila;

-- Activity 1

-- 1. Drop column picture from staff.

SELECT *
FROM staff;

ALTER TABLE staff
DROP COLUMN picture;

-- 2. A new person is hired to help Jon. Her name is TAMMY SANDERS, and she is a customer. Update the database accordingly.

SELECT *
FROM customer
where first_name = "TAMMY";

INSERT INTO customer (store_id, first_name, last_name, email, address_id, active)
VALUES (2, "TAMMY", "SANDERS", "tammy.s@gmail.com", 79, 1);

UPDATE customer
SET last_name = lower(last_name)
where first_name = "TAMMY";

-- 3. Add rental for movie "Academy Dinosaur" by Charlotte Hunter from Mike Hillyer at Store 1. You can use current date for the rental_date column in the rental table. 
-- Hint: Check the columns in the table rental and see what information you would need to add there. You can query those pieces of information. 
-- For eg., you would notice that you need customer_id information as well. To get that you can use the following query:

select * from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER'; -- Customer Id = 130

SELECT * from rental;

SELECT * from inventory
where film_id = 1 and store_id = 1; -- 1,2,3,4 = Inventory_ids

Select * from film
where title = "Academy Dinosaur";

Select * from staff; -- 1: Mike Hillyner

INSERT INTO rental 
(rental_date, inventory_id, customer_id, staff_id)
VALUES (now(), 4, 130, 1);

SELECT * 
from rental
where customer_id = 130; -- rental_id: 16050 (the ones updated now)


-- Activity 2

-- 1. The language table can be deleted. As each id represents only one language. 
-- And in table film, the language id column can be substituted by language itself.

-- 2. original_language column in film table is empty. So the column can be deleted.

-- 3. manager_staff_id column in store table is unused. 
