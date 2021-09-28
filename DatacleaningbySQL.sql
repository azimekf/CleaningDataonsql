--Cleaning Data In SQL

SELECT *
From aa..housing

--Standardize SaleDate

  

Alter Table housing
Add SaleDateconverted Date;

Update housing
Set SaleDateconverted= convert(Date,SaleDate);

-- Populate property address data

 

Update a 
Set PropertyAddress= Isnull(a.PropertyAddress,b.PropertyAddress)
From aa..housing a
Join aa..housing b
	on a.ParcelID=b.ParcelID
	AND A.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking address into Indivisul columns

Select
substring(PropertyAddress,1,charindex(',',PropertyAddress)-1) as address,
substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)+1) as city
from aa..housing



Alter Table housing
Add Propertysplitadd nvarchar(255);

Update housing
Set Propertysplitadd= substring(PropertyAddress,1,charindex(',',PropertyAddress)-1);

Alter Table housing
Add Propertysplitcity nvarchar(255);

Update housing
Set Propertysplitcity= substring(PropertyAddress,charindex(',',PropertyAddress)+1,len(PropertyAddress)+1);

Select * 
From aa..housing

--Use Parsename to Split Address

Select
	PARSENAME(Replace(OwnerAddress,',','.'),3)
	PARSENAME(Replace(OwnerAddress,',','.'),2)
	PARSENAME(Replace(OwnerAddress,',','.'),1)
From aa..housing

Alter Table housing
	Add Ownersplitadd nvarchar(255);

Update housing
	Set Ownersplitadd=PARSENAME(Replace(OwnerAddress,',','.'),3);

Alter Table housing
	Add Ownersplitcity nvarchar(255);

Update housing
	Set Ownersplitcity=PARSENAME(Replace(OwnerAddress,',','.'),2);

Alter Table housing
	Add Ownersplitstate nvarchar(255);

Update housing
	Set Ownersplitstate=PARSENAME(Replace(OwnerAddress,',','.'),1);

Select *
from aa..housing


--Replace 'N' and 'Y' by 'NO' and 'Yes'

Select Distinct (SoldasVacant), Count(SoldasVacant)
From aa..housing
Group by SoldasVacant

Select SoldasVacant
,Case when SoldasVacant='y' then 'Yes'
      when SoldasVacant='n' then 'No'
	  Else SoldasVacant
	  End
From aa..housing

Update housing
Set SoldasVacant= Case when SoldasVacant='y' then 'Yes'
      when SoldasVacant='n' then 'No'
	  Else SoldasVacant
	  End

-- Delete Duplicates

Select *
From aa..housing

with RownumCTE AS(
Select * ,
	ROW_NUMBER () over 
	(Partition by UniqueID,
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				order by UniqueID) Row_num
from aa..housing
)
DELETE
From RownumCTE
WHERE row_num>1

--Delete Unused Column

Select *
From aa..housing

Alter Table aa..housing
Drop column PropertyAddress,SaleDate,OwnerAddress
			


