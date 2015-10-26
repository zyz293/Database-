delete from Highschooler
where grade in (select max(grade) from Highschooler);


delete from Likes
where ID1 in (select f.ID1
from Friend f, Likes l
where f.ID1 = l.ID1 and f.ID2 = l.ID2
except
select f.ID1
from Friend f, Likes l1, Likes l2
where f.ID1 = l1.ID1 and f.ID2 = l1.ID2 and l1.ID1 = l2.ID2 and l1.ID2 = l2.ID1)
and ID2 in (select f.ID2
from Friend f, Likes l
where f.ID1 = l.ID1 and f.ID2 = l.ID2
except
select f.ID2
from Friend f, Likes l1, Likes l2
where f.ID1 = l1.ID1 and f.ID2 = l1.ID2 and l1.ID1 = l2.ID2 and l1.ID2 = l2.ID1);

/* or */
delete from Likes
where ID1 in
(select f.ID1
from Friend f join Likes l
where l.ID1=f.ID1 and l.ID2=f.ID2 and f.ID1 not in (select f1.ID1
from Friend f1 join Likes l1 join Likes l2
where l1.ID1=f.ID1 and l1.ID2=f.ID2 and f.ID2=l2.ID1 and f.ID1=l2.ID2))

/* or */
delete from Likes
where Likes.ID2 in (
select Friend.ID2 from Friend where Likes.ID1 = Friend.ID1
) and
Likes.ID2 not in (
select L.ID1 from Likes L where Likes.ID1 = L.ID2
);
/* can constrain both in and not in condition to achieve the goal */


insert into Friend
select f1.ID1, f2.ID2
from Friend f1, Friend f2
where f1.ID1 <> f2.ID2 and f1.ID2 = f2.ID1
except
select f3.ID1, f3.ID2
from Friend f1, Friend f2, Friend f3
where f1.ID2 = f2.ID1 and f1.ID1 = f3.ID1 and f2.ID2 = f3.ID2
/* when can not select directly, we can use except to achieve the goal*/