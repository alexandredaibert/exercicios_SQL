# Anotações Módulo 2 - SQL Joins

## INTRODUÇÃO

# Exemplo de aplicação do inner join.

    SELECT orders.*
    FROM   orders
    JOIN   accounts
    ON     orders.account_id = accounts.id;

# Try pulling all the data from the accounts table, and all the data from the orders table.

    SELECT *
    FROM accounts
    JOIN orders
    ON orders.account_id = accounts.id;

# Try pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.

    SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc as contato_primario
    FROM accounts
    JOIN orders
    ON orders.account_id = accounts.id;

## Join Questions parte 1:

# Provide a table for all web_events associated with account name of Walmart. There should be three columns. Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose to add a fourth column to assure only Walmart events were chosen.

    SELECT web_events.channel, 
           web_events.occurred_at, 
           accounts.primary_poc,
           accounts.name
      FROM web_events
      JOIN accounts
        ON accounts.id = web_events.account_id
     WHERE accounts.name = 'Walmart';

# Provide a table that provides the region for each sales_rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

    SELECT a.name AS "Nome Conta", 
        r.name AS "Região", 
        sr.name AS "Contato"
    FROM accounts AS a
    JOIN sales_reps AS sr
    ON sr.id = a.sales_rep_id
    JOIN region AS r
    ON r.id = sr.region_id
    ORDER BY "Nome Conta";
    
# Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.
    
    SELECT a.name AS "Nome Conta", 
           r.name AS "Região", 
           o.total/o.total_amt_usd AS "Preço unitário"
      FROM orders AS o
      JOIN accounts AS a
        ON a.id = o.account_id
      JOIN sales_reps AS sr
        ON sr.id = a.sales_rep_id
      JOIN region AS r
        ON r.id = sr.region_id
     WHERE o.total_amt_usd != 0
  ORDER BY "Nome Conta"; 

## LEFT JOIN, RIGHT JOIN e OUTER JOIN

# Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

    SELECT r.name AS "Region Name",
           sr.name AS "Sales Rep Name",
           a.name AS "Account Name"
      FROM region AS r
      JOIN sales_reps AS sr
        ON r.id = sr.region_id AND r.name = 'Midwest'
      JOIN accounts as a
        ON sr.id = a.sales_rep_id
  ORDER BY "Account Name";

# Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

   SELECT r.name AS "Region Name",
          sr.name AS "Sales Rep Name",
          a.name AS "Account Name"
     FROM region AS r
     JOIN sales_reps AS sr
       ON r.id = sr.region_id AND r.name = 'Midwest'
     JOIN accounts as a
       ON sr.id = a.sales_rep_id
    WHERE sr.name LIKE 'S%'
 ORDER BY "Account Name";
  
# Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.

   SELECT r.name AS "Region Name",
          sr.name AS "Sales Rep Name",
          a.name AS "Account Name"
     FROM region AS r
     JOIN sales_reps AS sr
       ON r.id = sr.region_id AND r.name = 'Midwest'
     JOIN accounts as a
       ON sr.id = a.sales_rep_id
    WHERE sr.name LIKE '% K%'
   ORDER BY "Account Name";

# Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).

   SELECT r.name AS "Region Name",
          a.name AS "Account Name",
          o.total_amt_usd/(o.total+0.001) AS unit_price
     FROM region AS r
     JOIN sales_reps AS sr
       ON r.id = sr.region_id
     JOIN accounts as a
       ON sr.id = a.sales_rep_id
     JOIN orders as o
       ON a.id = o.account_id AND o.standard_qty > 100;

# Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

   SELECT r.name AS "Region Name",
          a.name AS "Account Name",
          o.total_amt_usd/(o.total+0.001) AS unit_price
     FROM region AS r
     JOIN sales_reps AS sr
       ON r.id = sr.region_id
     JOIN accounts as a
       ON sr.id = a.sales_rep_id
     JOIN orders as o
       ON a.id = o.account_id AND o.standard_qty > 100 AND o.poster_qty> 50
 ORDER BY unit_price;

# Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

    SELECT r.name AS "Region Name",
        a.name AS "Account Name",
        o.total_amt_usd/(o.total+0.001) AS unit_price
    FROM region AS r
    JOIN sales_reps AS sr
    ON r.id = sr.region_id
    JOIN accounts as a
    ON sr.id = a.sales_rep_id
    JOIN orders as o
    ON a.id = o.account_id AND o.standard_qty > 100 AND o.poster_qty> 50
    ORDER BY unit_price DESC;

# What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.

    SELECT DISTINCT a.name account_name, w.channel
    FROM accounts a
    JOIN web_events w
    ON a.id = w.account_id AND a.id = 1001;

# Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
    
    SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id AND o.occurred_at BETWEEN '2015-01-01' AND '2016-01-01';
