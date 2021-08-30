Include EnsSQLTypes

Class JDBC.demo.INSERT.operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "JDBC.SQL.OutboundAdapter";

Property Adapter As JDBC.SQL.OutboundAdapter;

Property batchSize As %Integer [ InitialExpression = 1000 ];

Property insertSize As %Integer [ InitialExpression = 50000 ];

Parameter SETTINGS = "batchSize,insertSize";

Parameter INVOCATION = "Queue";

Method OnInit() As %Status
{
	do ##super()
	set $ZSTORAGE=2147483647
	return $$$OK
}

Method INSERT(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set sc = $$$OK
	
	try{
		set pResponse = ##class(Ens.StringResponse).%New()
		
		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		set insertQuery = "INSERT into customer (first_name,last_name,city,category) values (?,?,?,?))"

		$$$LOGINFO(insertQuery)
		
		set batchSize = ..batchSize
				
		set end =""
		set nbInserted=0
		while nbInserted<..insertSize{
			
			kill data
			
			for i=1:1:..batchSize {
				
				set data(i,1) = ##class(%PopulateUtils).FirstName()
				set data(i,1,"SqlType")=$$$SqlVarchar

				set data(i,2) = ##class(%PopulateUtils).LastName()
				set data(i,2,"SqlType")=$$$SqlVarchar

				set data(i,3) = ##class(%PopulateUtils).City()
				set data(i,3,"SqlType")=$$$SqlVarchar
			
				set data(i,3) = $RANDOM(5)+1
				set data(i,3,"SqlType")=$$$SqlInteger

				set data(i) = 4

				do $INCREMENT(nbInserted)
				q:(nbInserted=..insertSize)

			}	
		     
			set data = i
			
			set sc = ..Adapter.ExecuteUpdateBatchParamArray(.nrows,insertQuery,.data)

			$$$LOGINFO(sc)		
	}

	Set TimeStampEnd = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

	Set Delta = TimeStampEnd - TimeStampStart

	set pResponse.StringValue = nbLignes_" in "_Delta
		
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
		<Method>INSERT</Method>
	</MapItem>
</MapItems>
}

}
