select * from customer limit 20

-- total revenue from male vs female customers
SELECT gender, SUM(purchase_amount) as revenue
FROM customer
GROUP BY gender

-- customers who used a discount but still spent more than average?
SELECT customer_id, purchase_amount
FROM customer
WHERE discount_applied = 'Yes' and purchase_amount >= (select AVG(purchase_amount) from customer)

-- top 5 products with the highest average review rating?
SELECT item_purchased, ROUND(AVG(review_rating::numeric), 2) as "Average Product Rating"
FROM customer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;

-- compare the average purchase amounts between standard and express shipping
SELECT shipping_type,
ROUND(AVG(purchase_amount),2)
FROM customer
WHERE shipping_type in ('Standard', 'Express')
GROUP BY shipping_type

-- do subscribed customers spend more?
SELECT subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as avg_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue, avg_spend DESC

-- which 5 products are purchased the most with discounts applied?
SELECT item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/count(*),2) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

-- segment customers into new, returning, and loyal based on their total number of previous purchases
WITH customer_type as (
SELECT customer_id, previous_purchases,
CASE 
	WHEN previous_purchases = 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
	ELSE 'Loyal'
	END AS customer_segment
FROM customer
)

SELECT customer_segment, count(*) as "Number of Customers"
FROM customer_type
GROUP BY customer_segment

-- what are the top 3 most purchased products within each category?
WITH item_counts as (
SELECT category, 
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() OVER(PARTITION BY category ORDER BY COUNT(customer_id) DESC) as item_rank
FROM customer
GROUP BY category, item_purchased
)

SELECT item_rank, category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <= 3;

-- are customers who are repeat buyers also likely to subscribe?
SELECT subscription_status,
COUNT(customer_id) as repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status

-- what is the revenue contribution by age group?
SELECT age_group,
SUM(purchase_amount) as total_revenue
FROM customer
GROUP BY age_group
ORDER BY total_revenue desc;