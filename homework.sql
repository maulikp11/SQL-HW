use sakila;
-- 1a. Display the first and last names of all actors from the table actor.
select * from actor;
select first_name, last_name from actor;
-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select upper(concat(first_name, ' ' ,last_name)) from actor;
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name, last_name from actor where first_name = 'Joe';
-- 2b. Find all actors whose last name contain the letters GEN:
select * from actor where last_name like '%GEN%';
-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select first_name, last_name from actor where last_name like '%LI%' order by last_name, first_name;
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select country_id,country from country where country in ('Afghanistan', 'Bangladesh', 'China');
-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
alter table actor add description blob;
describe actor;
-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop description;
describe actor;
-- 4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(1) from actor group by last_name;
-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name,count(1) from actor group by last_name having count(1) > 1;
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
select * from actor where first_name = 'GROUCHO' and  last_name = 'WILLIAMS';
update actor set first_name = 'HARPO' where actor_id = 172;
select * from actor where actor_id=172;
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor set first_name = 'GROUCHO' where actor_id = 172;
-- update actor set first_name='HARPO' where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
-- update actor set first_name='GROUCHO' where first_name = 'HARPO';
select * from actor where actor_id=172;
-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select * from address;
select * from staff;
select f.first_name, f.last_name, a.address  from staff f inner join address a  on a.address_id = f. address_id;
-- 6b. Use JOIN to display the total amount rung up by each staff member in 
-- August of 2005. Use tables staff and payment.
select * from staff;
select * from payment;
select s.staff_id, s.first_name, sum(p.amount) from staff s
inner join payment p on s.staff_id = p.staff_id and payment_date like '%2005-08%'
group by s.staff_id, s.first_name;
-- 6c. List each film and the number of actors who are listed for 
-- that film. Use tables film_actor and film. Use inner join.
select * from film_actor;
select * from film;
select a.film_id, a.title, count(f.actor_id)
from film_actor f inner join film a   on a.film_id = f.film_id
group by a.title, a.film_id ;
-- 6d How many copies of the film Hunchback Impossible exist in the inventory system?
select count(1) from inventory i inner join film f on i.film_id=f.film_id and f.title ='HUNCHBACK IMPOSSIBLE';
-- 6e Using the tables payment and customer and the JOIN command, 
-- list the total paid by each customer. List the customers alphabetically by last name:
select a.first_name, a.last_name, sum(b.amount) from payment b
 inner join customer a on b.customer_id = a.customer_id group by  a.first_name, a.last_name
 order by a.last_name;
--  7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select f.title
from film f
where f.title like 'K%' or f.title like 'Q%' and f.language_id in (
select l.language_id
from language l
where l.name='ENGLISH'
);
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
select a.actor_id, a.first_name, a.last_name from actor a
where a.actor_id in (
select f.actor_id from film_actor f
where f.film_id in ( 
select i.film_id
from film i
where i.title ='ALONE TRIP'));
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
select a.first_name, a.last_name, a.email
from customer a inner join address b
on a.address_id = b.address_id
inner join city c on b.city_id = c.city_id
inner join country d on c.country_id = d.country_id and d.country = 'Canada';
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films
select f.title, c.name
from film f inner join film_category fc
on f.film_id = fc.film_id
inner join category c on c.category_id=fc.category_id
and c.name='Family';
-- 7e. Display the most frequently rented movies in descending order.
select a.title,count(r.rental_id)
from film a inner join inventory c
on a.film_id=c.film_id
inner join rental r on c.inventory_id=r.inventory_id
group by a.title
order by count(r.rental_id) desc;
-- 7f. Write a query to display how much business, in dollars, each store brought in.
select s.store_id, sum(p.amount)
from store s inner join inventory c on s.store_id=c.store_id
inner join rental r on r.inventory_id = c.inventory_id
inner join payment p on p.rental_id=r.rental_id
group by s.store_id;
-- 7g. Write a query to display for each store its store ID, city, and country.
select s.store_id, c.city, cr.country
from store s inner join address a on s.address_id=a.address_id
inner join city c on c.city_id=a.city_id
inner join country cr on c.country_id=cr.country_id;
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select c.name, sum(p.amount) gross_revenue
from category c inner join film_category b on c.category_id=b.category_id
inner join film f on f.film_id=b.film_id 
inner join  inventory i on f.film_id=i.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id=r.rental_id
group by c.name
order by sum(p.amount) desc limit 5;
-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
create view vw_top_five_generes as 
select c.name, sum(p.amount) gross_revenue
from category c inner join film_category b on c.category_id=b.category_id
inner join film f on f.film_id=b.film_id 
inner join  inventory i on f.film_id=i.film_id
inner join rental r on r.inventory_id = i.inventory_id
inner join payment p on p.rental_id=r.rental_id
group by c.name
order by sum(p.amount) desc limit 5;
-- 8b. How would you display the view that you created in 8a?
select * from vw_top_five_generes;
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
drop view vw_top_five_generes;

