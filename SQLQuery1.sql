select *
from SQLPRACTICE..Sheet1$

-- STANDARDIZE Date format

select *  
from SQLPRACTICE..Sheet1$

Alter Table Sheet1$
ADD Saledateconv Date

Update Sheet1$
Set "Saledateconv" = Convert(Date,SaleDate)

-- Populate Property Address

select a.ParcelID ,a.PropertyAddress , b.ParcelID ,b.PropertyAddress, ISnull(a.PropertyAddress,b.PropertyAddress)
from SQLPRACTICE..Sheet1$ a
join SQLPRACTICE..Sheet1$ b
ON a.ParcelID = b.ParcelID
AND b.PropertyAddress = b.PropertyAddress
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISnull(a.PropertyAddress,b.PropertyAddress)
from SQLPRACTICE..Sheet1$ a
join SQLPRACTICE..Sheet1$ b
ON a.ParcelID = b.ParcelID
AND b.PropertyAddress = b.PropertyAddress
Where a.PropertyAddress is null

--- Breaking out address into individual columns(address ,city , state)

select * 
from SQLPRACTICE..Sheet1$

Select
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) 
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1 , LEN(PropertyAddress))
from SQLPRACTICE..Sheet1$

ALTER TABLE Sheet1$
Add Pro Nvarchar(255);

Update Sheet1$
SET Pro = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Sheet1$
Add PropertyCity Nvarchar(255);

Update Sheet1$
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

--Chnage Y and N to yes and no in sold vacant field

Select Distinct(SoldAsVacant)
From SQLPRACTICE..Sheet1$

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From SQLPRACTICE..Sheet1$

Update Sheet1$
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


---- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					ParcelID
					) AS row_num
From SQLPRACTICE..Sheet1$ 
)
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



























