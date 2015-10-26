doc("countries.xml")//country[@name="Mongolia"]/data(@area)


doc("countries.xml")//city[name=doc("countries.xml")//country/data(@name)]/name


let $plist := doc("countries.xml")//country[language="Russian"]
return avg($plist/data(@population))
(:*use condition to select the thing you want*:)


doc("countries.xml")//country[count(city[population>3000000])>=3]/data(@name)


<result>
<French>
{for $b in doc("countries.xml")//country[language="French"]
return <country> {$b/data(@name)} </country>
}
</French>
<German>
{for $c in doc("countries.xml")//country[language="German"]
return <country> {$c/data(@name)} </country>
}
</German>
</result>


(:* when we use operator like count, max, avg and so on, should go with let $b := .. 
and if there are multiple flwor, should separate by {}*************************:)
<result>
{for $b in doc("countries.xml")//country
let $c := doc("countries.xml")//country
where $b/data(@population div @area) = max($c/data(@population div @area))
return <highest density='{$b/data(@population div @area)}'> {$b/data(@name)} </highest>
}
{for $d in doc("countries.xml")//country
let $e := doc("countries.xml")//country
where $d/data(@population div @area) = min($e/data(@population div @area))
return <lowest  density='{$d/data(@population div @area)}'> {$d/data(@name)} </lowest>
}
</result>
(:******************************************************************:)
doc("countries.xml")//country[@population>100000000]/data(@name)


doc("countries.xml")//country[language[.="German" and ./@percentage>50]]/data(@name)
(:***** '.' means current element*********:)


for $b in doc("countries.xml")//country
where $b/data(@population) div 3 < $b/city/population
return $b/data(@name)


for $b in doc("countries.xml")//country[@name="Qatar"]
return $b/data(@population) div $b/data(@area)


for $b in doc("countries.xml")//country
where some $f in doc("countries.xml")//city
satisfies $f/population div 1000 > $b/data(@population)
return $b/data(@name)


doc("countries.xml")//city[name=following::*/name]/name


doc("countries.xml")//country[city/name=following::*/city/name or city/name=preceding::*/city/name]/data(@name)


for $b in doc("countries.xml")//country
where some $f in $b/language
satisfies $b[contains(@name, $f)]
return $b/data(@name)


for $b in doc("countries.xml")//country
where some $f in $b/language
satisfies contains($f, $b/data(@name))
return $b/data(@name)


for $b in doc("countries.xml")//country/language
where $b[contains(./parent::*/data(@name), data(.))]
return $b/data(.)


for $b in doc("countries.xml")//country/language
where $b[contains(data(.), ./parent::*/data(@name))]
return $b/data(.)


count(doc("countries.xml")//country[language="Russian"])


doc("countries.xml")//country[@population>10000000 and not(exists(language)) and not(exists(city))]/data(@name)


doc("countries.xml")//country[@population=max(doc("countries.xml")//country/xs:int(data(@population)))]/data(@name)


doc("countries.xml")//country[city/population=max(doc("countries.xml")//city/population)]/data(@name)


let $b := doc("countries.xml")//country[language="Russian"]
return avg($b/count(language))
(:*********watch the position difference of count between for statement and let statement
pay attention to the calculation order***:)


for $b in doc("countries.xml")//country
for $f in $b/language
where $b[contains(./data(@name), $f)]
return <country language='{$f/data(.)}'>
        {$b/data(@name)}
       </country>
	   
	   
for $b in doc("countries.xml")//country
where $b/city/population > 7000000
return <country name='{$b/data(@name)}'>
         {for $c in $b/city[population>7000000]
         return <big> {$c/data(name)} </big> }
       </country> 

     
	 
for $b in doc("countries.xml")//country[language and sum(language/@percentage)<90]
return <country name='{$b/data(@name)}'>
        {for $c in $b/language
            return $c }
       </country>
(:***********there are sum operator *********:)


for $b in doc("countries.xml")//country[language]
where every $f in $b/language
satisfies $f/@percentage < 20
return <country name='{$b/data(@name)}'>
        {for $c in $b/language
        return $c}
       </country>
	   
	   
for $b in doc("countries.xml")//country[count(language)>1]
for $c in doc("countries.xml")//country[count(language)>1]
where $b/language[@percentage=max($b/language/@percentage)] = $c/language[@percentage=min($c/language/@percentage)]
return <LangPair language='{$b/data(language[@percentage=max($b/language/@percentage)])}'>
         <MostPopular> {$b/data(@name)} </MostPopular>
         <LeastPopular> {$c/data(@name)} </LeastPopular>
       </LangPair>
	   
	   
<languages>
{for $b in distinct-values(doc("countries.xml")//language)
order by $b
return <language name="{$b}">
        {for $c in doc("countries.xml")//country[language=$b]
        for $d in $c/language where $d=$b
        return <country name="{$c/data(@name)}" speakers="{xs:int($c/@population * $d/@percentage div 100)}"/>
        }
       </language>
}
</languages>