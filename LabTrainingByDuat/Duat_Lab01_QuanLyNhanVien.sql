/*
	Học phần cơ sở dữ liệu
	Ngày: 
	Người thực hiện: Trần Nhật Duật
	Lớp: CTK44B
*/

-- lệnh tạo database
create database Lab01_QuanLyNhanVien
go 
-- lệnh sử dụng database
use Lab01_QuanLyNhanVien
go

-- tạo các bảng
-- lệnh tạo bảng Chi Nhánh
create table ChiNhanh(
MSCN char(2) primary key,
TenCN nvarchar(50)
)
go
-- tạo bảng nhân viên
create table NhanVien(
MANV char(4) primary key,
Ho nvarchar(50)  not null,
Ten nvarchar(10) not null,
NgaySinh date,
NgayVaoLam date,
-- khai báo MSCN là khóa ngoại tham chiếu đến khóa chính MSCN của quan hệ ChiNhanh
MSCN char(2) references ChiNhanh(MSCN)
)
go
-- tạo bảng kỹ năng
create table KyNang(
MSKN char(2) primary key,
TenKN nvarchar(30)
)
go
-- tạo bảng nhân viên kỹ năng
create table NhanVienKyNang(
MANV char(4) references NhanVien(MANV),
MSKN char(2) references KyNang(MSKN),
MucDo tinyint check (MucDo between 1 and 9),		-- mức độ thuộc tập trong khoảng từ 1 đến 9
primary key(MANV, MSKN)		-- khai báo khóa chính gồm nhiều thuộc tính
)
go

-- xem các bảng vừa tạo
select * from ChiNhanh
select * from NhanVien
select * from KyNang
select * from NhanVienKyNang

-- nhập dữ liệu cho bảng 
insert into ChiNhanh values
('01', N'Quận 1'),
('02', N'Quận 5'),
('03', N'Bình Thạnh')
-- xem dữ liệu vừa nhập vào bảng
select * from ChiNhanh

-- nhập dữ liệu cho bảng NhanVien
set dateformat dmy
insert into NhanVien values
('0001', N'Lê Văn', N'Minh', '10/06/1960','02/05/1986', '01'),
('0002', N'Nguyễn Thị', N'Mai', '20/04/1970','04/07/2001', '01'),
('0003', N'Lê Anh', N'Tuấn', '25/06/1975','01/09/1982', '02'),
('0004', N'Vương Tuấn', N'Vũ', '25/03/1960','12/01/1986', '02'),
('0005', N'Lý Anh', N'Hân', '01/12/1980','15/05/2004', '02'),
('0006', N'Phan Lê', N'Tuấn', '04/06/1976','25/10/2002', '03'),
('0007', N'Lê Tuấn', N'Tú', '15/08/1975','15/08/2000', '03')
-- xem dữ liệu vừa nhập vào bảng
select * from NhanVien

-- nhập dữ liệu cho bảng KyNang
insert into KyNang values
('01', N'Word'),
('02', N'Excel'),
('03', N'Access'),
('04', N'Power Point'),
('05', N'SPSS')
-- xem dữ liệu nhập vào
select * from KyNang

-- nhập dữ liệu cho bảng nhân viên kỹ năng
insert into NhanVienKyNang values
('0001', '01', 2),
('0001', '02', 1),
('0002', '01', 2),
('0002', '03', 2),
('0003', '02', 1),
('0003', '03', 2),
('0004', '01', 5),
('0004', '02', 4),
('0004', '03', 1),
('0005', '02', 4),
('0005', '04', 4),
('0006', '05', 4),
('0006', '02', 4),
('0006', '03', 2),
('0007', '03', 4),
('0007', '04', 3)
select * from NhanVienKyNang
/*
delete tenbang: xóa dữ liệu trong bảng
vd: delete NhanVienKyNang
*/

-- truy vấn dữ liệu -------------
-- 1 truy vấn lựa chọn trên nhiều bảng
-- a> Hiển thị msnv , họ teenm số năm làm việc
/*
cách tính số năm làm việc: sử dụng hàm YEAR(năm hiện tại) - YEAR(năm của biến ngày vào làm)
- hàm GETDATE: lấy ngày giờ hiện tại
*/
select MANV, Ho + ' ' + Ten as HoTen, YEAR(GETDATE()) - YEAR(NgayVaoLam) as SoNamLamViec  
from NhanVien a
where YEAR(GETDATE()) - YEAR(NgayVaoLam) > 20

--b.  Liệt kê các thông tin về nhân viên: HoTen, NgaySinh, NgayVaoLam, TenCN(sap xep theo ten chi nhanh)
select Ho + ' ' + Ten as HoTen, NgaySinh, NgayVaoLam, TenCN 
from NhanVien a, ChiNhanh b
where a.MSCN = b.MSCN
order by TenCN

-- c. Liệt kê các nhân viên (HoTen, TenKN, MucDo) của những nhân viên biết sử dụng word
select Ho + ' ' + Ten as HoTen, c.TenKN, MucDo 
from NhanVien a, NhanVienKyNang b, KyNang c
where a.MANV = b.MANV and b.MSKN = c.MSKN and TenKN = N'Word'

--d. Liệt kê các kỹ năng (TenKN, MucDo) mà nhân viên 'Lê Anh Tuấn' biết sử dụng
select TenKN, MucDo
from NhanVien a, NhanVienKyNang b, KyNang c
where a.MANV = b.MANV and b.MSKN = c.MSKN and a.Ho = N'Lê Anh' and a.Ten = N'Tuấn' 

-- 2. truy vấn lồng
--a. liệt kê MANV, HoTen, MSCN, TenCN của các nhân viên có mức độ thành thạo về 'Excel' cao nhất trong công ty
select a.MANV, Ho + ' ' + Ten as HoTen, TenCN, MucDo 
from NhanVien a, ChiNhanh b, NhanVienKyNang c, KyNang d
where a.MSCN = b.MSCN and a.MANV = c.MANV and c.MSKN = d.MSKN and TenKN = N'Excel'
and c.MucDo = (
	select MAX(e.MucDo)		-- vì tìm mức độ cao nhất mà mức độ nằm ở bảng nhân viên kỹ năng nên => e.MucDo
	from NhanVienKyNang e, KyNang f
	where e.MSKN = f.MSKN and f.TenKN = N'Excel'
)
-- làm ngược: --a. liệt kê MANV, HoTen, MSCN, TenCN của các nhân viên có mức độ thành thạo về 'Excel' thấp nhất trong công ty
select a.MANV, Ho + ' ' + Ten as HoTen,  TenCN, MucDo
from NhanVien a, ChiNhanh b, KyNang c, NhanVienKyNang d
where a.MSCN = b.MSCN and a.MANV = d.MANV and c.MSKN = d.MSKN and TenKN = N'Excel'
and d.MucDo = (	-- truy vấn lồng tìm ra mức độ thấp nhất 
	select MIN(f.MucDo) 
	from KyNang e, NhanVienKyNang f
	where e.MSKN = f.MSKN and e.TenKN = N'Excel'
)

-- b. Liệt kê MANV, HoTen, TenCN của các nhân viên vừa biết word vừa biết excel
/*
b1: tìm ra các nhân viên biết sử dụng Execl trong bảng
b2: dựa vào a.MaNV mã nhân viên trong bảng nhân viên tìm xem tại cái mã nhân viên đó
b3: tìm ra các nhân viên biết sử dụng word thông qua mã nhân viên của bảng nhân viên
*/

select a.MANV, Ho + ' '+ Ten	as HoTen, TenCN
from NhanVien a, ChiNhanh b, KyNang c, NhanVienKyNang d
where a.MSCN = b.MSCN and a.MANV = d.MANV and c.MSKN = d.MSKN and TenKN = N'Excel'
and a.MANV in (
	select f.MANV 
	from KyNang  e, NhanVienKyNang f
	where e.MSKN = f.MSKN and e.TenKN = N'Word'
)
-- b. Liệt kê MANV, HoTen, TenCN của các nhân viên vừa biết access vừa biết power point
select a.MANV, Ho + ' ' + Ten as HoTen, TenCN 
from NhanVien a, ChiNhanh b, KyNang c, NhanVienKyNang d
where a.MANV = d.MANV and a.MSCN = b.MSCN and c.MSKN = d.MSKN and c.TenKN = N'Access'
and a.MANV in (
	select f.MANV
	from KyNang e, NhanVienKyNang f
	where e.MSKN = f.MSKN and e.TenKN = N'Power Point'
)

--c. Với từng kỹ năng, liệt kê các thong tin (MaNV, HoTen, TenCN, TenKN, MucDo) của những nhân viên thành thạo kỹ năng đó nhất
/*
-- muốn tìm kỹ năng thành thạo nhất dựa vào mức độ thành thạo trong bảng nhân viên kỹ năng
*/
select a.MANV, Ho + ' ' + Ten as HoTen, TenCN, TenKN, MucDo
from NhanVien a, ChiNhanh b, KyNang c, NhanVienKyNang d
where a.MANV = d.MANV and a.MSCN = b.MSCN and c.MSKN = d.MSKN 
and d.MucDo = (
	select MAX(e.MucDo)
	from NhanVienKyNang e
	where e.MSKN = c.MSKN
)
group by a.MANV, Ho + ' ' + Ten,TenCN, TenKN, MucDo

-- làm tương tự câu c mà chỉ có nhân viên thành thạo kỹ năng đó nhất trong các nhân viên
select a.MANV, Ho + ' ' + Ten as HoTen, TenKN, TenCN, MucDo 
from NhanVien a, ChiNhanh b, KyNang c, NhanVienKyNang d
where a.MANV = d.MANV and a.MSCN = b.MSCN and c.MSKN = d.MSKN 
and d.MucDo = (
	select Min(e.MucDo) 
	from NhanVienKyNang e, KyNang f
	where e.MSKN = f.MSKN
)
group by a.MANV, Ho + ' ' + Ten, TenKN, TenCN, MucDo 

-- d. liệt kê các chi nhánh(MSCN, TenCN) mà mọi nhân viên trong chi nhánh đó đều biết 'Word'
select distinct b.MSCN, TenCN
from NhanVien a, ChiNhanh b, KyNang c, NhanVienKyNang d
where a.MANV = d.MANV and a.MSCN = b.MSCN and c.MSKN = d.MSKN and c.TenKN = N'Word'

-- 3. truy vấn gom nhóm dữ liệu
-- a. với mỗi chi nhánh, hãy cho biết các thông tin sau TenCN, SoNV(số nhân viên)
select b.MSCN, TenCN, COUNT(MANV) as SoNV 
from NhanVien a, ChiNhanh b
where a.MSCN = b.MSCN
group by  TenCN , b.MSCN

-- b, với mỗi kỹ năng hãy cho biết TenKH, SoNguoiDung(Số nhân viên biết sử dụng kỹ năng đó )
select b.TenKN, COUNT(a.MANV) as SoNguoiBietDung
from NhanVien a, KyNang b, NhanVienKyNang c
where a.MANV = c.MANV and c.MSKN = b.MSKN
group by TenKN

-- c. Cho biết TenKN có từ 3 nhân viên trong cty sử dụng trở lên
select b.TenKN, COUNT(a.MANV) as SoNguoiBietDung
from NhanVien a, KyNang b, NhanVienKyNang c
where a.MANV = c.MANV and c.MSKN = b.MSKN
group by TenKN

-- d cho biết tên chi nhánh có nhiều nhân viên nhất
