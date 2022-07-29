/*
Học phần: Cơ sở dữ liệu
Ngày 29/03/2022
Người thực hiện: Trần Nhật Duật
MSSV: 2012254
Lab04: Quản lý đặt báo
*/

-- lenh tao database
create database Lab04_QuanLyDatBao
go
-- lenh su dung database
use Lab04_QuanLyDatBao
go

--=== tao cac bang =========
-- tạo bảng BAO_TCHI
create table Bao_TChi(
MaBaoTC char(4) primary key,
Ten nvarchar(100) not null,
DinhKy nvarchar(100),
SoLuong int,
GiaBan int
)
go
-- tạo bảng đối tác
create table PhatHanh(
MaBaoTC char(4) references Bao_TChi(MaBaoTC) not null ,
SoBaoTC int,
NgayPH Date,
primary key (MaBaoTC, SoBaoTC) -- khai báo khóa chính gồm nhiều thuộc tính
)
go
-- tạo bảng khách hàng
create table KhachHang(
MaKH char(4) primary key not null,
TenKH nvarchar(10),
DiaChi nvarchar(30)
)
go
-- tạo bảng đặt báo
create table DatBao(
MaKH char(4) references KhachHang(MaKH) not null,
MaBaoTC char(4) references Bao_TChi(MaBaoTC) not null,
SLMua int,
NgayDM date
primary key (MaKH, MaBaoTC)
)
go

-- xem các bảng vừa tạo
select * from Bao_TChi
select * from PhatHanh
select * from KhachHang
select * from DatBao

-- nhập dữ liệu cho bảng 
-- nhập dữ liệu bảng Báo, Tạp Chí
insert into Bao_TChi values
('TT01', N'Tuổi trẻ', N'Nhật báo', 1000, 1500),
('KT01', N'Kiến thức ngày nay', N'Bán nguyệt san', 3000, 6000),
('TN01', N'Thanh niên', N'Nhật báo', 1000, 2000),
('PN01', N'Phụ nữ', N'Tuần báo', 2000, 4000),
('PN02', N'Phụ nữ', N'Nhật báo', 1000, 2000)
go
delete Bao_TChi		-- xóa dữ liệu trong bảng
-- xem lại dữ liệu của bảng vừa nhập vào
select * from Bao_TChi

-- nhập dữ liệu bảng PhatHanh
-- khai báo định dạng ngày tháng năm
set dateformat dmy 
insert into PhatHanh values 
('TT01', 123, '15/12/2005'),
('KT01', 70, '15/12/2005'),
('TT01', 124, '16/12/2005'),
('TN01', 256, '17/12/2005'),
('PN01', 45, '23/12/2005'),
('PN02', 111, '18/12/2005'),
('PN02', 112, '19/12/2005'),
('TT01', 125, '17/12/2005'),
('PN01', 46, '30/12/2005')
go
-- xem dữ liệu của bảng vừa nhập vào
select * from PhatHanh

-- nhập dữ liệu cho bảng khách hàng
insert into KhachHang values
('KH01' , N'LAN', N'2NCT'),
('KH02' , N'NAM', N'32 THĐ'),
('KH03' , N'NGỌC', N'16 LHP')
go
-- xem dữ liệu bảng khách hàng
select * from KhachHang

-- nhập dữ liệu cho bảng Đặt báo
set dateformat dmy	-- khai báo định dạng ngày tháng năm
insert into DatBao values
('KH01', 'TT01', 100, '12/01/2000'),
('KH02', 'TN01', 150, '01/05/2001'),
('KH01', 'PN01', 200, '25/06/2001'),
('KH03', 'KT01', 50, '17/03/2002'),
('KH03', 'PN02', 200, '26/08/2003'),
('KH02', 'TT01', 250, '15/01/2004'),
('KH01', 'KT01', 300, '14/10/2004')
go
delete DatBao -- xóa mình dữ liệu trong bảng
-- xem dữ liệu bảng đặt báo
select * from DatBao


--============= truy vấn dữ liệu ============
--1. Cho biết các tờ báo , tạp chí (MaBaoTC, ten, Gia ban) có định kì phát hành hằng tuần (tuần báo)
select MaBaoTC, Ten, GiaBan 
from Bao_TChi
where DinhKy = N'Tuần báo'
--2. Cho biết thông tin về các tờ báo thuộc loại báo phụ nữ (mã báo tạp chí bắt đầu bằng PN)
select MaBaoTC, Ten, DinhKy, SoLuong, GiaBan 
from Bao_TChi
where MaBaoTC like 'PN%'
--3. cho biết tên khách hàng có đặt mua báo phụ nữ(mã báo tạp chí bắt đàu bằng PN) ko liệt kê khách hàng trùng
select distinct TenKH, c.Ten as 'Tên báo'
from KhachHang a, DatBao b, Bao_TChi c
where a.MaKH = b.MaKH and b.MaBaoTC = c.MaBaoTC and b.MaBaoTC like 'PN%'
--4. cho biết tên khách hàng có đặt mua tất cả các báo phụ nữ( báo tạp chí bắt đầu bằng PN)
select distinct TenKH, Ten as 'Tên báo' 
from KhachHang a, DatBao b, Bao_TChi c
where a.MaKH = b.MaKH and c.MaBaoTC like 'PN%'
group by TenKH, Ten
--having count(b.MaBaoTC) = (
--select count(*)
--from Bao_TChi
--where MaBaoTC like 'PN%') 
--> ko có khách hàng nào đặt mua tất cả báo phụ nữ
--5. Cho biết các khách hàng không đặt mua báo thanh niên 
select TenKH as 'Khách hàng không đặt báo thanh niên'
from KhachHang a
where a.MaKH not in (
select MaKH
from DatBao
where MaBaoTC like 'TN%'
)
--6. cho biết số tờ báo mà mỗi khách hàng đặt mua
select TenKH, SUM(SLMua) as 'Số tờ báo mà mỗi khách hàng đặt mua' 
from KhachHang a, DatBao b
where a.MaKH = b.MaKH
group by TenKH
--7. cho biết số khách hàng đặt mua báo trong năm 2004
select count(b.MaKH) as 'Số khách hàng đặt mua báo năm 2004'
from KhachHang a, DatBao b
where a.MaKH = b.MaKH and YEAR(b.NgayDM) = '2004'
-- 8. cho biết thông tin đặt mua báo của khách hàng
select  TenKH, Ten, DinhKy, SLMua * GiaBan as SoTien
from KhachHang a, DatBao b, Bao_TChi c
where a.MaKH = b.MaKH and b.MaBaoTC = c.MaBaoTC
-- 9. cho biết các tờ báo tạp chí(Ten, DinhKy) và tổng số lượng đặt mua của các khách hàng đối với tờ báo, tạp chí đó
select Ten, DinhKy, COUNT(b.MaKH) as N'Số lượng đặt mua'
from KhachHang a, DatBao b, Bao_TChi c 
where a.MaKH = b.MaKH and b.MaBaoTC = c.MaBaoTC
group by Ten, DinhKy
--10. Cho biết tên các tờ báo dành cho học sinh, sinh viên( mã báo tạp chí bắt đầu bằng HS)
select * from DatBao
where MaBaoTC like 'HS%'
--11. Cho biết những tờ báo không có người đặt mua
select distinct *
from Bao_TChi
where MaBaoTC not in(
select  MaBaoTC
from DatBao
)

-- 14. cho biết những các tờ báo phát hành định kì một tháng 2 lần
