/*
Học phần cơ sở dữ liệu
Ngày 05/04/2022
Người thực hiện : Trần Nhật Duật
Mssv: 2012254
Lab05 Quản lý đặt báo
*/

-- lenh tao database
create database Lab05_QLTour
go
-- lenh su dung database
use Lab05_QLTour
go

-- tao bang tour
create table Tour(
MaTour char(4) primary key not null,
TongSoNgay int check (TongSoNgay > 0)
)
go
-- tao bang thanh pho
create table ThanhPho(
MaTP char(2) primary key not null,
TenTP nvarchar(50)
)
go
-- tao bang tour thanh pho
create table Tour_TP(
MaTour char(4) references Tour(MaTour) not null,
MaTP char(2) references ThanhPho(MaTP) not null,
SoNgay int check (SoNgay > 0),
primary key(MaTour, MaTP)
)
go
-- tao bang lich tour du lich
create table Lich_TourDL(
MaTour char(4) references Tour(MaTour),
NgayKH date,
TenHDV nvarchar(10),
SoNguoi int,
TenKH nvarchar(50),
primary key(MaTour, NgayKH)
)
go

-- xem cac bang vua tao
select * from Tour
select * from ThanhPho
select * from Tour_TP
select * from Lich_TourDL

-- nhập dữ liệu vào bảng
-- nhập dữ liệu cho bảng tour
insert into Tour values
('T001', 3),
('T002', 4),
('T003', 5),
('T004', 7)
go
-- xem dữ liệu bảng vừa nhập
select * from Tour

-- nhập dữ liệu cho bảng thành phố
insert into ThanhPho values
('01', N'Đà Lạt'),
('02', N'Nha Trang'),
('03', N'Phan Thiết'),
('04', N'Huế'),
('05', N'Đà Nẵng')
go
select * from ThanhPho
-- nhập dữ liệu bảng Tour_TP
insert into Tour_TP values
('T001', '01', 2),
('T001', '03', 1),
('T002', '01', 2),
('T002', '02', 2),
('T003', '02', 2),
('T003', '01', 1),
('T003', '04', 2),
('T004', '02', 2),
('T004', '05', 2),
('T004', '04', 3)
go
-- xem dữ liệu bảng nhập vào
select * from Tour_TP
-- nhập dữ liệu cho bảng lịch tour du lịch
set dateformat dmy
insert into Lich_TourDL values
('T001', '14/02/2017', N'Vân', 20, N'Nguyễn Hoàng'),
('T002', '14/02/2017', N'Nam', 30, N'Lê Ngọc'),
('T002', '06/03/2017 ', N'Hùng', 20, N'Lý Dũng'),
('T003', '18/02/2017 ', N'Dũng', 20, N'Lý Dũng'),
('T004', '18/02/2017', N'Hùng', 30, N'Dũng Nam'),
('T003', '10/03/2017', N'Nam', 45, N'Nguyễn An'),
('T002', '28/04/2017', N'Vân', 25, N'Ngọc Dung'),
('T004', '29/04/2017 ', N'Dũng', 35, N'Lê Ngọc'),
('T001', '30/04/2017', N'Nam', 25, N'Trần Nam'),
('T003', '15/06/2017', N'Vân', 20, N'Trịnh Bá')
go
-- xem dữ liệu bảng
select * from Lich_TourDL

-- a) cho biết các tour du lịch có tổng số ngày của tour từ 3 đến 5 ngày
select * 
from Tour a, Lich_TourDL b
where a.MaTour = b.MaTour and TongSoNgay BETWEEN 3 and 5;
-- toán tử BETWEEN chọn ra giá trị trong khoảng từ giá trị bắt đầu đến giá trị kết thúc

--b) cho biết thông tin các tour được tổ chức trong tháng 2 năm 2017
select * 
from Tour a, Lich_TourDL b
where a.MaTour = b.MaTour and MONTH(NgayKH) = 2  and YEAR(NgayKH) = 2017;

--c) cho biết tour ko đi qua thành phố Nha Trang
select MaTour as N'Mã Tour ko đi qua Nha Trang'
from Tour a
where MaTour not in (
	select MaTour
	from Tour_TP b, ThanhPho c
	where c.MaTP = b.MaTP and TenTP = N'Nha Trang'
)

--d) cho biết số lượng thành phố mà mỗi tour du lịch đi qua
select a.MaTour, TongSoNgay, COUNT(b.MaTP) as N'Số lượng thành phố' 
from Tour a, Tour_TP b
where a.MaTour = b.MaTour
group by a.MaTour, TongSoNgay

--e) cho biết số lượng tour du lịch mà mỗi hướng dẫn viên hướng dẫn
select TenHDV, COUNT(MaTour) as N'Số lượng tour của hướng dẫn viên' 
from Lich_TourDL 
group by TenHDV

--f) Cho biết tên thành phố có nhiều tour du lịch đi qua nhất
select b.MaTP as N'Mã thành phố', b.TenTP, COUNT(MaTour) as N'Số lượng tour'
from Tour_TP a, ThanhPho b
where a.MaTP = b.MaTP
group by b.MaTP, b.TenTP
having COUNT(MaTour) >= all(
select COUNT(MaTour)
from Tour_TP
group by MaTP
)



