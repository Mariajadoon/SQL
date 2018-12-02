USE sakila
SELECT first_name FROM actor;
SELECT last_name FROM actor;


SELECT 
	UPPER(CONCAT(first_name, ' ', last_name)) AS `Actor Name`
FROM actor;

SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "Joe";

SELECT * FROM actor 
WHERE last_name LIKE '%GEN%';

SELECT * FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;


SELECT country_id, country 
FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh','China');

ALTER TABLE actor
ADD COLUMN description BLOB;

ALTER TABLE actor
DROP COLUMN description;

SELECT last_name,
  (
    SELECT COUNT(*)
    FROM actor
    WHERE last_name = table_alias.last_name
  ) AS count
FROM actor AS table_alias;


-- 4b
SELECT last_name, COUNT(last_name) AS "Last_name count"
FROM actor
GROUP BY last_name
HAVING `Last_name count` >= 2;



UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";

-- 4d

SHOW CREATE TABLE address;


SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;

SELECT staff.first_name, staff.last_name, payment.amount, payment.payment_date
FROM staff
INNER JOIN payment ON
staff.staff_id = payment.staff_id
WHERE payment_date LIKE '2005-08%';

-- 6c

SELECT f.title, COUNT(fa.actor_id) AS "actors"
FROM film AS f
INNER JOIN film_actor AS fa
ON fa.film_id = f.film_id
GROUP BY f.title
ORDER BY actors DESC;


SELECT COUNT(i.inventory_id) AS "number of copies", f.title 
FROM inventory AS i
INNER JOIN film as f 
ON i.film_id = f.film_id
WHERE title = "Hunchback Impossible"
GROUP BY title;


SELECT SUM(p.amount) AS "total payment", c.first_name, c.last_name 
FROM payment AS p
INNER JOIN customer as c 
ON p.customer_id = c.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name;


SELECT title 
FROM film
WHERE title LIKE 'K%' 
OR title LIKE 'Q%'
AND language_id IN 
	(
		SELECT language_id 
        FROM language 
        WHERE name = 'English'
        );
        
SELECT first_name, last_name
FROM actor
WHERE actor_id in
	(
		SELECT actor_id 
		FROM film_actor
		WHERE film_id IN
			(
			SELECT film_id
			FROM film
			WHERE title = "Alone Trip"
			)
		);
-- 7c names and email addresses of all Canadian customers
SELECT c.first_name, c.last_name, c.email, country.country
FROM customer AS c
INNER JOIN address ON
c.address_id = address.address_id
INNER JOIN city ON
city.city_id = address.address_id
INNER JOIN country ON
city.country_id = country.country_id
WHERE country = "Canada";

-- 7d Identify all movies categorized as family films.
SELECT film.title, category.name
FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
INNER JOIN category 
ON category.category_id = film_category.category_id
WHERE name LIKE '%family%';


-- 7e most frequently rented movies in descending order

SELECT COUNT(rental.rental_id) AS 'rental_count', film.title
FROM film, inventory, rental
WHERE
film.film_id = inventory.film_id AND inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY rental_count DESC;


-- 7f how much business, in dollars, each store brought in
SELECT store.store_id, payment.amount
FROM store
INNER JOIN payment 
ON payment.

-- 7g each store its store ID, city, and country
SELECT store.store_id, city.city, country.country
FROM store
INNER JOIN address ON
store.address_id = address.address_id
INNER JOIN city ON
city.city_id = address.city_id
INNER JOIN country ON
city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON inventory.film_id = film_category.film_id
INNER JOIN rental
ON rental.inventory_id = inventory. inventory_id
INNER JOIN payment 
ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY category.name DESC LIMIT 5;

-- 8a Use the solution from the problem above to create a view. 
CREATE VIEW `Top Genres` AS
SELECT category.name, SUM(payment.amount)
FROM category
INNER JOIN film_category
ON category.category_id = film_category.category_id
INNER JOIN inventory
ON inventory.film_id = film_category.film_id
INNER JOIN rental
ON rental.inventory_id = inventory. inventory_id
INNER JOIN payment 
ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY category.name DESC LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM `Top Genres`;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW `Top Genres`;

