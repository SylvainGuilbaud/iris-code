Include utils

Class utils.functions
{

ClassMethod median(colname As %String = "age", tablename As %String = "sample.person") As %Numeric [ ExternalProcName = median, SqlProc ]
{
    set median=""
    $$$sql("select count(*) nb FROM "_tablename)
    set stmt=##class(%SQL.Statement).%New()
    set sc=stmt.%Prepare(.sql)
    set result=stmt.%Execute()
    do result.%Next()
    set nb = result.%Get("nb")
    if nb#2=0 ; even number of rows 
    { 
        set even=1
        set rowInTheMiddle=nb/2
    } else ; odd number of rows
    {
        set even=0
        set rowInTheMiddle=(nb+1)/2
    }
    kill sql
    $$$sql("select "_colname_" data FROM "_tablename_" ORDER BY "_colname)
    set sc=stmt.%Prepare(.sql)
    set result=stmt.%Execute()
    set row = 0
    do {
        do result.%Next()
        set row=row+1
    } while row < rowInTheMiddle
    if even {
        set firstValue=result.%Get("data")
        do result.%Next()
        set secondValue=result.%Get("data")
        set median=(firstValue+secondValue)/2
    }
    else {
        set median=result.%Get("data")
    }
	return median
}

ClassMethod test() As %Status
{
    set age=..median()
    write "median age for sample.person is :",age,!
    set status=..median("status","sqluser.person")
    write "median status for sqluser.person is :",status,!
    return $$$OK
}

}
