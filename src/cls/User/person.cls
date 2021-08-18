/// Quand il y a des index, il faut absolument éviter de modifier les globales de données au risque de casser la cohérence avec les globales d’index.
/// Le moteur SQL n’a rien d’automatique pour reconstruire des globales d’index cassées suite à des manipulations en direct sur les globales de données.
/// Les index sont automatiquement maintenus par des modifications de données via des accès Objet/SQL uniquement ; pas par des modifications effectuées directement sur les globales.
/// Il est cependant possible de reconstruire partiellement les index via les méthodes ValidateIndices
/// Validating Indices
/// You can validate indices using the either of the following methods:
/// ·         <example>do $SYSTEM.OBJ.ValidateIndices() ;validates the indices for a table, 
/// ;and also validates any indices in collection child tables for that table.</example>
/// ·        <example>do ##class(%Library.Storage).%ValidateIndices() ; validates the indices for a table. 
/// ;Collection child table indices must be validated with separate %ValidateIndices() calls.</example>
/// Exemple ci-dessous en utilisant la classe User.person définie comme suit :
/// <example>
///  zw ^User.personD,^User.personI
///  w ##class(person).init(3)
/// </example>
/// <p>3
/// <example>
///  zw ^User.personD,^User.personI
/// </example>
/// <p>^User.personD=3
/// <p>^User.personD(1)=$lb("","Allen,Christen R.","Ukiah",42757,1)
/// <p>^User.personD(2)=$lb("","Baker,Belinda D.","Reston",59372,2)
/// <p>^User.personD(3)=$lb("","Vivaldi,Quigley T.","Miami",38721,1)
/// <p>^User.personI("$person",1)=$zwc(412,1,0)/*$bit(2..4)*/^User.personI("cityIdx"," MIAMI",3)=""
/// <p>^User.personI("cityIdx"," RESTON",2)=""
/// <p>^User.personI("cityIdx"," UKIAH",1)=""
/// <p>^User.personI("dobIdx",38721,1)=$zwc(404,1,3)/*$bit(4)*/
/// <p>^User.personI("dobIdx",42757,1)=$zwc(406,1,1)/*$bit(2)*/
/// <p>^User.personI("dobIdx",59372,1)=$zwc(405,1,2)/*$bit(3)*/
/// <p>^User.personI("nameIdx"," ALLEN,CHRISTEN R.",1)=""
/// <p>^User.personI("nameIdx"," BAKER,BELINDA D.",2)=""
/// <p>^User.personI("nameIdx"," VIVALDI,QUIGLEY T.",3)=""
/// <p>^User.personI("sexIdx",1,1)=$zwc(404,1,1,3)/*$bit(2,4)*/
/// <p>^User.personI("sexIdx",2,1)=$zwc(405,1,2)/*$bit(3)*/
/// <example>
///  w ##class(person).%ValidateIndices()
/// </example>
/// <p>Checking index integrity for class 'User.person'
/// <p>Begin time:  04/05/2021 13:04:20
/// <p>Verifying data from data map 'IDKEY' is indexed correctly...
/// <p>Data Map evaluation complete, 3 rows checked, 0 errors found, elapsed time: .000141 seconds
/// <p>Verifying data from index map "$person" is correct...
/// <p>Index map "$person" evaluation complete, 0 errors, elapsed time: .000216 seconds
/// <p>Verifying data from index map cityIdx is correct...
/// <p>Index map cityIdx evaluation complete, 0 errors, elapsed time: .000214 seconds
/// <p>Verifying data from index map dobIdx is correct...
/// <p>Index map dobIdx evaluation complete, 0 errors, elapsed time: .000185 seconds
/// <p>Verifying data from index map nameIdx is correct...
/// <p>Index map nameIdx evaluation complete, 0 errors, elapsed time: .000099 seconds
/// <p>Verifying data from index map sexIdx is correct...
/// <p>Index map sexIdx evaluation complete, 0 errors, elapsed time: .000124 seconds
/// <p>%ValidateIndices is complete, total elapsed time: .001932 seconds
/// <p>1
/// <example>
///  set ^User.personD(2)=$lb("","Hendrix, Jimi","Seattle",37220,1)
///  w ##class(person).%ValidateIndices()      
/// </example>                      
/// <p>Checking index integrity for class 'User.person'
/// <p>Begin time:  04/05/2021 13:05:44
/// <p>Verifying data from data map 'IDKEY' is indexed correctly...
/// <p>Index 'cityIdx', entry ^User.personI("cityIdx"," Seattle",2) missing. 
/// <p>Bitmap index 'dobIdx', entry $bit(^User.personI("dobIdx",37220,1),3)=0, row is missing from index, it should be 1. 
/// <p>Index 'nameIdx', entry ^User.personI("nameIdx"," Hendrix, Jimi",2) missing. 
/// <p>Bitmap index 'sexIdx', entry $bit(^User.personI("sexIdx",1,1),3)=0, row is missing from index, it should be 1. 
/// <p>Data Map evaluation complete, 3 rows checked, 4 errors found, elapsed time: .000243 seconds
/// <p>Verifying data from index map "$person" is correct...
/// <p>Index map "$person" evaluation complete, 0 errors, elapsed time: .000068 seconds
/// <p>Verifying data from index map cityIdx is correct...
/// <p>Index 'cityIdx', entry ^User.personI("cityIdx"," RESTON",2), data differs for field 'city' between data and index map.
/// <p>Index map cityIdx evaluation complete, 1 errors, elapsed time: .000097 seconds
/// <p>Verifying data from index map dobIdx is correct...
/// <p>Bitmap index 'dobIdx', entry  $bit(^User.personI("dobIdx",59372,1),3), for row with ID '2', bit is ON, but indexed field value(s) differ from data map value(s). 
/// <p>Index map dobIdx evaluation complete, 1 errors, elapsed time: .000191 seconds
/// <p>Verifying data from index map nameIdx is correct...
/// <p>Index 'nameIdx', entry ^User.personI("nameIdx"," BAKER,BELINDA D.",2), data differs for field 'name' between data and index map.
/// <p>Index map nameIdx evaluation complete, 1 errors, elapsed time: .000099 seconds
/// <p>Verifying data from index map sexIdx is correct...
/// <p>Bitmap index 'sexIdx', entry  $bit(^User.personI("sexIdx",2,1),3), for row with ID '2', bit is ON, but indexed field value(s) differ from data map value(s). 
/// <p>Index map sexIdx evaluation complete, 1 errors, elapsed time: .000068 seconds
/// <p>%ValidateIndices is complete, total elapsed time: .001616 seconds
/// <p>1
/// <example>
///  set autocorrect=1
///  w ##class(person).%ValidateIndices(,autocorrect)
/// </example>
/// <p>Checking index integrity for class 'User.person'
/// <p>Begin time:  04/05/2021 13:06:03
/// <p>Verifying data from data map 'IDKEY' is indexed correctly...
/// <p>Index 'cityIdx', entry ^User.personI("cityIdx"," Seattle",2) missing.  Corrected
/// <p>Bitmap index 'dobIdx', entry $bit(^User.personI("dobIdx",37220,1),3)=0, row is missing from index, it should be 1.  Corrected
/// <p>Index 'nameIdx', entry ^User.personI("nameIdx"," Hendrix, Jimi",2) missing.  Corrected
/// <p>Bitmap index 'sexIdx', entry $bit(^User.personI("sexIdx",1,1),3)=0, row is missing from index, it should be 1.  Corrected
/// <p>Data Map evaluation complete, 3 rows checked, 4 errors found, elapsed time: .000369 seconds
/// <p>Verifying data from index map "$person" is correct...
/// <p>Index map "$person" evaluation complete, 0 errors, elapsed time: .000068 seconds
/// <p>Verifying data from index map cityIdx is correct...
/// <p>Index 'cityIdx', entry ^User.personI("cityIdx"," RESTON",2), data differs for field 'city' between data and index map.  Corrected
/// <p>Index map cityIdx evaluation complete, 1 errors, elapsed time: .000615 seconds
/// <p>Verifying data from index map nameIdx is correct...
/// <p>Index 'nameIdx', entry ^User.personI("nameIdx"," BAKER,BELINDA D.",2), data differs for field 'name' between data and index map.  Corrected
/// <p>Index map nameIdx evaluation complete, 1 errors, elapsed time: .000815 seconds
/// <p>Verifying data from index map dobIdx is correct...
/// <p>Bitmap index 'dobIdx', entry  $bit(^User.personI("dobIdx",59372,1),3), for row with ID '2', bit is ON, but indexed field value(s) differ from data map value(s).  Corrected
/// <p>Index map dobIdx evaluation complete, 1 errors, elapsed time: .000879 seconds
/// <p>Verifying data from index map sexIdx is correct...
/// <p>Bitmap index 'sexIdx', entry  $bit(^User.personI("sexIdx",2,1),3), for row with ID '2', bit is ON, but indexed field value(s) differ from data map value(s).  Corrected
/// <p>Index map sexIdx evaluation complete, 1 errors, elapsed time: .000827 seconds
/// <p>%ValidateIndices is complete, total elapsed time: .002696 seconds
/// <p>1
/// <example>
///  zw ^User.personD,^User.personI   
/// </example>                               
/// <p>^User.personD=3
/// <p>^User.personD(1)=$lb("","Allen,Christen R.","Ukiah",42757,1)
/// <p>^User.personD(2)=$lb("","Hendrix, Jimi","Seattle",37220,1)
/// <p>^User.personD(3)=$lb("","Vivaldi,Quigley T.","Miami",38721,1)
/// <p>^User.personI("$person",1)=$zwc(412,1,0)/*$bit(2..4)*/
/// <p>^User.personI("cityIdx"," Seattle",2)=""
/// <p>^User.personI("cityIdx"," MIAMI",3)=""
/// <p>^User.personI("cityIdx"," UKIAH",1)=""
/// <p>^User.personI("dobIdx",38721,1)=$zwc(404,1,3)/*$bit(4)*/
/// <p>^User.personI("dobIdx",42757,1)=$zwc(406,1,1)/*$bit(2)*/
/// <p>^User.personI("dobIdx",37220,1)=$zwc(405,1,2)/*$bit(3)*/
/// <p>^User.personI("dobIdx",59372,1)=$zwc(149,1)/*$bit()*/
/// <p>^User.personI("nameIdx"," ALLEN,CHRISTEN R.",1)=""
/// <p>^User.personI("nameIdx"," Hendrix, Jimi",2)=""
/// <p>^User.personI("nameIdx"," VIVALDI,QUIGLEY T.",3)=""
/// <p>^User.personI("sexIdx",1,1)=$zwc(412,1,0)/*$bit(2..4)*/
/// <p>^User.personI("sexIdx",2,1)=$zwc(149,1)/*$bit()*/
/// <example>
///  w ##class(person).%ValidateIndices(,autocorrect)
/// </example>
/// <p>Checking index integrity for class 'User.person'
/// <p>Begin time:  04/05/2021 13:06:18
/// <p>Verifying data from data map 'IDKEY' is indexed correctly...
/// <p>Data Map evaluation complete, 3 rows checked, 0 errors found, elapsed time: .000141 seconds
/// <p>Verifying data from index map "$person" is correct...
/// <p>Index map "$person" evaluation complete, 0 errors, elapsed time: .000113 seconds
/// <p>Verifying data from index map cityIdx is correct...
/// <p>Index map cityIdx evaluation complete, 0 errors, elapsed time: .000101 seconds
/// <p>Verifying data from index map dobIdx is correct...
/// <p>Index map dobIdx evaluation complete, 0 errors, elapsed time: .000212 seconds
/// <p>Verifying data from index map nameIdx is correct...
/// <p>Index map nameIdx evaluation complete, 0 errors, elapsed time: .00008 seconds
/// <p>Verifying data from index map sexIdx is correct...
/// <p>Index map sexIdx evaluation complete, 0 errors, elapsed time: .000087 seconds
/// <p>%ValidateIndices is complete, total elapsed time: .001722 seconds
/// <p>1
Class User.person Extends (%Persistent, %Populate)
{

Property name As %String;

Property city As %String;

Property dob As %Date(FORMAT = 4);

Property sex As %Integer(VALUELIST = ",1,2");

Property status As %Numeric [ InitialExpression = {$RANDOM(100)} ];

Index nameIdx On name;

Index cityIdx On city;

Index dobIdx On dob [ Type = bitmap ];

Index sexIdx On sex [ Type = bitmap ];

ClassMethod init(nb As %Integer = 10) As %Integer
{
    set sc=$$$OK
    kill ^User.personS,^User.personD,^User.personI
    set inserted=..Populate(nb)
    return inserted
}

Storage Default
{
<Data name="personDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>name</Value>
</Value>
<Value name="3">
<Value>city</Value>
</Value>
<Value name="4">
<Value>dob</Value>
</Value>
<Value name="5">
<Value>sex</Value>
</Value>
<Value name="6">
<Value>status</Value>
</Value>
</Data>
<DataLocation>^User.personD</DataLocation>
<DefaultData>personDefaultData</DefaultData>
<IdLocation>^User.personD</IdLocation>
<IndexLocation>^User.personI</IndexLocation>
<StreamLocation>^User.personS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
