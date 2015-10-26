create table College(cName text primary key, state text, enrollment int);
create table Student (sID int primary key, sName text, GPA real, sizeHS int);
create table Apply(sID int references Student(sID), cName text references College(cName),
								major text, decision text);

insert into Apply values (123, 'Stranford', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N'); 
// error

// should first insert the tuple in Coggelge and Student
insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into College values ('Stanford', 'CA', 15000);
insert into College values ('Berkeley', 'CA', 36000);

update Apply set sID = 345 where sID = 123; // error
update Apply set sID = 234 where sID = 123; 

delete from College where cName = 'Stanford'; // error
delete from Student where sID = 234; //error
delete from Student where sID = 123; 

update College se cName = 'Bezerkeley', where cName = 'Berkeley'; // error

drop table Student; // error

create table Apply(sID int references Student(sID) on delete set null,
							cName text references College(cName) on update cascade, 
							major text, decision text);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (345, 'Craig', 3.5, 500);

insert into Apply values (123, 'Stanford', 'CS', 'Y');
insert into Apply values (123, 'Berkeley', 'CS', 'Y');
insert into Apply values (234, 'Berkeley', 'biology', 'N');
insert into Apply values (345, 'Stanford', 'history', 'Y');
insert into Apply values  (345, 'Stanford', 'CS', 'Y');

delete from Student where sID > 200;
update College set cName = 'Berzerkeley', where cName = 'Berkeley';

create table T (A int, B int, C int, primary key (A, B), foreign key (B, C) references T(A, B) on delete cascade);
// every tuple except the first, the BC pair, ereferences the AB pair of the preceding tuple
insert into T values (1,1,1);
insert into T values (2,1,1);
insert into T values (3,2,1);
insert into T values (4,3,2);
insert into T values (5,4,3);
insert into T values (6,5,4);
insert into T values (7,6,5);
insert into T values (8,7,6);

delete from T where A =1; // table is empty