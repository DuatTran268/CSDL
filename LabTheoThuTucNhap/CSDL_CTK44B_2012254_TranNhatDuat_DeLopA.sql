/*
Người thực hiện: Trần Nhật Duật
MSSV: 2012254
Lớp CTK44B
- Làm đề thi kiểm tra giữa kì lớp A
*/

create database CSDL_CTK44_2012254_TranNhatDuat
go

use CSDL_CTK44_2012254_TranNhatDuat
go
--1
create table SinhVien(
	MaSV char(7) primary key,
	TenSV nvarchar(50),
	Lop char(3)
)
go
--2
create table ChuyenNganh(
	MSCN char(2) primary key,
	TenCN nvarchar(100)
)
go
--3
create table CongViec(
	MSCV char(2) primary key,
	TenCV nvarchar(100)
)
go
--4
create table DeTai(
	MSDT char(6) primary key,
	TenDT nvarchar(100),
	MSCN char(2) references ChuyenNganh(MSCN),
	NgayBD datetime,
	NgayNT datetime
)
go
--5
create table ThucHienDeTai(
	MaSV char(7) references SinhVien(MaSV),
	MSDT char(6) references DeTai(MSDT),
	MSCV char(2) references CongViec(MSCV),
	DIEM tinyint
	primary key(MaSV, MSDT)
)
-- xem cac bang vua tao
select * from SinhVien
select * from ChuyenNganh
select * from CongViec
select * from DeTai
select * from ThucHienDeTai

-- nhap vao du lieu
go
create proc usp_ThemSinhVien
@masv char(7),
@tensv nvarchar(50),
@lop char(3)
as
	if exists (select * from SinhVien where MaSV = @masv)
		print N'Đã có mã sinh viên ' + @masv + ' trong CSDL'
	else
		begin 
			insert into SinhVien values (@masv, @tensv, @lop)
			print N'Nhập vào dữ liệu thành công'
		end
go

exec usp_ThemSinhVien '0400001', N'Nguyễn Văn An', 'K28'
exec usp_ThemSinhVien '0300095', N'Trần Hùng', 'K27'
exec usp_ThemSinhVien '0310005', N'Lê Thúy Hằng', 'K27'
exec usp_ThemSinhVien '0400023', N'Ngô Khoa', 'K28'
exec usp_ThemSinhVien '0400100', N'Phạm Tài', 'K28'
exec usp_ThemSinhVien '0310100', N'Đinh Tiến', 'K27'
-- xem dữ liệu sau khi nhập vào bảng
select * from SinhVien
go
-- nhập dữ liệu bảng chuyên ngành
create proc usp_ThemChuyenNganh
@mscn char(2),
@tencn nvarchar(100)
as 
	if exists (select * from ChuyenNganh where MSCN = @mscn)
		print N'Đã tồn tại mã chuyên ngành ' + @mscn + ' trong CSDL'
	else 
		begin
			insert into ChuyenNganh values (@mscn, @tencn)
			print N'Thêm dữ liệu thành công'
		end
go

exec usp_ThemChuyenNganh '01', N'Hệ thống thông tin'
exec usp_ThemChuyenNganh '02', N'Mạng'
exec usp_ThemChuyenNganh '03', N'Đồ họa'
exec usp_ThemChuyenNganh '04', N'Công nghệ phần mềm'
-- xem dữ liệu sau khi nhập
select * from ChuyenNganh

-- nhập dữ liệu cho bảng công việc 
create proc usp_ThemCongViec
@mscv char(2),
@tencv nvarchar(100)
as
	if exists (select * from CongViec where MSCV = @mscv)
		print N'Đã tồn tại mã số công việc ' + @mscv + ' trong CSDL'
	else
		begin
			insert into CongViec values (@mscv, @tencv)
			print N'Thêm dữ liệu thành công'
		end
go

exec usp_ThemCongViec 'C1', N'Trưởng nhóm'
exec usp_ThemCongViec 'C2', N'Thu thập thông tin'
exec usp_ThemCongViec 'C3', N'Phân tích'
exec usp_ThemCongViec 'C4', N'Thiết kế'
-- xem dữ liệu đã nhập vào bảng
select * from CongViec
go
-- nhập dữ liệu cho bảng Đề tài
create proc usp_ThemDeTai
@msdt char(6),
@tendt nvarchar(100),
@mscn char(2),	-- khóa ngoại
@ngaybd datetime,
@ngaynt datetime
as
	if exists (select * from ChuyenNganh where MSCN = @mscn)
		begin
			if exists (select * from DeTai where MSDT = @msdt)
				print N'Đã tồn tại mã đề tài ' + @msdt + N' trong CSDL'
			else
				begin
					insert into DeTai values (@msdt, @tendt, @mscn, @ngaybd, @ngaynt)
					print N'Thêm dữ liệu thành công'
				end
		end
	else 
		print N'Mã số chuyên ngành ' + @mscn + N' không tồn tại trong CSDL nên không thể thêm vào Chuyên Ngành này'
go
-- nhập vào dữ liệu
set dateformat dmy
go
exec usp_ThemDeTai 'DT0601', N'Quản lý thư viện', '01', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0602', N'Nhận dạng vân tay', '03', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0603', N'Bán đấu giá trên mạng', '02', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0604', N'Quản lý siêu thị', '04', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0605', N'Giấu tin trong ảnh', '03', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0606', N'Phát hiện tấn công trên mạng', '02', '15/09/2007', '15/12/2007'
-- xem dữ liệu
select * from DeTai
-- nhập dữ liệu bảng thực hiện đề tài
create proc usp_ThemThucHienDeTai
@masv char(7),
@msdt char(6),
@mscv char(2),
@diem tinyint
as
	if exists (select * from SinhVien where MaSV = @masv) 
		and exists (select * from DeTai where MSDT = @msdt)
		and exists (select * from CongViec where MSCV = @mscv)
		begin
			if exists (select * from ThucHienDeTai where MaSV = @masv) 
				
				print N'Đã tồn tại mã sinh viên ' + @masv + N' trong CSDL'
			else
				begin
					insert into ThucHienDeTai values (@masv, @msdt, @mscv, @diem)
					print N'Thêm dữ liệu thành công'
				end
		end
	else
		print N'Mã sinh viên ' + @masv + N' không tồn tại trong CSDL để thêm vào thực hiện đề tài này'
go

exec usp_ThemThucHienDeTai '0400001', 'DT0601', 'C1', 7
exec usp_ThemThucHienDeTai '0400001', 'DT0603', 'C2', 8
exec usp_ThemThucHienDeTai '0300095', 'DT0602', 'C2', 9
exec usp_ThemThucHienDeTai '0310005', 'DT0604', 'C3', 8
exec usp_ThemThucHienDeTai '0400023', 'DT0601', 'C3', 6
exec usp_ThemThucHienDeTai '0400023', 'DT0605', 'C4', 8
exec usp_ThemThucHienDeTai '0400100', 'DT0603', 'C3', 8
exec usp_ThemThucHienDeTai '0310100', 'DT0604', 'C4', 6
exec usp_ThemThucHienDeTai '0310100', 'DT0601', 'C2', 5


-- sử dụng alt shift dấu mũi tên xuống để select nhiều dòng

-- xem dữ liệu
select * from ThucHienDeTai
delete ThucHienDeTai

					



/*

	MaSV char(7) references SinhVien(MaSV),
	MSDT char(6) references DeTai(MSDT),
	MSCV char(2) references CongViec(MSCV),
	DIEM tinyint
	primary key(MaSV, MSDT)

*/