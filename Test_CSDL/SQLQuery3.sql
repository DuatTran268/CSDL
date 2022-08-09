CREATE TABLE SinhVien (
    Mssv int,
    HoTen nvarchar(50) ,
    Lop nvarchar(15),
	Diem float,
	DiaChi nvarchar(100)
);

INSERT INTO SinhVien (Mssv, HoTen, Lop, Diem, DiaChi)
VALUES (2015597, N'Đoàn Quang Huy', N'CTK44B', 9.5, N'Ninh Thuận');

CREATE TABLE GiangVien (
	MaGv int primary key not null,
	HoTen nvarchar(50), 
	BoMon nvarchar(25),
	GioiTinh bit,
	DiaChi nvarchar(100)
);

INSERT INTO GiangVien 
VALUES (123456, N'Trần Thống', N'CSDL', 1, N'Lâm Đồng');

