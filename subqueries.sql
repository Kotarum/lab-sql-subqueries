-- 1. How many copies of the film "Hunchback Impossible" exist in the inventory system?
SELECT COUNT(*) AS number_of_copies
FROM inventory
JOIN film ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

-- 2. List all films whose length is longer than the average of all the films.
SELECT title, length
FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 3. Use subqueries to display all actors who appear in the film "Alone Trip".
SELECT actor.first_name, actor.last_name
FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
WHERE film_actor.film_id = (
    SELECT film_id
    FROM film
    WHERE title = 'Alone Trip'
);

-- 4. Identify all movies categorized as family films for a promotion.
SELECT film.title
FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
WHERE category.name = 'Family';

-- 5. Get name and email from customers from Canada using subqueries and joins.
-- Using Subqueries:
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
WHERE address.city_id IN (
    SELECT city_id
    FROM city
    WHERE country_id = (
        SELECT country_id
        FROM country
        WHERE country = 'Canada'
    )
);
-- Using Joins:
SELECT customer.first_name, customer.last_name, customer.email
FROM customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- 6. Which are films starred by the most prolific actor?
SELECT film.title
FROM film
JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id = (
    SELECT actor_id
    FROM film_actor
    GROUP BY actor_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 7. Films rented by the most profitable customer.
SELECT film.title
FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
WHERE rental.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);

-- 8. Get the `customer_id` and the `total_amount_spent` of those clients who spent more than the average of the `total_amount` spent by each client.
SELECT customer_id, SUM(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
HAVING total_amount_spent > (
    SELECT AVG(total_amount)
    FROM (
        SELECT SUM(amount) AS total_amount
        FROM payment
        GROUP BY customer_id
    ) AS subquery
);