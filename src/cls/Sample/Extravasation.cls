Class Sample.Extravasation Extends (%Persistent, %JSON.Adaptor, %Populate)
{

// Relationship patient As Sample.Patient [ Cardinality = parent, Inverse = extravasation ];

Property Name As %VarString;

Storage Default
{
<Data name="ExtravasationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("extravasation")</DataLocation>
<DefaultData>ExtravasationDefaultData</DefaultData>
<IdLocation>^Sample.PatientC("extravasation")</IdLocation>
<IndexLocation>^Sample.ExtravasationI</IndexLocation>
<StreamLocation>^Sample.ExtravasationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
