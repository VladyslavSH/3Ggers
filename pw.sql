use bookshops
go

alter table books
add QuantityBooks int null
go

update Books
set QuantityBooks = ABS(CHECKSUM(Newid())%50)
where QuantityBooks = -1
go

create trigger SoldBooks
on Sales
for insert 
as
begin
	declare @CountSoldBooks int
	select @CountSoldBooks = Quantity from inserted
	update books set QuantityBooks = QuantityBooks - @CountSoldBooks where Books.ID_BOOK =(select ID_BOOK from inserted) 
end
go

insert into Sales values (6, 'Just for Fun', GETDATE(), 320.65, 6, 1)
go

-----------------------------------------------------------------------------

alter trigger Checked
on Sales
for insert
as
begin
	declare @CountSoldBooks2 int = 0
	declare @CountBooks int = 0
	select @CountSoldBooks2 = Quantity from inserted
	select @CountBooks = QuantityBooks from Books where Books.ID_BOOK =(select ID_BOOK from inserted) 
	if (@CountBooks<@CountSoldBooks2)
	begin
		print concat ('Ошибка! Вы пытаетесь заказать ', @CountSoldBooks2, ' книжки, а на складе ', @CountBooks + @CountSoldBooks2, ' книжки!')
		rollback transaction
	end
end

insert into Sales values (8, 'Цифровая схемотехника и архитектура компьютера', GETDATE(), 150.00, 35, 1)
go

----------------------------------------------------------------------------------------------------------

alter trigger addBooks   -- Триггер добавления!
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

alter trigger updateBooks      -- Триггер обновления!
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

alter trigger deleteBooks          -- Триггер удаления!
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

create table [Log]           -- Создание таблицы (Журнал)
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

----------- Ниже идут манипуляции с БД, наслаждайтесь)) -----------------------
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