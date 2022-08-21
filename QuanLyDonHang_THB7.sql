Create Database QuanLyDonHang
Use QuanLyDonHang
go

Create table NhanVien(
	MaNV int not null primary key identity(1,1),
	HoTen nvarchar(30),
	DiaChi nvarchar(30),
	SDT varchar(15),
	NgaySinh date,
	GT nvarchar(10),
	HSL float
)

Create table Hang(
	MaHang int not null primary key identity(1,1),
	TenHang nvarchar(30),
	NhaSX nvarchar(30),
	TGianBaoHanh int
)

Create table KhachHang(
	MaKH int not null primary key identity(1,1),
	TenKH nvarchar(30),
	CMT varchar(15),
	DiaChi nvarchar(30),
	SoDienThoai varchar(15),
	Email varchar(30)
)

Create table HoaDonXuat(
	MaHD int not null primary key,
	MaKH int,
	NgayLapHD date,
	MaNV int,
	PhuongThucTT nvarchar(50)
)

Create table CT_HoaDon(
	MaHD int,
	MaHang int,
	SoLuongMua int,
	DonGia float,
	Constraint PK_CTHD primary key (MaHD, MaHang)
)

Alter table HoaDonXuat add constraint FK_HoaDonXuat_KhachHang_MaKH foreign key  (MaKH) References KhachHang(MaKH);
Alter table HoaDonXuat add constraint FK_HoaDonXuat_NhanVien_MaNV foreign key  (MaNV) References NhanVien(MaNV);
Alter table CT_HoaDon add constraint FK_CT_HoaDon_HoaDonXuat_MaHD foreign key  (MaHD) References HoaDonXuat(MaHD);
Alter table CT_HoaDon add constraint FK_CT_HoaDon_Hang_MaHang foreign key  (MaHang) References Hang(MaHang);



--Bài 2: Viết các hàm và thủ tục để:
--	Tính tổng tiền đã mua hàng của một khách hàng nào đó theo mã KH
--Function
Go
Create Function TongTienHangKH1(@MaKH int)
Returns int
As
Begin
	Return ( Select Sum(SoLuongMua * DonGia)
			 From (KHACHHANG kh join HOADONXUAT hdx On kh.MaKH = hdx.MaKH) join CT_HOADON cthd On hdx.MaHD = cthd.MaHD
			 Where kh.MaKH = @MaKH )
End
Go

Select MaKH, dbo.TongTienHangKH1(MaKH) as N'Tổng Tiền Hàng' From KhachHang

--Procedure
Go
Create Proc TongTienHangKH2(@MaKH int)
As
Begin
	Select Sum(SoLuongMua * DonGia) as TongTienHang
	From (KHACHHANG kh join HOADONXUAT hdx On kh.MaKH = hdx.MaKH) join CT_HOADON cthd On hdx.MaHD = cthd.MaHD
	Where kh.MaKH = @MaKH
End
Go

TongTienHangKH2 2

--	Cho biết tổng số tiền hàng đã mua của một hóa đơn nào đó
--Function
Go
Create Function TongTienHangHD1(@MaHD int)
Returns int
As
Begin
	Return ( Select Sum(SoLuongMua * DonGia)
			 From CT_HOADON cthd
			 Where MaHD = @MaHD )
End
Go

Select MaHD, dbo.TongTienHangHD1(MaHD) as N'Tổng Tiền Hàng' From HoaDonXuat

--Procedure
Go
Create Proc TongTienHangHD2(@MaHD int)
As
Begin
	Select Sum(SoLuongMua * DonGia) as TongTienHang
	From CT_HOADON cthd
	Where MaHD = @MaHD
End
Go

TongTienHangHD2 2

--	Cho biết tổng số tiền hàng đã bán của một tháng nào đó.
--Function
Go
Create Function TongTienHangThang1(@Thang int)
Returns int
As
Begin
	Return ( Select Sum(SoLuongMua * DonGia)
			 From HOADONXUAT hdx join CT_HOADON cthd On hdx.MaHD = cthd.MaHD
			 Where month(NgayLapHD) = @Thang )
End
Go

Select distinct month(NgayLapHD) as 'Tháng', dbo.TongTienHangThang1(month(NgayLapHD)) as N'Tổng Tiền Tháng' From HoaDonXuat

--Procedure
Go
Create Proc TongTienHangThang2(@Thang int)
As
Begin
	Select Sum(SoLuongMua * DonGia) as TongTienHang
	From HOADONXUAT hdx join CT_HOADON cthd On hdx.MaHD = cthd.MaHD
	Where month(NgayLapHD) = @Thang
End
Go

TongTienHangThang2 4

--	Cho biết họ tên của nhân viên có tuổi cao nhất
--Function
Go
Create Function Tuoi_Max1()
Returns Table
As
Return ( Select HoTen From NHANVIEN
		 Where year(getdate()) - year(NgaySinh) = (Select Max(year(getdate()) - year(NgaySinh)) From NHANVIEN) )
Go

Select * From Tuoi_Max1()

--Procedure
Go
Create Proc Tuoi_Max
As
Begin
	Declare @TuoiMax int
	Set @TuoiMax = (Select Max(year(getdate()) - year(NgaySinh)) From NHANVIEN)
	Select HoTen, @TuoiMax as N'Tuổi' From NHANVIEN
	Where year(getdate()) - year(NgaySinh) = @TuoiMax
End
Go

Tuoi_Max
