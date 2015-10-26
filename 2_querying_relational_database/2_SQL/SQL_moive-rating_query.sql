select title
from Movie
where director = 'Steven Spielberg'；


select distinct year
from Movie natural join Rating
where stars >= 4
order by year;


select title
from Movie
where mID not in (select mID from Rating);


select name
from Reviewer
where rID in (select rID from Rating where ratingDate is null);


select name, title, stars, ratingDate
from (Movie natural join Rating) natural join Reviewer
order by name, title, stars


select r1.name, r1.title
from ((Movie natural join Rating) natural join Reviewer) r1, ((Movie natural join Rating) natural join Reviewer) r2
where r1.rID = r2.rID and r1.mID = r2.mID and r1.ratingDate < r2.ratingDate and r1.stars <r2.stars


select title, stars
from Movie join Rating using(mID)
group by mID
having count(mID) > 1 and max(stars)
order by title;


select title, max(stars)-min(stars) as ratingSpread
from Movie join Rating using (mID)
group by mID
order by ratingSpread desc, title;


select before - after
from (
(select avg(starb) as before
from (select avg(stars) as starb
from Movie join Rating using (mID)
where year < 1980
group by mID)),
(select avg(stara) as after
from (select avg(stars) as stara
from Movie join Rating using (mID)
where year > 1980
group by mID)));
/********************************************/
select distinct name
from (Reviewer join Rating using (rID)) join Movie using (mID)
where title = 'Gone with the Wind';


select name, title, stars
from (Movie join Rating using (mID)) join Reviewer using (rID)
where name = director;


select name as name from Reviewer
union 
select title as name from Movie
order by name;


select title
from Movie
where mID not in 
(select mID
from Reviewer join Rating using (rID)
where name = 'Chris Jackson');


select distinct n1.name, n2.name
from (Reviewer join Rating using (rID)) n1, (Reviewer join Rating using (rID)) n2
where n1.mID = n2.mID and n1.name < n2.name
order by n1.name;


select name, title, stars
from (Movie join Rating using (mID)) join Reviewer using (rID)
where stars = (select min(stars) from Rating);


select title, avg(stars)
from Movie join Rating using (mID)
group by mID
order by avg(stars) desc, title


select name
from Reviewer
where rID in (select rID from Rating
group by rID
having count(stars) >=3);


select title, director
from Movie
where director in (select director from Movie
group by director
having count(title) > 1)
order by director, title;


select title, avg(stars)
from Movie join Rating using (mID)
group by mID
having avg(stars) = (
select max(average)
from (select mID, avg(stars) as average
from Movie join Rating using (mID)
group by mID));


select title, avg(stars)
from Movie join Rating using (mID)
group by mID
having avg(stars) = (
select min(average)
from (select mID, avg(stars) as average
from Movie join Rating using (mID)
group by mID));


select director, title, stars
from Movie join Rating using (mID)
group by director
having stars = max(stars) and director is not null;