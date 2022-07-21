

create database CSDL_CTK44A_2012365_NguyenMinhLong
go

use CSDL_CTK44A_2012365_NguyenMinhLong
go

Create table SinhVien (
MaSV char(7) primary key, 
TenSV nvarchar(20), 
Lop char(3) 
)
go
create table chuyennganh
(
	mscn char(2) primary key not null,
	tencn nvarchar(50)
)
go

create table congviec
(
	mscv char(2) primary key not null,
	tencv nvarchar(50)
	
)
go

create table detai
(
	msdt char(6) primary key,
	tendt nvarchar(50),
	mscn char(2) references chuyennganh(mscn),
	ngaybd datetime,
	ngaynt datetime
	
)
go

create table thuchiendetai
(
	masv char(7) references sinhvien(masv),
	msdt char(6) references detai(msdt),
	mscv char(2) references congviec(mscv),
	diem int,
	primary key (masv, msdt)

)
go



create proc themsinhvien 
@maSV char(7),
@tenSV nvarchar(50),
@lop char(3)
as
	if exists (select * from SinhVien where MaSV=@maSV)
		print N'da trung ma sinh vien'
		else begin
			insert into SinhVien values(@maSV,@tenSV,@lop)
			print N'xong'
			end
go
exec themsinhvien '0400001',N'Nguyễn Văn An','K28'
exec themsinhvien'0300095',N'Trần Hùng','K27'
exec themsinhvien'0310005',N'Lê Thúy Hằng','K27'
exec themsinhvien'0400023',N'Ngô Khoa','K28'
exec themsinhvien'0400100',N'Phạm Tài','K28'
exec themsinhvien'0310100',N'Định Tiến','K27'
select * from SinhVien


create proc themChuyenNganh
@msCN char(2),
@tenCN nvarchar(50)
as
	if exists (select * from chuyennganh where mscn =@msCN)
		print N'da trung ma '
		else begin
			insert into chuyennganh values(@msCN,@tenCN)
			print N'xong'
			end
	
go

exec themChuyenNganh '01',N'Hệ thống thông tin'
exec themChuyenNganh'02',N'Mạng'
exec themChuyenNganh'03',N'Đồ họa'
exec themChuyenNganh'04',N'Công nghệ phần mềm'
select *from chuyennganh

	
create proc themCongViec
@msCV char(2),
@tenCV nvarchar(50)
as
	if exists (select * from congviec where mscv=@msCV)
		print N'da trung ma '
		else begin
			insert into congviec values(@msCV,@tenCV)
			print N'xong'
			end
	
go
exec themCongViec'C1',N'Trưởng nhóm'
exec themCongViec'C2',N'Thu thập thông tin'
exec themCongViec'C3',N'Phân tích'
exec themCongViec'C4',N'Thiết kế'
select *from congviec

	
create proc themDeTai
@msDT char(6) ,
@tendt nvarchar(50),
@mscn char(2),
@ngaybd datetime,
@ngaynt datetime
as
		if exists (select * from detai where msdt=@msDT)
		print N'da trung ma '
		else begin
			if exists (select * from chuyennganh where mscn=@mscn)
				begin
				insert into detai values(@msDT,@tendt,@mscn,@ngaybd,@ngaynt)
				print N'xong'
				end
			else print N'ko tim thay ma so'
			end
	
go
exec themDeTai'DT0601',N'Quản lý thư viên','01','20070915','20071215'
exec themDeTai'DT0602',N'Nhận dạng vân tay','03','20070915','20071215'
exec themDeTai'DT0603',N'Bán đấu giá trên mạng','02','20070915','20071215'
exec themDeTai'DT0604',N'Quản lý siêu thị','04','20070915','20071215'
exec themDeTai'DT0605',N'Giấu tin trong ảnh','03','20070915','20071215'
exec themDeTai'DT0606',N'Phát hiện tấn công trên mạng','02','20070915','20071215'
select * from detai

exec themDeTai'DT0601',N'Quản lý thư viên','05','20070915','20071215'


alter proc themThucHienDetai
@masv char(7) ,
@msdt char(6) ,
@mscv char(2),
@diem int
	
as
	if exists (select * from SinhVien where @masv=MaSV)
		and exists (select * from detai where @msdt=msdt)
		
		begin
				insert into thuchiendetai values(@masv,@msdt,@mscv,@diem)
				print N'xong'
		end
					else 
							begin
								if not exists (select * from SinhVien where @masv=MaSV)
								print N'ko tim thay mssv'
								else
								print N'ko tim thay ma so de tai'
							end 
go
exec themThucHienDeTai'0400001','DT0601','C1',7
exec themThucHienDeTai'0400001','DT0603','C2',8
exec themThucHienDeTai'0300095','DT0602','C2',9
exec themThucHienDeTai'0310005','DT0604','C3',8
exec themThucHienDeTai'0400023','DT0601','C3',6
exec themThucHienDeTai'0400023','DT0605','C4',8
exec themThucHienDeTai'0400100','DT0603','C3',8
exec themThucHienDeTai'0310100','DT0604','C4',6
exec themThucHienDeTai'0310100','DT0601','C2',5
select * from thuchiendetai
select * from SinhVien

exec themThucHienDeTai'1234567','DT0601','C1',7
exec themThucHienDeTai'0400023','DT9999','C4',8
select * from detai

exec themDeTai'DT0610',N'Quản lý thư viên','01','20070915','20070115'
delete detai where msdt='DT0610'


select * from detai
alter trigger cau10
on detai for insert,update
as
	if update(ngaybd) or update (ngaynt)
		if exists (select * from inserted i where i.ngaybd>i.ngaynt)
			begin
				raiserror(N'Loi ...',15,1)
				rollback tran --huy bo lenh
			end
go

