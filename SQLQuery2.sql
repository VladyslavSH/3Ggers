alter trigger addBooks   -- ������� ����������!
on Books
for insert
as
declare @NameAuthor int 
select @NameAuthor = inserted.ID_author from inserted
declare @NameBook varchar(25)
select @NameBook = inserted.NameBook from inserted
insert into [Log] values(
	getdate(),
	'Addition',
	(select Authors.FirstName from Authors where Authors.ID_AUTHOR = @NameAuthor),
	@NameBook,
	null,
	'New book added')
go
-------------------------------------------------------

alter trigger updateBooks      -- ������� ����������!
on Books
for update
as
declare @NameAuthor int 
select @NameAuthor = deleted.ID_author from deleted
declare @NameBook varchar(25)
select @NameBook = inserted.NameBook from inserted
declare @oldNameBook varchar(25)
select @oldNameBook = deleted.NameBook from deleted
insert into [Log] values(
	getdate(),
	'Update',
	(select Authors.FirstName from Authors where Authors.ID_AUTHOR = @NameAuthor),
	@NameBook,
	@oldNameBook,
	'Book updated')
go
-------------------------------------------------------

alter trigger deleteBooks          -- ������� ��������!
on Books
for delete
as
declare @NameAuthor int 
select @NameAuthor = deleted.ID_author from deleted
declare @NameBook varchar(25)
select @NameBook = deleted.NameBook from deleted
insert into [Log] values(
	getdate(),
	'Delete',
	(select Authors.FirstName from Authors where Authors.ID_AUTHOR = @NameAuthor),
	@NameBook,
	null,
	'Book deleted')
go
------------------------------------------------------------------------

create table [Log]           -- �������� ������� (������)
(
	id int primary key identity,
	[Date] date not null,
	eventName varchar(25) not null,
	authorName varchar(25) not null,
	bookName varchar(25) not null,
	oldBookName varchar(25) null,
	content text not null 
)
go
----------------------------------------------------------

----------- ���� ���� ����������� � ��, �������������)) -----------------------
insert into Books values
	('Boom 3', 4, 3, 1500, 'no pic', getdate(), 1800, 40)
go

update Books
set
NameBook = 'Only a victory!', Price = 120, DateOfPublish = GETDATE()
where ID_BOOK = 1056

delete from Books
where ID_BOOK = 1059

select * from [Log]

/*Truncate table
[Log]
go*/

