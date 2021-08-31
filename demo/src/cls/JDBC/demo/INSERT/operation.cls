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
					
		set nbInserted = 0
		set pResponse = ##class(Ens.StringResponse).%New()
		
		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())

		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"DROP TABLE IF EXISTS app.ODS_Products"))

		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"CREATE TABLE app.ODS_Products (id int8 NULL,productname varchar NULL,date_alimentation timestamp NULL)"))		

		set insertQuery = "INSERT into app.ODS_Products (ID,ProductName,Date_Alimentation) values (?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS'))"

		$$$TRACE(insertQuery)
		
		set batch = ..batchSize
				
		set end =""
		set i=0
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
		Set tStatus = exp.AsStatus()
	}

	Quit tStatus
}

Method INSERT(pRequest As JDBC.demo.msg.init, Output pResponse As Ens.StringResponse) As %Status
{
	set sc = $$$OK
	
	try{
		set pResponse = ##class(Ens.StringResponse).%New()
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"TRUNCATE "_ ..SCHEMA _".customer"))

		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())
		
		set insertQuery = "INSERT into "_ ..SCHEMA _".customer (id,first_name,last_name,city,category,active,created) values (?,?,?,?,?,?,?)"

		$$$TRACE(insertQuery_" batchSize:"_..batchSize)
				
		set nbInserted=0,inserts=0
		while inserts<..maxToInsert{
			
			set param = ""
			
			for i=1:1:..batchSize {
				
				do $INCREMENT(inserts)

				set columnNumber=0

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = inserts
				set param(i,columnNumber,"SqlType")=$$$SqlInteger

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = ##class(%PopulateUtils).FirstName()
				set param(i,columnNumber,"SqlType")=$$$SqlVarchar

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = ##class(%PopulateUtils).LastName()
				set param(i,columnNumber,"SqlType")=$$$SqlVarchar

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = ##class(%PopulateUtils).City()
				set param(i,columnNumber,"SqlType")=$$$SqlVarchar
			
				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = $RANDOM(5)+1
				set param(i,columnNumber,"SqlType")=$$$SqlInteger

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = $RANDOM(2)
				set param(i,columnNumber,"SqlType")=$$$SqlBit

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = $zdt($h-$RANDOM(1000)_","_$random(86400),3)
				set param(i,columnNumber,"SqlType")=$$$SqlTypeTimestamp

				set param(i) = columnNumber

				q:(inserts=..maxToInsert)

			}	
		     
			set param = i
			set sc = ..Adapter.ExecuteUpdateBatchParamArray(.nrows,insertQuery,.param)
			if sc {
				set nbInserted = nbInserted + nrows
			} else {
				$$$LOGWARNING("ERROR WHILE INSERTING : "_$system.Status.GetErrorText(sc))
			}

			kill param		
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

Method customers(pRequest As data.RM.customer.Batch, Output pResponse As Ens.StringResponse) As %Status
{
	set sc = $$$OK
	
	try{
		set pResponse = ##class(Ens.StringResponse).%New()
		#; $$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"TRUNCATE "_ ..SCHEMA _".customer"))

		set nbInserted=0
		for i=1:1:pRequest.Records.Count() {
			set customer = ##class(JDBC.demo.msg.customerRequest).%New()
			set customer.id = pRequest.Records.GetAt(i).id
			set customer.active	 = pRequest.Records.GetAt(i).active
			set customer.category	 = pRequest.Records.GetAt(i).category
			set customer.city	= pRequest.Records.GetAt(i).city
			set customer.created	= pRequest.Records.GetAt(i).created
			set customer.firstName	= pRequest.Records.GetAt(i).firstName
			set customer.lastName	= pRequest.Records.GetAt(i).lastName
			set sc = ..customer(customer)
			if sc {
				do $INCREMENT(nbInserted) 
			} else {
				$$$LOGERROR("ERROR WHILE INSERTING CUSTOMER "_$system.Status.GetErrorText(sc))
			}	
		} 

	set pResponse.StringValue = nbInserted
		
	}
	catch exp
	{
		set sc = exp.AsStatus()
	}
	return sc
}

Method customer(pRequest As JDBC.demo.msg.customerRequest, Output pResponse As JDBC.demo.msg.customerResponse) As %Status
{
	set sc = $$$OK
	
	try{
		set pResponse = ##class(JDBC.demo.msg.customerResponse).%New()
		
		set insertQuery = ""
		set insertQuery = insertQuery_"INSERT into "_ ..SCHEMA _".customer "
		set insertQuery = insertQuery_" ("
		set insertQuery = insertQuery_" id"
		set insertQuery = insertQuery_" ,active"
		set insertQuery = insertQuery_" ,category"
		set insertQuery = insertQuery_" ,city"
		set insertQuery = insertQuery_" ,created"
		set insertQuery = insertQuery_" ,first_name"
		set insertQuery = insertQuery_" ,last_name) " 
		set insertQuery = insertQuery_" values ("
		set insertQuery = insertQuery_"  ?"
		set insertQuery = insertQuery_" ,?"
		set insertQuery = insertQuery_" ,?"
		set insertQuery = insertQuery_" ,?"
		set insertQuery = insertQuery_" ,?"
		set insertQuery = insertQuery_" ,?"
		set insertQuery = insertQuery_" ,?"
		set insertQuery = insertQuery_" )"

		set updateQuery = ""
		set updateQuery = updateQuery_"UPDATE "_ ..SCHEMA _".customer "
		set updateQuery = updateQuery_" SET "
		set updateQuery = updateQuery_"  active = ?"
		set updateQuery = updateQuery_" ,category = ?"
		set updateQuery = updateQuery_" ,city = ?"
		set updateQuery = updateQuery_" ,created = ?"
		set updateQuery = updateQuery_" ,first_name = ?"
		set updateQuery = updateQuery_" ,last_name = ? " 
		set updateQuery = updateQuery_" WHERE "
		set updateQuery = updateQuery_"  id = "_pRequest.id

		$$$TRACE(insertQuery)
		$$$TRACE(updateQuery)
		#; id,active,category,city,created,firstName,lastName
		set id=pRequest.id
		set active=pRequest.active
		set category=pRequest.category
		set city=pRequest.city
		set created=pRequest.created
		set firstName=pRequest.firstName
		set lastName=pRequest.lastName

		if ..customerExists(pRequest.id) {
			$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,updateQuery,active,category,city,created,firstName,lastName))		
		} else {
			$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,insertQuery,id,active,category,city,created,firstName,lastName))
		}
		if sc {
			$$$TRACE(nrows_" inserted")
			set pResponse.result=nrows_" successfully inserted"
		} else {
			set pResponse.result="ERROR WHILE INSERTING "_$system.Status.GetErrorText(sc)
		}
	}
	catch exp
	{
		set sc = exp.AsStatus()
	}
	return sc
}

Method customerExists(id As %Integer) As %Boolean
{
	set sc = $$$OK
	
	try{
		set query = "",exist=0
		set query = query_"SELECT 1 FROM "_ ..SCHEMA_".customer"
		set query = query_" WHERE id = ?"
		$$$TRACE(query)

		$$$ThrowOnError(..Adapter.ExecuteQuery(.rs,query,id))

		if rs.%Next() {
			set exist = rs.%GetData(1)
			$$$LOGINFO(id_" already exists:" _ exist)
		} else {
			$$$LOGINFO("NO DATA FOUND FOR ID "_id)
		}
	}
	catch exp
	{
		set sc = exp.AsStatus()
	}
	return exist
}

Method customersBatch(pRequest As data.RM.customer.Batch, Output pResponse As Ens.StringResponse) As %Status
{
	set sc = $$$OK
	
	try{
		set pResponse = ##class(Ens.StringResponse).%New()
		$$$ThrowOnError(..Adapter.ExecuteUpdate(.nrows,"TRUNCATE "_ ..SCHEMA _".customer"))

		Set TimeStampStart = ##class(%Library.PosixTime).LogicalToUnixTime(##class(%Library.PosixTime).CurrentTimeStamp())
		
		set insertQuery = ""
		set insertQuery = insertQuery_"INSERT into "_ ..SCHEMA _".customer "
		#; set insertQuery = insertQuery_" (id,active,category,city,created,first_name,last_name) " 
		#; set insertQuery = insertQuery_" values (?,?,?,?,?,?,?)"
		#; set insertQuery = insertQuery_" (id,active,category,city,first_name,last_name) " 
		#; set insertQuery = insertQuery_" values (?,?,?,?,?,?)"
		set insertQuery = insertQuery_" (id,category,city,first_name,last_name) " 
		set insertQuery = insertQuery_" values (?,?,?,?,?)"
		$$$TRACE(insertQuery_" batchSize:"_..batchSize)
				
		set nbInserted=0,inserts=1
		do {
			set param = ""
			set columnNumber = 0
			for i=1:1:..batchSize {

				do $INCREMENT(inserts)
				q:(inserts>pRequest.Records.Count())

				#; ID,active,category,city,created,firstName,lastName
				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = pRequest.Records.GetAt(inserts).ID
				set param(i,columnNumber,"SqlType")=$$$SqlInteger

				#; do $INCREMENT(columnNumber)
				#; set param(i,columnNumber) = pRequest.Records.GetAt(inserts).active
				#; set param(i,columnNumber,"SqlType")=$$$SqlBit

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = pRequest.Records.GetAt(inserts).category
				set param(i,columnNumber,"SqlType")=$$$SqlInteger

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = pRequest.Records.GetAt(inserts).city
				set param(i,columnNumber,"SqlType")=$$$SqlVarchar

				#; do $INCREMENT(columnNumber)
				#; set param(i,columnNumber) = pRequest.Records.GetAt(inserts).created
				#; set param(i,columnNumber,"SqlType")=$$$SqlTypeTimestamp
			
				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = pRequest.Records.GetAt(inserts).firstName
				set param(i,columnNumber,"SqlType")=$$$SqlVarchar

				do $INCREMENT(columnNumber)
				set param(i,columnNumber) = pRequest.Records.GetAt(inserts).lastName
				set param(i,columnNumber,"SqlType")=$$$SqlVarchar

				set param(i) = columnNumber
			}	
		     
			set param = i
			kill ^DEBUG
			merge ^DEBUG("params")=param
			set sc = ..Adapter.ExecuteUpdateBatchParamArray(.nrows,insertQuery,.param)
			if sc {
				set nbInserted = nbInserted + nrows
			} else {
				$$$LOGWARNING("ERROR WHILE INSERTING : "_$system.Status.GetErrorText(sc))
			}

			kill param		
		} while inserts<pRequest.Records.Count()

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

XData MessageMap
{
<MapItems>
	<MapItem MessageType="JDBC.demo.msg.init"> 
		<Method>INSERT</Method>
	</MapItem>
	<MapItem MessageType="JDBC.demo.msg.testBatch"> 
		<Method>testBatch</Method>
	</MapItem>
	<MapItem MessageType="data.RM.customer.Batch"> 
		<Method>customers</Method>
	</MapItem>
	<MapItem MessageType="JDBC.demo.msg.customerRequest"> 
		<Method>customer</Method>
	</MapItem>
</MapItems>
}

}
