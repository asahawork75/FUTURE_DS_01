# Superstore Sales Analysis SQL-Based Exploratory Data Analysis

> **Internship Track:** Data Science & Analytics (`DS`)
> **Repository Name:** `FUTURE_DS_01` 
> **Submitted By:** Arindam Saha
> **Submission Date:** [06-06-2026]

---

## Table of Contents

1. [Project Overview](#-project-overview)
2. [Dataset Description](#-dataset-description)
3. [Tools & Technologies](#tools-technologies)
4. [Database Setup](#database-setup)
5. [Analysis Performed](#-analysis-performed)
6. [Key Insights](#-key-insights)
7. [Repository Structure](#-repository-structure)
8. [How to Run](#-how-to-run)
9. [Author](#author)

---

## Project Overview

This project performs an **Exploratory Data Analysis (EDA)** on the popular **Sample Superstore** dataset using **SQL**. The goal is to extract actionable business insights around revenue, profit, customer behaviour, and regional performance helping stakeholders make data-driven decisions.

The analysis answers the following business questions:

- Which products generate the most revenue and profit?
- How has revenue and profit grown year over year?
- Which product categories are most profitable?
- Which geographic regions drive the most profit?
- What is the most profitable customer segment and category combination?
- Who are the top customers by lifetime revenue?

---

## Dataset Description

| Attribute        | Details                                   |
|------------------|-------------------------------------------|
| **Source**       | Sample Superstore (Public)      |
| **File**         | 'Sample-Superstore.csv'                 |
| **Records**      | 9,994 rows                                |
| **Columns**      | 21                                        |
| **Time Period**  | 2014 to 2017                               |
| **Region**       | United States                             |

### Column Reference

| Column Name     | Description                                      |
|-----------------|--------------------------------------------------|
| `Row ID`       | Unique row identifier                            |
| `Order ID`      | Unique order identifier                          |
| `Order Date`    | Date when the order was placed                   |
| `Ship Date`     | Date when the order was shipped                  |
| `Ship Mode`     | Shipping method (e.g., First Class, Standard)    |
| `Customer ID`   | Unique customer identifier                       |
| `Customer Name` | Full name of the customer                        |
| `Segment`       | Customer segment: Consumer / Corporate / Home Office |
| `Country`       | Country of purchase                              |
| `City`          | City of delivery                                 |
| `State`         | State of delivery                                |
| `Postal Code`   | Postal code of delivery                          |
| `Region`        | US region: West / East / Central / South         |
| `Product ID`    | Unique product identifier                        |
| `Category`      | Product category: Furniture / Office Supplies / Technology |
| `Sub-Category`  | Product sub-category                             |
| `Product Name`  | Full name of the product                         |
| `Sales`         | Sale amount in USD                               |
| `Quantity`      | Number of units ordered                          |
| `Discount`      | Discount applied (0 1 scale)                     |
| `Profit`        | Profit earned in USD                             |

---

## Tools & Technologies

| Tool            | Purpose                        |
|-----------------|--------------------------------|
| **MySQL**       | Database engine & SQL queries  |
| **CSV (Excel)** | Raw data source                |
| **Git & GitHub**| Version control & submission   |

---

##  Database Setup

Follow these steps to load the dataset into MySQL before running the analysis queries.

### Step 1 Create the Database and Table

```sql
CREATE DATABASE superstore;
USE superstore;

CREATE TABLE db (
    row_id        INT,
    order_id      VARCHAR(20),
    order_date    DATE,
    ship_date     DATE,
    ship_mode     VARCHAR(30),
    customer_id   VARCHAR(15),
    customer_name VARCHAR(50),
    segment       VARCHAR(20),
    country       VARCHAR(30),
    city          VARCHAR(50),
    state         VARCHAR(50),
    postal_code   VARCHAR(10),
    region        VARCHAR(15),
    product_id    VARCHAR(20),
    category      VARCHAR(30),
    sub_category  VARCHAR(30),
    product_name  VARCHAR(150),
    sale          DECIMAL(10,2),
    quantity      INT,
    discount      DECIMAL(5,2),
    profit        DECIMAL(10,2)
);
```

### Step 2 Import the CSV

Using MySQL Workbench:
1. Right-click the `db` table **Table Data Import Wizard**
2. Select `Sample_-_Superstore.csv`
3. Map columns and click **Finish**

Or using the command line:
```sql
LOAD DATA INFILE '/path/to/Sample_-_Superstore.csv'
INTO TABLE db
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

### Step 3 Verify the Import

```sql
SELECT COUNT(*) FROM db;  -- Expected: 9994
SELECT * FROM db LIMIT 5;
```

---

## Analysis Performed

All queries are in the file `superstore_sales_anlysis.sql`. Here is a summary of each analysis section:

---

### 1. Top 10 Products by Total Revenue

```sql
SELECT product_name,
    ROUND(SUM(sale),2)          AS total_revenue,
    ROUND(SUM(profit),2)        AS total_profit,
    SUM(quantity)               AS total_quantity,
    COUNT(DISTINCT order_id)    AS num_order
FROM db
GROUP BY product_name
ORDER BY total_revenue DESC
LIMIT 10;
```

**What it answers:** Which individual products are the biggest revenue contributors and how profitable each one is.

---

### 2. Yearly Revenue, Profit & Growth

```sql
SELECT YEAR(order_date)         AS order_year,
    ROUND(SUM(sale), 2)         AS total_revenue,
    ROUND(SUM(profit), 2)       AS total_profit,
    COUNT(DISTINCT order_id)    AS total_orders
FROM db
GROUP BY 1
ORDER BY 1;
```

**What it answers:** Year-over-year business growth across revenue, profit, and order volume.

---

### 3. Category Profitability

```sql
SELECT category,
    ROUND(SUM(sale),2)          AS revenue,
    ROUND(SUM(profit),2)        AS profit,
    COUNT(DISTINCT order_id)    AS orders
FROM db
GROUP BY category
ORDER BY profit DESC;
```

**What it answers:** Which of the three product categories (Furniture, Office Supplies, Technology) is the most profitable.

---

### 4. Region Profitability

```sql
SELECT region,
    ROUND(SUM(sale),2)          AS revenue,
    ROUND(SUM(profit),2)        AS profit,
    COUNT(DISTINCT order_id)    AS orders
FROM db
GROUP BY region
ORDER BY profit DESC;
```

**What it answers:** Which US region (West, East, Central, South) generates the most profit.

---

### 5. Segment × Category Matrix (Most Profitable Combinations)

```sql
SELECT segment, category,
    ROUND(SUM(sale),2)              AS revenue,
    ROUND(SUM(profit),2)            AS profit,
    COUNT(DISTINCT customer_id)     AS orders
FROM db
GROUP BY segment, category
ORDER BY profit DESC;
```

**What it answers:** Which combination of customer segment and product category produces the highest profit — useful for targeted marketing.

---

### 6. Top 10 Customers by Lifetime Revenue

```sql
SELECT customer_name, segment, region,
    COUNT(DISTINCT order_id)    AS total_order,
    ROUND(SUM(sale),2)          AS lifetime_revenue,
    ROUND(SUM(profit),2)        AS lifetime_profit
FROM db
GROUP BY customer_name, segment, region
ORDER BY lifetime_revenue DESC
LIMIT 10;
```

**What it answers:** Who the highest-value customers are, where they are located, and how profitable their orders are.

---

## Key Insights

- **Top Product:** The highest-revenue product was `[Hot File 7-Pocket,Floor stand]` with `$[6532]` in total sales.
- **Year-over-Year Growth:** Revenue grew from `$[14136]` to `$[25295]`
- **Most Profitable Category:** `Technology` tends to have the highest profit margins despite lower volumes than Office Supplies.
- **Strongest Region:** The `West` region consistently leads in profitability.
- **Best Segment Category Pair:** `Consumer × Technology` is typically the most profitable combination.
- **Top Customer:** `[William Brown]` generated `$[5492]` in lifetime revenue across `[5]` orders.

---

## Repository Structure

```
FUTURE_DS_01/
│
├── README.md                        ← Project documentation (this file)
├── Sample_-_Superstore.csv          ← Raw dataset
└── superstore_sales_anlysis.sql     ← All SQL queries for the analysis
```

---

## How to Run

1. **Clone this repository**
   ```bash
   git clone https://github.com/<your-username>/FUTURE_DS_01.git
   cd FUTURE_DS_01
   ```

2. **Open MySQL Workbench** (or any MySQL client)

3. **Create the database and table** using the schema in the [Database Setup](database-setup) section above

4. **Import the CSV** (`Sample_-_Superstore.csv`) using the import wizard or `LOAD DATA INFILE`

5. **Open and run** `superstore_sales_anlysis.sql` execute each block one at a time or run the whole file

6. **Review results**  compare your output with the Key Insights section

---

## Author

| Field         | Details                              |
|---------------|--------------------------------------|
| **Name**      | Arindam Saha                     |
| **Track**     | Data Science & Analytics (DS)        |
| **Task**      | Task 01 Superstore Sales Analysis  |
| **LinkedIn**  | linkedin.com/in/arindam-saha-data-analyst |
| **GitHub**    | github.com/asahawork75        |

---

> *This project was completed as part of the Future Interns Data Science & Analytics internship programme.*
