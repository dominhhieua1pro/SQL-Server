USE QLMB
Go

--Bài 1: Mở CSDL QLMB, thực hiện các truy vấn sau bằng SQL

--1.	Cho biết thông tin về các chuyến bay đi Đà Lạt (DAD)
Select * From CHUYENBAY
Where GaDen = 'DAD'

--2.	Cho biết thông tin về các loại máy bay có tầm bay lớn hơn 10.000 km.
Select * From MAYBAY
Where TAMBAY > 10000

--3.	Cho biết thông tin về các nhân viên có lương nhỏ hơn 10000
Select * From NHANVIEN
Where Luong < 10000

--4.	Cho biết thông tin về các chuyến bay có độ dài đường bay nhỏ hơn 10000km và lớn hơn 8000km
Select * From CHUYENBAY
Where DoDai > 8000 and DoDai < 10000

--5.	Cho biết thông tin về các chuyến bay xuất phát từ Sài Gòn (SGN) đi Ban Mê Thuột (BMV)
Select * From CHUYENBAY
Where GaDi = 'SGN' and GaDen = 'BMV'

--6.	Có bao nhiêu chuyến bay xuất phát từ Sài Gòn (SGN)
Select Count(MaCB) From CHUYENBAY
Where GaDi = 'SGN'

--7.	Có bao nhiêu loại máy bay Boeing
Select Count(MaMB) From MAYBAY
Where Hieu like 'Boeing %'

--8.	Cho biết tổng số lương phải trả cho các nhân viên
Select Sum(Luong) as 'Tong Luong' From NHANVIEN

--9.	Cho biết mã số và tên của các phi công lái máy bay Boeing
Select Distinct NHANVIEN.MaNV, Ten From NHANVIEN, CHUNGNHAN, MAYBAY
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and Hieu Like 'Boeing %'

--10.	Cho biết mã số và tên của các phi công có thể lái được máy bay có mã số là 747
Select Distinct NHANVIEN.MaNV, Ten From NHANVIEN, CHUNGNHAN
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = 747

--11.	Cho biết mã số của các loại máy bay mà nhân viên có họ Nguyễn có thể lái
Select Distinct Ten, MaMB From NHANVIEN, CHUNGNHAN
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and Ten Like 'Nguyen %'

--12.	Cho biết mã số của các phi công vừa lái được Boeing vừa lái được Airbus A320
Select Distinct MaNV From CHUNGNHAN, MAYBAY
Where CHUNGNHAN.MaMB = MAYBAY.MaMB and Hieu Like 'Boeing %'
Intersect
Select Distinct MaNV From CHUNGNHAN, MAYBAY
Where CHUNGNHAN.MaMB = MAYBAY.MaMB and Hieu = 'Airbus A320'

--13.	Cho biết các loại máy bay có thể thực hiện được chuyến bay VN280
Select * From MAYBAY
Where TamBay >= (select DoDai From CHUYENBAY Where MaCB = 'VN280')

--14.	Cho biết các chuyến bay có thể thực hiện bởi máy bay Airbus A320
Select * From CHUYENBAY
Where DoDai <= (select TamBay From MAYBAY Where Hieu = 'Airbus A320')

--15.	Cho biết tên của các phi công lái máy bay Boeing
Select Distinct Ten From NHANVIEN, CHUNGNHAN, MAYBAY
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and Hieu Like 'Boeing %'

--16.	Với mỗi loại máy bay có phi công lái, cho biết mã số, loại máy bay và tổng số phi công có thể lái loại máy bay đó
Select MAYBAY.MaMB, Hieu, Count(Distinct NHANVIEN.MaNV) as 'Tong So PC Co The Lai' 
From NHANVIEN, CHUNGNHAN, MAYBAY
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB
Group By MAYBAY.MaMB, Hieu

--17.	Giả sử một hành khách muốn đi thẳng từ ga A đến ga B rồi quay trở về ga A. Cho biết các đường bay nào có thể đáp ứng yêu cầu này.
Select a.* From CHUYENBAY as a, CHUYENBAY as b 
Where a.GaDi = b.GaDen and a.GaDen = b.GaDi and a.GioDen < b.GioDi

--18.	Với mỗi ga có chuyến bay xuất phát từ đó, cho biết có bao nhiêu chuyến bay khởi hành từ ga đó
Select GaDi, Count(GaDi) as 'So Luong CB' From CHUYENBAY
Group By GaDi

--19.	Với mỗi ga có chuyến bay xuất phát từ đó, cho biết tổng chi phí phải trả chi phi công lái các chuyến bay khởi hành từ ga đó.
Select GaDi, Sum(ChiPhi) as 'Tong Chi Phi' From CHUYENBAY
Group By GaDi

--20.	Với mỗi ga xuất phát, cho biết có bao nhiêu chuyến bay có thể khởi hành trước 12:00 
Select GaDi, Count(MaCB) as 'SL CB XP Truoc 12h' From CHUYENBAY
Where GioDi < '12:00:00'
Group By GaDi

--21.	Cho biết mã số của phi công chỉ lái được 3 loại máy bay
Select MaNV From CHUNGNHAN
Group By MaNV
Having Count(MaMB) = 3

--22.	Với mỗi phi công có thể lái nhiều hơn 3 loại máy bay, cho biết mã số phi công và tầm bay lớn nhất của các loại máy bay mà phi công đó có thể lái
Select MaNV, Max(TamBay) as 'Tam Bay Cao Nhat' From CHUNGNHAN, MAYBAY
Where CHUNGNHAN.MaMB = MAYBAY.MaMB
Group By MaNV
Having Count(CHUNGNHAN.MaMB) > 3

--23.	Cho biết mã số của các phi công có thể lái được nhiều loại máy bay nhất
Select MaNV From CHUNGNHAN
Group By MaNV 
Having Count(MaMB) >= All(Select Count(MaMB) From CHUNGNHAN Group By MaNV)

--24.	Cho biết mã số của các phi công có thể lái được ít loại máy bay nhất.
Select MaNV From CHUNGNHAN
Group By MaNV 
Having Count(MaMB) <= All(Select Count(MaMB) From CHUNGNHAN Group By MaNV)

--25.	Tìm các nhân viên không phải là phi công
Select * From NHANVIEN
Where MaNV not in ( Select MaNV From CHUNGNHAN )

--26.	Cho biết mã số của các nhân viên có lương cao nhất
Select MaNV, Luong From NHANVIEN
Where Luong >= All(	Select Luong From NHANVIEN)

--27.	Cho biết tổng số lương phải trả cho các phi công
Select Sum(Luong) as 'Tong Luong Phi Cong' 
From NHANVIEN
Where MaNV in ( Select MaNV From CHUNGNHAN )

--28.	Tìm các chuyến bay có thể được thực hiện bởi tất cả các loại máy bay Boeing
Select * From CHUYENBAY
Where DoDai <= All(	Select TamBay From MAYBAY Where Hieu Like 'Boeing %')

--29.	Cho biết mã số của các máy bay có thể được sử dụng để thực hiện chuyến bay từ Sài gòn (SGN) đến Huế (HUI)
Select MaMB From MAYBAY
Where TamBay >= ( Select DoDai From CHUYENBAY 
				  Where GaDi = 'SGN' and GaDen = 'HUI')

--30.	Tìm các chuyến bay có thể được lái bởi các phi công có lương lớn hơn 100.000
Select * From CHUYENBAY
Where DoDai <= Some( Select Distinct TamBay 
					 From NHANVIEN, CHUNGNHAN, MAYBAY
					 Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and Luong > 100000 )

--31.	Cho biết tên các phi công có lương nhỏ hơn chi phí thấp nhất của đường bay từ Sài Gòn (SGN) đến Buôn mê Thuột (BMV)
Select Ten From NHANVIEN, CHUNGNHAN
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and Luong < All (	Select ChiPhi From CHUYENBAY 
														Where GaDi = 'SGN' and GaDen = 'BMV' )

--32.	Cho biết mã số của các phi công có lương cao nhất
Select Distinct NHANVIEN.MaNV From NHANVIEN, CHUNGNHAN
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and Luong = (	Select Max(Luong) From NHANVIEN, CHUNGNHAN 
													Where NHANVIEN.MaNV = CHUNGNHAN.MaNV )

--33.	Cho biết mã số của các nhân viên có lương cao thứ nhì
Select Distinct MaNV From NHANVIEN
Where Luong = (	Select Max(Luong) From NHANVIEN
				Where Luong < (Select Max(Luong) From NHANVIEN))

--34.	Cho biết mã số của các phi công có lương cao nhất hoặc thứ nhì
Select Distinct NHANVIEN.MaNV 
From NHANVIEN join CHUNGNHAN On NHANVIEN.MaNV = CHUNGNHAN.MaNV
Where Luong = (	Select Max(Luong) From NHANVIEN, CHUNGNHAN 
				Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and Luong < (	Select Max(Luong) From NHANVIEN, CHUNGNHAN 
																	Where NHANVIEN.MaNV = CHUNGNHAN.MaNV ) )
Union
Select Distinct NHANVIEN.MaNV From NHANVIEN, CHUNGNHAN
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and Luong = (	Select Max(Luong) From NHANVIEN, CHUNGNHAN 
													Where NHANVIEN.MaNV = CHUNGNHAN.MaNV )

--35.	Cho biết tên và lương của các nhân viên không phải là phi công và có lương lớn hơn lương trung bình của tất cả các phi công.
Select Ten, Luong From NHANVIEN
Where Luong >  ( Select Avg(Luong) From NHANVIEN 
				 Where MaNV in ( Select MaNV From CHUNGNHAN ) ) 
	  and MaNV not in (	Select MaNV From CHUNGNHAN )				 
						
--36.	Cho biết tên các phi công có thể lái các máy bay có tầm bay lớn hơn 4.800km nhưng không có chứng nhận lái máy bay Boeing
Select MaNV, Ten From NHANVIEN
Where not exists (	Select * From CHUNGNHAN, MAYBAY 
					Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and Hieu Like 'Boeing %' )
	  and exists (	Select * From CHUNGNHAN, MAYBAY 
					Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and TamBay > 4800 )

--37.	Cho biết tên các phi công lái ít nhất 3 loại máy bay có tầm xa hơn 3200km
Select NHANVIEN.MaNV, Ten From NHANVIEN, CHUNGNHAN, MAYBAY
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and TamBay > 3200
Group By NHANVIEN.MaNV, Ten
Having Count(CHUNGNHAN.MaMB) >= 3

--38.	Với mỗi nhân viên cho biết mã số, tên nhân viên và tổng số loại máy bay mà nhân viên đó có thể lái
Select NHANVIEN.MaNV, Ten, Count(Distinct MaMB) as 'Tong so MB Co The Lai' 
From NHANVIEN left join CHUNGNHAN On NHANVIEN.MaNV = CHUNGNHAN.MaNV
Group By NHANVIEN.MaNV, Ten

--39.	Với mỗi nhân viên, cho biết mã số, tên nhân viên và tổng số loại máy bay Boeing mà nhân viên đó có thể lái
Select NHANVIEN.MaNV,Ten, Count(a.MaNV) as 'Tong so MB Boeing Co The Lai' 
From (	Select MaNV 
		From (CHUNGNHAN join MAYBAY On CHUNGNHAN.MaMB = MAYBAY.MaMB) 
		Where Hieu Like 'Boeing %' ) as a right join NHANVIEN On NHANVIEN.MaNV = a.MaNV
Group By NHANVIEN.MaNV, Ten

--40.	Với mỗi loại máy bay,  cho biết loại máy bay và tổng số phi công có thể lái loại máy bay đó.
Select MAYBAY.MaMB, Hieu, Count(Distinct NHANVIEN.MaNV) as 'Tong so PC' 
From NHANVIEN, CHUNGNHAN, MAYBAY
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB
Group By MAYBAY.MaMB, Hieu

--41.	Với mỗi loại máy bay, cho biết loại máy bay và tổng số chuyến bay không thể thực hiện bởi loại máy bay đó.
Select Hieu, Count(MaCB) as 'So CB Khong The TH' 
From MAYBAY left join CHUYENBAY On TamBay < DoDai
Group By Hieu

--42.	Với mỗi loại máy bay, hãy cho biết loại máy bay và tổng số phi công có lương lớn hơn 100.000 có thể lái loại máy bay đó.
Select Hieu, Count(MAYBAY.MaMB) 'So Luong PC' 
From NHANVIEN, CHUNGNHAN, MAYBAY
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and Luong > 100000
Group By Hieu

--43.	Với mỗi loại máy bay có tầm bay trên 3200km, cho biết tên của loại máy bay và lương trung bình của các phi công có thể lái loại máy bay đó.
Select Hieu, Avg(Luong) as 'Luong TB'
From NHANVIEN, CHUNGNHAN, MAYBAY
Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and TamBay > 3200
Group By Hieu

--44.	Với mỗi loại máy bay hãy cho biết loại máy bay và tổng số nhân viên không thể lái loại máy bay đó
--Cách 1: not exists 
Select Hieu, Count(Distinct nv.MaNV) as SLNV 
From NHANVIEN nv, MAYBAY mb1
Where not exists (	Select * From CHUNGNHAN cn, MAYBAY mb2
					Where nv.MaNV = cn.MaNV and mb2.MaMB = cn.MaMB and mb1.Hieu = mb2.Hieu )
Group By Hieu

--Cách 2: subtract
Select Hieu, ((Select Count(MaNV) From NHANVIEN) - Count(cn.MaNV)) as SLNV
From CHUNGNHAN cn join MAYBAY mb On cn.MaMB = mb.MaMB
Group By Hieu

--45.	Với mỗi loại máy bay  hãy cho biết loại máy bay và tổng số phi công không thể lái loại máy bay đó.
--Cách 1: not exists
Select Hieu, Count(Distinct cn1.MaNV) as SLPC
From MAYBAY mb1, CHUNGNHAN cn1
where not exists (	Select * From MAYBAY mb2, CHUNGNHAN cn2
					Where cn1.MaNV = cn2.MaNV and mb2.MaMB = cn2.MaMB and mb1.Hieu = mb2.Hieu )
Group By Hieu

--Cách 2: subtract
Select Hieu, ((	Select Count(Distinct nv.MaNV) From NHANVIEN nv join CHUNGNHAN cn On nv.MaNV = cn.MaNV) - Count(cn.MaNV)) as SLPC
From CHUNGNHAN cn join MAYBAY mb On cn.MaMB = mb.MaMB
Group By Hieu

--46.	Với mỗi nhân viên, cho biết mã số, tên nhân viên và tổng số chuyến bay xuất phát từ Sài Gòn mà nhân viên đó không thể lái
Select nv.MaNV, nv.Ten, Count(a.MaCB) as N'Số CB Không Thể Lái'
From (	Select MaNV, MaCB From NHANVIEN nv, CHUYENBAY cb
		Where GaDi = 'SGN' and not exists (	Select * From CHUNGNHAN cn, MAYBAY mb
											Where nv.MaNV = cn.MaNV and mb.MaMB = cn.MaMB and TamBay > DoDai)
		) as a right join NHANVIEN nv On a.MaNV = nv.MaNV
Group By nv.MaNV, nv.Ten

--47.	Với mỗi phi công, cho biết mã số, tên phi công và tổng số chuyến bay xuất phát từ Sài Gòn mà phi công đó có thể lái
--Cách 1:
Select MaNV, Ten, Count(MaCB) as N'Số CB Có Thể Lái' 
From (	Select NHANVIEN.MaNV, Ten, Max(TamBay) as Max_TB 
		From ((NHANVIEN join CHUNGNHAN On NHANVIEN.MaNV = CHUNGNHAN.MaNV) join MAYBAY On CHUNGNHAN.MaMB = MAYBAY.MaMB) 
		Group By NHANVIEN.MaNV, Ten) as a left join CHUYENBAY On Max_TB >= DoDai and GaDi = 'SGN'
Group By MaNV, Ten

--Cách 2:
Select nv.MaNV, Ten, Count(Distinct MaCB) as N'Số CB Có Thể Lái' 
From ((NHANVIEN nv join CHUNGNHAN cn On nv.MaNV = cn.MaNV) join MAYBAY mb On cn.MaMB = mb.MaMB) left join CHUYENBAY On TamBay >= DoDai and GaDi = 'SGN'																
Group By nv.MaNV, Ten

--Bonus 47.	Với mỗi phi công, cho biết mã số, tên phi công và tổng số chuyến bay xuất phát từ Sài Gòn mà phi công không thể lái
Select MaNV, Ten, Count(MaCB) as N'Số CB Không Thể Lái' 
From (	Select NHANVIEN.MaNV, Ten, Max(TamBay) as Max_TB 
		From ( ( NHANVIEN join CHUNGNHAN On NHANVIEN.MaNV = CHUNGNHAN.MaNV ) join MAYBAY On CHUNGNHAN.MaMB = MAYBAY.MaMB ) 
		Group By NHANVIEN.MaNV, Ten ) as a left join CHUYENBAY On Max_TB < DoDai and GaDi = 'SGN'
Group By MaNV, Ten

--48.	Với mỗi chuyến bay, hãy cho biết mã số chuyến bay và tổng số loại máy bay có thể thực hiện chuyến bay đó
Select MaCB, Count(MAYBAY.MaMB) as N'Số MB Có Thể Thực Hiện' 
From MAYBAY right join CHUYENBAY On TamBay >= DoDai
Group By MaCB

--49.	Với mỗi chuyến bay, cho biết mã số chuyến bay và tổng số phi công không thể lái chuyến đó.
Select MaCB, Count(MaNV) as N'Số PC Không Thể Lái' 
From (	Select nv.MaNV, Max(TamBay) as Max_TB 
		From ((NHANVIEN nv join CHUNGNHAN cn On nv.MaNV = cn.MaNV) join MAYBAY mb On cn.MaMB = mb.MaMB) 
		Group By nv.MaNV ) as a right join CHUYENBAY On Max_TB < DoDai
Group By MaCB

--Note: cách sau đây không đúng
Select MaCB, Count(Distinct nv.MaNV) as N'Số PC Không Thể Lái' 
From ((NHANVIEN nv join CHUNGNHAN cn On nv.MaNV = cn.MaNV) join MAYBAY mb On cn.MaMB = mb.MaMB) 
	 right join CHUYENBAY On TamBay > DoDai 															
Group By MaCB

--50.	Một hành khách muốn đi từ Hà Nội (HAN) đến nha trang (CXR) mà không phải đổi chuyến bay quá một lần. Cho biết mã chuyến bay, thời gian khời hành từ Hà nội nếu hành khách muốn đến Nha Trang trước 16:00
Select MaCB, GioDi as 'GioDi tu HaNoi' From CHUYENBAY
Where GaDi = 'HAN' and GaDen = 'CXR' and GioDen < '16:00:00'
Union
Select a.MaCB, a.GioDi as 'GioDi tu HaNoi' From CHUYENBAY as a, CHUYENBAY as b
Where a.GaDi = 'HAN' and b.GaDen = 'CXR' and a.GaDen = b.GaDi and a.GioDen < b.GioDi and b.GioDen < '16:00:00'

--51.	Cho biết thông tin của các đường bay mà tất cả các phi công có thể bay trên đường bay đó đều có lương lớn hơn 100000
Select * From CHUYENBAY 
Where MaCB in (	Select MaCB 
				From (	Select nv.MaNV, Ten, Luong, MaCB
						From ((NHANVIEN nv join CHUNGNHAN cn On nv.MaNV = cn.MaNV) join MAYBAY mb On cn.MaMB = mb.MaMB) 
						right join CHUYENBAY On TamBay > DoDai ) as a
				Group By MaCB
				Having min(Luong) > 100000 )

--52.	Cho biết tên các phi công chỉ lái các loại máy bay có tầm xa hơn 3200km và một trong số đó là Boeing
--Cách 1: nested query
Select Distinct NHANVIEN.MaNV, NHANVIEN.Ten 
From (NHANVIEN join CHUNGNHAN On NHANVIEN.MaNV = CHUNGNHAN.MaNV) join MAYBAY On CHUNGNHAN.MaMB = MAYBAY.MaMB
Where NHANVIEN.MaNV in ( Select Distinct NHANVIEN.MaNV
						 From (NHANVIEN join CHUNGNHAN On NHANVIEN.MaNV = CHUNGNHAN.MaNV) join MAYBAY On CHUNGNHAN.MaMB = MAYBAY.MaMB
						 Group By NHANVIEN.MaNV
						 Having Min(TamBay) > 3200
						 ) and Hieu Like 'Boeing %'

--Cách 2: exists
Select MaNV, Ten From NHANVIEN
Where not exists (	Select * From CHUNGNHAN, MAYBAY 
					Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and TamBay < 3200 )
	  and exists (	Select * From CHUNGNHAN, MAYBAY 
					Where NHANVIEN.MaNV = CHUNGNHAN.MaNV and CHUNGNHAN.MaMB = MAYBAY.MaMB and Hieu Like 'Boeing %' )

--53.	Tìm các phi công có thể lái tất cả các loại máy bay Boeing.
--Cách 1:
Select NHANVIEN.MaNV, NHANVIEN.Ten From NHANVIEN
Where not exists (	Select * From CHUNGNHAN as CN1, MAYBAY 
					Where MAYBAY.MaMB = CN1.MaMB and Hieu Like 'Boeing %'
					and not exists ( Select * From CHUNGNHAN as CN2 
									 Where CN2.MaNV = NHANVIEN.MaNV and CN1.MaMB = CN2.MaMB))

--Cách 2:
Select NHANVIEN.MaNV, NHANVIEN.Ten 
From (NHANVIEN join CHUNGNHAN On NHANVIEN.MaNV = CHUNGNHAN.MaNV) join MAYBAY On CHUNGNHAN.MaMB = MAYBAY.MaMB
Where Hieu like 'Boeing %'
Group By NHANVIEN.MaNV, NHANVIEN.Ten
Having Count(CHUNGNHAN.MaMB) = (Select Count(MaMB) From MAYBAY Where Hieu like 'Boeing %')

