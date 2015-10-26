create trigger R1
after insert on Highschooler
for each row
when New.name = "Friendly"
begin
    insert into Likes
    select New.ID, ID from Highschooler where grade = New.grade and ID != New.ID;
end;


create trigger r2
after insert on Highschooler
for each row
when New.grade < 9 or New.grade > 12
begin
    update Highschooler set grade = null where ID = New.ID;
end;
|
create trigger r1
after insert on Highschooler
for each row 
when New.grade is null
begin
    update Highschooler set grade = 9 where ID = New.ID;
end;


create trigger r
after insert on Friend
for each row
begin
    insert into Friend values (New.ID2, New.ID1);
end;
|
create trigger r1
after delete on Friend
for each row
begin
    delete from Friend where ID1 = Old.ID2 and ID2 = Old.ID1;
end;


create trigger r
after update of grade on Highschooler
when New.grade > 12
begin
    delete from Highschooler where ID = New.ID;
    delete from Friend where ID1 = New.ID or ID2 = New.ID;
    delete from Likes where ID1 = New.ID or ID2 = New.ID;
end;


create trigger r
after update of grade on Highschooler
when New.grade = Old.grade + 1
begin
    update Highschooler
    set grade = grade + 1 where ID in (select ID2 from Friend where ID1 = New.ID);
end;
|
create trigger r1
after update of grade on Highschooler
when New.grade > 12
begin
    delete from Highschooler where ID = New.ID;
    delete from Friend where ID1 = New.ID or ID2 = New.ID;
    delete from Likes where ID1 = New.ID or ID2 = New.ID;
end;


create trigger r
after update of ID2 on Likes
for each row
when New.ID1 = Old.ID1 and New.ID2 != Old.ID2
begin
    delete from Friend where (ID1 = Old.ID2 and ID2 = New.ID2) or (ID1 = New.ID2 and ID2 = Old.ID2);
end;