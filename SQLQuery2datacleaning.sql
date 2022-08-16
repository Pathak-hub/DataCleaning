select *
from [portfolio project]..propertydata
-- to mention only date
Select newsalesdate
from [portfolio project]..propertydata

Alter table propertydata
ADD newsalesdate date


update propertydata
set newsalesdate = convert(date,SaleDate)
--address
select PropertyAddress
from [portfolio project]..propertydata
where PropertyAddress is null


select * 
from [portfolio project]..propertydata
--where PropertyAddress is null
order by ParcelID




--checking if any of the 2 adress with same parcelid is null if yes then add the address of the other one(same parcel id)

select a.ParcelID,b.ParcelID,a.PropertyAddress,b.PropertyAddress,isnull(a.PropertyAddress,b.PropertyAddress)  
from [portfolio project]..propertydata a
join [portfolio project]..propertydata b
  on a.ParcelId = b.ParcelId
  and a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

--updating the table
Update a
set PropertyAddress = isnull(a.propertyaddress,b.propertyaddress)
from [portfolio project]..propertydata a
join [portfolio project]..propertydata b
  on a.parcelId = b.parcelId
  and a.uniqueId <> b.uniqueId
Where a.PropertyAddress is null



--breaking out address into individual city etc
select PropertyAddress
from [portfolio project]..propertydata 



select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) --breakin till comma
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as PropertySplitCity--breakin after comma
  from [portfolio project]..propertydata 


  Alter table propertydata
  add Propertysplitaddress Nvarchar(255)

  update propertydata
  set Propertysplitaddress = substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

  Alter table propertydata
  add PropertySplitCity Nvarchar(255)

  update propertydata
  set PropertySplitCity  = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


  select * 
  from [portfolio project]..propertydata
  
  --breakdown of owner address usin parsename technique
  select OwnerAddress 
  from [portfolio project]..propertydata
 -- select SUBSTRING(OwnerAddress, 1 ,charindex(',',OwnerAddress)-1)
  --,SUBSTRING(OwnerAddress,CHARINDEX(',',OwnerAddress)+1,len(OwnerAddress))
  --from [portfolio project]..propertydata

  select 
  parsename(replace(OwnerAddress,',','.'),3)
  ,parsename(replace(OwnerAddress,',','.'),2)
  ,parsename(replace(OwnerAddress,',','.'),1)
  from [portfolio project]..propertydata

  Alter table propertydata
  add ownersplitaddress nvarchar(255)
  update propertydata
  set ownersplitaddress  = parsename(replace(OwnerAddress,',','.'),3)


  Alter table propertydata
  add ownercityaddress nvarchar(255)
  update propertydata
  set ownercityaddress  = parsename(replace(OwnerAddress,',','.'),2)


  alter table propertydata
  add owneraddressofstate nvarchar
  update propertydata
  set owneraddressofstate = parsename(replace(OwnerAddress,',', '.'),1)
  
select *
from [portfolio project]..propertydata

--exlorin soldasvacant
select distinct(SoldAsVacant),count(SoldAsVacant) as count
from [portfolio project]..propertydata
group by SoldAsVacant

--changing y to yes and n yo no
select SoldAsVacant
,CASE when SoldAsVacant = 'Y' then 'YES'
      when SoldAsVacant = 'N' then 'NO'
	  else SoldAsVacant
	  END
from [portfolio project]..propertydata

--update database
update propertydata
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'YES'
      when SoldAsVacant = 'N' then 'NO'
	  else SoldAsVacant
	  END

--removing the duplictes
--selecting the duplicates
with RownumCTE as(
select *,
    ROW_NUMBER() over(
	partition by parcelID,
	             propertyAddress,
				 SalePrice,
				 LegalReference
				 order by
				    uniqueID
					) row_num
from [portfolio project]..propertydata)
--order by parcelID

 select * from RownumCTE
 where row_num>1
 order by PropertyAddress

 --deleting the duplicate
 with RownumCTE as(
select *,
    ROW_NUMBER() over(
	partition by parcelID,
	             propertyAddress,
				 SalePrice,
				 LegalReference
				 order by
				    uniqueID
					) row_num
from [portfolio project]..propertydata)
--order by parcelID

 delete
 from RownumCTE
 where row_num>1
 --order by PropertyAddress


 --deletin columns
 --select *
 --from [portfolio project]..propertydata
 --alter table propertydata
 --drop column owneraddress,propertyaddress



