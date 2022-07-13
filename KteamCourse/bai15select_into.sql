use TruyVanKteam
go

-- trường hợp 1:
-- lấy hết dữ liệu bảng giáo viên đưa vào bảng mới 
-- bảng mới này có các dữ liệu tương ứng như bảng giáo viên 
select * into TableA
from GIAOVIEN
select * from TableA
-- gọi bảng tableA ra để xem kết quả (result) 

-- trường hợp 2:
-- tạo ra một bảng TableB mới. Có một cột dữ liệu là họ tên tương ứng như bảng giáo viên 
-- dữ liệu của bảng tableB được lấy ra từ bảng giáo viên
select HoTen as 'Họ tên' into TableB
from GIAOVIEN
select * from TableB

-- trường hợp 3:
-- tạo ra một bảng TableC mới . Có một cột dữ liệu là Họ Tên tương ứng như bảng giáo viên
-- với điều kiện lương > 2000
-- dữ liệu của bảng tableB lấy ra từ Giáo viên
select HOTEN as 'Họ Tên' , LUONG as 'Lương' into TableC
from GIAOVIEN
where LUONG > 2000
select * from TableC
drop table TableC		-- lệnh xóa bảng để cập nhật chỉnh sửa lại dữ liệu trong bảng

-- trường hợp 4:
-- tạo một bảng từ nhiều bảng
select MAGV, HOTEN, TENBM into GVBackUp 
from GIAOVIEN, BOMON
where GIAOVIEN.MABM = BOMON.MABM
select * from GVBackUp

-- trường hợp 5: 
-- tạo ra một bảng GVBK nhưng ko có dữ liệu
select * into GVBK 
from GIAOVIEN
where 6 > 8		-- đặt điều kiện 6 > 8 là điều kiện sai để kết quả trả về là bảng ko có dữ liệu
select * from GVBK



--========== Học về insert into select ==========

-- insert into select -> copy dữ liệu vào bảng đã tồn tại 
select * into CloneGV
from GIAOVIEN
where 1 = 0			--> tạo điều kiện sai để xuất ra thông tin bảng CloneGV ko có dữ liệu của bảng giáo viên
select * from CloneGV

-- copy dữ liệu từ bảng đã có là bảng GV sang bản cloneGV
insert into CloneGV	
select * from GIAOVIEN
select * from CloneGV