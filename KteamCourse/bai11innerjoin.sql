-- học về inner join

use TruyVanKteam
go

-- inner join 
-- kiểu cũ -> có thể sau này ko được sử dụng
-- mọi join cần điều kiện
select * from GIAOVIEN, BOMON
where BOMON.MABM = GIAOVIEN.MABM

-- viết theo inner join kiểu mới đúng chuẩn
select * from GIAOVIEN INNER JOIN BOMON
on BOMON.MABM = GIAOVIEN.MABM

-- có thể viết tắt inner join thành join
select * from KHOA JOIN BOMON
on BOMON.MAKHOA = KHOA.MAKHOA

---============= học về Full outer join
-- gom 2 bảng lại. theo điều kiện. bên nào ko có dữ liệu thì để null
select * from BOMON FULL OUTER JOIN GIAOVIEN
on BOMON.MABM = GIAOVIEN.MABM


--- ============== HỌC về LEFT - RIGHT Join
-- left join
select * from BOMON JOIN GIAOVIEN
on BOMON.MABM = GIAOVIEN.MABM

-- bảng bên phải nhập vào bên trái
-- record nào bảng phải ko có thì để null
-- record nào bảng trái không có thì không điền vào

select * from BOMON LEFT JOIN GIAOVIEN
on BOMON.MABM = GIAOVIEN.MABM

-- right join
select * from BOMON RIGHT JOIN GIAOVIEN
on BOMON.MABM = GIAOVIEN.MABM

