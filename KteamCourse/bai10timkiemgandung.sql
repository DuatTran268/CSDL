use TruyVanKteam
go

-- xuất ra thông tin giáo viên có tên bắt đầu bằng chữ h
select * from dbo.GIAOVIEN
where HOTEN like 'l%' -- dấu % ở đằng sau l có nghĩa là xuất các giá trị có l đứng đầu

-- xuất ra thông tin giáo viên kết thúc bằng chữ n
select * from dbo.GIAOVIEN
where HOTEN like '%n' -- dấu % đứng ở đằng trước có nghĩa là n nằm ở cuối cùng
-- xuất ra thông tin giáo viên có tồn tại chữ n
select * from dbo.GIAOVIEN
where HOTEN like '%n%' -- n nằm đâu cũng được 

-- xuất ra thông tin giáo viên có tồn tại chữ ế
select * from dbo.GIAOVIEN
where HOTEN like N'%ế%'


