Class JDBC.demo.msg.customerRequest Extends Ens.Request
{

Property active As %Boolean [ InitialExpression = {$random(2)} ];

Property created As %TimeStamp [ InitialExpression = {$zdt($h-$RANDOM(1000)_","_$random(86400),3)} ];

Property firstName As %String [ InitialExpression = {##class(%PopulateUtils).FirstName()} ];

Property lastName As %String [ InitialExpression = {##class(%PopulateUtils).LastName()} ];

Property city As %String [ InitialExpression = {##class(%PopulateUtils).City()} ];

Property category As %Integer [ InitialExpression = {$RANDOM(5)+1} ];

Property originID As %Integer [ InitialExpression = {$INCREMENT(^OriginID)} ];

Storage Default
{
<Data name="customerRequestDefaultData">
<Subscript>"customerRequest"</Subscript>
<Value name="1">
<Value>active</Value>
</Value>
<Value name="2">
<Value>created</Value>
</Value>
<Value name="3">
<Value>firstName</Value>
</Value>
<Value name="4">
<Value>lastName</Value>
</Value>
<Value name="5">
<Value>city</Value>
</Value>
<Value name="6">
<Value>category</Value>
</Value>
<Value name="7">
<Value>originID</Value>
</Value>
</Data>
<DefaultData>customerRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
