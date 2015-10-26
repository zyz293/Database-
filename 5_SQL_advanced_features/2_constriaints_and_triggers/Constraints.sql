// key constraints
create table Student(sID int, sName, text, GPA real not null, sizeHS int);

insert into Student values(123, 'Amy', 3.9, 1000);
insert into Student values(234, 'Bob', 3.6, null);
insert into Student values(345, 'Craig', null, 500); // error

update Student set GPA = null, where sID = 123; // error
update Student set GPA = null where sID = 456; // no effect

create table Student (sID int primary key, sName text, GPA real, sizeHS int);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (123, 'Craig', 3.5, 500); // error

update Student set sID = 123 where sName = 'Bob'; // error
update Student set sID= sID - 111; // error when using immediate checking

create table Student (sID int primary key, sName text primary key, GPA real, sizeHS int);
// two primary key, error. we can have multiply keys, but only one primary key
create table Student (sID int primary key, sName text  unique, GPA real, sizeHS int);

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 3.6, 1500);
insert into Student values (345, 'Amy', 3.5, 500); // error
insert into Student values (456, 'Doris', 3.9, 1000);
insert into Student values (567, 'Amy', 3.8, 1500); // error

create table College(cName text, state text, enrollment int, primary key (cName, state));

insert into College values ('Mason', 'CA', 10000);
insert into College values ('Mason', 'NY', 5000);
insert into College values ('Mason', 'CA', 2000); // error

create table Apply (sID int, cName text, major text, decision text, unique(sID, cName), unique(sID, major));

insert into Apply values (123, 'Stanford', 'CS', null);
insert into Apply values (123, 'Berkeley', 'EE', null);
insert into Apply values (123, 'Stanford', 'biology', null); // error
insert into Apply values (234, 'Stranford', 'biology', null);
insert into Apply values (123, 'MIT', 'EE', null); // error
insert into Apply values (123, 'MIT', 'biology', null); 

update Apply set major = 'CS' where cName = 'MIT'; // error

insert into Apply values (123, null, null, 'Y');
insert into Apply values (123, null, null, 'N'); // no error, allow duplicate null even the attribute is unique, but not for primary key

// attribute based check constraints - catch entry errors
create table Student (sID int, sName text, GPA real check(GPA <= 4.0 and GPA > 0.0), sizeHS int check (sizeHS < 5000));

insert into Student values (123, 'Amy', 3.9, 1000);
insert into Student values (234, 'Bob', 4.6, 1500); // error

update Student set sizeHS = 6 * sizeHS; // error

// tuple based constraints - check when insert or update but allow to talk about relationships between different values in each tuple
create table Apply (sID int, cName text, major text, decision text, check(decision='N' or cName <> 'Stranford' or major <> 'CS'));

insert into Apply values (123, 'Stanford', 'CS', 'N');
insert into Apply values (123, 'MIT', 'CS' 'N');
insert into Apply values (123, 'Stanford', 'CS', 'Y'); // error

update Apply set decision ='Y' where cName = 'Stanford'; // error
update Apply set cName = 'Stanford', where cName = 'MIT'; // error

// above works in SQLite and postrisks

create table Student (sID int, sName text, GPA real check(GPA is not null), sizeHS int);

insert into Student values (123, 'Amy', null, 1000); // error

// implement key constraints using attribute based check constraints
create table T (A int check(A not in (select A from T))); // this check constraints specifies A is a key // error

create table T(A int check((select count(distinct A) from T) = 
											select cont(*) from T))); 
											
create table Student (sID int, sName text, GPA real, sizeHS);
create table Apply (sID int, cName text, major text, decision text, check(sID in (select sID from Student)));
// no SQL system supports sub queries and check constraints

create table Apply (sID int, cName text, major text, decision text, check(sID in (select sID from Student)));
create table College(cName text, state text, enrollment int, check(enrollment > (select max (sizeHS) from Student)));
// no work

// general assertion, which is not supported
create asertion KEY // assertions can refer to any number of tables in the DB
check ((select count(distinct A) from T) = (select count(*) from T)));
// this assertion says that this condition written in SQL-like language must always be true on the DB

create assertion ReferentialIntegrity
check (not exists (select * from Apply)
							where sID not in (select sID from Student)));
// specify the bad thing in a subquery and then write not exists

