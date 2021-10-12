Class ZenTutorial.Contact Extends (%Persistent, %Populate, %XML.Adaptor) [ Inheritance = right ]
{

Property Name As %String [ Required ];

Property ContactType As %String(VALUELIST = ",Business,Personal");

Property Address1 As ZenTutorial.Address;

Relationship PhoneNumbers As ZenTutorial.PhoneNumber [ Cardinality = children, Inverse = Contact ];

Storage Default
{
<Data name="ContactDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ContactType</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Address1</Value>
</Value>
</Data>
<DataLocation>^ZenTutorial.ContactD</DataLocation>
<DefaultData>ContactDefaultData</DefaultData>
<IdLocation>^ZenTutorial.ContactD</IdLocation>
<IndexLocation>^ZenTutorial.ContactI</IndexLocation>
<Property name="Address1"/>
<Property name="ContactType"/>
<Property name="Name"/>
<StreamLocation>^ZenTutorial.ContactS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
