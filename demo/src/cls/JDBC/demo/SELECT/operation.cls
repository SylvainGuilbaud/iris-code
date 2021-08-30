Class JDBC.demo.SELECT.operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "JDBC.SQL.OutboundAdapter";

Property Adapter As JDBC.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property batchSize As %Integer [ InitialExpression = 500 ];

Parameter SETTINGS = "batchSize";


Method OnInit() As %Status
{
	do ##super()
	set $ZSTORAGE=2147483647
	return $$$OK
}

Method SELECT(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	
	set sc = $$$OK
	
	try{
		
		set pResponse = ##class(Ens.StringResponse).%New()
		set query = ""
		set query = query_"SELECT "
		set query = query_" id"
		set query = query_",last_name"
		set query = query_",first_name"
		set query = query_",city"
		set query = query_",active"
    	set query = query_",category"
		set query = query_",created" 
		set query = query_"FROM customer"
		
		Set start = $zh

		$$$TRACE(sqlGetView)
			
		$$$ThrowOnError(..Adapter.ExecuteQueryBatch(.rs,sqlGetView,..batchSize))
		
		While rs.%Next(){

			set id = rs.Get("id")
			if ##class(data.customer).%ExistsId(rs.Get("id")){
				set customer = ##class(data.customer).%OpenId(id)
			}
			else {
				set customer = ##class(data.customer).%New()
			}
			set customer.lastName = rs.Get("last_name")
			set customer.firstName = rs.Get("first_name")
			set customer.city = rs.Get("city")
			set customer.category = rs.Get("category")
			set customer.active = rs.Get("active")
			$$$ThrowOnError(customer.%Save())

			do $INCREMENT(records)
		}
		
		set elapse = $zh-start

		set pResponse.StringValue = records_" ("_elapse_" seconds)"
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
		<Method>SELECT</Method>
	</MapItem>
</MapItems>
}

}
