/*
Học phần cơ sở dữ liệu
Người thực hiện: Trần Nhật Duật
-- Lab01_QuanLyNhanVien
-- thực hiện theo thủ tục nhập 
*/

create database Lab01_QuanLyNhanVien
go

use Lab01_QuanLyNhanVien
go

create table ChiNhanh(
	MSCN char(2) primary key,
	TenCN nvarchar(30)
)
go

create table NhanVien(
	MSNV char(04) primary key,
	Ho nvarchar(30),
	Ten nvarchar(10),
	NgaySinh datetime,
	NgayVaoLam datetime,
	MSCN char(2) references ChiNhanh(MSCN)
)
go

create table KyNang(
	MSKN char(2) primary key,
	TenKN nvarchar(30),
)
go

create table NhanVienKyNang (
	MSNV char(4) references NhanVien(MSNV),
	MSKN char(2) references KyNang(MSKN),
	MucDo	tinyint check(MucDo between 1 and 9)--check(MucDo>=1 and MucDo<=9)
	primary key(MSNV,MSKN) --khai báo khóa chính gồm nhiều thuộc tính
)

select * from ChiNhanh
select * from NhanVien
select * from KyNang
select * from NhanVienKyNang

-- ham nhap thu tuc du lieu
-- nhap cho bang chi nhanh
create proc usp_ThemChiNhanh
@mscn char(2),
@tencn nvarchar(30)
as
	if exists (select * from ChiNhanh where MSCN = @mscn)
		print N'Đã tồn tại mã chi nhánh ' + @mscn + ' trong CSDL'
	else
		begin
			insert into ChiNhanh values (@mscn, @tencn)
			print N'Nhập vào dữ liệu thành công'
		end
go
 exec usp_ThemChiNhanh '01',N'Quận 1'
 exec usp_ThemChiNhanh '02',N'Quận 5'
 exec usp_ThemChiNhanh '03',N'Bình Thạnh'
 -- xem dữ liệu vừa nhập vào bảng
 select * from ChiNhanh

-- nhập dữ liệu cho bảng NhanVien
create proc usp_ThemNhanVien
@msnv char(4),
@ho nvarchar(30),
@ten nvarchar(10),
@ngaysinh datetime,
@ngayvaolam datetime,
@mscn char(2)	-- khóa ngoại tham chiếu đến khóa chính bảng chi nhánh
as
	-- b1: kiểm tra có ràng buộc toàn vẹn khóa ngoại
	if exists (select * from ChiNhanh where MSCN = @mscn)
		begin
			-- kiểm tra xem có trùng khóa chính của bảng
			if exists (select * from NhanVien where MSNV = @msnv)
				print N'Đã tồn tại mã nhân viên ' + @msnv + ' trong CSDL'
			else
				begin
					insert into NhanVien values (@msnv, @ho, @ten, @ngaysinh, @ngayvaolam, @mscn)
					print N'Nhập dữ liệu thành công'
				end
		end
	else
		print N'Không tồn tại ' + @mscn + ' trong CSDL '
go

set dateformat dmy
go
exec usp_ThemNhanVien '0001',N'Lê Văn',N'Minh','10/06/1960','02/05/1986','01'
exec usp_ThemNhanVien '0002',N'Nguyễn Thị',N'Mai','20/04/1970','04/07/2002','01'
exec usp_ThemNhanVien '0003',N'Lê Anh',N'Tuấn','25/06/1975','01/09/1982','02'
exec usp_ThemNhanVien '0004',N'Vương Tuấn',N'Vũ','25/03/1960','12/01/1986','02'
exec usp_ThemNhanVien '0005',N'Lý Anh',N'Hân','01/12/1980','15/05/2004','02'
exec usp_ThemNhanVien '0006',N'Phan Lê',N'Tuấn','04/06/1976','25/10/2002','03'
exec usp_ThemNhanVien '0007',N'Lê Tuấn',N'Tú','15/08/1975','15/08/2000','03'
-- xem dữ liệu
select * from NhanVien


-- nhập dữ liệu cho bảng kỹ năng
create proc usp_ThemKyNang
@mskn char(2),
@tenkn nvarchar(30)
as
	if exists (select * from KyNang where MSKN = @mskn)
		print N'Đã tồn tại mã số kỹ năng ' + @mskn + ' trong CSDL'
	else
		begin
			insert into KyNang values (@mskn, @tenkn)
			print N'Thêm dữ liệu thành công'
		end
go

exec usp_ThemKyNang '01', N'Word'
exec usp_ThemKyNang '02', N'Excel'
exec usp_ThemKyNang '03', N'Access'
exec usp_ThemKyNang '04', N'Power Point'
exec usp_ThemKyNang '05', N'SPSS'
-- xem dữ liệu
select * from KyNang

-- nhập dữ liệu bảng nhân viên kỹ năng
create proc usp_ThemNhanVienKyNang
@msnv char(4),
@mskn char(2),
@mucdo tinyint
as
	if exists (select * from NhanVien where MSNV = @msnv) and exists (select * from KyNang where MSKN = @mskn)
		begin
			if exists (select * from NhanVienKyNang where MSKN = @mskn) and exists (select * from NhanVienKyNang where MSKN = @mskn)
				print N'Đã tồn tại mã số nhân viên ' + @msnv + N' trong CSDL'
			else 
				begin
					insert into NhanVienKyNang values (@msnv, @mskn, @mucdo)
					print N'Nhập dữ liệu thành công'
				end
		end
	else
		print N'Không tồn tại mã số nhân viên ' + @msnv + ' trong CSDL ko thể thêm vào bảng'
go

exec usp_ThemNhanVienKyNang '0001','01',2
exec usp_ThemNhanVienKyNang '0001','02',1
exec usp_ThemNhanVienKyNang '0002','01',2
exec usp_ThemNhanVienKyNang '0002','03',2
exec usp_ThemNhanVienKyNang '0003','02',1
exec usp_ThemNhanVienKyNang '0003','03',2
exec usp_ThemNhanVienKyNang '0004','01',5
exec usp_ThemNhanVienKyNang '0004','02',4
exec usp_ThemNhanVienKyNang '0004','03',1
exec usp_ThemNhanVienKyNang '0005','02',4
exec usp_ThemNhanVienKyNang '0005','04',4
exec usp_ThemNhanVienKyNang '0006','05',4
exec usp_ThemNhanVienKyNang '0006','02',4
exec usp_ThemNhanVienKyNang '0006','03',2
exec usp_ThemNhanVienKyNang '0007','03',4
exec usp_ThemNhanVienKyNang '0007','04',3
-- xem dữ liệu nhập vào
select * from NhanVienKyNang
