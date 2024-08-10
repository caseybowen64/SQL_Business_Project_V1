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

