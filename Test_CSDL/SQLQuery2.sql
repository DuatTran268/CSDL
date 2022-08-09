CREATE DATABASE SQLDBQuery
GO

-- sử dụng DB SQLQuery
USE SQLDBQuery
GO
-- tạo bảng giáo viên có 2 thuộc tính
CREATE TABLE GiaoVien (
	MaGV nvarchar(10),
	Name nvarchar(100)
)
GO

CREATE TABLE SinhVien (
	MaSV nvarchar(10),
	Name nvarchar(100)

)
go  -- go có cũng được mà ko có cũng được


-- sửa bảng thêm cột ngày sinh vào bảng
ALTER TABLE SinhVien ADD NgaySinh Date

-- xóa toàn bộ dữ liệu của bảng
TRUNCATE TABLE SinhVien

-- xóa (gỡ) bảng sinh viên khỏi Database
DROP TABLE SinhVien
Go





