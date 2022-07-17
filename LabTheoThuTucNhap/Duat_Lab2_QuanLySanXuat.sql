/*
	Học phần cơ sở dữ liệu
	Ngày 07/03/2022
	Người thực hiện: Trần Nhật Duật
	MSSV: 2012254
	Lab 02: Quản lý sản xuất
	Thực hiện theo cách xây dựng thủ tục nhập dữ liệu
*/

-- lệnh tạo csdl
create database Lab02_QuanLySanXuat
go
-- lệnh sử dụng csdl
use Lab02_QuanLySanXuat
go

-- lệnh tạo các bảng
create table ToSanXuat(
MaTSX char(4) primary key, -- khai báo mã tổ sản xuất là khóa chính
TenTSX nvarchar(20) not null unique
)
go
create table CongNhan(
MaCN char(5) primary key, -- mã công nhân là khóa chính
Ho nvarchar(20) not null, 
Ten nvarchar(10) not null,
Phai nvarchar(3),
NgaySinh datetime,
MaTSX char(4) references ToSanXuat(MaTSX)
-- khai báo MaTSX là khóa ngoại tham chiếu đến khóa chính MaTSX của quan hệ ToSanXuat sử dụng references
)
go
create table SanPham(
MaSP char(5) primary key, -- MaSP làm khóa chính
TenSP nvarchar(30) not null,
DVT nvarchar(10),
TienCong int check(TienCong > 0) -- kiểm tra tiền công > 0 sử dụng check
)
go
create table ThanhPham(
MaCN char(5) references CongNhan(MaCN),		-- khoa ngoai tham chieu den khoa chinh cua quan he CongNhan
MaSP char(5) references SanPham(MaSP),
Ngay datetime,
SoLuong int check (SoLuong > 0)	-- kiểm tra số lượng > 0
primary key	(MaCN, MaSP, Ngay)	-- khai báo khóa chính gồm có nhiều thuộc tính
)
go

--=========== LỆNH XEM DỮ LIỆU TRONG BẢNG =====================
select * from ToSanXuat
select * from CongNhan
select * from SanPham
select * from ThanhPham


-- xây dựng các thủ tục nhập dữ liệu
create proc usp_ToSanXuat
@matsx char(4),
@tentsx nvarchar(20)
as
	--exists: tồn tại ( nếu tồn tại điều kiện )
	--b1: kiểm tra xem có trùng khóa chính MaTSX
	if exists (select * from ToSanXuat where MaTSX = @matsx)	
		print N'Đã tồn tại mã tổ sản xuất'+ @matsx+ N' này trong CSDL'
	else
		-- lệnh begin - end dùng để khai báo một khối lệnh SQL . Một khối lệnh là tập hợp những câu SQL sữ thực thi chung với nhau (tương tự như cặp dấu {} thể hiện cho khối lệnh)
		begin
			insert into ToSanXuat values (@matsx, @tentsx)
			print N'Dữ liệu nhập thành công'
		end
go
-- gọi thực hiện thủ tục usp_ToSanXuat
exec usp_ToSanXuat 'TS01', N'Tổ 1'
exec usp_ToSanXuat 'TS02', N'Tổ 2'
-- xem dữ liệu đã nhập vào bảng
select * from ToSanXuat

-- xây dựng thủ tục nhập vào bảng công nhân
create proc usp_CongNhan
@macn char(5),
@ho nvarchar(20),
@ten nvarchar(10),
@phai nvarchar(3),
@ngaysinh datetime,
@matsx char(4)		-- khóa ngoại tham chiếu đến khóa chính MaTSX của bảng ToSanXuat
as
	--b1: kiểm tra xem có ràng buộc toàn vẹn khóa ngoại
	if exists (select * from ToSanXuat where MaTSX = @matsx)
		begin
			--b2: kiểm tra có trùng khóa chính của bảng
			if exists (select * from CongNhan where MaCN = @macn)
				print 'Đã tồn tại mã công nhân ' + @macn + N' trong CSDL'
			else
				begin
					insert into CongNhan values (@macn, @ho, @ten, @phai, @ngaysinh, @matsx)
					print N'Dữ liệu nhập vào thành công'
				end
		end
	else
		print N'Không tồn tại ' + @macn + N' trong CSDL không thể thêm dữ liệu vào bảng'
go
-- gọi thực hiện thủ tục
set dateformat dmy	-- set format kiểu dữ liệu datetime
exec usp_CongNhan 'CN001',N'Nguyễn Trường',N'An',N'Nam','12/05/1981','TS01'
exec usp_CongNhan 'CN002',N'Lê Thị Hồng',N'Gấm',N'Nữ','04/06/1980','TS01'
exec usp_CongNhan 'CN003',N'Nguyễn Công',N'Thành',N'Nam','04/05/1981','TS02'
exec usp_CongNhan 'CN004',N'Võ Hữu',N'Hạnh',N'Nam','15/02/1980','TS02'
exec usp_CongNhan 'CN005',N'Lý Thanh',N'Hân',N'Nữ','03/12/1981','TS01'
select * from CongNhan

-- nhập dữ liệu cho bảng sản phẩm
create proc usp_SanPham
@masp char(5),		-- masp làm khóa chính
@tensp nvarchar(30),
@dvt nvarchar(10),
@tiencong int
as
	if exists (select * from SanPham where MaSP = @masp)
		print N'Đã tồn tại mã sản phẩm ' + @masp + N' trong CSDL'
	else
		begin 
			insert into SanPham values (@masp, @tensp, @dvt, @tiencong)
			print N'Dữ liệu nhập vào thành công'
		end
go

exec usp_SanPham 'SP001',N'Nồi đất',N'cái',10000
exec usp_SanPham 'SP002',N'Chén',N'cái',2000
exec usp_SanPham 'SP003',N'Bình gốm nhỏ',N'cái',20000
exec usp_SanPham 'SP004',N'Bình gốm lớn',N'cái',25000
-- xem dữ liệu
select * from SanPham
--delete from SanPham where MaSP = 'SP04'

---- nhập dữ liệ vào bảng thành phẩm
--create proc usp_ThanhPham
--@macn char(5),	-- khóa ngoại tham chiếu đến bảng Công Nhân
--@masp char(5),	-- khóa ngoại tham chiếu đến bảng Sản Phẩm
--@ngay datetime,
--@soluong int
--as
---- kiểm tra ràng buộc toàn vẹn khóa ngoại
--	if exists (select * from CongNhan where MaCN = @macn) and exists (select * from SanPham where MaSP = @masp)
--		begin
--			-- kiểm tra có trùng khóa chính của bảng (Gồm 3 khóa chính)
--			if exists (select * from ThanhPham where MaCN = @macn)
--				print N'Đã tồn tại trong CDSL'
--			else
--				begin
--					insert into CongNhan values (@macn, @masp, @ngay, @soluong)
--					print N'Nhập vào dữ liệu thành công'
--				end
--		end
--	else
--		print N'Không tồn tại trong CSDL'
--go

--set dateformat dmy	--khai báo định dạng ngày tháng
--go
--exec usp_ThanhPham 'CN001','SP001','01/02/2007',10
--exec usp_ThanhPham 'CN002','SP001','01/02/2007',5
--exec usp_ThanhPham 'CN003','SP002','10/01/2007',50
--exec usp_ThanhPham 'CN004','SP003','12/01/2007',10
--exec usp_ThanhPham 'CN005','SP002','12/01/2007',100
--exec usp_ThanhPham 'CN002','SP004','13/02/2007',10
--exec usp_ThanhPham 'CN001','SP003','14/02/2007',15
--exec usp_ThanhPham 'CN003','SP001','15/01/2007',20
--exec usp_ThanhPham 'CN003','SP004','14/02/2007',15
--exec usp_ThanhPham 'CN004','SP002','30/01/2007',100
--exec usp_ThanhPham 'CN005','SP003','01/02/2007',50
--exec usp_ThanhPham 'CN001','SP001','20/02/2007',30
---- xem dữ liệu
--select * from ThanhPham

-- truy vấn dữ liệu
--1. liệt kê các công nhân theo tổ sản xuất gồm các thông tin: TenTSX, HoTen, NgaySinh, Phai
select TenTSX, Ho + ' ' + Ten as HoTen, NgaySinh, Phai  
from CongNhan a, ToSanXuat b
where a.MaTSX = b.MaTSX
order by TenTSX, Ho + ' ' + Ten

-- 2. Liệt kê các thành phẩm mà công nhân 'Nguyễn Trường An ' đã làm được gồm các thông tin TenSP, Ngay, SoLuong, ThanhTien
select TenSP, Ngay, SoLuong, SoLuong * TienCong as ThanhTien 
from CongNhan a, SanPham b, ThanhPham c
where a.MaCN = c.MaCN and b.MaSP = c.MaSP and a.Ho = N'Nguyễn Trường' and a.Ten = N'An'
order by Ngay

-- 3. liệt kê các nhân viên không sản xuất bình gốm lớn
select MaCN, Ho + ' ' + Ten as HoTen 
from CongNhan a
where MaCN not in(
	select MaCN 
	from SanPham b, ThanhPham c
	where b.MaSP = c.MaSP and b.TenSP = N'Bình gốm lớn'
)

-- liệt kê các nhân viên có sản xuất nồi đất
select MaCN, Ho + ' ' + Ten as HoTen
from CongNhan a
where a.MaCN in (
	select MaCN
	from SanPham b, ThanhPham c
	where b.MaSP = c.MaSP and b.TenSP = N'Nồi đất'
)

-- liệt kê thông tin các công nhân có sản xuất cả nồi đất và bình gốm nhỏ
/*
b1: truy vấn ra dữ liệu các công nhân sản xuất nồi đất
b2: sử dụng mã công nhân truy vấn lồng các công nhân có sản xuất bình gốm nhỏ
*/
select distinct a.MaCN, Ho + ' ' + Ten as HoTen 
from CongNhan a, SanPham b, ThanhPham c
where a.MaCN = c.MaCN and b.MaSP = c.MaSP and TenSP = N'Nồi đất' 
and a.MaCN in (
	select MaCN
	from SanPham e, ThanhPham f
	where e.MaSP = f.MaSP and TenSP = N'Bình gốm nhỏ'
)

-- 5. Thống kê số lượng công nhân theo từng tổ sản xuất
select a.MaTSX , TenTSX, COUNT(a.MaCN) as N'Số công nhân trong tổ sản xuất' 
from CongNhan a, ToSanXuat b
where a.MaTSX = b.MaTSX
group by a.MaTSX, TenTSX -- lấy ra cái gì group cái đó

-- 6. Tổng số lượng thành phẩm theo từng loại mà mỗi nhân viên làm được
select a.MaCN, Ho + ' ' + Ten as HoTen , TenSP, SUM(SoLuong) as N'Tổng số lượng thành phẩm', SUM(SoLuong * TienCong) as N'Tổng thành tiền'
from CongNhan a, SanPham b, ThanhPham c
where a.MaCN = c.MaCN and b.MaSP = c.MaSP
group by a.MaCN, Ho, Ten, TenSP
order by a.MaCN

-- 7. Tổng số tiền công đã trả cho công nhân tháng 1 năm 2007
select SUM(SoLuong*TienCong) as N'Tổng tiền công trả 1/2007' 
from SanPham a, ThanhPham b
where a.MaSP = b.MaSP and MONTH(Ngay) = 1 and YEAR(Ngay) = 2007

-- 8. Cho biết sản phẩm được sản xuất nhiều nhất tháng 2/2007
select a.MaSP, TenSP, SUM(SoLuong) as N'Số lượng sản phẩm' 
from SanPham a, ThanhPham b
where a.MaSP = b.MaSP and MONTH(Ngay) = 2 and YEAR(Ngay) = 2007
group by a.MaSP, TenSP
having SUM(SoLuong) >= all(
	select SUM(c.SoLuong) 
	from ThanhPham c
	where MONTH(Ngay) = 2 and YEAR(Ngay) = 2007
	group by c.MaCN
)
-- 9. Cho biết công nhân sản xuất được nhiều chén nhất
select a.MaCN, Ho + ' ' + Ten as HoTen, TenSP, COUNT(distinct b.MaSP) 
from CongNhan a, ThanhPham b, SanPham c
where a.MaCN = b.MaCN and b.MaSP = c.MaSP and TenSP = N'Chén'
group by a.MaCN, Ho, Ten,TenSP
having SUM(SoLuong) >= all(
	select SUM(SoLuong)
	from ThanhPham d, SanPham e
	where d.MaSP = e.MaSP and TenSP = N'Chén'
	group by d.MaCN
)

-- 10. tiền công tháng 2/ 2006 của công nhân viên có mã số 'CN002'
select a.MaCN, Ho + ' '  + Ten as HoTen, SUM(SoLuong * TienCong) as N'Tiền công tháng 2'
from CongNhan a, ThanhPham b, SanPham c
where b.MaSP = c.MaSP and MONTH(Ngay) = 2 and YEAR(Ngay) = 2007 and b.MaCN = 'CN002'
group by a.MaCN, Ho, Ten

-- 11. liệt kê các công nhân có sản xuất từ 2 loại sản phẩm trở lên
select a.MaCN, Ho + ' ' + Ten as HoTen, COUNT(distinct MaSP) as N'Số lượng sản phẩm' 
from CongNhan a, ThanhPham b
where a.MaCN = b.MaCN
group by a.MaCN, Ho, Ten
having count(distinct MaSP) >= 3

-- 12. cập nhật giá tiền công cả các loại bình gốm thêm 1000
update SanPham 
set TienCong = TienCong + 1000
where TenSP like N'Bình gốm%'
-- xem lại bảng dữ liệu sau khi cập nhật
select * from SanPham

/*13. Thêm bộ <’CN006’, ‘Lê Thị’, ‘Lan’, ‘Nữ’,’TS02’ > vào bảng CongNhan.*/
insert into CongNhan values ('CN006', N'Lê Thị', N'Lan', N'Nữ',NULL,'TS02')
-- xem lại dữ liệu bảng công nhân sau khi thêm vào
select * from CongNhan
-- xóa dữ liệu bảng công nhân bằng mã công nhân
delete from CongNhan where MaCN = 'CN006'