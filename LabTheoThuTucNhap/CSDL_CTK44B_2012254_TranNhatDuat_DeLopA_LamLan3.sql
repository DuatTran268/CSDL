/*

Họ và tên: Trần Nhật Duật
MSSV: 2012254
Lớp CTK44B
-- Làm test đề lớp A

*/

create database CSDL_CTK44B_2012254_TranNhatDuat
go

use CSDL_CTK44B_2012254_TranNhatDuat
go

/*
xác định thứ tự bảng
1. Sinh viên
2. Chuyên ngành
3. Đề tài
4. Công việc
5. Thực hiện đề tài
*/

create table SinhVien(
	MaSV char(7) primary key,
	TenSV nvarchar(30),
	Lop char(3)
)
go

create table ChuyenNganh(
	MSCN char(2) primary key,
	TenCN nvarchar(50)
)
go

create table DeTai (
	MSDT char(6) primary key,
	TenDT nvarchar(50),
	MSCN char(2) references ChuyenNganh(MSCN),
	NgayBD datetime,
	NgayNT datetime
)
go

create table CongViec(
	MSCV char(2) primary key,
	TenCV nvarchar(30)
)
go

create table ThucHienDeTai (
	MaSV char(7) references SinhVien(MaSV) not null,
	MSDT char(6) references DeTai(MSDT) not null,
	MSCV char(2) references CongViec(MSCV),
	Diem tinyint
	primary key (MaSV, MSDT)
)
go

-- xem tất cả các bảng 
select * from SinhVien
select * from ChuyenNganh
select * from DeTai
select * from CongViec
select * from ThucHienDeTai
go

-- viết thủ tục nhập dữ liệu
-- nhập dữ liệu cho bảng sinh viên
create proc usp_ThemSinhVien
@masv char(7),
@tensv nvarchar(30),
@lop char(3)
as 
	-- kiểm tra xem có trùng khóa chính của bảng sinh viên
	if exists (select * from SinhVien where MaSV = @masv)
		print N'Tồn tại mã sinh viên ' + @masv +' tróng CSDL'
	else
		begin
			insert into SinhVien values (@masv, @tensv, @lop)
			print N'Thêm dữ liệu thành công'
		end
go

exec usp_ThemSinhVien '0400001', N'Nguyễn Văn An', 'K28'
exec usp_ThemSinhVien '0300095', N'Trần Hùng', 'K27'
exec usp_ThemSinhVien '0310005', N'Lê Thúy Hằng', 'K27'
exec usp_ThemSinhVien '0400023', N'Ngô Khoa', 'K28'
exec usp_ThemSinhVien '0400100', N'Phạm Tài', 'K28'
exec usp_ThemSinhVien '0310100', N'Đinh Tiến', 'K27'
-- xem dữ liệu
select * from SinhVien
go
-- nhập dữ liệu cho bảng ChuyenNganh
create proc usp_ThemChuyenNganh
@mscn char(2),
@tencn nvarchar(50)
as
	if exists (select * from ChuyenNganh where MSCN = @mscn)
		print N'Tồn tại mã chuyên ngành ' + @mscn + 'trong CSDL'
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
go

-- nhập dữ liệu cho bảng đề tài
create proc usp_ThemDeTai
@msdt char(6),
@tendt nvarchar(50),
@mscn char(2),	-- khóa ngoại tham chiếu tới bảng ChuyenNganh(MSCN)
@ngaybd datetime,
@ngaynt datetime
as
	-- b1: kiểm tra có ràng buộc khóa ngoại bảng chuyên ngành 
	if exists (select * from ChuyenNganh where MSCN = @mscn)
		begin
			if exists (select * from DeTai where MSDT = @msdt)
				print N'Tồn tại mã đề tài ' + @msdt + 'trong CSDL'
			else
				begin
					insert into DeTai values (@msdt, @tendt, @mscn, @ngaybd, @ngaynt)
					print N'Thêm dữ liệu thành công'
				end
		end
go
-- nhập vào dữ liệu
set dateformat dmy		-- set định dạng ngày giờ theo day month year
go
exec usp_ThemDeTai 'DT0601', N'Quản lý thư viện', '01', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0602', N'Nhận dạng vân tay', '03', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0603', N'Bán đấu giá trên mạng', '02', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0604', N'Quản lý siêu thị', '04', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0605', N'Giấu tin trong ảnh', '03', '15/09/2007', '15/12/2007'
exec usp_ThemDeTai 'DT0606', N'Phát hiện tấn công trên mạng', '02', '15/09/2007', '15/12/2007'
-- xem dữ liệu vừa nhập
select * from DeTai
go

-- nhập dữ liệu cho bảng công việc
create proc usp_ThemCongViec
@mscv char(2),
@tencv nvarchar(30)
as
	if exists (select * from CongViec where MSCV = @mscv)
		print N'Tồn tại mã công việc ' + @mscv + ' trong CSDL'
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
select * from CongViec
go
		
-- nhập dữ liệu cho bảng thực hiện đề tài
create proc usp_ThemThucHienDeTai
@masv char(7), -- khoa ngoai SinhVien(MaSV)
@msdt char(6),	-- khóa ngoại DeTai(MSDT)
@mscv char(2),	-- khóa ngoại CongViec(MSCV)
@diem tinyint
as	
	-- kiểm tra ràng buộc khóa ngoại của 3 bảng SinhVien, DeTai, CongViec
	if not exists (select * from SinhVien where MaSV = @masv)
		begin
			print N'Không tồn tại mã sinh viên ' + @masv + ' trong CSDL'
			return
		end
	if not exists (select * from DeTai where MSDT = @msdt)
		begin
			print N'Tồn tại mã đề tài ' + @msdt + ' trong CSDL'
			return
		end
	if not exists (select * from CongViec where MSCV = @mscv)
		begin
			print N'Tồn tại mã công việc ' + @mscv + ' trong CSDL'
			return
		end
	insert into ThucHienDeTai values (@masv, @msdt, @mscv, @diem)
		print N'Thêm thành công dữ liệu'
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
-- xem dữ liệu
select * from ThucHienDeTai
