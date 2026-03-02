/*
==================================================================
Project: Data Cleaning for Nashville Housing Dataset
Tool: MySQL
Purpose: Transform raw housing data for Power BI analysis
==================================================================
*/



/*
================================================
 Creating Table for our Nashiville Properties
=================================================
*/

Drop Table Nashiville_properties;
Create Table Nashiville_properties(
Property_id  int (10) not null primary key,
Parcel_id varchar(225),
Land_use varchar(225),
Property_add Varchar(250),
Suite varchar (250),
Property_city varchar (250),
Sale_date Varchar(225),
Sale_price varchar(50),
Legal_reference Varchar(225),
Sold_As_Vacant Varchar(225),
Multiple_parcels Varchar(225),
Owner_name Varchar(225),
Address Varchar(225),
City varchar(100),
State varchar (50),
Acreage varchar(100),
Tax_district Varchar(225),
Neighbourhood varchar(10),
Image Varchar(100),
Land_value varchar(100),
Building_value varchar(100),
Total_value varchar(100),
Finished_Area varchar(250),
Foundation_type Varchar(100),
Year_Built Varchar(10),
Exterior_wall Varchar (100),
Grade Varchar(10),
Bedroom varchar(10),
Full_bath varchar(10),
Half_bath varchar(10)
)

/*
====================================================
Impoerting the File to the new Table Created
====================================================
*/

SET GLOBAL local_infile = 1; -- Enables local loading
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/SQL Datasets/Nashville_housing_data_2013_2016.csv'
INTO TABLE nashiville_properties
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- Skips the header row


/*
================================================
1. Standardize date Format
Converting string date to a proper SQL Date
=================================================
*/

Alter Table nashiville_properties
Add Column SaleDateConverted Date;

Update nashiville_properties
Set SaleDateConverted = str_to_date(Sale_date, '%m/%d/%Y');

/*
======================================================================
2. Populate property address Data
using a self join to filling in missing addresss where ParcelIDs Match
=======================================================================
*/

Update nashiville_properties a
Join nashiville_properties b
	ON a.Parcel_id = b.Parcel_id
    And a.Property_id <> b.Property_id
Set a.Property_add = ifnull(a.Property_add, b.Property_add)
Where a.Property_add is null;

/* 
=========================================
3. Remove duplicate
We use a CTE to identify them.
=========================================
*/
With RownumCTE as (
	Select *,
		Row_Number() Over(
			partition by Parcel_id, Property_add, Sale_price, Sale_date, Legal_reference
            Order By Property_id
		) As row_num
	from
		nashiville_properties
)
select * from RownumCTE where row_num > 1

/*
========================================================
4. Delete Unused columns 
========================================================
*/
Alter Table nashiville_properties
Drop column Tax_district,
Drop Column Neighbourhood,
Drop Column Legal_reference;

