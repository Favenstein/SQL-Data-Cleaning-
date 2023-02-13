
--CLEANING DATA IN SQL QUERIES............................................................................................

Select *
From NashvilleHousing


--.........................................................................................................................
-- Standardize Date

select saledate, (convert(date,SaleDate))
from NashvilleHousing

Update NashvilleHousing
Set SaleDate = convert(date,SaleDate)

-- it did not work properly so i am Adding New a Column To Table

alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = convert(date,SaleDate)

Select SaleDateConverted
From NashvilleHousing

--...................................................................................................

--cleaning property address

						--checking for null values

Select PropertyAddress
from NashvilleHousing
Where PropertyAddress is null

--Populating PropertyAddress with ref to ParcelID

Select a.ParcelID, a.propertyaddress, b.ParcelID, b.propertyaddress, isnull(a.propertyaddress,b.propertyaddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
Set PropertyAddress = isnull(a.propertyaddress,b.propertyaddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--DONE!

--------------------------------------------------------------------------------------------------------------------------

-- Seperating Address into Individual Columns (Address, City, State)

Select PropertyAddress
From NashvilleHousing

Select
substring(PropertyAddress, 1, charindex(',',propertyaddress) -1) as Address
, substring(PropertyAddress, charindex(',',propertyaddress) +1, len(propertyaddress)) as City

From NashvilleHousing

alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',',propertyaddress) -1)

alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = substring(PropertyAddress, charindex(',',propertyaddress) +1, len(propertyaddress))

Select *
From NashvilleHousing


--OWNER ADDRESS SPLIT

Select OwnerAddress
From NashvilleHousing



Select
parsename(replace(OwnerAddress, ',', '.') ,3) OwnerSplitAddress
,parsename(replace(OwnerAddress, ',', '.') ,2) OwnerSplitCity
,parsename(replace(OwnerAddress, ',', '.') ,1) OwnerSplitState
From NashvilleHousing

--Now altering and updating table


alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.') ,3)


alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.') ,2)


alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.') ,1)


Select *
From NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT SoldAsVacant, COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant

Select SoldAsVacant
, CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE	WHEN SoldAsVacant = 'Y' THEN 'Yes'
		WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END




-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates



WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN SaleDate









