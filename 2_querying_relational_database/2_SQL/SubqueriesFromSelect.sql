/**************************************************************
  SUBQUERIES IN THE FROM AND SELECT CLAUSES
  Works for MySQL and Postgres
  SQLite doesn't support All
**************************************************************/

/**************************************************************
  Students whose scaled GPA changes GPA by more than 1
**************************************************************/

select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where GPA*(sizeHS/1000.0) - GPA > 1.0
   or GPA - GPA*(sizeHS/1000.0) > 1.0;

/*** Can simplify using absolute value function ***/

select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
from Student
where abs(GPA*(sizeHS/1000.0) - GPA) > 1.0;

/*** Can further simplify using subquery in From 
compute the scale GPA in the from clause and used it elsewhere in the query***/

select *
from (select sID, sName, GPA, GPA*(sizeHS/1000.0) as scaledGPA
      from Student) G
where abs(G.scaledGPA - GPA) > 1.0;

/**************************************************************
  Colleges paired with the highest GPA of their applicants
**************************************************************/

select College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
  and Apply.sID = Student.sID
  and GPA >= all
          (select GPA from Student, Apply
           where Student.sID = Apply.sID
             and Apply.cName = College.cName);

/*** Add Distinct to remove duplicates ***/

select distinct College.cName, state, GPA
from College, Apply, Student
where College.cName = Apply.cName
  and Apply.sID = Student.sID
  and GPA >= all
          (select GPA from Student, Apply
           where Student.sID = Apply.sID
             and Apply.cName = College.cName);

/*** Use subquery in Select ***/

select distinct cName, state,
  (select distinct GPA
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID
     and GPA >= all
           (select GPA from Student, Apply
            where Student.sID = Apply.sID
              and Apply.cName = College.cName)) as GPA
from College;

/*** Now pair colleges with names of their applicants
    (doesn't work due to multiple rows in subquery result) 
	when you write a sub-query in the select clause, it is critical that that sub-query
	return exactly one value, because the result of that is being used to fill in 
	just one cell of the result. in this case, we have several students applying to
	colleges, so we would not know, when we get a bunch of values in the result,
	which one to put in the tule that is being constructed.***/

select distinct cName, state,
  (select distinct sName
   from Apply, Student
   where College.cName = Apply.cName
     and Apply.sID = Student.sID) as sName
from College;
