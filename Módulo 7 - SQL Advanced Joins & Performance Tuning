Anotações Módulo 7 - SQL Advanced Joins & Performance Tuning

## FULL OUTER JOIN

Say you are an analyst at Parch & Posey and you want to see:

- each account who has a sales rep and each sales rep that has an account (all of the columns in these returned rows will be full)
- but also each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)

    SELECT a.id as account,
        s.id as sales_rep
    FROM accounts a
    FULL OUTER JOIN sales_reps s    ## Poderia ser FULL JOIN
    ON s.id = a.sales_rep_id
    WHERE s.id IS NULL OR a.id IS NULL;

    
## Inequality JOINs

In the following SQL Explorer, write a query that left joins the accounts table and the sales_reps tables on each sale rep''s ID number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name

The query results should be a table with three columns: the account name (e.g. Johnson Controls), the primary contact name (e.g. Cammy Sosnowski), and the sales representative''s name (e.g. Samuel Racine). Then answer the subsequent multiple choice question.

    SELECT a.name account_name, 
        a.primary_poc, 
        s.name sales_reps_name
    FROM accounts a
    LEFT JOIN sales_reps s
    ON s.id = a.sales_rep_id 
    AND a.primary_poc < s.name;


## Self JOINs

One of the most common use cases for self JOINs is in cases where two events occurred, one after another. As you may have noticed in the previous video, using inequalities in conjunction with self JOINs is common.

Modify the query from the previous video, which is pre-populated in the SQL Explorer below, to perform the same interval analysis except for the web_events table. Also:

change the interval to 1 day to find those web events that occurred after, but not more than 1 day after, another web event
add a column for the channel variable in both instances of the table in your query

    SELECT w1.id AS w1_id,
        w1.account_id AS w1_account_id,
        w1.occurred_at AS w1_occurred_at,
        w1.channel AS w1_channel,
        w2.id AS w2_id,
        w2.account_id AS w2_account_id,
        w2.occurred_at AS w2_occurred_at,
        w2.channel AS w2_channel
    FROM web_events w1
    LEFT JOIN web_events w2
    ON w1.account_id = w2.account_id
    AND w2.occurred_at > w1.occurred_at
    AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
    ORDER BY w1.account_id, w1.occurred_at;

Write a query that uses UNION ALL on two instances (and selecting all columns) of the accounts table. Then inspect the results and answer the subsequent quiz.

    SELECT *
    FROM accounts

    UNION ALL

    SELECT *
    FROM accounts;

Add a WHERE clause to each of the tables that you unioned in the query above, filtering the first table where name equals Walmart and filtering the second table where name equals Disney. Inspect the results then answer the subsequent quiz.
    
    SELECT *
    FROM accounts a
    WHERE a.name = 'Walmart'

    UNION ALL

    SELECT *
    FROM accounts a
    WHERE a.name = 'Disney';

Perform the union in your first query (under the Appending Data via UNION header) in a common table expression and name it double_accounts. Then do a COUNT the number of times a name appears in the double_accounts table. If you do this correctly, your query results should have a count of 2 for each name.

    WITH double_accounts AS (
        SELECT *
        FROM accounts

        UNION ALL

        SELECT *
        FROM accounts
    )

    SELECT COUNT(*),
           name
    FROM double_accounts
    GROUP BY 2;

    
## Performance Tuning with SQL

Optimze the query below:
/*
SELECT o.occurred_at AS date,
       COUNT(DISTINCT a.sales_rep_id),
       COUNT(DISTINCT o.id AS order_id),
       COUNT(DISTINCT we.id AS web_event_id)
FROM   accounts a
JOIN   orders o
ON     o.account_id = a.id
JOIN   web_events we
ON     DATE_TRUNC('day', we.occurred_at) = DATE_TRUNC('day', o.occurred_at)
GROUP BY 1
ORDER BY 1 DESC
*/


Solução:

    WITH web AS (
        SELECT DATE_TRUNC('day', w.occurred_at) date,
                COUNT(DISTINCT w.id) web_event_count
        FROM web_events w
        GROUP BY 1
    ),

    order_account AS (
        SELECT DATE_TRUNC('day', o.occurred_at) date,
                COUNT(DISTINCT a.sales_rep_id) sales_rep_count,
                COUNT(DISTINCT o.id) order_count
        FROM accounts a
        JOIN orders o
        ON a.id = o.account_id
        GROUP BY 1
    )

    SELECT COALESCE(w.date, o.date) date,
        w.web_event_count,
        o.sales_rep_count,
        o.order_count
    FROM web w
    FULL JOIN order_account o
    ON w.date = o.date;
