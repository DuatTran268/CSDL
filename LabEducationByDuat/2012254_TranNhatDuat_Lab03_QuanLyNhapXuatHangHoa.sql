/*
	Học phần cơ sở dữ liệu
	Ngày 15/03/2022
	Người thực hiện: Trần Nhật Duật
	MSSV: 2012254
	Lab03: Quản lý nhập xuất hàng hóa

*/
-- lệnh tạo database
create database Lab03_QLNhapXuatHangHoa
go
-- lệnh sử dụng csdl
use Lab03_QLNhapXuatHangHoa
go

-- lệnh tạo các bảng
-- tạo bảng hàng hóa
create table HangHoa(
MaHH char(5) primary key,
TENHH nvarchar(100) not null,
DVT nvarchar(5) not null,
SoLuongTon int check (SoLuongTon > 0)
)
go
-- tạo bảng đối tác
create table DoiTac(
MaDT char(5) primary key,
TenDT nvarchar(50) not null,
DiaChi nvarchar(50) not null,
DienThoai nvarchar(10) unique
)
go
-- tạo bảng khả năng cung cấp
create table KhaNangCC(
MaDT char(5) references DoiTac(MaDT) not null,
MaHH char(5) references HangHoa(MaHH) not null,
primary key(MaDT, MaHH)	-- khai bao khoa chinh gom nhieu thuoc tinh
)
go
-- tạo bảng hóa đơn
create table HoaDon(
SoHD char(5) primary key not null,
NgayLapHD date not null,
MaDT char(5) references DoiTac(MaDT),
TongTG int 
)
go
-- tạo bảng CT hóa đơn
create table CT_HoaDon(
SoHD char(5) not null,
MaHH char(5) references HangHoa(MaHH),
DonGia char(3),
SoLuong int check(SoLuong > 0),
primary key(SoHD, MaHH)
)
go
 -- lệnh xóa bảng:  drop table CT_HoaDon

 -- xem các bảng vừa tạo
 select * from HangHoa
 select * from DoiTac
 select * from HoaDon
 select * from KhaNangCC
 select * from CT_HoaDon

 -- Nhập dữ liệu cho bảng hàng hóa
 insert into HangHoa values 
 ('CPU01', 'CPU INTEL, CELERON 600 BOX', N'CÁI', 5),
 ('CPU02', 'CPU INTEL, PIII 700', N'CÁI', 10),
 ('CPU03', 'CPU AMD K7 ATHL, ON 600', N'CÁI', 8),
 ('HDD01', 'HDD 10.2 GB QUANTUM', N'CÁI',10),
 ('HDD02', 'HDD 13.6 GB SEA GAME', N'CÁI', 10),
 ('HDD03', 'HDD 20 GB QUANTUM ', N'CÁI', 6),
 ('KB01', 'KB GENIUS ', N'CÁI', 12),
 ('KB02', 'KB MITSUMIMI', N'CÁI', 5),
 ('MB01', 'GIGABYTE CHIPSET INTEL', N'CÁI', 10),
 ('MB02', 'ACOPR BX CHIPSET VIA', N'CÁI', 10),
 ('MB03', 'INTEL PHI CHIPSET INTEL', N'CÁI', 10),
 ('MB04', 'ESC CHIPSET SIS', N'CÁI', 10),
 ('MB05', 'ESC CHIPSET VIA', N'CÁI', 10),
 ('MNT01', 'SAMSUNG 14" SYNCMASTER', N'CÁI', 5),
 ('MNT02', 'LG 14"', N'CÁI', 5),
 ('MNT03', 'ACER 14"', N'CÁI', 8),
 ('MNT04', 'PHILIPS 14" ', N'CÁI', 6),
 ('MNT05', 'VIEWSONIC 14"', N'CÁI', 7)
 -- xem dữ liệu vừa nhập vào bảng hàng hóa
 select * from HangHoa
 -- nhập sai dữ liệu sử dụng lệnh update
 -- update tên bảng
update HangHoa	
set SoLuongTon = 15 where MaHH = 'HDD02'
-- set cho vị trí giá trị cột cần sửa where vị trí của hàng cần sửa
select * from HangHoa

 -- nhập dữ liệu cho bảng đối tác
 insert into DoiTac values
 ('CC001', N'Cty TNC', N'176 BTX Q1 - TPHCM', '08.8250259'),
 ('CC002', N'Cty Hoàng Long', N'15A TTT Q1 – TP. HCM', '08.8250898'),
 ('CC003', N'Cty Hợp Nhất', N'152 BTX Q1 – TP.HCM', '08.8252376'),
 ('K0001', N'Nguyễn Minh Hải', N'91 Nguyễn Văn Trỗi Tp. Đà Lạt', '063.831129'),
 ('K0002', N'Như Quỳnh', N'21 Điện Biên Phủ. N.Trang', '058590270'),
 ('K0003', N'Trần nhật Duật', N'Lê Lợi TP. Huế', '054.848376'),
 ('K0004', N'Phan Nguyễn Hùng Anh', N'11 Nam Kỳ Khởi nghĩa- TP. Đà lạt ', '063.823409')
 -- xem dữ liệu bảng dữ liệu bảng đối tác
 select * from DoiTac

 -- nhập dữ liệu cho bảng dữ liệu hóa đơn
 set dateformat dmy	-- khai báo định dạng ngày tháng năm
 insert into HoaDon values
 ('N0001', '25/01/2006','CC001', null),
 ('N0002', '01/05/2006','CC002', null),
 ('X0001', '12/05/2006','K0001', null),
 ('X0002', '16/06/2006','K0002', null),
 ('X0003', '20/04/2006','K0001', null)
 select * from HoaDon

 -- nhập bảng dữ liệu khả năng cung cấp
 insert into KhaNangCC values
 ('CC001', 'CPU01'),
 ('CC001', 'HDD03'),
 ('CC001', 'KB01'),
 ('CC001', 'MB02'),
 ('CC001', 'MB04'),
 ('CC002', 'MNT01'),
 ('CC002', 'CPU01'),
 ('CC002', 'CPU02'),
 ('CC002', 'CPU03'),
 ('CC002', 'KB02'),
 ('CC002', 'MB01'),
 ('CC002', 'MB05'),
 ('CC002', 'MNT03'),
 ('CC003', 'HDD01'),
 ('CC003', 'HDD02'),
 ('CC003', 'HDD03'),
 ('CC003', 'MB03')
 select * from KhaNangCC	-- xem dữ liệu bảng khả năng cung cấp

 -- nhập dữ liệu bảng chi tiết hóa đơn
 insert into CT_HoaDon values
 ('N0001', 'CPU01', '63', 10),
 ('N0001', 'HDD03', '97', 7),
 ('N0001', 'KB01', '3', 5),
 ('N0001', 'MB02', '57', 5),
 ('N0001', 'MNT01', '112', 3),
 ('N0002', 'CPU02', '115', 3),
 ('N0002', 'KB02', '5', 7),
 ('N0002', 'MNT03', '111', 5),
 ('X0001', 'CPU01', '67', 2),
 ('X0001', 'HDD03', '100', 2),
 ('X0001', 'KB01', '5', 2),
 ('X0001', 'MB02', '62', 1),
 ('X0002', 'CPU01', '67', 1),
 ('X0002', 'KB02', '7', 3),
 ('X0002', 'MNT01', '115', 2),
 ('X0003', 'CPU01', '67', 1),
 ('X0003', 'MNT03', '115', 2)
 select * from CT_HoaDon	-- xem dữ liệu bảng hóa đơn

 --=================== TRUY VẤN DỮ LIỆU =================
 --1. liệt kê các mặt hàng thuộc loại đĩa cứng
 select MaHH , TENHH as N'Tên Hàng Hóa'
 from HangHoa a
 where a.TENHH like 'HDD%'

 --2. liệt kê các mặt hàng có số lượng tồn trên 10
 select MaHH, TENHH, SoLuongTon
 from HangHoa a
 where a.SoLuongTon > 10

 --3. Cho biết thông tin về các nhà cung cấp ở Thành phố Hồ Chí Minh
 select MaDT, TenDT, DiaChi, DienThoai
 from DoiTac a
 where a.DiaChi like '%HCM%'

 --4. Liệt kê hóa đơn nhập hàng trong tháng 5/2016, thông tin hiển thị gồm sohd; ngaylaphd; tên, địa chỉ, và điện thoại của nhà cung cấp mặt hàng
 select TenDT, DiaChi, DienThoai, NgayLapHD
 from DoiTac a, HoaDon b
 where  a.MaDT = b.MaDT  and MONTH(b.NgayLapHD) = '5' and YEAR(b.NgayLapHD) = '2006'
 group by a.TenDT, a.Diachi, a.DienThoai, b.NgayLapHD

 --5. Cho biết tên các nhà cung cấp có thể cung cấp đĩa cứng
 select a.MaHH, TENHH, TenDT
 from HangHoa a, DoiTac b, KhaNangCC c 
 where b.MaDT = c.MaDT and c.MaHH = a.MaHH and a.TENHH like 'HDD%'

 -- 6. Cho biết tên các nhà cung cấp có thể cung cấp có thể cung cấp các loại đĩa cứng
 select a.TenDT, a.DiaChi, a.DienThoai, COUNT(*) as SoLuongDiaCungCap
 from DoiTac a, KhaNangCC b where b.MaDT = a.MaDT and MaHH like 'HDD%'
 group by a.MaDT, TenDT, DiaChi, DienThoai
 having COUNT(*) = (select COUNT(*) from HangHoa where MaHH like 'HDD%')

 ----7. Cho biết tên nhà cung cấp ko cung cấp đĩa cứng
 -- not in kiểm tra ko nằm trong tập giá trị( tìm các nhà cung cấp nhưng ko tìm nhà cung cấp đĩa cứng HDD)
 select distinct TenDT, DiaChi, DienThoai
from KhaNangCC a, DoiTac b 
where a.MaDT = b.MaDT and b.MaDT not in ( 
select MaDT 
from KhaNangCC 
where MaHH like 'HDD%');

-- cách 2
select distinct TenDT, DiaChi, DienThoai
from KhaNangCC a
join DoiTac b on a.MaDT = b.MaDT and b.MaDT not in (
select MaDT 
from KhaNangCC 
where MaHH like 'HDD%');

-- 8. cho biết thông tin của mặt hàng chưa bán được
select * from HangHoa a
where a.MaHH not in
(select  MaHH
from HoaDon b, CT_HoaDon c where b.SoHD = c.SoHD and b.SoHD like 'X%');

-- cách 2
select * from HangHoa a
where a.MaHH not in
(select  MaHH
from HoaDon b
join CT_HoaDon c on b.SoHD = c.SoHD
where b.SoHD like 'X%');

-- 9. cho biết tên và tổng số lượng bán của mặt hàng bán chạy nhất ( tính theo số lượng)
select TENHH, SUM(SoLuong) as N'Số Lượng Hàng Hóa'
from HangHoa a, HoaDon b, CT_HoaDon c
where a.MaHH = c.MaHH
group by TENHH
having SUM(SoLuong) >= all(
		select sum(SoLuong)
		from HangHoa a, CT_HoaDon c
		where a.MaHH = c.MaHH
		)

-- 10. cho biết tên và tổng số lượng của mặt hàng nhập về ít nhất
-- lấy ra tất cả số lượng nhập
SELECT b.MaHH , b.TENHH,
       SUM(soLuong) AS N'Số lượng nhập'
FROM CT_HoaDon a, HangHoa b			-- lấy dữ liệu từ bảng chi tiết hóa đơn và bảng hàng hóa gán lần lượt cho a và b
WHERE a.MaHH = b.MaHH and SoHD LIKE 'N%'  -- điều kiện cho mã hàng hóa của bảng hóa đơn = với mã hàng hóa của bảng hàng hóa (và and) mã số của hóa đơn bắt đầu có kí tự 'N' là nhập
GROUP BY b.MaHH, b.TENHH		-- truy vấn theo nhóm 
-- nhỏ hơn tất cả
-- mệnh đề Having được dùng kết hợp với mệnh đề group by
HAVING SUM(soLuong) <= ALL			-- so sánh tổng số lượng với tất cả
  (SELECT SUM(soLuong)		-- lấy ra tổng số lượng
   FROM CT_HoaDon			-- từ bảng chi tiết hóa đơn
   WHERE SoHD LIKE 'N%'		-- với điều kiện số hóa đơn có kí hiệu N (nhập) đầu tiên tìm tiếp theo	
   GROUP BY MaHH);			-- truy vấn theo nhóm mã hàng hóa

-- 12. Cho biết các mặt hàng ko được nhập hàng trong tháng 1/2006
select MaHH, TENHH, DVT, SoLuongTon
from HangHoa a
where MaHH not in (
				select distinct MaHH
				from HoaDon b, CT_HoaDon c
				where b.SoHD = c.SoHD and b.SoHD like 'N%'
				and MONTH(NgayLapHD) = 1
				and YEAR(NgayLapHD) = 2006);

--13. cho biết tên các mặt hàng ko được bán trong tháng 6/2006
select MaHH, TENHH, DVT, SoLuongTon 
from HangHoa a
where MaHH not in (
				select distinct MaHH
				from HoaDon b, CT_HoaDon c
				where b.SoHD = c.SoHD and b.SoHD like 'X%'		-- dựa vào kí tự đầu x bảng hóa đơn
				and MONTH(NgayLapHD) = 6
				and YEAR(NgayLapHD) = 2006);

--14. Cho biết cửa hàng bán bao nhiêu mặt hàng
select COUNT(*) as N'Số lượng mặt hàng bán ra' from HangHoa
-- 15. Cho biết số mặt hàng mà từng nhà cung cấp có khả năng cung cấp
select b.MaDT, TenDT, DiaChi, DienThoai, COUNT(*) as SoLuongMatHang
from KhaNangCC a, DoiTac b
where a.MaDT = b.MaDT
group by b.MaDT, TenDT, DiaChi, DienThoai
order by SoLuongMatHang desc
--17. Tính tổng doanh thu năm 2006
select SUM(DonGia * SoLuong) as TongDoanhThu
from HoaDon a, CT_HoaDon b
where a.SoHD = b.SoHD and a.SoHD like 'X%' and YEAR(NgayLapHD) = 2006;





