Class JDBC.demo.msg.test Extends Ens.Request
{

Property firstName As %String [ InitialExpression = {##class(%PopulateUtils).FirstName()} ];

Property lastName As %String [ InitialExpression = {##class(%PopulateUtils).LastName()} ];

Property city As %String [ InitialExpression = {##class(%PopulateUtils).City()} ];

Property category As %Integer [ InitialExpression = {$RANDOM(5)+1} ];

Property originID As %Integer [ InitialExpression = {$INCREMENT(^OriginID)} ];

Storage Default
{
<Data name="testDefaultData">
<Subscript>"test"</Subscript>
<Value name="1">
<Value>firstName</Value>
</Value>
<Value name="2">
<Value>lastName</Value>
</Value>
<Value name="3">
<Value>city</Value>
</Value>
<Value name="4">
<Value>category</Value>
</Value>
<Value name="5">
<Value>originID</Value>
</Value>
</Data>
<DefaultData>testDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
