Class JDBC.demo.SELECT.operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "JDBC.SQL.OutboundAdapter";

Property Adapter As JDBC.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property batchSize As %Integer [ InitialExpression = 500 ];

Parameter SETTINGS = "batchSize";

// Set storage max pour ce processus

Method OnInit() As %Status
{
	Do ##super()
	SET $ZSTORAGE=2147483647
	q $$$OK
}

Method SELECT(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	
	set tStatus = $$$OK
	set nbRows = 0

	try{
		
		set pResponse = ##class(Ens.StringResponse).%New()
		set sqlGetView = "SELECT ID, ProductName FROM demo.ODS_Products"
		
		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		$$$TRACE(sqlGetView)
			
		$$$ThrowOnError(..Adapter.ExecuteQueryBatch(.tRs,sqlGetView,..batchSize))
		
		While tRs.%Next(){

			Set tID = tRs.Get("ID")

			If ##class(JDBC.demo.product).%ExistsId(tID){
				Set tProduct = ##class(JDBC.demo.product).%OpenId(tID)
			}
			Else {
				Set tProduct = ##class(JDBC.demo.product).%New()
			}
			
			Set tProduct.ID = tID
			Set tProduct.Name = tRs.Get("ProductName")
			$$$ThrowOnError(tProduct.%Save())

			Do $INCREMENT(nbRows)
		}
		
		Set TimeStampEnd = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		Set Delta = TimeStampEnd - TimeStampStart

		Set pResponse.StringValue = nbRows_" in "_Delta
	}
	catch exp
	{
		Set tStatus = exp.AsStatus()
	}
	Quit tStatus
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
