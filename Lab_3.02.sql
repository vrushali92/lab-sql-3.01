use sakila;

-- 1. How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT count(*)
FROM film as f
inner join inventory as i
on f.film_id = i.film_id
and f.title = "Hunchback Impossible";

-- Answer: 6

-- 2. List all films whose length is longer than the average of all the films.

Select AVG(length)
FROM film;

Select *
FROM film
where length > (
	Select AVG(length)
	From film
)
ORDER BY length;

-- Answer: 489 film have duration more than the average.

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.

Select film_id 
From film
where title = "Alone Trip";

Select actor_id
from film_actor
where film_id = (
	Select film_id 
	From film
	where title = "Alone Trip"
);

-- Final query:

Select first_name, last_name
From actor
where actor_id in (
	Select actor_id
	from film_actor
	where film_id = (
			Select film_id 
			From film
			where title = "Alone Trip"
		)
);

-- Answer: 8 actors name.

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

Select category_id
from category
where name = "Family";

Select film_id
from film_category
where category_id = (
		Select category_id
		from category
		where name = "Family"
);

-- Final query:

Select * 
from film
where film_id in (
			Select film_id
			from film_category
			where category_id = (
						Select category_id
						from category
						where name = "Family"
		)
)
order by film_id;

-- Answer: 69 family movies

-- 5. Get name and email from customers from Canada using subqueries. Do the same with joins. 
-- Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.

-- Customer -> Address -> City -> Country

-- INNER JOIN

Select ct.country_id, cy.city_id, c.address_id, c.first_name, c.last_name, c.email, ct.country
From customer as c
inner join address as a
on c.address_id = a.address_id
inner join city as cy
on cy.city_id = a.city_id
inner join country as ct
on ct.country_id = cy.country_id
where ct.country = "Canada";

-- SUBQUERY

SELECT first_name, last_name, email
FROM customer
WHERE address_id IN (SELECT address_id 
                    FROM address
                    WHERE city_id IN (SELECT city_id
                                      FROM city
                                      WHERE country_id IN (SELECT country_id
                                                          FROM country
                                                          WHERE country = 'Canada')));



-- 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
-- First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.

-- Step 1:
Select actor_id, count(film_id) as total_films
from film_actor
group by actor_id
order by total_films desc
limit 1;

-- Step 2:

Select film_id 
From film_actor
where actor_id = (
		Select actor_id
		from film_actor
		group by actor_id
		order by count(film_id) desc
		limit 1
);

-- Query 1: 
Select film_id, title
From film
where film_id in (

				Select film_id 
				From film_actor
				where actor_id = (
							Select actor_id
                            From actor
                            where actor_id = (
                            
								Select actor_id
								from film_actor
								group by actor_id
								order by count(film_id) desc
								limit 1
                            ) 
				) 
);

-- Query 2:

SELECT film.film_id, film.title, a.actor_id, a.first_name, a.last_name
FROM film_actor as fa
LEFT JOIN film 
USING (film_id)
inner join actor as a
on a.actor_id = fa.actor_id
WHERE fa.actor_id = (SELECT actor_id
     FROM (SELECT actor_id, COUNT(film_id)
       FROM film_actor
       GROUP BY actor_id
       ORDER BY COUNT(film_id)DESC
                            LIMIT 1) sub1); 


-- Answer: Actor id = 107 has acted in 42 films.
-- Query 1 return film's info but query 2 return actor's info as well.



-- 7. Films rented by most profitable customer. 
-- You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.

Select customer_id, sum(amount) as total_amount
From payment
group by customer_id
order by total_amount desc
limit 1;

-- Final query:

SELECT title
FROM film
WHERE film_id IN (SELECT film_id
                 FROM inventory_rental
                 WHERE rental_id IN (SELECT rental_id
                                     FROM payment
                                     WHERE customer_id = (
											Select customer_id
											From payment
											group by customer_id
											order by sum(amount) desc
											limit 1
                                     )));

-- Answer: 44 films


-- 8. Customers who spent more than the average payments.

-- Step 1:
Select customer_id, sum(amount)
From payment
group by customer_id;

-- Step 2:

Select customer_id
from payment
group by customer_id
having sum(amount) > (
				Select avg(sum)
				From (
						Select sum(amount) as sum
						From payment
						group by (customer_id)
						)sub1
);

-- Final query:
Select first_name, last_name
From customer
where customer_id in (
			Select customer_id
			from payment
			group by customer_id
			having sum(amount) > (
							Select avg(sum)
							From (
								Select sum(amount) as sum
								From payment
								group by (customer_id)
								)sub1
)
)

-- Answer: 285 customers spent more than average.





