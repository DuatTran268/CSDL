-- unique: duy nhất -> trong toàn bộ bảng. trường nào có từ khóa unique thì ko thể có 2 giá trị trùng nhau
-- not null: trường đó ko được phép null
-- default: giá trị mặc định của trường đó nếu ko gán giá trị insert

-- trường hợp 1: tạo bảng 
create table TestPrimaryKey1(
	ID int unique not null,
	Name nvarchar(100) default N'Trần Nhật Duật'
)
go
-- trường hợp 2: khi đã tạo bảng muốn sửa cột thành primary key 
alter table dbo.TestPrimaryKey1 add primary key (ID)

insert dbo.TestPrimaryKey1(ID)
values (10)
insert dbo.TestPrimaryKey1(ID)
values (11)
insert dbo.TestPrimaryKey1(ID)
values (12)
-- trường hợp 3: tạo primary key trong bảng ko phải ngay khi khai báo
create table TestPrimaryKey2(
	ID int not null,
	name nvarchar(100) default N'Duật Nhật Trần'
	-- tạo khóa chính
	primary key (ID)
)
go

-- trường hợp 4: tạo primary key ngay trong bảng mà đặt tên cho key đó
create table TestPrimaryKey3(
	ID int not null,
	name nvarchar(100) default N'Duật Nhật Trần'
	constraint pk_test3		--sau này xóa key cho dễ
	-- tạo khóa chính
	primary key (ID)
)
go

-- trường hợp 5: tạo primary key sau khi tạo bảng và đặt tên cho key đó 
create table TestPrimaryKey4(
	ID int not null,
	Name nvarchar(100) default N'Trần Nhật Duật'
)
go
-- cấu trúc để set primary key cấu trúc bảng nào đó mà muốn add thêm cái tên cho primary key
alter table TestPrimaryKey4 
add constraint PK_Test4
primary key (ID)

-- trường hợp khóa chính là 2 trường
create table TestPrimaryKey5 (
	ID1 int not null,
	ID2 int not null,
	Name nvarchar(100) default N'Duật Trần' 

	primary key (ID1, ID2)	-- set khóa chính primary key 2 trường hợp
)
go