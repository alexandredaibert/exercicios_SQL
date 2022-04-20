Anotações Módulo 4 - SQL Subqueries & Temporary Tables

## Subqueries

Use the test environment below to find the number of events that occur for each day for each channel.

    SELECT channel,
        DATE_TRUNC('day', occurred_at) day,
        COUNT(*)
    FROM web_events
    GROUP BY 1, 2
    ORDER BY 3 DESC;

Now create a subquery that simply provides all of the data from your first query.

    SELECT *
    FROM
    (SELECT channel,
        DATE_TRUNC('day', occurred_at) _day,
        COUNT(*) contagem
    FROM web_events
    GROUP BY 1, 2
    ORDER BY 3 DESC) subquery;

Now find the average number of events for each channel. Since you broke out by day earlier, this is giving you and average per day.

    SELECT channel, AVG(contagem) media_eventos_dia
    FROM
    (SELECT channel,
        DATE_TRUNC('day', occurred_at) _day,
        COUNT(*) contagem
    FROM web_events
    GROUP BY 1, 2
    ORDER BY 3 DESC) subquery
    GROUP BY 1;

Use DATE_TRUNC to pull month level information about the fist order ever placed in the orders table.

    SELECT DATE_TRUNC('month',MIN(occurred_at))
    FROM orders;

Use the result to the previous query to find the orders that took place in the same month and year as the first order, and then pull the average for each type of paper qty in this month.    
    
    SELECT AVG(standard_qty) avg_standard,
        AVG(poster_qty) avg_poster,
        AVG(gloss_qty) avg_gloss
    FROM orders
    WHERE DATE_TRUNC('month', occurred_at) = 
        (SELECT DATE_TRUNC('month',MIN(occurred_at))
        FROM orders);

Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

    SELECT r.name region,
        s.name sales_rep,
        SUM(o.total_amt_usd) max_usd
    FROM orders o
    JOIN accounts a
    ON a.id = o.account_id
    JOIN sales_reps s
    ON s.id = a.sales_rep_id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY 1, 2
    HAVING SUM(o.total_amt_usd) IN 
        (   
        SELECT max_sum 
        FROM
            (
            SELECT region, MAX(sum) max_sum
            FROM
                (SELECT s.name sales_rep,
                        r.name region,
                        SUM(o.total_amt_usd)
                FROM orders o
                JOIN accounts a
                ON a.id = o.account_id
                JOIN sales_reps s
                ON s.id = a.sales_rep_id
                JOIN region r
                ON r.id = s.region_id
                GROUP BY 1, 2
                ORDER BY 3 DESC
                ) AS sub
            GROUP BY 1
            ) AS sub2
        );

For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

    SELECT r.name, COUNT(o.total) total_orders
    FROM sales_reps s
    JOIN accounts a
    ON a.sales_rep_id = s.id
    JOIN orders o
    ON o.account_id = a.id
    JOIN region r
    ON r.id = s.region_id
    GROUP BY r.name
    HAVING SUM(o.total_amt_usd) = 
        (
        SELECT MAX(total_amt)
        FROM (
            SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
            FROM sales_reps s
            JOIN accounts a
            ON a.sales_rep_id = s.id
            JOIN orders o
            ON o.account_id = a.id
            JOIN region r
            ON r.id = s.region_id
            GROUP BY r.name) sub
        );

How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

    SELECT account_id,
        SUM(total) total_purchases,
        SUM(standard_qty)
    FROM orders
    GROUP BY 1
    HAVING SUM(total) > 
        (
        SELECT total_purchases
        FROM /* account com máxima venda de standard */
            (
            SELECT a.name, 
                SUM(o.standard_qty), 
                SUM(o.total) total_purchases
            FROM orders o
            JOIN accounts a
            ON a.id = o.account_id
            GROUP BY 1
            ORDER BY 2 DESC
            LIMIT 1) AS sub
        );

For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

    SELECT w.channel, COUNT(*)
    FROM web_events w
    JOIN accounts a
    ON a.id = w.account_id
    JOIN (SELECT account_id,
          SUM(total_amt_usd) total_sales
          FROM orders
          GROUP BY account_id
          ORDER BY total_sales DESC
          LIMIT 1) AS sub
    ON a.id = sub.account_id
    GROUP BY 1;

What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

    SELECT AVG(usd_total) lt_avg_amount
    FROM /* top 10 accounts */
    (   SELECT account_id,
        SUM(total_amt_usd) usd_total
        FROM orders
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 10
    ) AS sub;

What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

    SELECT AVG(total_sales_per_id)
    FROM
        (SELECT id, SUM(total_amt_usd) total_sales_per_id
        FROM orders
        GROUP BY id
        HAVING AVG(total_amt_usd) > (
            SELECT AVG(total_amt_usd) 
            FROM orders)
                                    ) sub;
 
## WITH / Common Table Expressions (CTE)

Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

    /* vendas por representante por região */
    WITH soma_vendas AS (
        SELECT r.name regiao,
               s.name sales_rep,
               SUM(total_amt_usd) venda_por_rep
        FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
        JOIN sales_reps s
        ON s.id = a.sales_rep_id
        JOIN region r
        ON r.id = s.region_id
        GROUP BY 1, 2
        ORDER BY 3 DESC);

    /* query 2 */    
    SELECT sales_rep, regiao, max
    FROM (SELECT regiao, MAX(venda_por_rep) max
        FROM soma_vendas
        GROUP BY regiao) s
    JOIN 
        (SELECT sales_rep, venda_por_rep
        FROM soma_vendas) sub
    ON s.max = sub.venda_por_rep;

For the region with the largest sales total_amt_usd, how many total orders were placed?

    WITH soma_vendas AS (
        SELECT r.name regiao,
               SUM(o.total_amt_usd) venda_por_reg,
               COUNT(o.total) total_orders
        FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
        JOIN sales_reps s
        ON s.id = a.sales_rep_id
        JOIN region r
        ON r.id = s.region_id
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1)

    SELECT total_orders
    FROM soma_vendas;

How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

    WITH account_1 AS (
        SELECT account_id, 
        SUM(standard_qty) std_qty,
        SUM(total) tot_purch_1
        FROM orders
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 1
    ),
    total_purchase_1 AS (
        SELECT tot_purch_1
        FROM account_1
    ),
    table_filtered_accounts AS (
        SELECT account_id, SUM(total) total_purchases
        FROM orders o
        GROUP BY account_id
        HAVING SUM(total) > (SELECT * FROM total_purchase_1)  
    )
    SELECT COUNT(*) FROM table_filtered_accounts;

For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

    WITH customer_1 AS (
        SELECT account_id, SUM(total_amt_usd) total
        FROM orders
        GROUP BY account_id
        ORDER BY 2 DESC
        LIMIT 1
    )
    SELECT w.channel, COUNT(*)
    FROM web_events w
    JOIN customer_1 c
    ON w.account_id = c.account_id
    GROUP BY w.channel;

What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

    WITH ten_spending AS (
        SELECT account_id, SUM(total_amt_usd) total_usd
        FROM orders
        GROUP BY 1
        ORDER BY 2 DESC
        LIMIT 10
    )
    SELECT AVG(total_usd) 
    FROM ten_spending;

What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

    WITH avg_orders AS (
        SELECT AVG(o.total_amt_usd)
        FROM orders o
        JOIN accounts a
        ON a.id = o.account_id
    ),  
    company_filter AS (
        SELECT account_id, AVG(total_amt_usd) total_usd
        FROM orders
        GROUP BY 1
        HAVING AVG(total_amt_usd) > (SELECT * FROM avg_orders)
    )
    SELECT AVG(total_usd) 
    FROM company_filter;
