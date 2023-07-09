--1
create table book(
	book_id char(10) primary key,
	tittle varchar(50) not null,
	publisher varchar(20) not null,
	published_year bigint,
	total_number_of_copies int,
	current_number_of_copies int,
	check(total_number_of_copies>0),
	check(published_year>1900),
	check(current_number_of_copies>0),
	check(total_number_of_copies >= current_number_of_copies)
);
create table borrower (
	borrower_id char(10) primary key,
	name varchar(50) not null,
	address text,
	telephone_number char(12)
);
create table borrowcard (
	card_id int generated always as identity primary key,
	borrower_id char(10),
	borrow_date date not null,
	expected_return_date date not null,
	actual_return_date date,
	foreign key (borrower_id) references borrower(borrower_id)
);
create table borrowcarditem(
	card_id int,
	foreign key(card_id) references borrowcard(card_id),
	book_id char(10),
	foreign key(book_id) references book(book_id),
	primary key (card_id, book_id)
);

--2
select book_id, tittle from book
where published_year = 2020 and publisher = 'Wiley';

--3
select publisher, count(book_id) as total from book
group by(publisher);

--4
select borrowcarditem.book_id, tittle from borrowcarditem
inner join borrowcard on borrowcarditem.card_id = borrowcard.card_id
inner join book on borrowcarditem.book_id = book.book_id
where extract(year from borrow_date) = 2020 
group by(borrowcarditem.book_id, tittle)
order by (count(borrowcard.card_id)) desc limit 5;

--5
select * from borrower
where borrower_id in (select borrower_id from borrowcard
					 where actual_return_date = null);
					 
--6
select * from borrower
where borrower_id in(select borrower_id from borrowcard
				  where actual_return_date > expected_return_date)				
				  order by (borrower.name) asc;
				  
--7
delete from book
where book_id not in (select book_id from borrowcarditem);

--8
update book
set current_number_of_copies = current_number_of_copies + 10,
total_number_of_copies = total_number_of_copies + 10
where book_id in 
(select book_id from book join borrowcarditem using (book_id) where publisher =
'Wiley' group by (book_id) order by (count(*)) desc limit 5);

--9
select borrower.borrower_id, name from borrower
inner join borrowcard on borrower.borrower_id = borrowcard.borrower_id
inner join borrowcarditem on borrowcard.card_id = borrowcarditem.card_id
where borrowcarditem.book_id in ((select book.book_id from book
where publisher = 'Wiley')
intersect
(select book.book_id from book
where publisher = 'Addison-Wesley'))

				  

