Class msg.customerResponse Extends Ens.Response
{

Property nb As %Integer;

Property customers As array Of struct.customer;

Storage Default
{
<Data name="customerResponseDefaultData">
<Subscript>"customerResponse"</Subscript>
<Value name="1">
<Value>nb</Value>
</Value>
</Data>
<Data name="customers">
<Attribute>customers</Attribute>
<Structure>subnode</Structure>
<Subscript>"msg.customerResponse.customers"</Subscript>
</Data>
<DefaultData>customerResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
