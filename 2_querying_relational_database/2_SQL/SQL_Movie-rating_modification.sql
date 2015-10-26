insert into Reviewer values('209', 'Roger Ebert');


insert into Rating 
select rID, mID, 5, null 
from (select rID, mID from Reviewer, Movie
where name = 'James Cameron');


update Movie
set year = year + 25
where mID in (select mID from Rating group by mID having avg(stars) >=4);


delete from Rating
where mID in (select mID
from Movie where year < 1970 or year > 2000)
and stars in (select stars from Rating where stars < 4);