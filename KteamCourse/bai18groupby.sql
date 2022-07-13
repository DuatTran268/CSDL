/*Lệnh sử dụng cơ sở dữ liệu*/
use TruyVanKteam
go


/*
agreeate function

avg()  tính trung bình
count() Đếm 
first() 
last() phần tử cuối cùng
max() phần tử lớn nhất
min() phần tử nhỏ nhất
round() làm tròn
sum() tính tổng


string function
charindex: tìm một phần tử có tồn tại trong chuỗi ko
concat() cắt chuỗi
left() lấy ra bên trái bao nhiêu phần tử
len() lấy ra độ dài 
lower() cho thành kiểu viết thường
ltrim() cắt khoảng trắng
subtring() lấy ra chuỗi phụ 
replace() thay thế
right() lấy bên phải
rtrimh() cắt khoảng trắng ở bên phải
upper() cho tất cả viết hoa
*/


-- xuất ra danh sách tên bộ môn và số lượng giáo viên của bộ môn đó
select TENBM, COUNT(*) from BOMON BM, GIAOVIEN GV
where BM.MABM = GV.MABM
group by TENBM

-- column cột hiển thị phải là thuộc tính nằm trong khối grop by hoặc là agreegate functio
-- group by hiển thị cái gì thì gom nhóm cái đó
--group by: nhóm cái gì cũng được, gom nhóm theo cái gì đưa vào trong đó, nó chung cái gì là gom lại cái đó 

select TENBM, PHONG, COUNT(*) from BOMON BM, GIAOVIEN GV
where BM.MABM = GV.MABM
group by TENBM, BM.MABM, PHONG			-- gom nhóm group by theo tên bộ môn, mã bộ môn và phòng

-- lấy ra danh sách giáo viên có lương lớn hơn lương trung bình của giáo viên

select * from GIAOVIEN
where LUONG > (select SUM(Luong) from GIAOVIEN)/(select COUNT(*) from GIAOVIEN)

-- xuất ra tên giáo viên và số lượng đề tài giáo viên đó đã làm
select GV.HOTEN, COUNT(*) from GIAOVIEN GV, THAMGIADT as TGDT
where GV.MAGV = TGDT.MAGV
group by GV.MAGV, GV.HOTEN
