select name
from Highschooler
where ID in (select ID1 from Highschooler, Friend
where ID2 = ID and name = 'Gabriel');


select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1, Highschooler h2, Likes
where h1.grade - h2.grade >= 2 and h1.ID = ID1 and h2.ID = ID2;


select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1, Highschooler h2, Likes l1, Likes l2
where l1.ID1 = l2.ID2 and l1.ID2 = l2.ID1 and h1.ID = l1.ID1 and h2.ID = l1.ID2 and h1.name < h2.name;



select name, grade
from Highschooler
where ID not in (select ID1 from Likes union select ID2 from Likes)
order by grade, name;


select h1.name, h1.grade, h2.name, h2.grade
from Highschooler h1, Highschooler h2,
(select ID1, ID2
from Likes
where ID2 not in (select ID1 from Likes
where ID1 in (select ID2 from Likes))) M
where h1.ID = M.ID1 and h2.ID = M.ID2;


select name, grade
from Highschooler
where ID not in (select ID1 from Friend, Highschooler h1, Highschooler h2
where ID1 = h1.ID and ID2 = h2.ID and h1.grade <> h2.grade)
order by grade, name;


select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from (select l.ID1 as ID1, l.ID2 as ID2
from Friend f1, Friend f2, Likes l
where f1.ID1 = l.ID1 and f2.ID1 = l.ID2 and f1.ID2 = f2.ID2
except
select ID1, ID2
from Friend) M, Friend f1, Friend f2, Highschooler h1, Highschooler h2, Highschooler h3
where M.ID1 = f1.ID1 and M.ID2 = f2.ID1 and f1.ID2 = f2.ID2 and M.ID1 = h1.ID and M.ID2 = h2.ID and f1.ID2 = h3.ID;


select M1.c1 - M2.c2
from (select count(*) as c1 from Highschooler) M1,
(select count(*) as c2
from (select name from Highschooler group by name)) M2


select name, grade
from Highschooler
where ID in (select ID2
from Likes
group by ID2
having count(*) > 1);
/**************************************/


select h1.name, h1.grade, h2.name, h2.grade, h3.name, h3.grade
from Highschooler h1, Highschooler h2, Highschooler h3, Likes f1, Likes f2
where f1.ID1 = h1.ID and f1.ID2 = h2.ID and f2.ID2 = h3.ID and f1.ID2 = f2.ID1 and f1.ID1 <> f2.ID2;


select name, grade 
from Highschooler
where ID in (select ID 
from Highschooler
except
select ID1 as ID
from Friend, Highschooler h1, Highschooler h2
where ID1 = h1.ID and ID2 = h2.ID and h1.grade = h2.grade);


select avg(M.c)
from (select count(*) as c
from Friend
group by ID1) M;


select count(*)
from Highschooler
where ID in (select ID1
from Friend, Highschooler
where ID2 = ID and name = 'Cassandra'
union
select f1.ID1 as ID1
from Friend f1, Friend f2, Highschooler 
where f1.ID1 <> f2.ID2 and f1.ID2 = f2.ID1 and f2.ID2 = ID and name = 'Cassandra');


select name, grade
from Highschooler
where ID in (select ID1
from Friend 
group by ID1
having count(*) = (select max(M.c)
from (select count(*) as c
from Friend
group by ID1) M));