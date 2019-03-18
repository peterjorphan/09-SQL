/* 1a. Display the first and last names of all actors from the table `actor`. */ 
USE sakila;
SELECT first_name, last_name FROM actor;

/* 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`. */
SELECT concat(first_name, " ", last_name) AS 'Actor Name' FROM actor;

/* 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
What is one query would you use to obtain this information? */
SELECT actor_id, first_name, last_name FROM actor 
WHERE first_name='Joe';

/* 2b. Find all actors whose last name contain the letters `GEN`: */
SELECT actor_id, first_name, last_name FROM actor 
WHERE last_name LIKE '%GEN%';

/* 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order: */
SELECT actor_id, first_name, last_name FROM actor 
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

/* 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China: */
SELECT country_id, country FROM country 
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

/* 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
so create a column in the table `actor` named `description` and use the data type `BLOB` 
(Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).  */
ALTER TABLE actor 
ADD COLUMN description BLOB;

/* 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column. */
ALTER TABLE actor 
DROP COLUMN description;

/* 4a. List the last names of actors, as well as how many actors have that last name. */
SELECT last_name, COUNT(last_name) AS 'No of Actors' FROM ACTOR
GROUP BY last_name
ORDER BY COUNT(last_name) DESC;

/* 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors. */
SELECT last_name, COUNT(last_name) AS 'No of Actors' FROM ACTOR
GROUP BY last_name
HAVING COUNT(last_name) >= 2
ORDER BY COUNT(last_name) DESC;

/* 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record. */
UPDATE actor 
SET first_name='HARPO'
WHERE concat(first_name, " ", last_name)='GROUCHO WILLIAMS';

/* 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. 
It turns out that `GROUCHO` was the correct name after all! 
In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. */
UPDATE actor 
SET first_name='GROUCHO'
WHERE first_name='HARPO';

/* 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it? */
DESCRIBE address;







/* 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`: */
SELECT first_name, last_name, address FROM staff 
INNER JOIN address
ON staff.address_id=address.address_id;

/* 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`. */
SELECT first_name, last_name, SUM(amount) AS 'Total Amount' FROM staff 
INNER JOIN payment 
ON staff.staff_id=payment.staff_id
GROUP BY payment.staff_id;

/* 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join. */
SELECT film_actor.film_id, title, COUNT(actor_id) AS 'No of Actors' FROM film_actor 
INNER JOIN film 
ON film_actor.film_id=film.film_id 
GROUP BY film_id
ORDER by film_id;

/* 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system? */
SELECT film.film_id, title, COUNT(inventory_id) AS 'No of Copies' FROM inventory 
INNER JOIN film
ON inventory.film_id=film.film_id 
WHERE film.title='Hunchback Impossible';

/* 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name: */
SELECT first_name, last_name, SUM(amount) AS 'Total Paid' FROM customer 
INNER JOIN payment 
ON customer.customer_id=payment.customer_id
GROUP BY customer.customer_id
ORDER BY last_name;

/* 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English. */
SELECT title AS 'Films Starting with K or Q in English' FROM  film 
WHERE 
	(title LIKE 'K%' OR title LIKE 'Q%')
	AND language_id in (SELECT language_id
						FROM language
						WHERE name = 'English');

/* 7b. Use subqueries to display all actors who appear in the film `Alone Trip`. */
SELECT first_name, last_name, actor_id FROM actor 
WHERE actor_id IN (	SELECT actor_id FROM film_actor 
					WHERE film_id IN (	SELECT film_id FROM film 
										WHERE title='Alone Trip'
									 )
				   );

/* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information. */
SELECT first_name, last_name, email, country FROM customer 
INNER JOIN address 
ON customer.address_id=address.address_id
INNER JOIN city
ON address.city_id=city.city_id
INNER JOIN country
ON city.country_id=country.country_id
WHERE country='Canada';

/* 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films. */
SELECT film.film_id, title, name FROM film 
INNER JOIN film_category 
ON film.film_id = film_category.film_id 
INNER JOIN category 
ON film_category.category_id = category.category_id 
WHERE name = 'family';

/* 7e. Display the most frequently rented movies in descending order. */
SELECT title, COUNT(rental_id) AS 'Times Rented' FROM film 
INNER JOIN inventory 
ON film.film_id=inventory.film_id
INNER JOIN rental
ON inventory.inventory_id=rental.inventory_id
GROUP BY film.film_id
ORDER BY COUNT(rental_id) DESC;

/* 7f. Write a query to display how much business, in dollars, each store brought in. */
SELECT store_id, rental.inventory_id, payment.rental_id, SUM(amount) FROM payment
INNER JOIN rental
ON payment.rental_id=rental.rental_id
INNER JOIN inventory
ON rental.inventory_id=inventory.inventory_id
GROUP BY store_id;

/* 7g. Write a query to display for each store its store ID, city, and country. */
SELECT store_id, city, country FROM store 
INNER JOIN address 
ON store.address_id=address.address_id
INNER JOIN city
ON address.city_id=city.city_id
INNER JOIN country
ON city.country_id=country.country_id;

/* 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.) */
SELECT name, sum(amount) AS 'Total Amount' FROM payment
INNER JOIN rental
ON payment.rental_id=rental.rental_id
INNER JOIN inventory
ON rental.inventory_id=inventory.inventory_id
INNER JOIN film_category
ON inventory.film_id=film_category.film_id
INNER JOIN category
ON film_category.category_id=category.category_id
GROUP BY category.category_id
ORDER BY sum(amount) DESC
LIMIT 5;

/* 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 
Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view. */
CREATE VIEW topgenres AS
SELECT name, sum(amount) AS 'Total Amount' FROM payment
INNER JOIN rental
ON payment.rental_id=rental.rental_id
INNER JOIN inventory
ON rental.inventory_id=inventory.inventory_id
INNER JOIN film_category
ON inventory.film_id=film_category.film_id
INNER JOIN category
ON film_category.category_id=category.category_id
GROUP BY category.category_id
ORDER BY sum(amount) DESC
LIMIT 5;

/* 8b. How would you display the view that you created in 8a? */
SELECT * FROM topgenres;

/* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it. */
DROP VIEW topgenres;

/* 
## Uploading Homework

* To submit this homework using BootCampSpot:

  * Create a GitHub repository.
  * Upload your .sql file with the completed queries.
  * Submit a link to your GitHub repo through BootCampSpot.
 */
