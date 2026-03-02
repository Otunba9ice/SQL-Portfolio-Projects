**Nashville Housing Data Cleaning**

**Project Overview**
This project focuses on transforming raw, messy housing data into a structured, analysis-ready format using MySQL. The goal was to take a dataset with inconsistent formatting, missing values, and duplicate entries and apply professional data-cleaning techniques to ensure data integrity for future visualization in Power BI.

**Technical Skills Demonstrated**
Data Standardization: Converting inconsistent date strings into proper SQL DATE formats.

Self-Joins: Populating missing property addresses by matching ParcelID.

Deduplication: Identifying and removing duplicate records using Window Functions (ROW_NUMBER) and CTEs.

Schema Optimization: Cleaning up the database by dropping unused or redundant columns to improve query performance.

**The Cleaning Process**

1. Standardizing Dates
The original SaleDate was stored as a string. I converted this to a proper Date type to allow for time-series analysis.

2. Handling Missing Address Data
I discovered that many rows had a NULL Property Address but shared a ParcelID with another row that did have an address. I used a Self-Join to fill those gaps.

3. Removing Duplicates
I used a CTE and the ROW_NUMBER() function to partition the data by unique identifiers. Any row with a number greater than 1 was flagged as a duplicate.

**The Result**
The final cleaned dataset is now:

Consistent: All dates and addresses follow a unified format.

Accurate: Missing values were populated using logical relationships.

Lean: Redundant columns were removed, reducing the storage footprint and improving Power BI load times.
