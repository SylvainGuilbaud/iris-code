Class data.customer Extends %Persistent
{

Property originID As %Integer [ Required ];

Property firstName As %String(MAXLEN = "");

Property lastName As %String(MAXLEN = "");

Property city As %String(MAXLEN = "");

Property category As %Integer(DISPLAYLIST = ",diamond,platinum,gold,silver,bronze", VALUELIST = ",1,2,3,4,5");

Property active As %Boolean [ InitialExpression = 1 ];

Property created As %TimeStamp [ InitialExpression = {$zdt($h,3)} ];

Property gender As %String;

Property hashtag As %String(MAXLEN = "");

Index idKey On originID [ Unique ];

Index firstNameIdx On firstName [ Type = index ];

Index lastNameIdx On lastName [ Type = index ];

Index categoryIdx On category [ Type = bitmap ];

Index cityIdx On city [ Type = bitmap ];

Index activeIdx On active [ Type = bitmap ];

Index genderIdx On gender [ Type = bitmap ];

Index createdIdx On created [ Type = index ];

ClassMethod getRecord(id As %Integer) As data.customer
{
    set sql($INCREMENT(sql))="SELECT id from data.customer WHERE originID = ?"
    set rs=##class(%SQL.Statement).%ExecDirect(,.sql,id)
    if rs.%Next() {
        set record = ..%OpenId(rs.%Get("id"))
    } else {
        set record = ..%New()
        set record.originID=id
    }
    return record
}

Storage Default
{
<Data name="customerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>originID</Value>
</Value>
<Value name="3">
<Value>firstName</Value>
</Value>
<Value name="4">
<Value>lastName</Value>
</Value>
<Value name="5">
<Value>city</Value>
</Value>
<Value name="6">
<Value>category</Value>
</Value>
<Value name="7">
<Value>active</Value>
</Value>
<Value name="8">
<Value>created</Value>
</Value>
<Value name="9">
<Value>gender</Value>
</Value>
<Value name="10">
<Value>hashtag</Value>
</Value>
</Data>
<DataLocation>^data.customerD</DataLocation>
<DefaultData>customerDefaultData</DefaultData>
<IdLocation>^data.customerD</IdLocation>
<IndexLocation>^data.customerI</IndexLocation>
<StreamLocation>^data.customerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
