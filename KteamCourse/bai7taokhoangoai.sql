create database Primary_Foreign
go

use Primary_Foreign
go

create table BoMon (
	MaBM char(10) primary key,
	Name nvarchar(100) default N'Tên bộ môn'
)
go

create table Lop (
	MaLop char(10) not null,
	Name nvarchar(10) default N'Tên lớp'
	primary key (MaLop)
)
go

--- điều kiện để tạo khóa ngoại
-- tham chiếu tới khóa chính
-- unique, not null
-- cùng kiểu dữ liệu
-- cùng số lượng trường sắp xếp

-- lợi ích
-- đảm bảo toàn vẹn dữ liệu, ko có trường hợp tham chiếu tới dữ liệu ko tồn tại 
-- 

create table GiaoVien (
	MaGV char(10) not null,
	Name nvarchar(100) default N'Tên giáo viên',
	DiaChi nvarchar(100) default N'Địa chỉ giáo viên',
	NgaySinh Date,
	Sex bit,
	MaBM char(10),

	foreign key (MaBM) references dbo.BoMon(MaBM) -- tao khoa ngoai trong bang, ngay khi tao bang
)
go

alter table dbo.GiaoVien add primary key (MaGV)

create table HocSinh(
	MaHS char(10)  primary key,
	Name nvarchar(100)
	MaLop char(10)
)
go

-- tao khoa ngoai sau khi tao bang
alter table dbo.HocSinh add constraint FK_HS foreign key(MaLop) references dbo.Lop(MaLop)

-- huy khoa
-- alter table dbo.HocSinh drop constraint FK_HS
insert into dbo.BoMon (MaBM, Name)
values ('BM01',
		N'Bộ môn 1')

insert into dbo.BoMon (MaBM, Name)
values ('BM02',
		N'Bộ môn 2')

		insert into dbo.BoMon (MaBM, Name)
values ('BM03',
		N'Bộ môn 3')

insert dbo.GiaoVien (MaGV, Name, DiaChi, NgaySinh, Sex, MaBM)
values ('GV01', N'GV 1', N'DC 1', getdate(), 1, 'BM03')
insert dbo.GiaoVien (MaGV, Name, DiaChi, NgaySinh, Sex, MaBM)
values ('GV02', N'GV 1', N'DC 1', getdate(), 1, 'BM01')