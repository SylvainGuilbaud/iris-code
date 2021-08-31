/// RECORDMAP: Generated from RecordMap 'data.RM.customer'
/// on 2021-08-31 at 16:54:34.205 [2021-08-31 16:54:34.205 UTC]
/// by user _SYSTEM
Class data.RM.customer.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right, ProcedureBlock ]
{

Parameter INCLUDETOPFIELDS = 1;

Property id As %Integer [ SqlColumnNumber = 2 ];

Property active As %Boolean [ SqlColumnNumber = 3 ];

Property category As %Integer [ SqlColumnNumber = 4 ];

Property city As %String [ SqlColumnNumber = 5 ];

Property created As %TimeStamp [ SqlColumnNumber = 6 ];

Property firstName As %String [ SqlColumnNumber = 7 ];

Property lastName As %String [ SqlColumnNumber = 8 ];

Parameter RECORDMAPGENERATED = 1;

Relationship %ParentBatch As data.RM.customer.Batch [ Cardinality = one, Inverse = Records ];

Index %ParentBatchIdx On %ParentBatch;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>id</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>category</Value>
</Value>
<Value name="5">
<Value>city</Value>
</Value>
<Value name="6">
<Value>created</Value>
</Value>
<Value name="7">
<Value>firstName</Value>
</Value>
<Value name="8">
<Value>lastName</Value>
</Value>
<Value name="9">
<Value>%ParentBatch</Value>
</Value>
<Value name="10">
<Value>active</Value>
</Value>
</Data>
<DataLocation>^data.RM.customer.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^data.RM.customer.RecordD</IdLocation>
<IndexLocation>^data.RM.customer.RecordI</IndexLocation>
<StreamLocation>^data.RM.customer.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
