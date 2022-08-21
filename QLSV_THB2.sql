Create database QLSV_THB2
USE QLSV_THB2
go


Create table SinhVien (
MaSV int primary key,
TenSV nvarchar(25) not null,
GT nvarchar(3) default N'Nam',
Ngaysinh date check(Ngaysinh < getdate()),
Que nvarchar(20) not null,
Lop varchar(5)
)
Go


Create table MonHoc (
MaMH int primary key,
TenMH nvarchar(20) unique,
DHVT int check(DHVT >= 2 and DHVT <= 9)
)
Go


Create table KetQua (
MaSV int,
MaMH int,
Diem int check(Diem >= 0 and Diem <= 10),
Constraint PK_Khoa_KQ Primary key(MaSV, MaMH),
Constraint FK_KhoaN1_KQ Foreign Key(MaSV) references SinhVien(MaSV),
Constraint FK_KhoaN2_KQ Foreign Key(MaMH) references MonHoc(MaMH)
)
Go


Insert SinhVien Values(1, N'Trần Bảo Trọng', N'Nam', 1995-12-14, N'Hà Giang', 'L02')
Insert SinhVien Values(2, N'Lê Thùy Dương', N'Nữ', 1997-05-12, N'Hà Nội', 'L03')
Insert SinhVien Values(3, N'Trần Phương Thảo', N'Nam', 1996-03-30, N'Quảng Ninh', 'L01')
Insert SinhVien Values(4, N'Lê Trường An', N'Nam', 1995-11-20, N'Ninh Bình', 'L04')
Insert SinhVien Values(5, N'Phạm Thị Hương Giang ', N'Nữ', 1999-02-21, N'Hòa Bình', 'L02')
Insert SinhVien Values(6, N'Trần Anh Bảo', N'Nam', 1995-12-14, N'Hà Giang', 'L02')
Insert SinhVien Values(7, N'Lê Thùy Dung', N'Nữ', 1997-05-12, N'Hà Nội', 'L03')
Insert SinhVien Values(8, N'Phạm Trung Tính', N'Nam', 1996-03-30, N'Quảng Ninh', 'L01')
Insert SinhVien Values(9, N'Lê An Hải', N'Nam', 1995-11-20, N'Ninh Bình', 'L04')
Insert SinhVien Values(10, N'Phạm Thị Giang Hương', N'Nữ', 1999-02-21, N'Hòa Bình', 'L02')
Go

Insert MonHoc Values(1, N'Toán cao cấp', 3)
Insert MonHoc Values(2, N'Mạng máy tính', 3)
Insert MonHoc Values(3, N'Tin đại cương', 4)
Go

Insert KetQua Values(1, 1, 8)
Insert KetQua Values(1, 2, 5)
Insert KetQua Values(1, 3, 7)
Insert KetQua Values(2, 1, 9)
Insert KetQua Values(2, 2, 5)
Insert KetQua Values(2, 3, 2)
Insert KetQua Values(3, 1, 4)
Insert KetQua Values(3, 2, 2)
Insert KetQua Values(4, 1, 1)
Insert KetQua Values(4, 2, 3)



