
create table test2(
	MaSo int,
	Ten nvarchar(10),
	NgaySinh Date,
	Nam bit,
	DiaChi char(20),
	TienLuong float
)
go

-- thêm dữ liệu
-- kiểu số ghi rõ số bình thường
-- kiểu ký tự hoặc ngày cần để trong cặp dấu nháy đơn 
-- nếu là unicode thì cần có N phía trước cặp dấu nháy đơn N''

-- inset dữ liệu theo thứ tự của bảng
insert dbo.test2 (MaSo, Ten, NgaySinh, Nam, DiaChi, TienLuong)
values ( 102,	-- MaSo - kiểu int 
		N'Duật',	-- Tên - nvarchar(10)
		GETDATE(),	-- ngay sinh - date
		0,		-- Nam - bit (nam là 1, nữ là 0)
		'Thanh Hóa',	-- Địa chỉ - char(20)
		1000000			-- tiền lương - float
		)

-- xóa dữ liệu
-- nếu chỉ delete <Tên bảng> => xóa toàn bộ dữ liệu trong bảng
-- xóa trường mong muốn thêm where
-- các toán tử >, <, >=, <=, and, or, =


-- xóa toàn bộ dữ liệu trong bảng test2
delete dbo.test2

-- xóa với điều kiện 
-- vd: xóa thỏa mãn điều kiện có mã số là 12
delete dbo.test2 where MaSo = 12
-- xóa tiền lương lớn hơn 5000
delete dbo.test2 where TienLuong > 5000

-- xóa tiền lương lớn hơn 5000 và có mã số là 10
delete dbo.test2 where TienLuong > 5000 and MaSo < 15

--=========== update dữ liệu ============
-- update dữ liệu toàn bộ bảng với 1 trường update
update dbo.test2 set TienLuong = 2000000

-- update toàn bộ dữ liệu toàn bộ bảng với nhiều trường update
update dbo.test2 set TienLuong = 100000000, DiaChi = 'Tp HCM'

-- update trường dữ liệu mong muốn
update dbo.test2 set TienLuong = 368000 where Nam = 1



