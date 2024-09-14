--select * from housingdata

--Standardise Date format
Select saledate, convert(date, saledate) as Saledateconverted
from housingdata

Update housingdata
set saledate=convert(date, saledate) 

alter table housingdata	
add saledateconverted date;

update housingdata
set saledateconverted = convert(date, saledate)


--populate property address
select * from housingdata
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from housingdata as a
join housingdata as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null

update a
set propertyaddress=isnull(a.propertyaddress, b.propertyaddress)
from housingdata as a
join housingdata as b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.propertyaddress is null

--Breaking out address into separate columns
select propertyaddress
from housingdata 

select 
substring(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) address
,substring(propertyaddress, CHARINDEX(',', propertyaddress)+1, len(propertyaddress)) city
from housingdata

alter table housingdata	
add propertysplitaddress nvarchar(255);

Update housingdata
set PropertyspiltAddress=substring(propertyaddress, 1, CHARINDEX(',', propertyaddress)+1)


alter table housingdata	
add propertysplitcity nvarchar(255);

update housingdata
set propertyspiltcity = substring(propertyaddress, CHARINDEX(',', propertyaddress)+1, len(propertyaddress))
 
select * from housingdata

alter table housingdata
drop column PropertysplitAddress, Propertysplitcity, propertysplitadd

select  
parsename(replace(owneraddress,',','.'), 3),
parsename(replace(owneraddress,',','.'), 2),
parsename(replace(owneraddress,',','.'), 1)
from housingdata

alter table housingdata	
add ownersplitadd nvarchar(255);

Update housingdata
set ownersplitadd =parsename(replace(owneraddress,',','.'), 3)

alter table housingdata	
add ownersplitct nvarchar(255);

update housingdata
set ownersplitct=parsename(replace(owneraddress,',','.'), 2)
 
 alter table housingdata	
add ownersplitstate nvarchar(255);

update housingdata
set ownersplitstate = parsename(replace(owneraddress,',','.'), 1)


select * from housingdata

--Change Y and N to Yes and No in "Sold as Vacant"

select SoldAsVacant,count(SoldAsVacant) from housingdata
group by SoldAsVacant

select
case when SoldAsVacant='Y' then 'Yes'
     When SoldAsVacant='N' then 'No'
	 else SoldAsVacant
	 end
	 from housingdata
	 group by SoldAsVacant

Update housingdata
set SoldAsVacant=
case when SoldAsVacant='Y' then 'Yes'
     When SoldAsVacant='N' then 'No'
	 else SoldAsVacant
	 end

	 select * from housingdata
	 
	 --Remove duplicates
	 
	 with RowNumCTE as(
	 select *,
	 ROW_NUMBER() over(
	 partition by ParcelID,
	 PropertyAddress,
	 SalePrice,
	 SaleDate,
	 LegalReference
	 order by
	 UniqueID) as rownum
	 from housingdata
	 )
	 select *
	 from RowNumCTE
	 where rownum>1

	 --Delete Unused columns
	 select * from housingdata
	 
	 alter table housingdata
	 drop column Owneraddress, TaxDistrict, PropertyAddress

	 
	 alter table housingdata
	 drop column SaleDate