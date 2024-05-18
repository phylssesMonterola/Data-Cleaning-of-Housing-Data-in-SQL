/*Data Cleaning in SQL*/

/*Let's take a look at our data set and all of its columns*/
Select *
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
/*We allowed NULL values in our import process*/


--------------------------------------------------------------------
/*Property Address Data contains NULL values. Let's do something about that*/
/*Check to see that there are repeating ParcelID values with repeating PropertyAddress values as well*/
Select *
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
order by ParcelID
/*We choose to check ParcelID and PropertyAddress because these values are expected to be unique and unchanging*/
/*Let's try attempting to do a 'self join' to see if a particular ParcelID with a PropertyAddress would share/correspond the same with it's joined copy */
Select x.ParcelID, 
	   x.PropertyAddress, 
	   y.ParcelID, 
	   y.PropertyAddress,
	   ISNULL(x.PropertyAddress, y.PropertyAddress) --if x is null, it's going to be replaced by y
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data] x
JOIN [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data] y
	on x.ParcelID = y.ParcelID
	and x.UniqueID <> y.UniqueID --Same ParcelID implies same PropertyAddress, however they're going to end up with different UniqueIDs
Where x.PropertyAddress is null --One PropertyAddress column shows null values. The null values will be replaced by the values shown by the other PropertyAddress column
/*For the above code to take effect. Do an update*/
Update x
SET PropertyAddress = ISNULL(x.PropertyAddress, y.PropertyAddress)
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data] x
JOIN [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data] y
	on x.ParcelID = y.ParcelID
	and x.UniqueID <> y.UniqueID 
Where x.PropertyAddress is null


--------------------------------------------------------------------
/*Let us split PropertyAddress into two individual columns: PropertySplitAddress, PropertySplitCity*/
Select PropertyAddress,
	   SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1),
	   --SUBSTRING(string you want to extract from, starting position of the substring, length of the substring [int])
	   --CHARINDEX(substring you're searching, string within which you're searching for it, starting position of the search within the string)
	   SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
	   --LEN() is used to get the length of a string
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
/*Let's add PropertySplitAddress and PropertySplitCity columns with both having nvarchar data type*/
Alter Table [Nashville Housing Data] Add PropertySplitAddress nvarchar(255)
Alter Table [Nashville Housing Data] Add PropertySplitCity nvarchar(255)
/*Let's update our table for our changes to take effect*/
Update [Nashville Housing Data] SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)
Update [Nashville Housing Data] SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
/*Let's check on our table to see if changes are applied*/
Select *
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
/*Newly created columns after the update are placed to the furthest right*/


--------------------------------------------------------------------
/*Let us split OwnerAddress into three individual columns: OwnerSplitAddress, OwnerSplitCity, OwnerSplitState*/
Select OwnerAddress,
	   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
	   --parse: to divide (a sentence) into grammatical parts and identify the parts and their relations to each other
	   --PARSENAME(object name (such as a table or column name), component number to extract (from right to left))
	   --REPLACE(original string, substring to find, substring to replace it with)
	   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
	   PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
/*Now that we have our split outputs. Let us apply them to our table by altering and updating*/
Alter Table [Nashville Housing Data] Add OwnerSplitAddress nvarchar(255)
Alter Table [Nashville Housing Data] Add OwnerSplitCity nvarchar(255)
Alter Table [Nashville Housing Data] Add OwnerSplitState nvarchar(255)
Update [Nashville Housing Data] SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
Update [Nashville Housing Data] SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
Update [Nashville Housing Data] SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
/*Let's check on our table to see if changes are applied*/
Select *
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
/*Newly created columns after the update are placed to the furthest right*/


--------------------------------------------------------------------
/*Sold as vacant has binary as values where 0 indicates No and 1 means Yes. Let's change this*/
Select Distinct(SoldAsVacant),
	   Count(SoldAsVacant)
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
Group By SoldAsVacant
/*Let's turn 0 to No and 1 to Yes using Case Statements*/
/*Let's alter the data type of SoldAsVacant to nvarchar*/
Alter Table [Nashville Housing Data] Alter Column SoldAsVacant nvarchar(255)
Select SoldAsVacant,
	   CASE
	     When SoldAsVacant = '1' THEN 'Yes'
	     When SoldAsVacant = '0' THEN 'No'
	     Else SoldAsVacant
	   END
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
/*Apply these change by update*/
Update [Nashville Housing Data] SET SoldAsVacant = 
CASE
  When SoldAsVacant = '1' THEN 'Yes'
  When SoldAsVacant = '0' THEN 'No'
  Else SoldAsVacant
END
/*Run the script below to see if changes are in effect*/
Select *
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]


--------------------------------------------------------------------
/*Let's get rid of duplicates now*/
/*We'll do it using Common Table Expressions*/
WITH RowNumCTE AS(
Select *,
	   ROW_NUMBER() OVER
	     ( PARTITION BY ParcelID,
					  SalePrice,
					  SaleDate,
					  LegalReference
		 ORDER BY UniqueID ) row_num
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]
)
SELECT * --Change Select * to Delete if you want to delete duplicates 
From RowNumCTE
Where row_num > 1 --made possible because of Partition By clause
/*Check if changes are in effect*/
Select *
From [Data_Cleaning_Housing_Data].[dbo].[Nashville Housing Data]


--------------------------------------------------------------------
/*Lastly, let's remove unused columns*/
ALTER Table [Nashville Housing Data] Drop Column OwnerAddress,
												 TaxDistrict,
												 PropertyAddress,
												 SaleDate





