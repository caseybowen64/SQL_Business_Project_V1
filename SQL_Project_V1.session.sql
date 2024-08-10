-- Creating Database Tables
-- We want 1 table 

CREATE TABLE public.customer_behavior (
    customer_id INT PRIMARY KEY,
    gender TEXT,
    age INT,
    city TEXT,
    memb TEXT,
    spend FLOAT,
    items_purchase INT,
    avg_rate INT,
    Discount BOOLEAN,
    days_since_purchase INT,
    satisfaction TEXT
)

ALTER TABLE public.customer_behavior OWNER to postgres;
CREATE INDEX indx_customer_id ON public.customer_behavior(customer_id);

SELECT *
FROM customer_behavior;

ALTER TABLE customer_behavior
ALTER COLUMN avg_rate SET DATA TYPE FLOAT;

COPY customer_behavior
FROM '/tmp/E-commerce Customer Behavior - Sheet1.csv'
DELIMITER ',' CSV HEADER;

-- Now we we have our table initialized, we want to do some analysis!
/* First, let's try to understand our data more.
Grouped by membership, what is the average total spend? */

SELECT 
AVG(spend) AS "Avg Spend", 
AVG(items_purchase) AS "Items Purchase", 
AVG(days_since_purchase) AS "Days since last purchase",  
memb
FROM customer_behavior

GROUP BY memb
ORDER BY "Avg Spend";

/* We are seeing that both the average spend, items purchased
and days since last spend all correlate with the increasing
of the membership type.

Now, let's check out the demographics of each membership type*/

SELECT ROUND(AVG(age), 2) AS "rounded age", memb
FROM customer_behavior
GROUP BY memb
ORDER BY "rounded age" ASC;


