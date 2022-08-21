USE QLSV_THB2
Go


--
select MaSV, TenSV,
case 
	when GT = N'Nam' then N'Đây là nam'
	when GT = N'Nữ' then N'Đây là nữ'
	else N'Không Xác định'
end as 'Thông tin'
from Sinhvien	
Go

Select Sinhvien.MaSV as 'Mã Sinh viên',TenSV as 'Họ và tên', TenMH as 'Tên môn',Diem as 'Điểm',
Case
  when (Diem<4) then N'Thi lại'
  when (Diem >=4) and (Diem<6) then N'Trung bình'
  when (Diem >=6) and (Diem<7) then N'Trung bình khá'
  when (Diem>=7) and (Diem<8) then N'Khá'
  when (Diem>=8) and (Diem<9) then N'Giỏi'
  when (Diem is null) then N'Thi lại'
  else N'Xuất sắc'
end as N'Xếp Loại'
from Sinhvien, Monhoc, Ketqua
where (Sinhvien.MaSV = Ketqua.MaSV) and (Monhoc.MaMH = Ketqua.MaMH)
Go
--sắp xếp theo chiều tăng dần của MaSV, nếu nhiều MaSV mà giống nhau thì xếp điểm giảm dần
select * from Ketqua
order by MaSV, Diem DESC

	
USE QLSV_THB2
Go


--1.	Cho biết mã môn học, tên môn học,  điểm thi  tất cả các môn của sinh viên tên Thức
Select mh.MaMH, mh.TenMH, Diem 
From ( Sinhvien sv join KetQua kq On sv.MaSV = kq.MaSV ) join MonHoc mh On mh.MaMH = kq.MaMH
Where sv.TenSV Like N'% Thức'

--2.	Cho biết mã môn học, tên môn và điểm thi ở những môn mà sinh viên tên Dung phải thi lại (điểm<5)
Select mh.MaMH, mh.TenMH, Diem 
From ( Sinhvien sv join KetQua kq On sv.MaSV = kq.MaSV ) join MonHoc mh On mh.MaMH = kq.MaMH
Where sv.TenSV Like N'% Dung'and Diem < 5

--3.	Cho biết mã sinh viên, tên những sinh viên đã thi ít nhất là 1 trong 3 môn Lý thuyết Cơ sở dữ liệu, Tin học đại cương, mạng máy tính.
Select Distinct sv.MaSV, sv.TenSV 
From ( Sinhvien sv join KetQua kq On sv.MaSV = kq.MaSV ) join MonHoc mh On mh.MaMH = kq.MaMH
Where mh.TenMH = N'Lý thuyết cơ sở dữ liệu' or mh.TenMH = N'Tin học đại cương' or mh.TenMH = N'Mạng máy tính'

--4.	Cho biết mã môn học, tên môn mà sinh viên có mã số 1 chưa có điểm 
Select MaMH, TenMH From MonHoc
Except
Select mh.MaMH, mh.TenMH
From ( Sinhvien sv join KetQua kq On sv.MaSV = kq.MaSV ) join MonHoc mh On mh.MaMH = kq.MaMH
Where sv.MaSV = 1

--5.	Cho biết điểm cao nhất môn 1 mà các sinh viên đạt được
Select Max(Diem) as 'Diem cao nhat mon 1' From KetQua
Where MaMH = 1

--6.	Cho biết mã sinh viên, tên những sinh viên có điểm thi môn 2 không thấp nhất khoa
Select Distinct sv.MaSV, sv.TenSV 
From Sinhvien sv Join KetQua kq On sv.MaSV = kq.MaSV
Where MaMH = 2 and Diem != (Select Min(Diem) From KetQua Where MaMH = 2)
			

--9.	Đối với mỗi môn, cho biết tên môn và số sinh viên phải thi lại môn đó mà số sinh viên thi lại >=2
Select TenMH, Count(MaSV) as 'So SV thi lai'
From MonHoc join KetQua On KetQua.MaMH = MonHoc.MaMH
Where Diem is null or Diem < 5
Group By TenMH
Having Count(MaSV) >= 2


--10.	Cho biết mã sinh viên, tên và lớp của sinh viên đạt điểm cao nhất môn Tin đại cương
Select Top (1) SinhVien.MaSV, TenSV, Lop
From ( KetQua join MonHoc On Ketqua.MaMH = MonHoc.MaMH ) join SinhVien On SinhVien.MaSV = KetQua.MaSV
Where TenMH = N'Tin học đại cương'
Order By Diem Desc


--11.	Đối với mỗi lớp, lập bảng điểm gồm mã sinh viên, tên sinh viên và điểm trung bình chung học tập. 
Select Distinct sv.MaSV, TenSV, DTB1N as 'Diem TBC', Lop
From (	Select MaSV, Sum(Cast(Diem * DHVT as float)) / Sum(DHVT) as DTB1N
		From KetQua kq join MonHoc mh On kq.MaMH = mh.MaMH
		Group By MaSV ) as a right join SinhVien sv 
		On a.MaSV = sv.MaSV
Group By Lop, sv.MaSV, TenSV, DTB1N

--12.	Đối với mỗi lớp, cho biết mã sinh viên và tên những sinh viên phải thi lại từ 2 môn trở lên

Select SinhVien.MaSV, TenSV, Lop
From SinhVien join KetQua On KetQua.MaSV = SinhVien.MaSV
Where Diem is null or Diem < 5
Group By Lop, SinhVien.MaSV, TenSV
Having Count(KetQua.MaMH) >= 2

--13.	Cho biết mã số và tên của những sinh viên tham gia thi tất cả các môn.

Select SinhVien.MaSV, SinhVien.TenSV From SinhVien
Where not exists (	Select * From KetQua as KQ1, MonHoc Where MonHoc.MaMH = KQ1.MaMH
					and not exists (Select * From KetQua as KQ2 Where KQ2.MaSV = SinhVien.MaSV and KQ1.MaMH = KQ2.MaMH))

--14.	Cho biết mã sinh viên và tên của sinh viên có điểm trung bình chung học tập >=6
select Tensv, AVG(CAST(Diem as float)) as Diemtb
from Sinhvien sv, Ketqua kq
where sv.Masv = kq.Masv
group by Tensv
having AVG(CAST(Diem as float)) >= 6

--15.	Cho biết mã sinh viên và tên những sinh viên phải thi lại ở ít nhất là những môn mà sinh viên có mã số 3 phải thi lại

Select Distinct sv.MaSV, TenSV
From ( SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV) join MonHoc mh On mh.MaMH = kq.MaMH
Where sv.Masv != 3 and (Diem < 5 or Diem is null) 
and TenMH in (	Select TenMH From Monhoc mh, Ketqua kq
				Where mh.Mamh = kq.Mamh and (Diem < 5 or Diem is null) and kq.Masv = 3 )	

--16.	Cho mã sv và tên của những sinh viên có hơn nửa số điểm >= 5. 

Select MaSV, TenSV From SinhVien
Where MaSV in ( Select a.MaSV 
				From (	Select MaSV, COUNT(MaMH) as SoMonThi From KetQua 
						Group By MaSV ) as a join (	Select MaSV, Count(MaMH) as SoMonTM From KetQua 
													Where Diem >= 5 
													Group By MaSV ) as b 
											 On a.MaSV = b.MaSV and SoMonThi < 2 * SoMonTM )

--17.	Cho danh sách tên và mã sinh viên có điểm trung bình chung lớn hơn điểm trung bình của toàn khóa.

Select sv.MaSV, sv.TenSV
From ( SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV ) join MonHoc mh On kq.MaMH = mh.MaMH
Group By sv.MaSV, sv.TenSV
Having Sum(Cast(Diem * DHVT as float)) / Sum(DHVT) > (	Select	Avg(DTB1SV)
														From (	Select Sum(Cast(Diem * DHVT as float)) / Sum(DHVT) as DTB1SV
																From KetQua kq join MonHoc mh On kq.MaMH = mh.MaMH
																Group By MaSV ) as DTBToanKhoa )


Select sv.MaSV, sv.TenSV
From SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV
Group By sv.MaSV, sv.TenSV
Having Avg(Cast(Diem as float)) > (	Select	Avg(Cast(DTB1SV as float))
									From (	Select Avg(Cast(Diem as float)) as DTB1SV
											From KetQua
											Group By MaSV ) as DTBToanKhoa )
											
--18.	*Cho danh sách mã sinh viên, tên sinh viên có điểm cao nhất môn Tin học đại cương của mỗi lớp.

Select Distinct sv.MaSV, sv.TenSV, Diem as 'Diem THDC cao nhat', a.Lop
From (	Select Lop, Max(Diem) as MaxDiemTHDC
		From SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV and MaMH = 3
		Group By Lop ) as a, SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV
Where a.Lop = sv.Lop and kq.Diem = MaxDiemTHDC and MaMH = 3

--19.	*Cho danh sách tên và mã sinh viên có điểm trung bình chung lớn hơn điểm trung bình của lớp sinh viên đó theo học.

Select MaSV, TenSV From SinhVien
Where MaSV in ( Select MaSV 
				From (	Select sv.MaSV, Sum(Cast(Diem * DHVT as float)) / Sum(DHVT) as DTB1SV, Lop 
						From ( SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV ) join MonHoc mh On kq.MaMH = mh.MaMH
						Group By sv.MaSV, Lop ) as a join (	Select Lop, Avg(DTB1SV) as DTB1L
															From (	Select MaSV, Sum(Cast(Diem * DHVT as float)) / Sum(DHVT) as DTB1SV
																	From KetQua kq join MonHoc mh On kq.MaMH = mh.MaMH
																	Group By MaSV ) as b join SinhVien sv On b.MaSV = sv.MaSV
															Group By Lop ) as c 
													 On a.Lop = c.Lop and DTB1SV > DTB1L )


Select MaSV, TenSV From SinhVien
Where MaSV in ( Select MaSV 
				From (	Select sv.MaSV, Avg(Cast(Diem as float)) as DTB1SV, Lop 
						From SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV
						Group By sv.MaSV, Lop) as a join (	Select Lop, Avg(Cast(DTB1SV as float)) as DTB1L
															From (	Select MaSV, Avg(Cast(Diem as float)) as DTB1SV
																	From KetQua
																	Group By MaSV ) as b join SinhVien sv On b.MaSV = sv.MaSV
															Group By Lop ) as c 
													On a.Lop = c.Lop and DTB1SV > DTB1L )



--View													
--Bài 1:  Sử dụng cơ sở dữ liệu Sinh viên hãy tạo các view:
--1.	Lấy ra danh sách sinh viên nữ học môn Lý thuyết cơ sở dữ liệu và điểm thi tương ứng. 
Go
Create View DSSV1
As
Select sv.MaSV, TenSV, mh.TenMH, Diem
From (SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV) join MonHoc mh On kq.MaMH = mh.MaMH
Where GT = N'Nữ' and TenMH = N'Lý thuyết cơ sở dữ liệu' 
Go

Select * From DSSV1

--2.	Cho biết số sinh viên thi đỗ môn toán cao cấp
Go
Create View DSSV2(SoSV)
As
Select Count(MaSV)
From KetQua kq join MonHoc mh On kq.MaMH = mh.MaMH
Where Diem >= 5 and TenMH = N'Toán cao cấp'
Go

Select * From DSSV2

--3.	Lấy ra tên sinh viên và điểm trung bình của các sinh viên theo từng lớp
Go
Create View DSSV3
As
Select Distinct sv.MaSV, TenSV, DTB1N as 'Diem TBC', Lop
From (	Select MaSV, Sum(Cast(Diem * DHVT as float)) / Sum(DHVT) as DTB1N
		From KetQua kq join MonHoc mh On kq.MaMH = mh.MaMH
		Group By MaSV ) as a right join SinhVien sv On a.MaSV = sv.MaSV
Group By Lop, sv.MaSV, TenSV, DTB1N
Go

Select * From DSSV3

--4.	Cho biết số sinh viên thi lại của từng môn
Go
Create View DSSV4(MaMH, TenMH, SoSV)
As
Select kq.MaMH, TenMH, Count(MaSV)
From KetQua kq join MonHoc mh On kq.MaMH = mh.MaMH
Where Diem < 5 or Diem is null
Group By kq.MaMH, TenMH
Go

Select * From DSSV4

--5.	*. Cho biết mã số và tên môn của những môn học mà tất cả các sinh viên đều đạt điểm >=5
Go 
Create View DSMH5 
As
Select MaMH, TenMH From MonHoc
Where not exists (	Select * From KetQua 
					Where MonHoc.MaMH = KetQua.MaMH and Diem < 5)
Go

Select * From DSMH5

--6.	*. Cho biết mã số và tên những sinh viên có điểm trung bình chung học tập cao hơn điểm trung bình chung của mỗi lớp.
Go
Create View DSSV6
As
Select MaSV, TenSV From SinhVien
Where MaSV in ( Select MaSV 
				From (	Select sv.MaSV, Sum(Cast(Diem * DHVT as float)) / Sum(DHVT) as DTB1SV, Lop 
						From ( SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV ) join MonHoc mh On kq.MaMH = mh.MaMH
						Group By sv.MaSV, Lop ) as a join (	Select Lop, Avg(DTB1SV) as DTB1L
															From (	Select MaSV, Sum(Cast(Diem * DHVT as float)) / Sum(DHVT) as DTB1SV
																	From KetQua kq join MonHoc mh On kq.MaMH = mh.MaMH
																	Group By MaSV ) as b join SinhVien sv On b.MaSV = sv.MaSV
															Group By Lop ) as c 
													 On a.Lop = c.Lop and DTB1SV > DTB1L )
Go

Select * From DSSV6

--7.	Cho biết mã số và tên nhưng sinh viên có hơn một nửa số điểm >=5
Go
Create View DSSV7
As
Select MaSV, TenSV From SinhVien
Where MaSV in ( Select a.MaSV 
				From (	Select MaSV, COUNT(MaMH) as SoMonThi From KetQua 
						Group By MaSV ) as a join (	Select MaSV, Count(MaMH) as SoMonTM From KetQua 
													Where Diem >= 5 
													Group By MaSV ) as b 
											 On a.MaSV = b.MaSV and SoMonThi < 2 * SoMonTM )
Go

--8.	Cho biết mã số và số điểm lớn hơn 7 của những sinh viên có hơn một nửa số điểm là >=7
Go
Create View DSSV8(MaSV, SoLuongDiem)
As
Select a.MaSV, b.SoMonTM 
From (	Select MaSV, COUNT(MaMH) as SoMonThi From KetQua 
		Group By MaSV ) as a join (	Select MaSV, Count(MaMH) as SoMonTM From KetQua 
									Where Diem >= 7 
									Group By MaSV ) as b 
							 On a.MaSV = b.MaSV and SoMonThi < 2 * SoMonTM 
Go

Select * From DSSV8

--Bài 2: Tạo các View thực hiện các yêu cầu sau:
--	Tạo View chứa danh sách nhân viên nữ
Go
Create View DSNV1
As
Select * From NHANVIEN
Where GT = N'Nữ'


--	Tạo View chứa danh sách nhân viên với các thông tin: mã nhân viên, họ tên, giới tính và tuổi
Go
Create View DSNV2(MaNV, HoTen, GioiTinh, Tuoi)
As
Select MaNV, HoTen, GT, year(getdate()) - year(NgaySinh)
From NHANVIEN

--	Tạo View cho biết họ tên của khách hàng đã mua tổng số tiền hàng > 10 triệu
Go
Create View DSKH1
As
Select HoTen
From (KHACHHANG kh join HOADONXUAT hdx On kh.MaKH = hdx.MaKH) join CT_HOADON cthd On hdx.MaHD = cthd.MaHD
Group By MaKH
Having Sum(SoLuongMua * DonGia) > 10000000

--	Tạo View cho biết họ tên của nhân viên đã bán được > 20 triệu tiền hàng.
Go
Create View DSNV3
As
Select HoTen
From (NHANVIEN nv join HOADONXUAT hdx On nv.MaNV = hdx.MaNV) join CT_HOADON cthd On hdx.MaHD = cthd.MaHD
Group By MaNV
Having Sum(SoLuongMua * DonGia) > 20000000


--Procedure and Function
--Bài 1: Cho CSDL Sinh viên, thực hiện các yêu cầu sau:
--1.	Viết một thủ tục đưa ra các sinh viên có năm sinh bằng với năm sinh được nhập vào (lấy năm sinh bằng hàm datepart(yyyy,ngaysinh))
Go
Create Proc Check_NamSinh (@NamSinh int)
As
Select * From SinhVien
Where datepart(yyyy, Ngaysinh) = @NamSinh
Go
Check_NamSinh 1999


--2.	So sánh 2 sinh viên có mã được nhập vào xem sinh viên nào được sinh trước.
Go
Create Proc Check_NgaySinh (@MaSV1 int, @MaSV2 int )
As
Declare @NgaySinh1 date, @NgaySinh2 date
Select @NgaySinh1 = Ngaysinh From SinhVien Where MaSV = @MaSV1
Select @NgaySinh2 = Ngaysinh from Sinhvien where MaSV = @MaSV2
if (@NgaySinh1 < @NgaySinh2)
	print 'Ban co ma sv' + str(@MaSV1) + ' sinh truoc ban co ma sv' + str(@MaSV2)
else if (@NgaySinh1 > @NgaySinh2)
	print 'Ban co ma sv' + str(@MaSV2) + ' sinh truoc ban co ma sv' + str(@MaSV1)
else
	print 'Ban co ma sv' + str(@MaSV1) + ' sinh cung ngay voi ban co ma sv' + str(@MaSV2)
Go

Check_NgaySinh 5, 10

--3.	Viết một hàm đưa ra tháng sinh. Áp dụng để đưa ra tháng sinh các bạn sinh viên đã thi môn có mã là 1.
Go
Create Function ThangSinh(@MaSV int)
Returns int
As
Begin
	Declare @thang int
	Select @thang = month(Ngaysinh) 
	From SinhVien
	Where MaSV = @MaSV
	Return @thang
End
Go
Select sv.MaSV, TenSV, dbo.ThangSinh(sv.MaSV) as N'Tháng Sinh'
From SinhVien sv join KetQua kq On sv.MaSV = kq.MaSV
Where MaMH = 1


--Nếu chỉ cần đưa ra tháng sinh các bạn sinh viên đã thi môn có mã là 1:
Go
Create Function ThangSinh2(@MaMH int)
Returns Table
As
Return ( Select SinhVien.MaSV, TenSV, month(Ngaysinh) as N'Tháng Sinh'
		 From SinhVien join KetQua On SinhVien.MaSV = KetQua.MaSV
		 Where KetQua.MaMH = @MaMH )
Go

Select * From dbo.ThangSinh2(1)




--Linh tinh
create function diem_lop(@lop nvarchar(10))
returns Table
as
return
(select a.Masv, Tensv, Ngaysinh, GT, Tenmh, Diem
from (sinhvien a join ketqua b on a.masv=b.masv) join monhoc c on b.mamh=c.mamh
where lop=@lop
)
Go
--Thực thi lời gọi hàm
select * from dbo.diem_lop('L01')
drop function diem_lop


drop function dbo.func_thangsinh2


Create Function tao_bang_TK (@MMH int)
Returns @Bang_TK Table (Lop nvarchar(10), SL int)--Bảng có hai cột Lop và SL
As
Begin
 Insert into @Bang_TK
 select Lop, count(a.Masv) as SL
 from (sinhvien a join ketqua b on a.masv=b.masv) join monhoc c on b.mamh=c.mamh
 where b.mamh=@mmh
 group by Lop
 return
end
--Thực thi lời gọi hàm
Go
select * from dbo.Tao_bang_TK(1)

drop function tao_bang_TK 

	