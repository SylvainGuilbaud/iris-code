Class Sample.Patient Extends (%Persistent, %JSON.Adaptor, %Populate)
{

// Relationship extravasation As Sample.Extravasation [ Cardinality = children, Inverse = patient ];

// Relationship hypersensitivity As Sample.Hypersensitivity [ Cardinality = children, Inverse = patient ];

Relationship adverseEvents As Sample.AdverseEvents [ Cardinality = children, Inverse = patient ];

Property Name As %VarString;

Property Title As %String;

Property Company As %String;

Property Phone As %VarString;

Property DOB As %Date(MAXVAL = "$piece($horolog, "","", 1)");

/// Index for property DOB
Index DOBIndex On DOB;

Storage Default
{
<Data name="PatientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Title</Value>
</Value>
<Value name="4">
<Value>Company</Value>
</Value>
<Value name="5">
<Value>Phone</Value>
</Value>
<Value name="6">
<Value>DOB</Value>
</Value>
</Data>
<DataLocation>^Sample.PatientD</DataLocation>
<DefaultData>PatientDefaultData</DefaultData>
<IdLocation>^Sample.PatientD</IdLocation>
<IndexLocation>^Sample.PatientI</IndexLocation>
<StreamLocation>^Sample.PatientS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
