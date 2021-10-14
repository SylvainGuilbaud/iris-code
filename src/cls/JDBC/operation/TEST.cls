Class JDBC.operation.TEST Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method test(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set sc = $$$OK
	
	try{
		set pResponse = ##class(Ens.StringResponse).%New()
		set query = ""
		set query = query_"SELECT count(*) as nb FROM "_pRequest.StringValue

		$$$TRACE(query)

		$$$ThrowOnError(..Adapter.ExecuteQuery(.rs,query))

		if rs.%Next() {
			set nb = rs.%Get("nb")
			$$$LOGINFO("nb:" _ nb)
		} else {
			$$$LOGINFO("NO DATA FOUND")
		}
		
		set pResponse.StringValue = nb
	}
	catch exp
	{
		set sc = exp.AsStatus()
	}
	return sc
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Ens.StringRequest"> 
		<Method>test</Method>
	</MapItem>
</MapItems>
}

}
