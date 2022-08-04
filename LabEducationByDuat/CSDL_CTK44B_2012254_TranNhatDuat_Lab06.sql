/*
Học phần cơ sở dữ liệu
Người thực hiện: Trần Nhật Duật
MSSV: 2012254
Lớp CTK44B
Ngày thực hiện: 19/04/2022
*/

create database Lab06_QLHocVien
go
use Lab06_QLHocVien
go

-- tao bang 
create table CaHoc(
	Ca tinyint primary key,
	GioBatDau Datetime,
	GioKietThuc Datetime
)
go
create table GiaoVien(
	MSGV char(4) primary key,
	HoGV nvarchar(20),
	TenGV nvarchar(10),
	DienThoai varchar(11)
)
go
create table Lop(
	MaLop char(4) primary key,
	TenLop nvarchar(30),
	NgayKG Datetime,
	HocPhi int,
	Ca tinyint references CaHoc(Ca),
	SoTiet int,
	SoHV int,
	MSGV char(4) references GiaoVien(MSGV)
)
go


create table HocVien(
	MSHV char(4) primary key,
	Ho nvarchar(20),
	Ten nvarchar(10),
	NgaySinh Datetime,
	Phai nvarchar(4),
	MaLop char(4) references Lop(MaLop)
)
go
create table HocPhi(
	SoBL char(6) primary key,
	MSHV char(4) references HocVien(MSHV),
	NgayThu Datetime,
	SoTien int,
	NoiDung nvarchar(50),
	NguoiThu nvarchar(30)
)
go
-- xem cac bang da tao
select * from CaHoc
select * from GiaoVien
select * from Lop
select * from HocVien
select * from HocPhi

-- xay dung thu tuc nhap du lieu
-- CaHoc
create proc usp_ThemCaHoc
	@ca tinyint, @giobd Datetime, @giokt Datetime
as
	if exists (select * from Ca Hoc where Ca = @ca)	--kiem tra co trung khoa chinh (Ca) nếu trùng xuất ra câu lệnh bên dưới
		print N'Đã có ca học ' + @ca + ' trong CSDL'
	else 
		begin 
			insert into CaHoc values (@ca, @giobd, @giokt)
			print N'Thêm ca học thành công'
		end
go
-- gọi thực hiện thủ tục
exec usp_ThemCaHoc 1,'7:30', '10:45'
exec usp_ThemCaHoc 2,'13:30', '16:45'
exec usp_ThemCaHoc 3,'17:30', '20:45'
-- xem dữ liệu bảng usp_ThemCaHoc
select * from CaHoc

-- dữ liệu vào bảng GV
create proc usp_ThemGiaoVien
	@msgv char(4), @hogv nvarchar(20), @tengv nvarchar(10), @dt varchar(11)
as
	if exists (select * from GiaoVien where MSGV = @msgv)
		print N'Đã có giáo viên' + @msgv + ' trong CSDL'
	else 
		begin
			insert into GiaoVien values (@msgv, @hogv, @tengv, @dt)
			print N'Thêm giáo viên thành công'
		end
go
-- gọi thực hiện thủ tục
exec usp_ThemGiaoVien 'G001',N'Lê Hoàng',N'Anh', '858936'
exec usp_ThemGiaoVien 'G002',N'Nguyễn Ngọc',N'Lan', '845623'
exec usp_ThemGiaoVien 'G003',N'Trần Minh',N'Hùng', '823456'
exec usp_ThemGiaoVien 'G004',N'Võ Thanh',N'Trung', '841256'
-- 
select * from GiaoVien

-- dữ iệu vào bảng 
create proc usp_ThemLopHoc
	@malop char(4), @tenlop nvarchar(30),  @ngaykg Datetime, @hocphi int, @ca tinyint, @sotiet int, @sohocvien int , @msgv char(4) 
as
	if exists (select * from CaHoc where Ca = @ca) and exists (select * from GiaoVien where MSGV = @msgv)	-- kiểm tra ràng buộc khóa ngoại
		begin
			if exists (select * from Lop where MaLop = @malop)
				print N'Đa có lớp ' + @malop + ' trong CSDL';
			else 
				begin 
					insert into Lop values (@malop, @tenlop, @ngaykg, @hocphi, @ca, @sotiet, @sohocvien, @msgv)
					print N'Thêm lớp học thành công'
				end
		end
	else	-- vi phạm ràng buộc khóa ngoại
		if not exists (select * from CaHoc where Ca = @ca)
			print N'Không có ca học ' + @ca + ' trong CSDL'
		else
			print N'không có giáo viên ' + @msgv + ' trong CSDL'
go
-- goi thuc hien thu tuc
set dateformat dmy
go
exec usp_ThemLopHoc 'A075',N'Access 2-4-6','18/12/2008', 150000,3,60,3,'G003'
exec usp_ThemLopHoc 'E114',N'Excel 3-5-7','02/01/2008', 120000,1,45,3,'G003'
exec usp_ThemLopHoc 'A115',N'Excel 2-4-6','22/01/2008', 120000,3,45,0,'G001'
exec usp_ThemLopHoc 'W123',N'Word 2-4-6','18/02/2008', 100000,3,30,1,'G001'
exec usp_ThemLopHoc 'W124',N'Word 3-5-7','01/03/2008', 100000,1,30,0,'G002'
select * from Lop

create proc usp_ThemHocVien
	@mshv char(4), @ho nvarchar(20), @ten nvarchar(10), @ngaysinh Datetime, @phai nvarchar(4), @malop char(4)
as
	if exists (select * from Lop where MaLop = @malop)	-- kiểm tra có ràng buộc toàn vẹn khóa ngoại
		begin 
			if exists (select * from HocVien where MSHV = @mshv)	-- kiểm tra có trùng khóa chính MSHV
				print N'Đã có mã số ' + @mshv + N' học viên này trong CSDL'
			else
				begin 
					insert into HocVien values (@mshv, @ho, @ten, @ngaysinh, @phai, @malop)
					print N'Thêm học viên thành công'
				end
		end
	else
		print N'Lớp ' + @malop + N' không tồn tại trong CSDL'
go

set dateformat dmy
go
exec usp_ThemHocVien '0001',N'Lê Văn', N'Minh', '10/06/1988',N'Nam', 'A075'
exec usp_ThemHocVien '0002',N'Nguyễn Thị', N'Mai', '20/04/1988',N'Nữ', 'A075'
exec usp_ThemHocVien '0003',N'Lê Ngọc', N'Tuấn', '10/06/1984',N'Nam', 'A075'
exec usp_ThemHocVien '0004',N'Vương Tuấn', N'Vũ', '25/03/1979',N'Nam', 'E114'
exec usp_ThemHocVien '0005',N'Lý Ngọc', N'Hân', '01/12/1985',N'Nữ', 'E114'
exec usp_ThemHocVien '0006',N'Trần Mai', N'Linh', '04/06/1980',N'Nữ', 'E114'
exec usp_ThemHocVien '0007',N'Nguyễn Ngọc', N'Tuyết', '12/05/1986',N'Nữ', 'W123'
-- xem dữ liệu bảng học viên vừa nhập vào
select * from HocVien

create proc usp_ThemHocPhi
	@sobl char(6), @mshv char(4), @ngaythu datetime, @sotien int, @noidung nvarchar(50), @nguoithu nvarchar(30)
as
	if exists (select * from HocVien where MSHV = @mshv)
		begin 
			if exists (select * from HocPhi where SoBL = @sobl)	-- kiểm tra có trùng khóa chính (SoBL)
				print N'Đã có biên lai học phí này trong CSDL'
			else
			begin
				insert into HocPhi values (@sobl, @mshv, @ngaythu, @sotien, @noidung, @nguoithu)
					print N'Thêm biên lai học phí thành công'
			end
		end
	else
		print N'Học viên ' + @mshv + N' không tồn tại trong CSDL'
go

set dateformat dmy
go
exec usp_ThemHocPhi 'A07501','0001','16/12/2008',150000,'HP Access 2-4-6', N'Lan'
exec usp_ThemHocPhi 'A07502','0002','16/12/2008',100000,'HP Access 2-4-6', N'Lan'
exec usp_ThemHocPhi 'A07503','0003','18/12/2008',150000,'HP Access 2-4-6', N'Vân'
exec usp_ThemHocPhi 'A07504','0002','15/01/2009',50000,'HP Access 2-4-6', N'Vân'
exec usp_ThemHocPhi 'E11401','0004','02/01/2008',120000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi 'E11402','0005','02/01/2008',120000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi 'E11403','0006','02/01/2008',80000,'HP Excel 3-5-7', N'Vân'
exec usp_ThemHocPhi 'W12301','0007','18/02/2008',100000,'HP Word 2-4-6', N'Lan'

select * from HocPhi

	

	