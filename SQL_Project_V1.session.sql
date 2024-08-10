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

--Are more men or women in each membership?
--Firstly, we can see that there are exactly 175 Men and 175 women in the data set.

SELECT COUNT(*), gender FROM customer_behavior
GROUP BY gender

SELECT COUNT(*), memb FROM customer_behavior
WHERE gender LIKE 'Male'
GROUP BY memb;

SELECT COUNT(*), memb FROM customer_behavior
WHERE gender LIKE 'Female'
GROUP BY memb;

/*After looking at the different breakdowns of behavior by gender,
we see that more men purchase silver, whereas women are more likely to
purchase either gold or bronze. */

--How satisfied are each membership group with their purchase?
--Does that change if they got a discount or not?

SELECT COUNT(*), satisfaction
FROM customer_behavior
GROUP BY satisfaction
LIMIT 10;

/*To figure out the levels of satisfaction per group, I'm going to 
transform the satisfaction column into an INT, where Unsatisfied = 1,
Neutral = 2, Satisfied = 3, and NULL stays NULL. 

Then, we can take the avg satisfaction INT per group, and use that to
determine approximate levels of satisfaction. */

ALTER TABLE customer_behavior ADD COLUMN sat_INT INT;
UPDATE customer_behavior
    SET sat_INT = CASE
        WHEN satisfaction LIKE 'Unatisfied' THEN 1
        WHEN satisfaction LIKE 'Neutral' THEN 2
        WHEN satisfaction LIKE 'Satisfied' THEN 3
        ELSE NULL
    END;

SELECT sat_INT FROM customer_behavior LIMIT 10;

SELECT ROUND(AVG(sat_INT), 5), memb 
FROM customer_behavior
GROUP BY memb;

/* Looks like Gold customers are really satisfied with thier products!
Bronze is a solid neutral, and silver is a little above neutral.
Looks like the area of opportunity lies in increasing satisfaction
among our lower-tier members.

Now let's look at how discounts play into this.

Firstly I'd like to understand which membership group is getting the 
most discounts.*/

SELECT COUNT(discount), memb
FROM customer_behavior
WHERE discount IS TRUE
GROUP BY memb;

/*Looks like discounts are spread evenly accross the memberships, which
means the sales team is probably doing a good job, but doesn't help us
determine why those lower tier users are less satisfied. We might not be
able to get to the "why" from these queries alone, if there's such an 
even spread of demographics and discounts.*/

