Anotações Módulo 5 - Data Cleaning

## LEFT, RIGHT, LENGTH

In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.

    SELECT COUNT(DISTINCT right(website, 3))
    FROM accounts;

There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).

    SELECT LEFT(name, 1) first_letter, COUNT(*)
    FROM accounts
    GROUP BY 1
    ORDER BY 1;

Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?

    WITH fl AS (
        SELECT name,
               LEFT(name, 1) first_letter
        FROM accounts
        )
    SELECT CASE WHEN first_letter IN ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN 'number'
                ELSE 'letter' END AS clas,
           COUNT(*)
    FROM fl
    GROUP BY 1;

Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?

    WITH fl AS (
      SELECT name,
             UPPER(LEFT(name, 1)) first_letter
      FROM accounts
    )
    SELECT CASE WHEN first_letter IN ('A', 'E', 'I', 'O', 'U') THEN 'vowels'
                ELSE 'other' 
                END AS clas,
    COUNT(*) qtd
    FROM fl
    GROUP BY 1;

    
## POSITION e STRPOS

Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.

    SELECT primary_poc,
        LEFT( primary_poc, STRPOS(primary_poc, ' ') - 1 ) AS first_name,
        RIGHT( primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ') ) AS last_name
    FROM accounts;

Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.

    SELECT name,
        LEFT(name, STRPOS(name, ' ') - 1 ) AS first_name,
        RIGHT(name, LENGTH(name) - STRPOS(name, ' ') ) AS last_name
    FROM sales_reps;

    
## CONCAT e ||

Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.

    WITH t1 AS (
        SELECT primary_poc,
               LOWER( LEFT( primary_poc, STRPOS(primary_poc, ' ') - 1 ) ) AS first_name,
               LOWER( RIGHT( primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ') ) ) AS last_name
        FROM accounts
    )
    SELECT primary_poc, 
        CONCAT(first_name, '.', last_name, '@parchandposey.com')
    FROM t1;

You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.

    WITH t1 AS (
        SELECT primary_poc,
            LOWER( LEFT( primary_poc, STRPOS(primary_poc, ' ') - 1 ) ) AS first_name,
            LOWER( RIGHT( primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ') ) ) AS last_name,
            LOWER(name) company_name
        FROM accounts
    )
    SELECT primary_poc, 
        first_name || '.' || last_name || '@' || REPLACE(company_name, ' ', '') || '.com'
    FROM t1;

We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.

    WITH t1 AS (
        SELECT primary_poc,
            LOWER( LEFT( primary_poc, STRPOS(primary_poc, ' ') - 1 ) ) AS first_name,
            LOWER( RIGHT( primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ') ) ) AS last_name,
            LOWER(name) company_name
        FROM accounts
    )
    SELECT primary_poc,
        CONCAT(
            LEFT(first_name, 1),
            RIGHT(first_name, 1),
            RIGHT(last_name, 1),
            LENGTH(first_name),
            LENGTH(last_name),
            UPPER( REPLACE(company_name, ' ', '') )
        ) AS password
    FROM t1;

## CAST

Write a query to change the date into the correct SQL date format. You will need to use at least SUBSTR and CONCAT to perform this operation.

    WITH t1 AS (
        SELECT date,
            LEFT(date, 2) mes,
            SUBSTRING(date FROM 4 FOR 2) AS dia,
            SUBSTRING(date FROM 7 FOR 4) AS ano
        FROM sf_crime_data
    )
    SELECT ano || '-' || mes || '-' || dia AS data_
    FROM t1;

Once you have created a column in the correct format, use either CAST or :: to convert this to date.
    
    WITH t1 AS (
        SELECT date,
            LEFT(date, 2) mes,
            SUBSTRING(date FROM 4 FOR 2) AS dia,
            SUBSTRING(date FROM 7 FOR 4) AS ano
        FROM sf_crime_data
    )
    SELECT (ano || '-' || mes || '-' || dia)::DATE AS data_
    FROM t1;

