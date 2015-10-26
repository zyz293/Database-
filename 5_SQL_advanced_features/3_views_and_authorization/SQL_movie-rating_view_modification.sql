create trigger r
instead of update of title on LateRating
for each row 
begin
    update Movie
    set title = New.title
    where mID = New.mID;
end;


create trigger r
instead of update of stars on LateRating
for each row
begin
    update Rating
    set stars = New.stars
    where mID = New.mID and ratingDate = New.ratingDate;
end;


create trigger r
instead of update of mID on LateRating
for each row
begin
    update Movie
    set mID = New.mID
    where mID = Old.mID;
    update Rating
    set mID = New.mID
    where mID = Old.mID;
end;



create trigger r
instead of update of mID,title,stars on LateRating
for each row
when new.ratingDate = old.ratingDate
begin
  update Movie  set title = NEW.title where Movie.mID  = OLD.mID;
  update Movie  set mID   = NEW.mID   where Movie.mID  = OLD.mID;
  update Rating set stars = NEW.stars where Rating.mID = OLD.mID and Rating.stars = OLD.stars;
  update Rating set mID   = NEW.mID   where Rating.mID = OLD.mID;
end;


create trigger r
instead of delete on HighlyRated
for each row
begin
    delete from Rating
    where mID = Old.mID and stars > 3;
end;


create trigger r
instead of delete on HighlyRated
for each row
begin
    update Rating
    set stars = 3
    where mID = Old.mID and stars >3;
end;


create trigger r
instead of insert on HighlyRated
for each row
begin
    insert into Rating
    select 201, New.mID, 5, null
    where New.mID in (select mID from Movie) and New.title in (select title from Movie);
end;


create trigger r
instead of insert on NoRating
for each row
begin
    delete from Rating
    where New.mID in (select mID from Movie) 
          and New.title in (select title from Movie)
          and mID = New.mID;
end;


create trigger r
instead of delete on NoRating
for each row
begin
    delete from Movie
    where mID = Old.mID and title = Old.title;
end;


create trigger r
instead of delete on NoRating
for each row
begin
    insert into Rating
    select 201, Old.mID, 1, null;
end;
/*** or ***/
create trigger r
instead of delete on NoRating
for each row
begin
    insert into Rating values (201, Old.mID, 1, null);
end;