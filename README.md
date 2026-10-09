# Mini Project 05: Advanced SQL - Window Functions

## Project Overview
This project demonstrates advanced SQL analytical techniques using the classicmodels relational database. The primary objective is to execute complex calculations—including price hierarchies, customer lifetime payment tracking, month-over-month growth rates, and moving averages.

---

## SQL Concepts

### 1. Window Functions
Window Functions perform calculations across a set of rows while retaining individual row identities. This allows you to display detailed attribute data alongside aggregated metrics in the same output row.
#### 2 Kinds of Window Functions
* **PARTITION BY**: Divides the query result set into partitions (subsets). The window function is applied to each partition separately, resetting calculations when crossing partition boundaries.
* **ORDER BY**: Defines the logical sequence of rows within each partition. This is critical for sequential operations such as ranking items by price or calculating chronological running totals.

### 2. Ranking Functions
When ranking data with identical values (ties), each function behaves differently.
* **ROW_NUMBER()**: Assigns a unique, sequential integer to every row starting at 1. It strictly avoids ties by assigning arbitrary order among identical values.
* **RANK()**: Assigns identical ranks to duplicate values, but skips subsequent rank numbers to maintain position count.
* **DENSE_RANK()**: Assigns identical ranks to duplicate values without skipping subsequent numbers.

### 3. Common Table Expressions (CTEs), WITH
A CTE creates a temporary named result set that exists only within the execution scope of a single query. CTEs are used here to:
1. Break complex multi-stage calculations into readable steps.
2. Bypassing SQL order-of-execution limitations.

### 4. Time-Series Windowing
* **LAG(column, offset)**: Accesses data from a preceding row at a specified offset without requiring a self-JOIN. Used to pull previous month revenue for growth comparisons.
* **LEAST(arg1, arg2, ...)**: Returns the smallest value among the provided arguments. Used to dynamically scale the moving average denominator during initial months (dividing by 1 in Month 1, 2 in Month 2, and capping at 3 for Month 3 onwards).

---
