/*USE magist*/
USE magist;
/*Total Orders: SELECT ALL FROM magist*/

SELECT count(*) AS t_order 
	FROM ORDERS;
    
/*Counts per order status*/
SELECT order_status ,
        count(*) AS Count_per_status 
	FROM orders
    GROUP BY order_status
    ORDER BY order_status;
    
 /*orders perchased per year and month*/   
 
SELECT YEAR(order_purchase_timestamp) As Years, 
                    MONTH(order_purchase_timestamp) AS Months,
                    count(customer_id) As Count
	FROM orders
    GROUP BY Years, Months
    ORDER BY Years, Months;
    
  /*Amount of products present in actual transactions*/  
  
 SELECT  COUNT(DISTINCT(product_id)) AS Prod_count
	FROM products;
    
/*Category with most products*/ 

SELECT product_category_name, count(DISTINCT(product_id)) AS Count_per_Cat
    FROM products
    GROUP BY product_category_name
    ORDER BY Count_per_Cat DESC;

/*Amount of Products in Actual Transactions*/
	
SELECT COUNT(DISTINCT(product_id)) AS Amount_Prod_Ord
	FROM order_items;  
    
/*Expensive and Cheapest  Product*/

SELECT MAX(price) AS Exp_Price, MIN(price) AS Cheap_Price
	FROM order_items
    ORDER BY price;  
 SELECT * 
	FROM order_items
    ORDER BY price;     
/*Highest and Lowest Payment Value*/


SELECT MAX(payment_value) AS Highest_payment,
       Min(payment_value) AS Lowest_payment
	FROM order_payments;
    
    /*SELECT SUM(payment_value) AS Highest_Order
        FROM order_payments
        GROUP BY order_id
        ORDER BY Highest_Order DESC; */
   
   /*
   SELECT DISTINCT(product_category_name),
                   product_category_name_english
        FROM product_category_name_translation
        ORDER BY product_category_name;
    
    SELECT DISTINCT(t.product_category_name), s.product_category_name_english
      FROM  products t
          RIGHT JOIN product_category_name_translation s 
          ON s.product_category_name = t.product_category_name
           ORDER BY t.product_category_name;
    */
    
    SELECT DISTINCT * 
        FROM products;
 SELECT DISTINCT * 
        FROM orders
        WHERE order_status IN ('delivered','shipped'); 
        
   SELECT DISTINCT * 
        FROM orders;
        
     SELECT DISTINCT Max(price) ,min(price)
        FROM order_items;
        
 SELECT DISTINCT * 
        FROM order_reviews;
        
 /*What categories of tech products does Magist have?  */
 SELECT DISTINCT * 
        FROM products;
 
 SELECT product_category_name, product_category_name_english as Eng_tech_Cat  
    FROM product_category_name_translation
    WHERE product_category_name_english IN ('audio','cds_dvds_musicals','consoles_games','consoles_games',
                      'cds_dvds_musicals','consoles_games','dvds_blu_ray','electronics',
                      'computers_accessories','pc_gamer','computers','tablets_printing_image',
                      'tablets_printing_image','telephony', 'fixed_telephony');
                      
/*How many products of these tech categories have been sold (within the time window of the database snapshot)? */ 
SELECT DISTINCT * 
        FROM order_items;
        
SELECT 
    CASE
        WHEN pt.product_category_name_english 
        IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 'computers_accessories',
            'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,
    SUM(oi.order_item_id) AS total_order_it #Both Tech and Other
FROM order_items  oi
RIGHT JOIN products  p ON oi.product_id = p.product_id
RIGHT JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
GROUP BY category
#HAVING category = 'Tech'
ORDER BY total_order_it DESC;

/*What percentage does that represent from the overall number of products sold?*/
SELECT SUM(order_item_id) FROM order_items;
SELECT 
    CASE
        WHEN pt.product_category_name_english 
        IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 
            'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,
           SUM(oi.order_item_id) AS total_items,
           SUM(order_item_id) * 100.0 / (SELECT SUM(order_item_id) FROM order_items) as Percentage
FROM order_items as oi
JOIN products as p ON oi.product_id = p.product_id
JOIN product_category_name_translation as pt ON p.product_category_name = pt.product_category_name
GROUP BY category
#HAVING category = 'Tech'
ORDER BY total_items DESC;

/*What’s the average price of the products being sold?*/

SELECT 
    CASE
        WHEN pt.product_category_name_english IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 
                                                  'electronics', 'computers_accessories', 'pc_gamer', 'computers',
                                                  'tablets_printing_image', 'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,
    AVG(oi.price) AS average_price
FROM order_items as oi
JOIN products as p ON oi.product_id = p.product_id
JOIN product_category_name_translation as pt ON p.product_category_name = pt.product_category_name
GROUP BY category;

/*Are expensive tech products popular? */
SELECT DISTINCT Max(price) ,min(price)
        FROM order_items;        
SELECT
    CASE
        WHEN price <= 100 THEN 'Low'
        WHEN price > 100 AND price <= 500 THEN 'Medium'
        ELSE 'High'
    END AS price_range,
    AVG(price) AS avg_price,
    SUM(oi.order_item_id) AS total_units_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN product_category_name_translation pt ON p.product_category_name = pt.product_category_name
WHERE pt.product_category_name_english IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics',
                                           'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 
                                           'telephony', 'fixed_telephony')
GROUP BY price_range
ORDER BY avg_price;

/*How many months of data are included in the magist database?*/
SELECT DISTINCT MAX(order_approved_at),MIN(order_approved_at)
        FROM orders
        ORDER BY order_approved_at DESC;  
 SELECT TIMESTAMPDIFF(MONTH, '2016-09-15 14:16:38', '2018-09-03 19:40:06') as Months; 
 
SELECT TIMESTAMPDIFF(MONTH, '2016-09-04', '2018-10-17') as Months;
SELECT 
    DISTINCT DATE_FORMAT(order_approved_at, '%Y-%m') AS number_of_months
FROM orders;

/*How many sellers are there? */
SELECT 
    count(DISTINCT seller_id) as seller
FROM order_items;

/*How many Tech sellers are there? 
What percentage of overall sellers are Tech sellers?*/
SELECT 
    CASE
        WHEN pt.product_category_name_english IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 
                                                'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 
                                                'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,
    count(oi.seller_id) AS total_seller, count(seller_id) * 100.0 / (SELECT count(seller_id) FROM order_items) as Percentage
FROM order_items as oi
JOIN products as p ON oi.product_id = p.product_id
JOIN product_category_name_translation as pt ON p.product_category_name = pt.product_category_name
GROUP BY category;

/*What is the total amount earned by all sellers? */

select sum(price) as Amount
from order_items;

/*What is the total amount earned by all Tech sellers?*/
SELECT 
    CASE
        WHEN pt.product_category_name_english 
            IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,
    SUM(oi.price) AS price
FROM order_items as oi
JOIN products as p ON oi.product_id = p.product_id
JOIN product_category_name_translation as pt ON p.product_category_name = pt.product_category_name
GROUP BY category;

SELECT 
    CASE
        WHEN pt.product_category_name_english IN ('audio', 'cds_dvds_musicals', 'consoles_games', 
        'dvds_blu_ray', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 
        'tablets_printing_image', 'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,
    SUM(oi.price*order_item_id) AS amount
FROM order_items as oi
JOIN products as p ON oi.product_id = p.product_id
JOIN product_category_name_translation as pt ON p.product_category_name = pt.product_category_name
GROUP BY category;

/*What’s the average time between the order being placed and the product being delivered?*/
SELECT YEAR(order_purchase_timestamp),
       AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) as average_time
FROM orders
GROUP BY YEAR(order_purchase_timestamp);

  /*      
  CREATE TABLE Tech_2 AS
    SELECT *,
        CASE               
            WHEN product_category_name_english 
            IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 
                'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony') 
            THEN 'Tech'
            ELSE 'others'
        END AS Tech_Cat
        FROM product_category_name_translation;
        
   SELECT *
    FROM Tech_1 ;
    
  SELECT p.*,t.* 
    FROM Tech_1 t
    JOIN products p ON p.product_category_name=t.product_category_name
    WHERE Tech_Cat='Tech';
 */ 
 
 /*
 SELECT 
    CASE
        WHEN pt.product_category_name_english IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 
                                                  'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 
                                                  'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,
    count(s.seller_id) AS amount
FROM order_items as oi
JOIN sellers s ON oi.seller_id = s.seller_id
JOIN products as p ON oi.product_id = p.product_id
JOIN product_category_name_translation as pt ON p.product_category_name = pt.product_category_name
GROUP BY category;


    
 SELECT 
    COUNT(DISTINCT DATE_FORMAT(order_approved_at, '%Y-%m')) AS number_of_months
FROM orders;
 
 SELECT count(s.seller_id)
    FROM sellers s
    JOIN order_items i on s.seller_id=i.seller_id;
    
SELECT 
    CASE
        WHEN pt.product_category_name_english IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 
                                                  'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 
                                                  'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,s. seller_id
FROM order_items  oi
JOIN product_category_name_translation  pt ON p.product_category_name = pt.product_category_name
JOIN sellers s ON oi.seller_id = s.seller_id;
#GROUP BY category;

SELECT YEAR(order_purchase_timestamp), AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) as average_time
FROM orders
GROUP BY YEAR(order_purchase_timestamp);
*/

/*How many orders are delivered on time vs orders delivered with a delay?*/
CREATE TABLE order_date AS 
    SELECT 
    order_status,order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,
    order_estimated_delivery_date,
        CASE
            WHEN datediff(order_estimated_delivery_date, order_delivered_customer_date) <= 0 THEN 'ND'
            ELSE 'D' 
        END As Diff
    FROM orders;
    
    SELECT Diff, COUNT(Diff) AS amt_Dif
     FROM  order_date;


SELECT YEAR(o.order_approved_at) AS order_year,
    CASE
        WHEN pt.product_category_name_english 
            IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony') 
        THEN 'Tech'
        ELSE 'others'
    END AS category,
    AVG(DATEDIFF(o.order_delivered_customer_date, o.order_approved_at)) as average_time_difference
FROM order_items as oi
JOIN products as p ON oi.product_id = p.product_id
JOIN product_category_name_translation as pt ON p.product_category_name = pt.product_category_name
JOIN orders as o ON oi.order_id = o.order_id
GROUP BY order_year, category
ORDER BY order_year;

/*3.2 How many orders are delivered on time vs orders delivered with a delay?*/

SELECT 
    CASE
        WHEN pt.product_category_name_english IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony') 
            AND order_delivered_customer_date <= order_estimated_delivery_date THEN 'Tech - On Time'
        WHEN pt.product_category_name_english IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony') 
            AND order_delivered_customer_date > order_estimated_delivery_date THEN 'Tech - Delayed'
        WHEN pt.product_category_name_english NOT IN ('audio', 'cds_dvds_musicals', 'consoles_games', 'dvds_blu_ray', 'electronics', 'computers_accessories', 'pc_gamer', 'computers', 'tablets_printing_image', 'telephony', 'fixed_telephony') 
            AND order_delivered_customer_date <= order_estimated_delivery_date THEN 'Others - On Time'
        ELSE 'Others - Delayed'
    END AS delivery_status,
    COUNT(*) AS order_count
FROM orders
JOIN order_items AS oi ON orders.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS pt ON p.product_category_name = pt.product_category_name
GROUP BY delivery_status;

/*3.3 Is there any pattern for delayed orders, e.g. big products being delayed more often?*/

SELECT 
    CASE
        WHEN product_weight_g <= 1000 THEN 'Small'
        WHEN product_weight_g > 1000 AND product_weight_g <= 5000 THEN 'Medium'
        ELSE 'Large'
    END AS weight_range,
    COUNT(*) AS total_orders,
    SUM(CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
        ELSE 0
    END) AS delayed_orders,
    (SUM(CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1
        ELSE 0
    END) / COUNT(*)) * 100 AS delayed_percentage
FROM orders
JOIN order_items AS oi ON orders.order_id = oi.order_id
JOIN products AS p ON oi.product_id = p.product_id
JOIN product_category_name_translation AS pt ON p.product_category_name = pt.product_category_name
GROUP BY weight_range;
