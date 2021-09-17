Class msg.customerRequest Extends Ens.Request
{

Property nb As %Integer [ InitialExpression = 3 ];

Storage Default
{
<Data name="customerRequestDefaultData">
<Subscript>"customerRequest"</Subscript>
<Value name="1">
<Value>nb</Value>
</Value>
</Data>
<DefaultData>customerRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
