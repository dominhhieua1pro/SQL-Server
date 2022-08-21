Create Database SPJ
Use SPJ
Go
Create Table NCC (
	MaNCC char(5) primary key,
	Ten varchar(40),
	Heso int check(Heso between 0 and 100) default(0),
	ThPho varchar(20)
)
Go
Create Table VATTU (
	MaVT char(5) primary key,
	Ten varchar(40) not null,
	Mau varchar(15) unique,
	TrLuong float check(TrLuong >= 2.0),
	ThPho varchar(20) not null
)
Go
Create Table DUAN (
	MaDA char(5) primary key,
	Ten varchar(40) ,
	ThPho varchar(20)
)
Go
Create Table CC (
	MaNCC char(5),
	MaVT char(5), 
	MaDA char(5),
	SoLuong int default(0),
	Constraint PK_Khoa primary key(MaNCC, MaVT, MaDA),
	Foreign key(MaNCC) references NCC(MaNCC),
	Foreign key(MaVT) references VATTU(MaVT),
	Foreign key(MaDA) references DUAN(MaDA)
)
Go
Create index ID_MaNCC on NCC(MaNCC)
Create index ID_MaVT on VATTU(MaVT)
Create index ID_MaDA on DUAN(MaDA)

Select * from CC
Select * from DUAN
Select * from NCC
Select * from VATTU
