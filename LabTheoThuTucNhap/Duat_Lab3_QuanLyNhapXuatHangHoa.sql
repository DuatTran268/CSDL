/*
	Học phần cơ sở dữ liệu
	Ngày 15/03/2022
	Người thực hiện: Trần Nhật Duật
	MSSV: 2012254
	Lab03: Quản lý nhập xuất hàng hóa
	-- viết theo thủ tục nhập
*/

create database Lab03_QLNhapXuatHangHoa
go

use Lab03_QLNhapXuatHangHoa
go

create table HangHoa(
	MaHH char(5) primary key,
	TenHH nvarchar(100), 
	DVT nvarchar(5), 
	SoLuongTon tinyint check(SoLuongTon > 0)
)
go

create table DoiTac(
	MaDT char(05) primary key,
	TenDT nvarchar(50),
	DiaChi nvarchar(50),
	DienThoai nvarchar(10) unique
)
go

create table KhaNangCC (
	MaDT char(5) references DoiTac(MaDT),
	MaHH char(5) references HangHoa(MaHH),
	primary key (MaDT, MaHH)
)
go

create table HoaDon(
	SoHD char(5) primary key,
	NgayLapHD datetime,
	MaDT char(5) references DoiTac(MaDT),
	Tong int,
)
go

create table CT_HoaDon(
	SoHD char(5) references HoaDon(SoHD),
	MaHH char(5) references HangHoa(MaHH),
	DonGia char(3),
	SoLuong int check (SoLuong > 0)
)

-- xem tất cả các bảng
select * from HangHoa
select * from DoiTac
select * from KhaNangCC
select * from HoaDon
select * from CT_HoaDon

-- thu tuc nhap vao du lieu
