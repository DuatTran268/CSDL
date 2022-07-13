-- lệnh sử dụng database
use TruyVanKteam
go

/*
- truy vấn lồng: muốn sử dụng khi lấy ra danh sách tái sử dụng thêm lần nữa ngay trong câu truy vấn thì sử dụng truy  vấn lồng
in: là tồn tại bên trong
not: in là ko tồn tại bên trong ( not ngược lại, phủ định)

*/


/*
- kiểm tra xem giáo viên 001 có phải là giáo viên quản lý chuyên môn hay không
b1: lấy ra danh sách các mã giáo viên quản lý chuyên môn
b2: kiểm tra mã giáo viên có tồn tại trong danh sách đó

*/

-- truy vấn lồng trong câu điều kiện where
select * from GIAOVIEN
where MAGV = '001'
and MAGV in (
select GVQLCM from GIAOVIEN
)

-- truy vấn lồng trong form
select * from GIAOVIEN, (select * from DETAI) as DeTai

--Câu 1: xuất ra danh sách giáo viên tham gia đề tài nhiều hơn một đề tài

--B1: Lấy ra tất cả thông tin của giáo viên
select * from GIAOVIEN as GV
-- B2: khi mà số lượng đề tài giáo viên đó tham gia > 1
where 1 < (
	select COUNT(*) from THAMGIADT
	where MAGV = GV.MAGV
)


-- Câu 2: Xuất ra thông tin của khoa mà có nhiều hơn 2 giáo viên
-- lấy danh sách bộ môn nằm trong khoa hiện tại
select * from KHOA as K
where 2 < (
select COUNT(*) from BOMON as BM, GIAOVIEN as GV
where BM.MAKHOA = K.MAKHOA and BM.MABM = GV.MABM
)


/*

DESC: Sắp xếp giảm dần
ASC : Sắp xếp tăng dần :(mặc định để order by cũng sắp xếp tăng dần)
*/

select MAGV 
from GIAOVIEN
order by MAGV asc

select MAGV 
from GIAOVIEN
order by MAGV desc


-- lấy ra 5 phần tử top ở đầu bảng
select top(5) * from GIAOVIEN
