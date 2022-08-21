USE SPJ
Go

--Bài 2: Mở CSDL SPJ, thực hiện các truy vấn sau bằng SQL:
--1.	Cho biết màu và thành phố của các vật tư không được lưu trữ tại Hà Nội và có trọng lượng lớn hơn 10
Select Mau, ThPho From VATTU
Where ThPho != 'Ha Noi'  and TrLuong > 10

--2.	Cho biết thông tin chi tiết về các dự án ở Tp HCM
Select * From DUAN Where ThPho = 'TpHCM'

--3.	Cho biết tên nhà cung cấp vật tư cho dự án J1.
Select Ten From CC join NCC On CC.MaNCC = NCC.MaNCC 
Where MADA = 'J1'

--4.	Cho biết tên nhà cung cấp, tên vật tư, tên dự án mà số lượng vật tư được cung cấp cho dự án bởi nhà cung cấp lớn hơn 300 và nhỏ hơn 750.
Select NCC.Ten, VATTU.Ten, DUAN.Ten 
From ((VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
Where SoLuong > 300 and SoLuong < 750

--5.	Cho biết mã số các vật tư được cung cấp cho các dự án tại Tp HCm bởi các nhà cung cấp ở TpHCM
Select VATTU.MaVT
From ((VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
Where DUAN.ThPho = 'TpHCM' and NCC.ThPho = 'TpHCM'

--6.	Liệt kê các cặp tên thành phố mà nhà cung cấp ở thành phố thứ nhất cung cấp vật tư được lưu trữ tại thành phố thứ hai.
Select NCC.ThPho as 'ThPho NCC', VATTU.ThPho as 'ThPho VATTU'
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC

--7.	Liệt kê các cặp mã số nhà cung cấp ở cùng một thành phố
Select ncc1.MaNCC, ncc2.MaNCC
From NCC as ncc1 join NCC as ncc2 On ncc1.ThPho = ncc2.ThPho and ncc1.MaNCC != ncc2.MaNCC

--8.	Cho biết mã số và tên các vật tư được cung cấp cho dự án cùng thành phố với nhà cung cấp.
Select Distinct VATTU.MaVT, VATTU.Ten
From ((VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
Where DUAN.ThPho = NCC.ThPho

--9.	Cho biết mã số và tên các vật tư được cung cấp vật tư bởi ít nhất một nhà cung cấp không cùng thành phố.
Select Distinct VATTU.MaVT, VATTU.Ten
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC
Where VATTU.ThPho <> NCC.ThPho

--10.	Cho biết mã số nhà cung cấp và cặp mã số vật tư được cung cấp bởi nhà cung cấp này.
Select Distinct NCC.MaNCC, VATTU.MaVT
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC

--11.	Cho biết mã số các vật tư được cung cấp bởi nhiều hơn một nhà cung cấp
Select Distinct VATTU.MaVT
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC
Group By VATTU.MaVT
Having Count(Distinct NCC.MaNCC) > 1

--12.	Với mỗi vật tư, cho biết mã số và tổng số lượng được cung cấp cho các dự án.
Select VATTU.MaVT, Sum(SoLuong) as 'Tong So Luong'
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join DUAN On DUAN.MaDA = CC.MaDA
Group By VATTU.MaVT

--13.	Cho biết tổng số các dự án được cung cấp vật tư bởi nhà cung cấp S1
Select Count(Distinct DUAN.MaDA) as 'Tong So DA'
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
Where NCC.MaNCC = 'S1'

--14.	Cho biết tổng số lượng vật tư P1 được cung cấp bởi nhà cung cấp S1
Select Count(Distinct VATTU.MaVT) as 'Tong So VT'
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Where NCC.MaNCC = 'S1' and VATTU.MaVT = 'P1'

--15.	Với mỗi vật tư được cung cấp cho một dự án, cho biết mã số, tên vật tư, tên dự án và tổng số lượng vật tư tương ứng.
Select VATTU.MaVT, VATTU.Ten, DUAN.MaDA, DUAN.Ten, Sum(SoLuong) as 'So Luong VT'
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join DUAN On DUAN.MaDA = CC.MaDA
Group By VATTU.MaVT, VATTU.Ten, DUAN.MaDA, DUAN.Ten

--16.	Cho biết mã số, tên các vật tư và tên dự án có số lượng vật tư trung bình cung cấp cho dự án lớn hơn 350
Select VATTU.MaVT, VATTU.Ten, DUAN.MaDA, DUAN.Ten, Avg(SoLuong) as 'So Luong VT TB'
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join DUAN On DUAN.MaDA = CC.MaDA
Group By VATTU.MaVT, VATTU.Ten, DUAN.MaDA, DUAN.Ten
Having Avg(SoLuong) > 350

--17.	Cho biết tên các dự án được cung cấp vật tư bởi nhà cung cấp S1
Select Distinct DUAN.Ten
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
Where NCC.MaNCC = 'S1'

--18.	Cho biết màu của các vật tư được cung cấp bởi nhà cung cấp S1.
Select Distinct VATTU.Mau
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Where NCC.MaNCC = 'S1'

--19.	Cho biết mã số và tên các vật tư được cung cấp cho một dự án bất kỳ ở TpHCM
Select Distinct VATTU.MaVT, VATTU.Ten
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join DUAN On DUAN.MaDA = CC.MaDA
Where DUAN.ThPho = 'TpHCM'

--20.	Cho biết mã số và tên các dự án sử dụng vật tư có thể được cung cấp bởi nhà cung cấp S1.
Select Distinct DUAN.MaDA, DUAN.Ten
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
Where NCC.MaNCC = 'S1'

--21.	Cho biết mã số và tên các nhà cung cấp có cung cấp vật tư có quy cách màu đỏ
Select Distinct NCC.MaNCC, NCC.Ten
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Where Mau = 'Do'

--22.	Cho biết tên các nhà cung cấp có chỉ số xếp hạng nhỏ hơn chỉ số lớn nhất.
Select NCC.Ten
From NCC
Where Heso < (Select Max(Heso) From NCC)

--23.	Cho biết tên các nhà cung cấp không cung cấp vật tư P2
Select Ten From NCC Where MaNCC in (
Select Distinct NCC.MaNCC
--From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Except
Select Distinct NCC.MaNCC
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Where VATTU.MaVT = 'P2'
)

--24.	Cho biết mã số và tên các nhà cung cấp đang cung cấp vật tư P2
Select Distinct MaNCC, Ten From NCC 
Where exists (Select * From VATTU, CC Where NCC.MaNCC = CC.MaNCC and VATTU.MaVT = CC.MaVT and VATTU.MaVT = 'P2')
--From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
--Where VATTU.MaVT = 'P2'

--25.	Cho biết mã số và tên các nhà cung cấp đang cung cấp vật tư được cung cấp bởi nhà cung cấp có cung cấp vật tư với quy cách màu đỏ
Select Distinct NCC.MaNCC, NCC.Ten
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Where VATTU.MaVT in (
Select Distinct VATTU.MaVT
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Where NCC.MaNCC in (
Select Distinct NCC.MaNCC
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Where Mau = 'Do'
))

--26.	Cho biết mã số và tên các nhà cung cấp có chỉ số xếp hạng cao hơn nhà cung cấp S1
Select MaNCC, Ten
From NCC
Where Heso > (Select Heso From NCC Where MaNCC = 'S1')

--27.	Cho biết mã số và tên các dự án được cung cấp vật tư P1 với số lượng vật tư trung bình lớn hơn tất cả các số lượng vật tư được cung cấp cho dự án J1
Select Distinct DUAN.MaDA, DUAN.Ten 
From (VATTU join CC On VATTU.MaVT = CC.MaVT) join DUAN On DUAN.MaDA = CC.MaDA
Where VATTU.MaVT = 'P1'
Group By DUAN.MaDA, DUAN.Ten
Having Avg(SoLuong) > All(Select SoLuong From CC Where MaDA = 'J1')

--28.	Cho biết mã số và tên các nhà cung cấp cung cấp vật tư P1 cho một dự án nào đó với số lượng lớn hơn số lượng trung bình của vật tư P1 được cung cấp cho dự án đó.
Select Distinct NCC.MaNCC, NCC.Ten
From ((VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
Where VATTU.MaVT = 'P1' and SoLuong > (	Select SLVTTB From (	Select VATTU.MaVT, DUAN.MaDA, Avg(SoLuong) as SLVTTB
															From ((VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
															Where VATTU.MaVT = 'P1'
															Group By VATTU.MaVT, DUAN.MaDA	) as a 
										Where a.MaDA = DUAN.MaDA	)

--29.	Cho biết mã số và tên các dự án không được cung cấp vật tư nào có quy cách màu đỏ bởi một nhà cung cấp bất kỳ ở TpHCM
Select Distinct MaDA, Ten From DUAN
Except
Select Distinct MaDA, Ten From DUAN
Where exists (	Select * From VATTU, CC, NCC
				Where DUAN.MaDA = CC.MaDA and VATTU.MaVT = CC.MaVT and NCC.MaNCC = CC.MaNCC and NCC.ThPho = 'TpHCM' and Mau = 'Do')

--30.	Cho biết mã số và tên các dự án được cung cấp toàn bộ vật tư bởi nhà cung cấp S1
Select Distinct MaDA, Ten From DUAN
Except
Select Distinct MaDA, Ten From DUAN
Where exists (	Select * From CC, NCC
				Where DUAN.MaDA = CC.MaDA and NCC.MaNCC = CC.MaNCC and NCC.MaNCC != 'S1' )

--31.	Cho biết tên các nhà cung cấp cung cấp tất cả các vật tư.
Select Ten From NCC
Where not exists (	Select * From CC as CC1, VATTU Where CC1.MaVT = VATTU.MaVT
					and not exists (Select * From CC as CC2 Where CC2.MaNCC = NCC.MaNCC and CC1.MaVT = CC2.MaVT))

--32.	Cho biết mã số và tên các vật tư được cung cấp cho tất cả các dự án tại TpHCM
Select MaVT, Ten From VATTU
Where not exists (	Select * From CC as CC1, DUAN Where CC1.MaDA = DUAN.MaDA and DUAN.ThPho = 'TpHCM'
					and not exists (Select * From CC as CC2 Where CC2.MaVT = VATTU.MaVT and CC1.MaDA = CC2.MaDA))

--33.	Cho biết mã số và tên các vật tư được cung cấp cho tất cả các dự án tại TpHCM
Select MaVT, Ten From VATTU
Where not exists (	Select * From CC as CC1, DUAN Where CC1.MaDA = DUAN.MaDA and DUAN.ThPho = 'TpHCM'
					and not exists (Select * From CC as CC2 Where CC2.MaVT = VATTU.MaVT and CC1.MaDA = CC2.MaDA))

--34.	Cho biết mã số và tên cac nhà cung cấp cung cấp cùng một vật tư cho tất cả các dự án
Select NCC.MaNCC, NCC.Ten 
From (NCC join CC On NCC.MaNCC = CC.MaNCC) join VATTU On VATTU.MaVT = CC.MaVT
Group By NCC.MaNCC, NCC.Ten 
Having Count(Distinct VATTU.MaVT) = 1

--35.	Cho biết mã số và tên các dự án được cung cấp tất cả các vật tư có thể được cung cấp bởi nhà cung cấp S1
Select Distinct MaDA, Ten From DUAN
Where exists (	Select * From CC, NCC
				Where DUAN.MaDA = CC.MaDA and NCC.MaNCC = CC.MaNCC and NCC.MaNCC = 'S1' )

--36.	Cho biết tất cả các thành phố mà nơi đó có ít nhất một nhà cung cấp, lưu trữ ít nhất một vật tư hoặc có ít nhất một dự án
Select ThPho From VATTU
Union
Select ThPho From NCC
Union
Select ThPho From DUAN

--37.	Cho biết mã số các vật tư hoặc được cung cấp bởi một nhà cung cấp ở Tp HCM hoặc cung cấp cho một dự án tại Tp HCM
Select Distinct VATTU.MaVT 
From ((VATTU join CC On VATTU.MaVT = CC.MaVT) join NCC On NCC.MaNCC = CC.MaNCC) join DUAN On DUAN.MaDA = CC.MaDA
Where NCC.ThPho = 'TpHCM' Or DUAN.ThPho = 'TpHCM'

--38.	Liệt kê các cặp (mã số nhà cung cấp, mã số vật tư) mà nhà cung cấp không cung cấp vật tư
Select Distinct NCC.MaNCC, VATTU.MaVT
From NCC, VATTU
Except
Select Distinct CC.MaNCC, VATTU.MaVT
From CC join VATTU On VATTU.MaVT = CC.MaVT

--39.	Liệt kê các cặp mã số nhà cung cấp có thể cung cấp cùng tất cả các loại vật tư
Select a.MaNCC, b.MaNCC From NCC as a, NCC b
Where a.MaNCC <> b.MaNCC 
	  and not exists ( Select * From CC as cc1
					   Where a.MaNCC = cc1.MaNCC and not exists ( Select * From CC as cc2 
															      Where b.MaNCC = cc2.MaNCC and cc1.MaVT = cc2.MaVT))
	  and not exists ( Select * From CC as cc1
					   Where b.MaNCC = cc1.MaNCC and not exists ( Select * From CC as cc2 
															      Where a.MaNCC = cc2.MaNCC and cc1.MaVT = cc2.MaVT))

--40.	Cho biết tên các thành phố lưu trữ nhiều hơn 5 vật tư có quy cách màu đỏ.
Select ThPho From VATTU
Where Mau = 'Do'
Group By ThPho
Having Count(MaVT) > 5

