doc ("courses.xml") //Title


doc("courses.xml") /Course_Catalog/Department/Chair/Professor/Last_Name


doc("courses.xml") /Course_Catalog/Department/Course[@Enrollment > 500]/Title


for $b in doc("courses.xml")/Course_Catalog/Department
where $b/Course/Prerequisites/Prereq = 'CS106B'
return $b/Title


for $b in doc("courses.xml") //(Professor | Lecturer)
where $b[Middle_Initial]
return $b/Last_Name


count(doc("courses.xml")//Course[contains(Description, "Cross-listed")])


let $plist := doc("courses.xml")//Department[@Code="CS"]/Course/@Enrollment
return avg($plist)


for $b in doc("courses.xml") //Course
where $b[@Enrollment > 100] and $b[contains(Description, "system")]
return $b/Instructors/(Professor | Lecturer)/Last_Name


doc("courses.xml")//Course[@Enrollment=max(doc("courses.xml")//Course/@Enrollment)]/Title

(:*******************************************************************:)

doc("courses.xml")//Course[contains(Description, "LING180")]/data(@Number)


doc("courses.xml") //Course[Title=following::*/Title or Title=preceding::*/Title]/data(@Number)


for $b in doc("courses.xml")//Course
where $b/Instructors/*[First_Name="Daphne" or First_Name="Julie"]
return $b/data(@Number)


let $b := doc('courses.xml')//Course
 return count(
    for $c in $b
      where count($c/Instructors/Lecturer) = 0
      return $c)
	  
	  
doc("courses.xml")//Course[Instructors/*/Last_Name=(doc("courses.xml")//Chair/*/Last_Name)]/Title


doc("courses.xml")//Course[Instructors[count(Professor)!=0 and count(Lecturer)!=0]]/Title


doc("courses.xml")//Course[Instructors[Professor[Last_Name="Ng"] and count(Professor[Last_Name="Thrun"])=0]]/Title


doc("courses.xml")//Course[Prerequisites/Prereq=doc("courses.xml")//Course[Instructors/*/First_Name="Eric" and Instructors/*/Last_Name="Roberts"]/data(@Number)]/data(@Number)


<Summary>
{for $b in doc("courses.xml")//Department[@Code="CS"]/Course
order by xs:int($b/@Enrollment)
return  <Course>
            {$b/@Enrollment}
            {$b/Title}
       </Course>}
</Summary>
(:* look at return, with data() return the number, without data() return and number and format*:)


<Professors>
{for $b in distinct-values(doc("courses.xml")//Professor/Last_Name)
for $c in distinct-values(doc("courses.xml")//Professor[Last_Name=$b]/First_Name)
order by $b
return <Professor>
         <First_Name> {$c} </First_Name>
         {for $d in distinct-values(doc("courses.xml")//Professor[Last_Name=$b and Middle_Initial]/Middle_Initial)
         return <Middle_Initial> {$d} </Middle_Initial>}   
         <Last_Name> {$b} </Last_Name>
       </Professor>
}
</Professors>


<Inverted_Course_Catalog>
{for $b in distinct-values(doc("courses.xml")//Professor/Last_Name)
for $c in distinct-values(doc("courses.xml")//Professor[Last_Name=$b]/First_Name)
order by $b
return <Professor>
         <First_Name> {$c} </First_Name>
         {for $d in distinct-values(doc("courses.xml")//Professor[Last_Name=$b and Middle_Initial]/Middle_Initial)
         return <Middle_Initial> {$d} </Middle_Initial>}   
         <Last_Name> {$b} </Last_Name>
        
         {if (count(doc("courses.xml")//Course[Instructors/Professor/Last_Name=$b]) != 0)
         then (<Courses>
         {for $f in doc("courses.xml")//Course[Instructors/Professor/Last_Name=$b]
         return <Course>
                {$f/data(@Number)}
                </Course>}
               </Courses>)
         else()}
      
       </Professor>
}
</Inverted_Course_Catalog>