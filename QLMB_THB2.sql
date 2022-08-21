Create database QLMB
Use QLMB
Go
Create Table CHUYENBAY (
	MaCB char(5) primary key,
	GaDi varchar(50), 
	GaDen varchar(50),
	DoDai int,
	GioDi time,
	GioDen time,
	ChiPhi int
)
Go
Create Table MAYBAY (
	MaMB int primary key,
	Hieu varchar(50),
	TamBay int 
)
Go
Create Table NHANVIEN (
	MaNV char(9) primary key,
	Ten varchar(50),
	Luong int
)
Go
Create Table CHUNGNHAN (
	MaNV char(9),
	MaMB int,
	Constraint PK_Khoa primary key(MaNV, MaMB),
	Foreign key(MaNV) references NHANVIEN(MaNV),
	Foreign key(MaMB) references MAYBAY(MaMB)
)

Go

Select * from CHUNGNHAN 
Select * from CHUYENBAY
Select * from MAYBAY
Select * from NHANVIEN
