Include EnsSQLTypes

Class JDBC.demo.INSERT.operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "JDBC.SQL.OutboundAdapter";

Property Adapter As JDBC.SQL.OutboundAdapter;

Property batch As %Integer [ InitialExpression = 10 ];

Property batchSize As %Integer [ InitialExpression = 10 ];

Parameter SETTINGS = "batch,batchSize";

Parameter INVOCATION = "Queue";

// Set max RAM memory for this process

Method OnInit() As %Status
{
	Do ##super()
	SET $ZSTORAGE=2147483647
	q $$$OK
}

Method INSERT(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set tStatus = $$$OK
	
	try{
					
		set nbLignes = 0
		set pResponse = ##class(Ens.StringResponse).%New()
		
		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		//Pour les tests, on truncate les tables avant insertion
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"DROP TABLE IF EXISTS demo.ODS_Products"))

		//Creer la table pour l'exemple
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"CREATE TABLE demo.ODS_Products (id int8 NULL,productname varchar NULL,date_alimentation date NULL)"))		

		set SqlInsertView = "INSERT into demo.ODS_Products (ID,ProductName,Date_Alimentation) values (?,?,TO_DATE(?,'yyyy-mm-dd hh24:mi:ss'))"

		$$$LOGINFO(SqlInsertView)
		
		set batch = ..batch
				
		set end =""
		set i=0
		while i<..batchSize{
			
			set param = ""
			
			for k=1:1:batch {
				
				set param(k,1) = i
				set param(k,1,"SqlType")=$$$SqlInteger

				set param(k,2) = ##class(%PopulateUtils).Name()
				set param(k,2,"SqlType")=$$$SqlVarchar
			
				set param(k,3) = $ZDATETIME($NOW(),3)
				set param(k,3,"SqlType")=$$$SqlVarchar

				set param(k) = 3

				set i = i + 1
				q:(i=..batchSize)
							
				}	
		     
			set param = k
			
			set sc = ..Adapter.ExecuteUpdateBatchParamArray(.nrows,SqlInsertView,.param)

			$$$LOGINFO(sc)	

			k param
				
			set nbLignes = nbLignes + nrows
				
	}

	Set TimeStampEnd = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

	Set Delta = TimeStampEnd - TimeStampStart

	set pResponse.StringValue = nbLignes_" in "_Delta
		
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
		<Method>INSERT</Method>
	</MapItem>
</MapItems>
}

}
