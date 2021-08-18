Class Sample.AdverseEvents Extends (%Persistent, %JSON.Adaptor, %Populate)
{

Relationship patient As Sample.Patient [ Cardinality = parent, Inverse = adverseEvents ];

Property type As %String(VALUELIST = ",extravasation,hypersensitivity") [ Required ];

Storage Default
{
<Data name="AdverseEventsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>type</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("adverseEvents")</DataLocation>
<DefaultData>AdverseEventsDefaultData</DefaultData>
<ExtentSize>100</ExtentSize>
<IdLocation>^Sample.PatientC("adverseEvents")</IdLocation>
<IndexLocation>^Sample.AdverseEventsI</IndexLocation>
<Property name="%%CLASSNAME">
<AverageFieldSize>1</AverageFieldSize>
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="%%ID">
<AverageFieldSize>5.82</AverageFieldSize>
<Selectivity>1</Selectivity>
</Property>
<Property name="childsub">
<AverageFieldSize>1.92</AverageFieldSize>
<Selectivity>1.0000%</Selectivity>
</Property>
<Property name="patient">
<AverageFieldSize>1.9</AverageFieldSize>
<Selectivity>1.6129%</Selectivity>
</Property>
<Property name="type">
<AverageFieldSize>14.8</AverageFieldSize>
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="IDKEY">
<BlockCount>-16</BlockCount>
</SQLMap>
<StreamLocation>^Sample.AdverseEventsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
