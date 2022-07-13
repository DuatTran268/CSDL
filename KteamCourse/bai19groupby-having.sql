use TruyVanKteam
go

-- having -> như where của select nhưng giành cho group by
-- having là where của grop by

-- xuất ra số lượng giáo viên trong từng bộ môn mà số giáo viên > 2
select bm.MABM, COUNT(*)
from GIAOVIEN gv, BOMON bm
where bm.MABM = gv.MABM
group by bm.MABM
having COUNT(*) > 2

/*xuất ra mức lương và tổng tuổi của giáo viên nhận mức lương đó 
và có người thân và có tuổi lớn hơn tuổi trung bình*/
select LUONG, SUM(YEAR(GETDATE()) - YEAR(gv.NGSINH))
from GIAOVIEN gv, NGUOITHAN nt 
where gv.MAGV = nt.MAGV and gv.MAGV in( select MAGV from NGUOITHAN)
group by LUONG, gv.NGSINH
having YEAR(GETDATE()) - YEAR(gv.NGSINH) > 
(
	(select SUM(YEAR(GETDATE()) - YEAR(gv.NGSINH)) from GIAOVIEN)
	/ (select COUNT(*) from GIAOVIEN)
)
