Class ZenTutorial.Address Extends (%SerialObject, %Populate, %XML.Adaptor) [ Inheritance = right ]
{

Property Street As %String(MAXLEN = 100);

Property City As %String(MAXLEN = 100);

Property State As %String(MAXLEN = 2);

Property Zip As %String(MAXLEN = 5);

Storage Default
{
<Data name="AddressState">
<Value name="1">
<Value>City</Value>
</Value>
<Value name="2">
<Value>State</Value>
</Value>
<Value name="3">
<Value>Street</Value>
</Value>
<Value name="4">
<Value>Zip</Value>
</Value>
</Data>
<State>AddressState</State>
<StreamLocation>^ZenTutorial.AddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
