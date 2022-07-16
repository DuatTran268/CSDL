/*
Học phần cơ sở dữ liệu
Người thực hiện: Trần Nhật Duật
Lớp CTK44B
Mssv: 2012254
*/

create database Lab06_QLHocVien
go
use Lab06_QLHocVien
go

create table CaHoc(
Ca tinyint primary key,		-- kiểu dữ liệu tinyint: kích thước từ 0 -> 255
GioBatDau datetime,
GioKetThuc datetime
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
NgayKG datetime,
HocPhi int,
Ca tinyint references CaHoc(Ca),
SoTiet int,
SoHV int,
MSGV char(4) references GiaoVien(MSGV)
)
go
create table HocVien(
MSHV char(4) primary key,
Ho nvarchar(30),
Ten nvarchar(10),
NgaySinh datetime,
Phai nvarchar(4),
MaLop char(4) references Lop(MaLop)
)
go
create table HocPhi(
SoBL char(6) primary key,
MSHV char(4) references HocVien(MSHV),
NgayThu datetime,
SoTien int,
NoiDung nvarchar(50),
NguoiThu nvarchar(30)
)
go

--drop table HocPhi	-- lệnh xóa bảng

-- xem các bảng vừa tạo
select * from CaHoc
select * from GiaoVien
select * from Lop
select * from HocVien
select * from HocPhi

-- xây dựng các thủ tục nhập dữ liệu vào các bảng
create proc usp_CaHoc
@ca tinyint,
@giobd datetime,
@giokt datetime
as	
-- exists: tồn tại điều kiện -> nếu tồn tại điều kiện-> thì
	if exists (select * from CaHoc where Ca = @ca) -- kiểm tra xem có trùng khóa chính Ca
		print N'Đã có ca học ' + @ca + N' trong CSDL'
	else
		begin
			insert into CaHoc values (@ca, @giobd, @giokt)
			print N'Thêm ca học thành công'
		end
go
-- gọi thực hiện thủ tục usp_CaHoc
exec usp_CaHoc 1,'7:30', '10:45'
exec usp_CaHoc 2,'13:30', '16:45'
exec usp_CaHoc 3,'17:30', '20:45'
select * from CaHoc

-- thêm dữ liệu vào bảng giáo viên
create proc usp_GiaoVien
@magv char(4),
@hogv nvarchar(20),
@tengv nvarchar(10),
@dienthoai varchar(11)
as
	if exists (select * from GiaoVien where MSGV = @magv)	-- kiểm tra khóa chính nếu có trùng lặp lại xuất ra thông báo
		print N'Đã tồn tại Mã GV ' + @magv + N' trong CSDL'
	else
		begin
			insert into GiaoVien values (@magv, @hogv, @tengv, @dienthoai)
			print N'Thêm giáo viên thành công'
		end
go

exec usp_GiaoVien 'G001',N'Lê Hoàng',N'Anh', '858936'
exec usp_GiaoVien 'G002',N'Nguyễn Ngọc',N'Lan', '845623'
exec usp_GiaoVien 'G003',N'Trần Minh',N'Hùng', '823456'
exec usp_GiaoVien 'G004',N'Võ Thanh',N'Trung', '841256'
select * from GiaoVien

-- nhập dữ liệu vào bảng lớp
create proc usp_Lop
@malop char(4),
@tenlop nvarchar(30),
@ngaykg datetime,
@hocphi int,
@ca tinyint,		-- khóa ngoại ca tham chiếu đến khóa chính trong bảng CaHoc
@sotiet int,
@sohv int,
@msgv char(4)		-- khóa ngoại msgv tham chiếu đến khóa chính trong bảng GiaoVien
as
	-- kiểm tra các ràng buộc toàn vẹn khóa ngoại
	if exists (select * from CaHoc where Ca = @ca) and exists (select * from GiaoVien where MSGV = @msgv)
		begin
			if exists (select * from Lop where MaLop = @malop)	-- kiểm tra có trùng khóa chính của quan hệ Lớp
				print N'Đã có mã lớp ' + @malop + ' trong CSDL'
			else
				begin
					insert into Lop values (@malop, @tenlop, @ngaykg, @hocphi, @ca, @sotiet, @sohv, @msgv)
					print N'Thêm dữ liệu vào bảng lớp học thành công'
				end
		end
	else
		print N'Lớp ' + @malop + N' không tồn tại trong CSDL nên không thể thêm học viên vào lớp này'
go
-- gọi thực hiện thủ tục usp_Lop
set dateformat dmy
go
exec usp_Lop 'A075',N'Access 2-4-6','18/12/2008', 150000,3,60,3,'G003'
exec usp_Lop 'E114',N'Excel 3-5-7','02/01/2008', 120000,1,45,3,'G003'
exec usp_Lop 'A115',N'Excel 2-4-6','22/01/2008', 120000,3,45,0,'G001'
exec usp_Lop 'W123',N'Word 2-4-6','18/02/2008', 100000,3,30,1,'G001'
exec usp_Lop 'W124',N'Word 3-5-7','01/03/2008', 100000,1,30,0,'G002'
-- xem dữ liệu bảng vừa nhập
select * from Lop

-- nhập dữ liệu cho bảng học viên
create proc usp_HocVien
@mshv char(4),
@ho nvarchar(30),
@ten nvarchar(10),
@ngaysinh datetime,
@phai nvarchar(4),
@malop char(4)	-- khóa ngoại mã lớp tham chiếu đến khóa chính mã lớp ở bảng Lớp
as
	-- kiểm tra có ràng buộc toàn vẹn khóa ngoại
	if exists (select * from Lop where MaLop = @malop)
		begin 
			if exists (select * from HocVien where MSHV = @mshv)
				print N'Đã tồn tại mã học viên ' + @mshv + N' trong CSDL'
			else
				begin
					insert into HocVien values (@mshv, @ho, @ten, @ngaysinh, @phai, @malop)
					print N'Thêm học viên thành công'
			end
		end
	else
		print N'Lớp ' + @malop + N' không tồn tại trong CSDL'
go
-- gọi thực hiện thủ tục
set dateformat dmy
go
exec usp_HocVien '0001',N'Lê Văn', N'Minh', '10/06/1988',N'Nam', 'A075'
exec usp_HocVien '0002',N'Nguyễn Thị', N'Mai', '20/04/1988',N'Nữ', 'A075'
exec usp_HocVien '0003',N'Lê Ngọc', N'Tuấn', '10/06/1984',N'Nam', 'A075'
exec usp_HocVien '0004',N'Vương Tuấn', N'Vũ', '25/03/1979',N'Nam', 'E114'
exec usp_HocVien '0005',N'Lý Ngọc', N'Hân', '01/12/1985',N'Nữ', 'E114'
exec usp_HocVien '0006',N'Trần Mai', N'Linh', '04/06/1980',N'Nữ', 'E114'
exec usp_HocVien '0007',N'Nguyễn Ngọc', N'Tuyết', '12/05/1986',N'Nữ', 'W123'
select * from HocVien

-- nhập dữ liệu cho bảng học phí
create proc usp_HocPhi
@sobl char(6),
@mshv char(4),
@ngaythu datetime,
@sotien int,
@noidung nvarchar(50),
@nguoithu nvarchar(30)
as
	-- kiểm tra ràng buộc toàn vẹn khóa ngoại
	if exists (select * from HocVien where MSHV = @mshv)
		begin
			if exists (select * from HocPhi  where SoBL = @sobl)	-- kiểm tra xem có trùng khóa (số biên lai)
				print N' Đã tồn tại số biên lai ' + @sobl + N' trong CSDL'
			else
				begin
					insert into HocPhi values (@sobl, @mshv, @ngaythu, @sotien, @noidung, @nguoithu)
					print N'Thêm dữ liệu vào bảng Học phí thành công'
				end
		end
	else
		print N'Học viên ' + @mshv + N' không tồn tại bên trong CSDL'
go
----goi thuc hien thu tuc usp_ThemHocPhi-------
set dateformat dmy
go
exec usp_HocPhi 'A07501','0001','16/12/2008',150000,'HP Access 2-4-6', N'Lan'
exec usp_HocPhi 'A07502','0002','16/12/2008',100000,'HP Access 2-4-6', N'Lan'
exec usp_HocPhi 'A07503','0003','18/12/2008',150000,'HP Access 2-4-6', N'Vân'
exec usp_HocPhi 'A07504','0002','15/01/2009',50000,'HP Access 2-4-6', N'Vân'
exec usp_HocPhi 'E11401','0004','02/01/2008',120000,'HP Excel 3-5-7', N'Vân'
exec usp_HocPhi 'E11402','0005','02/01/2008',120000,'HP Excel 3-5-7', N'Vân'
exec usp_HocPhi 'E11403','0006','02/01/2008',80000,'HP Excel 3-5-7', N'Vân'
exec usp_HocPhi 'W12301','0007','18/02/2008',100000,'HP Word 2-4-6', N'Lan'
		
select * from HocPhi
