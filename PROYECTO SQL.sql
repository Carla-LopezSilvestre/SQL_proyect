
-- 2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
select f.title , f.rating 
from film f   
where f.rating = 'R';

-- 3. Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40.
select first_name, last_name  
from "actor" 
where actor_id between 30 and 40;

-- 4. Obtén las películas cuyo idioma coincide con el idioma original.
select f.title  
from film f 
where language_id = original_language_id 
   or original_language_id is null;

-- 5. Ordena las películas por duración de forma ascendente.
select title, length  
from film 
order by film.length asc;

-- 6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.
select first_name, last_name
from actor
where last_name like '%ALLEN%' or last_name like '%Allen%';

/* 7. Encuentra la cantidad total de películas en cada clasificación 
de la tabla “film” y muestra la clasificación junto con el recuento.*/
select rating as "categoría", count(*) as "total_peliculas"
from film 
group by rating;

/* 8. Encuentra el título de todas las películas que son 
‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film.*/
select title 
from film 
where rating = 'PG-13'
or length > 180;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
select stddev(replacement_cost) as "variabilidad_costo"
from film;

-- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select MAX(length) as "mayor_duración", MIN(length) as "menor_duración"
from film; 

-- 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select p.amount 
from payment p  
order by p.payment_date 
limit 1 offset 2;

/* 12. Encuentra el título de las películas en la tabla “film” que no 
sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación.*/
select f.title 
from film f 
where f.rating not in ('NC-17', 'G');

/* 13. Encuentra el promedio de duración de las películas para cada clasificación 
de la tabla film y muestra la clasificación junto con el promedio de duración.*/
select rating, ROUND(AVG(length), 2) as promedio_duracion
from film
group by rating
order by rating;

-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select f.title 
from film f 
where f.length > 180;

-- 15. ¿Cuánto dinero ha generado en total la empresa?
select SUM(p.amount) as "ingresos_totales"
from payment p;

-- 16. Muestra los 10 clientes con mayor valor de id.
select c.first_name, c.last_name  
from customer c 
order by c.customer_id DESC 
limit 10; 

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
select a.first_name, a.last_name
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film f on fa.film_id = f.film_id
where upper(f.title) = upper('Egg Igby');

-- 18. Selecciona todos los nombres de las películas únicos.
select distinct f.title 
from film f;

/* 19. Encuentra el título de las películas que son comedias y 
tienen una duración mayor a 180 minutos en la tabla “film”.*/
select f.title 
from film f 
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
where c."name" = 'Comedy' and f.length > 180;

/* 20. Encuentra las categorías de películas que tienen un 
promedio de duración superior a 110 minutos y muestra el nombre de 
la categoría junto con el promedio de duración.*/
select c."name", AVG(f.length) as "promedio_duración"
from film f 
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
group by c."name" 
having AVG(f.length) >110;

-- 21. ¿Cuál es la media de duración del alquiler de las películas?
select AVG(f.rental_duration) as "media_alquiler"
from film f; 

-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat(a.first_name, ' ', a.last_name ) as "nombre_completo"
from actor a; 

-- 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select DATE(r.rental_date) as dia, COUNT(*) as total_alquileres
from rental r 
group by DATE(r.rental_date)
order by total_alquileres desc; 

-- 24. Encuentra las películas con una duración superior al promedio.
select f.title, f.length 
from film f 
where f.length > (select AVG(f.length) from film f);

-- 25. Averigua el número de alquileres registrados por mes.
select DATE_FORMAT(rental_date, '%Y-%m') AS mes, COUNT(*) AS total_alquileres
from rental r 
group by mes 
order by mes;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select 
	AVG(amount) AS promedio,
    STDDEV(amount) AS desviacion_estandar,
    VARIANCE(amount) AS varianza
from payment;

-- 27. ¿Qué películas se alquilan por encima del precio medio?
select distinct f.title
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
inner join payment p on r.rental_id = p.rental_id
where p.amount > (SELECT AVG(amount) FROM payment)
order by f.title;

-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
select a.actor_id, a.first_name, a.last_name, count(*) as "películas"
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id 
having count(*) > 40;

-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select f.title, count(i.inventory_id) as "cantidad_disponible"
from film f 
left join inventory i on f.film_id = i.film_id 
group by f.title;

-- 30. Obtener los actores y el número de películas en las que ha actuado.
select a.first_name, a.last_name, count(fa.film_id) as "num_peliculas"
from actor a 
left join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id;

/* 31. Obtener todas las películas y mostrar los actores que han actuado 
en ellas, incluso si algunas películas no tienen actores asociados.*/
select f.title, a.first_name, a.last_name 
from film f 
left join film_actor fa on f.film_id = fa.film_id
left join actor a on fa.actor_id = a.actor_id;

/* 32. Obtener todos los actores y mostrar las películas en las que han actuado, 
incluso si algunos actores no han actuado en ninguna película.*/
select a.first_name, a.last_name, f.title 
from actor a 
left join film_actor fa on a.actor_id = fa.actor_id
left join film f on fa.film_id = f.film_id;

-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
select f.title, r.rental_date 
from film f 
cross join rental r;

-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select c.customer_id, c.first_name, c.last_name, SUM(p.amount) as "total_gastado"
from customer c 
inner join payment p on c.customer_id = p.customer_id
group by c.customer_id 
order by "total_gastado" desc
limit 5;

-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select a.first_name, a.last_name 
from actor a 
where a.first_name = 'JOHNNY';

-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
select a.first_name as "Nombre", a.last_name as "Apellido"
from actor a;

-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select MIN(a.actor_id), MAX(a.actor_id)
from actor a; 

-- 38. Cuenta cuántos actores hay en la tabla “actor”.
select count(*)
from actor a;

-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select a.first_name, a.last_name 
from actor a 
order by a.last_name desc;

-- 40. Selecciona las primeras 5 películas de la tabla “film”.
select f.title 
from film f 
limit 5;

/* 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. 
 ¿Cuál es el nombre más repetido?*/
select a.first_name, count(*) as "repeticiones"
from actor a 
group by a.first_name 
order by "repeticiones"  desc
limit 1;

-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r.rental_id, c.first_name, c.last_name 
from rental r 
inner join customer c on r.customer_id = c.customer_id;

-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select c.first_name, c.last_name, r.rental_date 
from customer c 
left join rental r on c.customer_id = r.customer_id;

/* 44. Realiza un CROSS JOIN entre las tablas film y category. 
¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.*/
select *
from film f 
cross join category c;
-- No, ya que sale toda la información

-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select a.first_name, a.last_name 
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id 
inner join film_category fc on fa.film_id = fc.film_id 
inner join category c on fc.category_id = c.category_id
where c."name" = 'Action';

-- 46. Encuentra todos los actores que no han participado en películas.
select a.first_name, a.last_name 
from actor a 
left join film_actor fa on a.actor_id = fa.actor_id 
where fa.actor_id is null

SELECT first_name, last_name
FROM actor
WHERE actor_id NOT IN (SELECT actor_id FROM film_actor WHERE actor_id IS NOT NULL);

-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select a.first_name, a.last_name, count(fa.film_id) as num_películas
from actor a 
left join film_actor fa on a.actor_id = fa.actor_id
group by a.actor_id;

/* 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores 
y el número de películas en las que han participado.*/
CREATE OR REPLACE VIEW actor_num_peliculas AS
select 
	first
    a.last_name,
    COUNT(fa.film_id) AS num_peliculas
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
ORDER BY num_peliculas DESC;

-- 49. Calcula el número total de alquileres realizados por cada cliente.
select c.customer_id, c.first_name, c.last_name, count(r.rental_id) 
from customer c 
left join rental r on c.customer_id = r.customer_id 
group by c.customer_id; 

-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select SUM(f.length) as "duración_total"
from  film f 
inner join film_category fc on f.film_id = fc.film_id 
inner join category c on fc.category_id = c.category_id 
where c."name" = 'Action';

/* 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para 
almacenar el total de alquileres por cliente.*/
create view cliente_rentas_temporal as
select 
    c.customer_id,
    c.first_name,
    c.last_name,
    count(r.rental_id) as total_alquileres
from customer c
left join rental r on c.customer_id = r.customer_id
group by c.customer_id, c.first_name, c.last_name;

/* 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene 
las películas que han sido alquiladas al menos 10 veces.*/
create view peliculas_alquiladas_num as
select 
    f.title,
    count(r.rental_id) as veces_alquilada
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
group by f.film_id, f.title
having count(r.rental_id) >= 10
order by veces_alquilada desc;

/* 53. Encuentra el título de las películas que han sido alquiladas por el cliente
con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena
los resultados alfabéticamente por título de película.*/
select f.title 
from film f 
inner join inventory i on f.film_id = i.film_id 
inner join rental r on i.inventory_id = r.inventory_id 
inner join customer c on r.customer_id = c.customer_id 
where c.first_name = 'Tammy' and c.last_name = 'Sanders'
group by f.title;

/* 54. Encuentra los nombres de los actores que han actuado en al menos una película 
que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.*/
select distinct a.first_name, a.last_name 
from actor a 
inner join film_actor fa on a.actor_id = fa.actor_id
inner join film_category fc on fa.film_id = fc.film_id 
inner join category c on fc.category_id = c.category_id
where c."name" = 'Sci-Fi'
order by a.last_name; 

/* 55. Encuentra el nombre y apellido de los actores que han actuado en películas 
que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. 
Ordena los resultados alfabéticamente por apellido.*/
with primer_alquiler_spartacus as (
    select MIN(r.rental_date) as fecha
    from rental r
    inner join inventory i on r.inventory_id = i.inventory_id
    inner join film f on i.film_id = f.film_id
    where f.title = 'SPARTACUS CHEAPER'
)
select distinct a.first_name, a.last_name
from actor a
inner join film_actor fa on a.actor_id = fa.actor_id
inner join inventory i on fa.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
cross join primer_alquiler_spartacus p
where r.rental_date > p.fecha
order by a.last_name;

/* 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna 
película de la categoría ‘Music’.*/
select a.first_name, a.last_name 
from actor a 
left join (
	select fa.actor_id 
	from film_actor fa 
	inner join film_category fc on fa.film_id = fc.film_id 
	inner join category c on fc.category_id = c.category_id 
	where c."name" = 'Music'
) music on a.actor_id = music.actor_id 
where music.actor_id is null;

-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select distinct f.title
from film f
inner join inventory i on f.film_id = i.film_id
inner join rental r on i.inventory_id = r.inventory_id
where extract(day from age(r.return_date, r.rental_date)) > 8
  and r.return_date is not null
order by f.title;

-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
select distinct f.title
from film f
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
where lower(c.name) like '%anim%'   
order by f.title;

/* 59. Encuentra los nombres de las películas que tienen la misma duración que la película 
con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película.*/
select title
from film
where length = (SELECT length FROM film WHERE title = 'DANCING FEVER')
  and title != 'DANCING FEVER'
order by title;
	
/* 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. 
Ordena los resultados alfabéticamente por apellido.*/
select c.first_name, c.last_name 
from customer c 
inner join rental r on c.customer_id = r.customer_id
inner join inventory i on r.inventory_id = i.inventory_id
group by c.customer_id 
having count(distinct i.film_id) >= 7
order by c.last_name; 

/* 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre 
de la categoría junto con el recuento de alquileres.*/
select c."name", count(r.rental_id) 
from category c 
inner join film_category fc on c.category_id = fc.category_id
inner join inventory i on fc.film_id = i.film_id 
inner join rental r on i.inventory_id = r.inventory_id
group by c."name";

-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
select c."name", count(f.film_id )
from film f 
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
where f.release_year = 2006
group by c."name";

-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select s.first_name, s.last_name, s.store_id 
from staff s 
cross join store s2;

/* 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, 
su nombre y apellido junto con la cantidad de películas alquiladas.*/
select c.customer_id, c.first_name, c.last_name, count(r.rental_id ) as "total_alquileres"
from customer c 
left join rental r on c.customer_id = r.customer_id
group by c.customer_id 
order by "total_alquileres" desc;
