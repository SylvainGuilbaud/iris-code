Class Sample.Hypersensitivity Extends (%Persistent, %JSON.Adaptor, %Populate)
{

// Relationship patient As Sample.Patient [ Cardinality = parent, Inverse = hypersensitivity ];

Property Name As %VarString;

Storage Default
{
<Data name="HypersensitivityDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("hypersensitivity")</DataLocation>
<DefaultData>HypersensitivityDefaultData</DefaultData>
<IdLocation>^Sample.PatientC("hypersensitivity")</IdLocation>
<IndexLocation>^Sample.HypersensitivityI</IndexLocation>
<StreamLocation>^Sample.HypersensitivityS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
