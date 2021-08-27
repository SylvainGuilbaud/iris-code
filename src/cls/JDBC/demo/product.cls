Class JDBC.demo.product Extends %Persistent
{

Property ID As %String;

Property Name As %String;

Index IDKey On ID [ IdKey ];

Storage Default
{
<Data name="productDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>^JDBC.demo.productD</DataLocation>
<DefaultData>productDefaultData</DefaultData>
<IdLocation>^JDBC.demo.productD</IdLocation>
<IndexLocation>^JDBC.demo.productI</IndexLocation>
<StreamLocation>^JDBC.demo.productS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
