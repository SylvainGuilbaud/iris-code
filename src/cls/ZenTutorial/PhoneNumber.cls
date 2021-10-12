Class ZenTutorial.PhoneNumber Extends (%Persistent, %Populate, %XML.Adaptor) [ Inheritance = right ]
{

Property Number As %String(POPSPEC = "USPhone()");

Property PhoneNumberType As %String(VALUELIST = ",Home,Office,Mobile");

Relationship Contact As ZenTutorial.Contact [ Cardinality = parent, Inverse = PhoneNumbers ];

Storage Default
{
<Data name="PhoneNumberDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Number</Value>
</Value>
<Value name="3">
<Value>PhoneNumberType</Value>
</Value>
</Data>
<DataLocation>^ZenTutorial.PhoneNumberD</DataLocation>
<DefaultData>PhoneNumberDefaultData</DefaultData>
<IdLocation>^ZenTutorial.PhoneNumberD</IdLocation>
<IndexLocation>^ZenTutorial.PhoneNumberI</IndexLocation>
<Property name="Contact"/>
<Property name="Number"/>
<Property name="PhoneNumberType"/>
<Property name="childsub"/>
<StreamLocation>^ZenTutorial.PhoneNumberS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
