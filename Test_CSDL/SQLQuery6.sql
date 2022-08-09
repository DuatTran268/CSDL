-- HỌC VỀ KIỂU DỮ LIỆU
-- các kiểu dữ liệu hay dùng
-- int: kiểu số nguyên (tập hợp n) vd: -9, -8, -6, 3, 10
-- float: kiểu số thực ( tập hợp r) vd: -0.5, 0.9, 10, 9.6
-- char: kiểu ký tự -- ko viết tiếng việt được (bộ nhớ cấp phát cứng) vd: A, a, B, b, f, h, j char(10)
-- varchar: kiểu ký tự -- ko viết tiếng việt được : (bộ nhớ cấp phát động)  
-- nchar: kiểu ký tự . Có thể lưu tiếng việt 
-- nvarchar: kiểu ký tự cấp phát động có thể lưu tiếng việt
-- date: lưu trữ ngày, tháng, năm, giờ 
-- time: lưu trữ giờ, phút, giây, ...
-- bit: lưu giá trị 0 hoặc 1
-- text: lưu văn bản lớn có
-- ntext: lưu văn bản lớn có tiếng việt


create table Test(
	Doc nvarchar(50),	-- khai báo trường Doc kiểu nvarchar cấp phát động 50 ô nhớ
	Masv char(10),		-- khai báo trường MaSV kiểu char cấp phát cứng 10 ô nhớ
	Birthday Date,		-- lưu trữ ngày tháng năm 
	Sex BIT, -- lưu giá trị 0 và 1
)