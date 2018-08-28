alter trigger checkingPrice
on sales
for insert
as
begin
	declare @PriceBook money
	select @PriceBook = Price from books where books.ID_BOOK=(select ID_BOOK from inserted)
	declare @PriceSold money
	select @PriceSold = price from inserted
	if(@PriceSold<@PriceBook)
	begin
		print concat ('Книга стоит дороже, цена книги ' , @priceBook , '$')
		rollback transaction
	end
end
go

insert into Sales values (1056, 'Only a victory!', GETDATE(), 100.00, 2, 1)
go

----------------------------------------------------------------------

create trigger checkingDate
on books
for insert
as
begin
	declare @Date date
	select @Date = DateOfPublish from inserted
	if (@Date = null)
	begin
		print 'Вы забыли ввести дату, введите дату!'
		rollback transaction
	end
end
go

insert into Books values
	('Boom 3', 4, 3, 1500, 'no pic', null, 1800, 40)
go

drop trigger checkingDate
go