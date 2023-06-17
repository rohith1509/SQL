
select * from Project_Portfolio..NashHouse;

Alter table Project_Portfolio..NashHouse add SaleDateConverted Date;
update Project_Portfolio..NashHouse set SaleDateConverted=convert(Date,SaleDate);


select a.PropertyAddress,a.[UniqueID ],b.PropertyAddress,b.[UniqueID ], ISNULL(b.PropertyAddress,a.PropertyAddress) from Project_Portfolio..NashHouse a
join Project_Portfolio..NashHouse b on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ] where
b.PropertyAddress is null;

update b set 
PropertyAddress=
ISNULL(b.PropertyAddress,a.PropertyAddress) from Project_Portfolio..NashHouse a
join Project_Portfolio..NashHouse b on a.ParcelID=b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ] where
b.PropertyAddress is null;

select * from Project_Portfolio..NashHouse;

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) from Project_Portfolio..NashHouse;
select SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) from Project_Portfolio..NashHouse;

Alter table Project_Portfolio..NashHouse add SplitAddress nvarchar(255);
update Project_Portfolio..NashHouse set SplitAddress=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) from Project_Portfolio..NashHouse;

Alter table Project_Portfolio..NashHouse add SplitCity nvarchar(255);
update Project_Portfolio..NashHouse set SplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) from Project_Portfolio..NashHouse;

select PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from Project_Portfolio..NashHouse;

Alter table Project_Portfolio..NashHouse add OwnerSplitAddress nvarchar(255);
update Project_Portfolio..NashHouse set OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress,',','.'),3) from Project_Portfolio..NashHouse;

Alter table Project_Portfolio..NashHouse add OwnerSplitCity nvarchar(255);
update Project_Portfolio..NashHouse set OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2) from Project_Portfolio..NashHouse;

Alter table Project_Portfolio..NashHouse add OwnerSplitState nvarchar(255);
update Project_Portfolio..NashHouse set OwnerSplitState=PARSENAME(REPLACE(OwnerAddress,',','.'),1) from Project_Portfolio..NashHouse;

select distinct(SoldAsVacant),count(SoldAsVacant) from Project_Portfolio..NashHouse
group by SoldAsVacant order by 2;

update Project_Portfolio..NashHouse set SoldAsVacant=
case when SoldAsVacant='Y' then 'Yes'
when SoldAsVacant='N' then 'No'
else SoldAsVacant
end

with row_num_cte as(
select *,
ROW_NUMBER() over(partition by parcelid,propertyaddress,saleprice,saledate,legalreference order by uniqueid) row_num
from Project_Portfolio..NashHouse 
--order by ParcelID
)
--select * from row_num_cte where row_num>1 order by PropertyAddress;
delete from row_num_cte where row_num>1;


select * from Project_Portfolio..NashHouse;

alter table Project_Portfolio..NashHouse drop column propertyaddress,saledate,owneraddress,taxdistrict;
