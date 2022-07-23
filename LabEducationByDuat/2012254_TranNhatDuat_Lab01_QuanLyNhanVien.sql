/* Học phần: Cơ sở dữ liệu
   Ngày: 01/03/2022
   Người thực hiện: Trần Nhật Duật
*/


-- lệnh tạo cơ sở dữ liệu
create database Lab01_QuanLyNhanVien
go
-- lệnh tạo cơ sở dữ liệu
use Lab01_QuanLyNhanVien

--lệnh tạo các bảng  
-- tạo bảng chi nhánh
create table ChiNhanh	(
MSCN	char(2) primary key, -- khai báo MSCN là khóa chính
TenCN	nvarchar(30) not null unique
)
go
-- tạo bảng nhân viên
create table NhanVien	(
MANV char(4) primary key,
Ho	nvarchar(20) not null,
Ten nvarchar(10)	not null,
Ngaysinh	datetime,
NgayVaoLam	datetime,
MSCN	char(2)	references ChiNhanh(MSCN) -- khai báo MSCN là khóa ngoại tham chiếu đến khóa chính MSCN của quan hệ ChiNhanh 
)
go
-- tạo bảng kĩ năng
create table KyNang (
MSKN	char(2) primary key,
TenKN	nvarchar(30) not null
)
go
create table NhanVienKyNang (
MANV char(4) references NhanVien(MANV),
MSKN char(2) references KyNang(MSKN),
MucDo	tinyint check(MucDo between 1 and 9)--check(MucDo>=1 and MucDo<=9)
primary key(MANV,MSKN) --khai báo khóa chính gồm nhiều thuộc tính
)

-- xem các bảng vừa tạo -------
-- select : là chọn, dấu * là chọn tất cả, from chọn ra từ bảng, Tên bảng
select * from ChiNhanh
select * from NhanVien
select * from KyNang
select * from NhanVienKyNang


-- nhập dữ liệu cho các bảng ----------------
insert into ChiNhanh values 
('01',N'Quận 1'),
('02',N'Quận 5'),
('03',N'Bình Thạnh')
-- xem dữ liệu nhập vào của bảng chi nhanh
select * from ChiNhanh

-- nhập dữ liệu cho bảng kỹ năng
insert into KyNang values
('01', N'Word'),
('02', N'Excel'),
('03', N'Access'),
('04', N'Power Point'),
('05', N'SPSS')
-- xem bảng kỹ năng
select * from KyNang

-- nhập bảng dữ liệu nhân viên
set dateformat dmy --Khai báo định dạng ngày tháng năm
go
insert into NhanVien values
('0001',N'Lê Văn',N'Minh','10/06/1960','02/05/1986','01'),
('0002',N'Nguyễn Thị',N'Mai','20/04/1970','04/07/2002','01'),
('0003',N'Lê Anh',N'Tuấn','25/06/1975','01/09/1982','02'),
('0004',N'Vương Tuấn',N'Vũ','25/03/1960','12/01/1986','02'),
('0005',N'Lý Anh',N'Hân','01/12/1980','15/05/2004','02'),
('0006',N'Phan Lê',N'Tuấn','04/06/1976','25/10/2002','03'),
('0007',N'Lê Tuấn',N'Tú','15/08/1975','15/08/2000','03')
-- xem dữ liệu bảng nhân viên
select * from NhanVien
-- nhập dữ liệu cho bảng nhân viên kỹ năng
insert into NhanVienKyNang values
('0001','01',2),
('0001','02',1),
('0002','01',2),
('0002','03',2),
('0003','02',1),
('0003','03',2),
('0004','01',5),
('0004','02',4),
('0004','03',1),
('0005','02',4),
('0005','04',4),
('0006','05',4),
('0006','02',4),
('0006','03',2),
('0007','03',4),
('0007','04',3)
select * from NhanVienKyNang

--- ================= truy vấn dữ liệu ===============
-- phép chọn 
select * from NhanVien where MSCN='01'
-- liệt kê các nhân viên họ lê làm việc tại chi nhanh 01
select * from NhanVien where Ho like N'Lê%' and MSCN = '01'	-- dấu % thể hiện tìm phía trước Lê
-- liệt kê danh sách nhân viên sinh sau năm 1975
select * from NhanVien where YEAR(Ngaysinh) > 1975

-- phép chiếu mở rộng
--- bài tập
--1a, hiển thị msnv, HoTen , số năm làm việc
select MANV, ho + ' ' + ten as HoTen, YEAR(GETDATE()) - YEAR(ngayvaolam) as SoNamLamViec
from NhanVien
--số năm làm việc = YEAR(GETDATE() lấy năm hiện tại của ngày giờ hệ thống - trừ đi năm của ngày vào làm)

-- hiển thị ra các nhân viên có số năm làm việc lớn hơn 20 năm
where YEAR(GETDATE())-YEAR(ngayvaolam)>20
----Phép kết-------
-- gộp bảng nhân viên với bảng chi nhánh
select nhanvien.*, ChiNhanh.*
from NhanVien,ChiNhanh
where Nhanvien.mscn=Chinhanh.mscn
-----------sử dụng bí danh --------------
select a.*, b.*
from NhanVien a,ChiNhanh b 
where a.mscn=b.mscn

--1b. liệt kê các thông tin về nhân viên: họ tên, ngày sinh, ngày vào làm tên chi nhánh ( sắp xếp tên chi nhánh )
select Ho + ' ' + Ten as HoTen, NgaySinh, NgayVaoLam, TenCN
from NhanVien A, ChiNhanh B
where a.MSCN = b.MSCN
order by TenCN, Ten, Ho	-- sắp xếp tên chi nhánh

--1c. liệt kê các nhân viên (Họ tên, Tên KN, MucDo) của những nhân viên biết sử dụng 'word'
select Ho + ' ' + Ten as HoTen, TenKN, MucDo
from NhanVien A, NhanVienKyNang B, KyNang C
where A.manv = B.MANV and B.MSKN = C.MSKN and TenKN = 'word'

--1d
select TenKN, MucDo
from NhanVien a, NhanVienKyNang b, KyNang c
where a.manv = b.MANV and b.MSKN = c.MSKN and Ho = N'Lê Anh' and Ten = N'Tuấn'


--- truy vấn lồng
--2a. liệt kê manv, hoten, macn, ten cn của các nhân viên có mức độ thành thạo về excel cao nhất trong cty



--2b. liệt kê nhân viên sử dụng được 'word' và 'excel'
select b.MANV, Ho + ' ' + Ten as HoTen, tencn
from ChiNhanh a, NhanVien b, NhanVienKyNang c, KyNang d
where a.mscn = b.mscn and b.manv = c.MANV and c.MSKN = d.MSKN 
and TenKN = 'excel'
and b.MANV in (select e.manv
				from NhanVienKyNang e, KyNang f
				where e.MSKN = f.MSKN and TenKN = 'word')