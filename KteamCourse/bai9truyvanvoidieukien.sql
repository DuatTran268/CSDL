use TruyVanKteam
go

select GV.MAGV, HOTEN, NT.TEN 
from dbo.GIAOVIEN as GV, dbo.NGUOITHAN as NT
where GV.MAGV = NT.MAGV

select * from dbo.GIAOVIEN as GV, dbo.NGUOITHAN as NT

-- lấy ra giáo viên lương lớn hơn 2000
select * from dbo.GIAOVIEN
where LUONG > 2000

-- lấy ra giáo viên là nữ lương > 2000
select * from dbo.GIAOVIEN
where LUONG > 2000 and  PHAI = N'Nữ'

-- lấy ra giáo viên lớn hơn 45 tuổi
-- year -> lấy ra năm của ngày 
-- getdate -> lấy ra ngày hiện tại 
select * from dbo.GIAOVIEN
where year(GETDATE()) - year(NGSINH) > 45
-- lấy năm của ngày hiện tại - đi năm của ngày sinh nhỏ hơn 40 tuổi thì xuất ra


-- vd: lấy ra họ tên giáo viên năm sinh và tuổi của giáo viên nhỏ hơn 40t
select HOTEN, NGSINH, year(GETDATE()) - year(NGSINH) from dbo.GIAOVIEN
where year(GETDATE()) - year(NGSINH) <= 45

-- lấy ra mã GV, tên GV và tên khoa của giáo viên đó làm việc
select gv.MAGV, gv.HOTEN, k.TENKHOA from dbo.GIAOVIEN as GV, dbo.BOMON as BM, dbo.KHOA as K
where GV.MABM = bm.MABM and bm.MAKHOA = k.MAKHOA

-- lấy ra giáo viên là trưởng bộ môn
select gv.* from dbo.GIAOVIEN as GV, dbo.BOMON as BM
where gv.MAGV = bm.TRUONGBM

-- đếm số lượng giáo viên
/*
-- để đếm có hàm hỗ trợ COUNT
- count(*) -> đếm số lượng của tất cả record
- count(tên trường nào đó) -> đếm số lượng của tên trường đó
*/
select count(*) from dbo.GIAOVIEN
select count(*) as N'Số lượng giáo viên' from dbo.GIAOVIEN

-- đếm số lượng người thân của giáo viên có mã giáo viên là 007
select count(*) as N'Số lượng người thân' from dbo.GIAOVIEN, dbo.NGUOITHAN
where GIAOVIEN.MAGV = '007'

select count(*) as N'Số lượng người thân'
select*
from dbo.GIAOVIEN, dbo.NGUOITHAN
where GIAOVIEN.MAGV = '007' 
and GIAOVIEN.MAGV = NGUOITHAN.MAGV

-- lấy ra tên giáo viên và tên đề tài người đó tham gia khi mà người đó tham gia nhiều hơn 1 lần
select HOTEN, TENDT from dbo.GIAOVIEN, dbo.THAMGIADT, dbo.DETAI
where GIAOVIEN.MAGV = THAMGIADT.MAGV
AND DETAI.MADT = THAMGIADT.MADT

/*
-- bài tập
*/
--1. xuất ra thông tin giáo viên và giáo viên quản lý của chủ nhiệm của người đó
select gv1.HOTEN, gv2.HOTEN from dbo.GIAOVIEN as GV1, dbo.GIAOVIEN as GV2
where gv1.GVQLCM = gv2.MAGV
--2. xuất ra số lượng giáo viên của khoa công nghệ thông tin 
select count(*) from dbo.GIAOVIEN as GV, dbo.BOMON as BM, dbo.KHOA as K
where gv.MABM = bm.MABM
and bm.MAKHOA = k.MAKHOA
and k.MAKHOA = 'CNTT'
--3. xuất ra thông tin giáo viên và đề tài người đó tham gia khi mà kết quả là đạt
select GV.* from dbo.GIAOVIEN as GV, dbo.THAMGIADT as TG
where gv.MAGV = tg.MAGV
and tg.KETQUA = N'Đạt'