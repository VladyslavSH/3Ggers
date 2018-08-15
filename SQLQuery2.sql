create trigger addBooks
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
	'New book added')
go

create trigger updateBooks
on Books
for update
as


create table [Log](
	id int primary key identity,
	[Date] date not null,
	eventName varchar(25) not null,
	authorName varchar(25) not null,
	bookName varchar(25) not null,
	content text not null 
)
go

insert into Books values
	('Boom', 4, 3, 1500, 'no pic', getdate(), 1800),
	('Boom2', 1, 1, 2500, 'no pic', getdate(), 2800),
	('Boom3', 2, 2, 3500, 'no pic', getdate(), 3800),
	('Boom4', 3, 4, 4500, 'no pic', getdate(), 4800)
go
select * from [Log]