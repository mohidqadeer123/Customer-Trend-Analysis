--Q1 What is the total and average purchase amount by product category?
SELECT
    category,
    ROUND(SUM(purchase_amount), 2) AS total_revenue,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer
GROUP BY category
ORDER BY total_revenue DESC;

--Q2 Which locations generate the highest total revenue?
SELECT
    location,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY location
ORDER BY total_revenue DESC;

--Q3 How does purchase behavior differ between subscribed and non-subscribed customers?
SELECT
    subscription_status,
    COUNT(*) AS total_purchases,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount,
    ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases
FROM customer
GROUP BY subscription_status;

--Q4 Which items are most frequently purchased?
SELECT
    item_purchased,
    COUNT(*) AS purchase_count
FROM customer
GROUP BY item_purchased
ORDER BY purchase_count DESC
LIMIT 10;

--Q5 Does applying a discount or promo code increase the average purchase amount?
SELECT
    discount_applied,
    ROUND(AVG(purchase_amount), 2) AS avg_purchase_amount
FROM customer
GROUP BY discount_applied;

--Q6 Which season records the highest number of purchases and revenue?
SELECT
    season,
    COUNT(*) AS total_purchases,
    ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY season
ORDER BY total_revenue DESC;

--Q7 Which customer segment customers (New, Returning, and Loyal) had most total number of previous purchases.
with customer_type as (
SELECT customer_id, previous_purchases,
CASE 
    WHEN previous_purchases = 1 THEN 'New'
    WHEN previous_purchases BETWEEN 2 AND 10 THEN 'Returning'
    ELSE 'Loyal'
    END AS customer_segment
FROM customer)

select customer_segment,count(*) AS "Number of Customers" 
from customer_type 
group by customer_segment;

--Q8 What are the top 3 most purchased products within each category?
WITH item_counts AS (
    SELECT category,
           item_purchased,
           COUNT(customer_id) AS total_orders,
           ROW_NUMBER() OVER (PARTITION BY category ORDER BY COUNT(customer_id) DESC) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT item_rank,category, item_purchased, total_orders
FROM item_counts
WHERE item_rank <=3;
 
--Q9 Are customers who are repeat buyers (more than 5 previous purchases) also likely to subscribe?
SELECT subscription_status,
       COUNT(customer_id) AS repeat_buyers
FROM customer
WHERE previous_purchases > 5
GROUP BY subscription_status;

--Q10 Is there a relationship between review ratings and repeat purchases (Previous Purchases)?
SELECT
    review_rating,
    ROUND(AVG(previous_purchases), 2) AS avg_previous_purchases,
    COUNT(*) AS total_customers
FROM customer
GROUP BY review_rating
ORDER BY review_rating;

