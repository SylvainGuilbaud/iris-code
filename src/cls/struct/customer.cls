Class struct.customer Extends (%SerialObject, %XML.Adaptor)
{

Property firstName As %String;

Property gender As %String;

Storage Default
{
<Data name="customerState">
<Value name="1">
<Value>firstName</Value>
</Value>
<Value name="2">
<Value>gender</Value>
</Value>
</Data>
<State>customerState</State>
<StreamLocation>^struct.customerS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
