Include EnsSQLTypes

Class JDBC.demo.INSERT.operation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "JDBC.SQL.OutboundAdapter";

Property Adapter As JDBC.SQL.OutboundAdapter;

Property batchSize As %Integer [ InitialExpression = 1000 ];

Property maxToInsert As %Integer [ InitialExpression = 50000 ];

Property SCHEMA As %String [ InitialExpression = "app" ];

Parameter SETTINGS = "batchSize:JDBC,maxToInsert:JDBC,SCHEMA:app";

Parameter INVOCATION = "Queue";

Method OnInit() As %Status
{
	do ##super()
	set $ZSTORAGE=2147483647
	return $$$OK
}

Method testBatch(pRequest As JDBC.demo.msg.testBatch, Output pResponse As Ens.StringResponse) As %Status
{
	set tStatus = $$$OK
	
	try{
					
		set nbLignes = 0
		set pResponse = ##class(Ens.StringResponse).%New()
		
		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		//Pour les tests, on truncate les tables avant insertion
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"DROP TABLE IF EXISTS app.ODS_Products"))

		//Creer la table pour l'exemple
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"CREATE TABLE app.ODS_Products (id int8 NULL,productname varchar NULL,date_alimentation date NULL)"))		

		set SqlInsertView = "INSERT into app.ODS_Products (ID,ProductName,Date_Alimentation) values (?,?,TO_DATE(?,'yyyy-mm-dd hh24:mi:ss'))"

		$$$LOGINFO(SqlInsertView)
		
		set batch = ..batchSize
				
		set end =""
		set i=0
		k ^testBatch
		while i<..maxToInsert{
			
			set param = ""
			
			for k=1:1:..batchSize {
				
				set param(k,1) = i
				set param(k,1,"SqlType")=$$$SqlInteger

				set param(k,2) = ##class(%PopulateUtils).Name()
				set param(k,2,"SqlType")=$$$SqlVarchar
			
				set param(k,3) = $ZDATETIME($NOW(),3)
				set param(k,3,"SqlType")=$$$SqlVarchar

				set param(k) = 3

				set i = i + 1
				q:(i=..maxToInsert)
							
				}	
		     
			set param = k
			merge ^testBatch = param
			
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

Method INSERT(pRequest As Ens.StringRequest, Output pResponse As Ens.StringResponse) As %Status
{
	set sc = $$$OK
	
	try{
		set pResponse = ##class(Ens.StringResponse).%New()
		
		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		set insertQuery = "INSERT into "_ ..SCHEMA _".customer (id,first_name,last_name,city,category) values (?,?,?,?,?)"

		$$$LOGINFO(insertQuery_" batchSize:"_..batchSize)
				
		set nbInserted=0,inserts=0
		while inserts<..maxToInsert{
			
			set param = ""
			
			for i=1:1:..batchSize {
				
				set param(i,1) = $INCREMENT(^OriginID)
				set param(i,1,"SqlType")=$$$SqlInteger

				set param(i,2) = ##class(%PopulateUtils).FirstName()
				set param(i,2,"SqlType")=$$$SqlVarchar

				set param(i,3) = ##class(%PopulateUtils).LastName()
				set param(i,3,"SqlType")=$$$SqlVarchar

				set param(i,4) = ##class(%PopulateUtils).City()
				set param(i,4,"SqlType")=$$$SqlVarchar
			
				set param(i,5) = $RANDOM(5)+1
				set param(i,5,"SqlType")=$$$SqlInteger

				set param(i) = 5

				//do $INCREMENT(inserts)
				set inserts = inserts + 1
				q:(inserts=..maxToInsert)

			}	
		     
			set param = i
			$$$LOGINFO(param_" to insert "_param(1,1)_":"_param(1,2)_":"_param(1,3)_":"_param(1,4)_":"_param(1,5))
			merge ^DEBUG = param
			set sc = ..Adapter.ExecuteUpdateBatchParamArray(.nrows,insertQuery,.param)
			if sc {
				set nbInserted = nbInserted + nrows
			} else {
				$$$LOGWARNING("ERROR WHILE INSERTING : "_$system.Status.GetErrorText(sc))
			}

			k param

					
	}

	Set TimeStampEnd = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

	Set Delta = TimeStampEnd - TimeStampStart

	set pResponse.StringValue = nbInserted_" in "_Delta
		
	}
	catch exp
	{
		set sc = exp.AsStatus()
	}
	return sc
}

Method test(pRequest As JDBC.demo.msg.test, Output pResponse As Ens.StringResponse) As %Status
{
	set sc = $$$OK
	
	try{
		set pResponse = ##class(Ens.StringResponse).%New()
		
		set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		set query=""
		set query=query_"INSERT INTO "_ ..SCHEMA_".customer"
		set query=query_" (id,first_name,last_name,city,category) values (?,?,?,?,?)"
		set originID=pRequest.originID
		set firstName=pRequest.firstName
		set lastName=pRequest.lastName
		set city=pRequest.city
		set category=pRequest.category

		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,query,originID,firstName,lastName,city,category))
		$$$LOGINFO(nrows_" inserted")		
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
	<MapItem MessageType="JDBC.demo.msg.test"> 
		<Method>test</Method>
	</MapItem>
	<MapItem MessageType="JDBC.demo.msg.testBatch"> 
		<Method>testBatch</Method>
	</MapItem>
</MapItems>
}

}
