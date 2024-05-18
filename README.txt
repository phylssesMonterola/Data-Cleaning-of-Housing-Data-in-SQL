This project explores Data Cleaning in SQL using SQL Server Management Studio

This project also involves importing excel worksheets to SQL Server Management Studio and serves as a practice ground for writing SQL scripts

What we 'cleaned':

1. Checked for NULL values and figured out a way to fill these values using Joins and aggregate functions like ISNULL(). Updating the changes using UPDATE + SET statements.

2. Split PropertyAddress and OwnerAddress into different columns using aggregate functions like SUBSTRING(), CHARINDEX(), LEN(). Change the data type of some columns using ALTER.

3. Change SoldAsVacant column values from binary [0,1] to 'No' and 'Yes' by using CASE statement

4. Deleted duplicates by using Common Table Expressions, Partition By, etc.

5. Removing irrelevant columns by using Alter + Drop Column statement.
