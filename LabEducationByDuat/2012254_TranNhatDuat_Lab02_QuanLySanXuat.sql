/*
	Học phần cơ sở dữ liệu
	Ngày 07/03/2022
	Người thực hiện: Trần Nhật Duật
	MSSV: 2012254
	Lab 02: Quản lý sản xuất

*/

-- lệnh tạo csdl
create database Lab02_QuanLySanXuat
go

-- lệnh sử dụng csdl
use Lab02_QuanLySanXuat
go

-- lệnh tạo các bảng
create table ToSanXuat(
MaTSX char(4) primary key, -- khai báo mã tổ sản xuất là khóa chính
TenTSX nvarchar(20) not null unique
)
go
create table CongNhan(
MaCN char(5) primary key, -- ma cong nhan lam khoa chinh
Ho nvarchar(20) not null, 
Ten nvarchar(10) not null,
Phai nvarchar(3),
NgaySinh datetime,
MaTSX char(4) references ToSanXuat(MaTSX)
-- khai báo MaTSX là khóa ngoại tham chiếu đến khóa chính MaTSX của quan hệ ToSanXuat
)
go
create table SanPham(
MaSP char(5) primary key, -- MaSP lam khoa chinh
TenSP nvarchar(30) not null,
DVT nvarchar(10),
TienCong int check(TienCong > 0) -- kiểm tra tiền công > 0
)
go
create table ThanhPham(
MaCN char(5) references CongNhan(MaCN),		-- khoa ngoai tham chieu den khoa chinh cua quan he CongNhan
MaSP char(5) references SanPham(MaSP),
Ngay datetime,
SoLuong int check (SoLuong > 0)	-- kiểm tra số lượng > 0
primary key	(MaCN, MaSP, Ngay)	-- khai báo khóa chính gồm có nhiều thuộc tính
)
go

--=========== LỆNH XEM DỮ LIỆU TRONG BẢNG =====================
select * from ToSanXuat
select * from CongNhan
select * from SanPham
select * from ThanhPham

--=============== NHẬP DỮ LIỆU CHO CÁC BẢNG ===============
insert into ToSanXuat values
('TS01',N'Tổ 1'),
('TS02',N'Tổ 2')
-- xem bảng tổ sản xuất
select * from ToSanXuat
-- nhập bảng công nhân
set dateformat dmy -- khai báo định dạng ngày tháng 
go
insert into CongNhan values
('CN001',N'Nguyễn Trường',N'An',N'Nam','12/05/1981','TS01'),
('CN002',N'Lê Thị Hồng',N'Gấm',N'Nữ','04/06/1980','TS01'),
('CN003',N'Nguyễn Công',N'Thành',N'Nam','04/05/1981','TS02'),
('CN004',N'Võ Hữu',N'Hạnh',N'Nam','15/02/1980','TS02'),
('CN005',N'Lý Thanh',N'Hân',N'Nữ','03/12/1981','TS01')
select * from CongNhan

-- nhập bảng sản phẩm
insert into SanPham values
('SP001',N'Nồi đất',N'cái',10000),
('SP002',N'Chén',N'cái',2000),
('SP003',N'Bình gốm nhỏ',N'cái',20000),
('SP004',N'Bình gốm lớn',N'cái',25000)
select * from SanPham

-- nhập bảng thành phẩm
set dateformat dmy	--khai báo định dạng ngày tháng
go
insert into ThanhPham values
('CN001','SP001','01/02/2007',10),
('CN002','SP001','01/02/2007',5),
('CN003','SP002','10/01/2007',50),
('CN004','SP003','12/01/2007',10),
('CN005','SP002','12/01/2007',100),
('CN002','SP004','13/02/2007',10),
('CN001','SP003','14/02/2007',15),
('CN003','SP001','15/01/2007',20),
('CN003','SP004','14/02/2007',15),
('CN004','SP002','30/01/2007',100),
('CN005','SP003','01/02/2007',50),
('CN001','SP001','20/02/2007',30)
select * from ThanhPham

-- ================= truy vấn dữ liệu ======================
/*1. Liệt kê các công nhân theo tổ sản xuất gồm các thông tin: TenTSX, HoTen,
NgaySinh, Phai (xếp thứ tự tăng dần của tên tổ sản xuất, Tên của công nhân).*/
select TenTSX, Ho + ' ' + Ten as HoTen, NgaySinh, Phai 
from ToSanXuat a, CongNhan b		-- lấy ra bảng tổ sản xuất và bảng công nhân
where a.MaTSX = b.MaTSX				-- cho điều kiện của 2 bảng bằng nhau (thông nhau)
order by TenTSX, HoTen		-- sắp xếp theo tổ sản xuất, tên công nhân


/* 2. Liệt kê các thành phẩm mà công nhân ‘Nguyễn Trường An’ đã làm được gồm
các thông tin: TenSP, Ngay, SoLuong, ThanhTien (xếp theo thứ tự tăng dần
của ngày).*/
select TenSP, Ngay, SoLuong,  SoLuong * TienCong as ThanhTien		-- cách tính thành tiền ta lấy số lượng nhân với * tiền công
from CongNhan a, SanPham b, ThanhPham c
where a.MaCN = c.MaCN and b.MaSP = c.MaSP and Ho = N'Nguyễn Trường' and Ten = N'An'

/*3. Liệt kê các nhân viên không sản xuất sản phẩm ‘Bình gốm lớn’.*/
select MaCN , Ho + ' ' + Ten as HoTen
from CongNhan a 
where a.MaCN not in (		-- not in : chọn không
	select MaCN 
	from ThanhPham b, SanPham c
	where b.MaSP = c.MaSP and TenSP = N'Bình gốm lớn'
)

/*4. Liệt kê thông tin các công nhân có sản xuất cả ‘Nồi đất’ và ‘Bình gốm nhỏ’*/
select	distinct A.MaCN, Ho+' '+ Ten As HoTen, MaTSX
from	CongNhan A, ThanhPham B, SanPham C
where	A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP = N'Nồi đất'
		and A.MaCN IN (select	D.MaCN
						from	ThanhPham D, SanPham E
						where	D.MaSP = E.MaSP and TenSP = N'Bình gốm nhỏ')
-- cách 2
select	distinct A.MaCN, Ho+' '+ Ten As HoTen, MaTSX
from	CongNhan A, ThanhPham B, SanPham C
where	A.MaCN = B.MaCN and B.MaSP = C.MaSP and TenSP = N'Bình gốm nhỏ'
		and A.MaCN IN (select	D.MaCN
						from	ThanhPham D, SanPham E
						where	D.MaSP = E.MaSP and TenSP = N'Nồi đất')

/*5.  Thống kê Số luợng công nhân theo từng tổ sản xuất*/
select a.MaTSX , TenTSX, COUNT(MaCN) as N'Số công nhân'
from CongNhan a, ToSanXuat b
where a.MaTSX = b.MaTSX
group by a.MaTSX , TenTSX		

/*6. Tổng số lượng thành phẩm theo từng loại mà mỗi nhân viên làm được (Ho,
Ten, TenSP, TongSLThanhPham, TongThanhTien).*/

select a.MaCN, Ho + ' ' + Ten as HoTen, TenSP, SUM(SoLuong) as N'Tổng SL thành phẩm' , SUM(SoLuong * TienCong) as N'Tổng thành tiền'
from CongNhan a, ThanhPham b, SanPham c
where a.MaCN = b.MaCN and b.MaSP = c.MaSP
group by a.MaCN, Ho, Ten, TenSP
order by a.MaCN		-- sắp xếp theo mã công nhân


/*7. Tổng số tiền công đã trả cho công nhân trong tháng 1 năm 2007*/
select SUM(SoLuong * TienCong) as N'Tổng số tiền công trong tháng 1 năm 2007' 
from ThanhPham a, SanPham b
where a.MaSP = b.MaSP and MONTH(Ngay) = 1 and YEAR(Ngay) = 2007

/*8. Cho biết sản phẩm được sản xuất nhiều nhất trong tháng 2/2007*/
select a.MaSP, TenSP , SUM(SoLuong) as N'Tổng số lượng' 
from ThanhPham a, SanPham b
where a.MaSP = b.MaSP and MONTH(Ngay) = 2 and YEAR(Ngay) = 2007
group by a.MaSP, TenSP 
having SUM(SoLuong) >= all (		-- điều kiện là tổng của số lượng lớn hơn tất cả
	select SUM(c.SoLuong)			-- lấy tổng số lượng
	from ThanhPham c				-- trong bảng thành phẩm
	where MONTH(Ngay) = 2 and YEAR(Ngay) = 2007		-- kiểm tra điều kiện xem tổng số lượng trong tháng 2/2007
	group by c.MaCN									-- gom nhóm theo mã công nhân
)

/*
- Mệnh đề having thường được sử dụng với mệnh đề group by để lọc các nhóm dựa trên một danh sách các điều kiện
- Mệnh đề group by cho phép sắp xếp các bản ghi của một truy vấn theo nhóm
*/

/*9.  Cho biết công nhân sản xuất được nhiều ‘Chén’ nhất.*/
select a.MaCN, a.Ho + ' ' + a.Ten as HoTen, MaTSX, SUM(SoLuong)  as 'Tổng số lượng chén' 
from CongNhan a, ThanhPham b, SanPham c
where a.MaCN = b.MaCN and b.MaSP = c.MaSP and TenSP = N'Chén'
group by a.MaCN , a.Ho, a.Ten, MaTSX
having SUM(SoLuong) >= all(
	select SUM(SoLuong)
	from ThanhPham d, SanPham e
	where D.MaSP = E.MaSP and TenSP = N'Chén'
	Group by D.MaCN
)

/*10. Tiền công tháng 2/2007 của công nhân viên có mã số ‘CN002’*/

select Ho + ' ' + Ten as HoTen, SUM(SoLuong * TienCong) as N'Tiền công tháng 2'
from CongNhan a,ThanhPham b , SanPham c
where b.MaSP = c.MaSP and MONTH(Ngay) = 2 and YEAR(Ngay) = 2007 and b.MaCN = 'CN002'
group by Ho, Ten 


/*11. Liệt kê các công nhân có sản xuất từ 3 loại sản phẩm trở lên.*/
select a.MaCN, Ho + ' ' + Ten as HoTen, COUNT(distinct MaSP) as N'Số lượng sản phẩm'
from CongNhan a, ThanhPham b
where a.MaCN = b.MaCN
group by a.MaCN, Ho, Ten	
having COUNT(distinct MaSP) >= 3	-- điều kiện có mã sản phẩm lớn hơn hoặc bằng 3 sản phẩm trở lên
--distinct: riêng biệt, duy nhất

/*12 Cập nhật giá tiền công của các loại bình gốm thêm 1000.*/
update SanPham
set TienCong = TienCong + 1000
where TenSP like N'Bình gốm%'
-- xem lại bảng sau khi cập nhật dữ liệu
select * from SanPham

/*13. Thêm bộ <’CN006’, ‘Lê Thị’, ‘Lan’, ‘Nữ’,’TS02’ > vào bảng CongNhan.*/
insert into CongNhan values ('CN006', N'Lê Thị', N'Lan', N'Nữ',NULL,'TS02')
-- xem lại dữ liệu bảng công nhân sau khi thêm
select * from CongNhan
-- xóa dữ liệu bảng công nhân bằng mã công nhân
delete from CongNhan where MaCN = 'CN006'