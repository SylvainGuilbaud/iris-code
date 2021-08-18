Include utils

/// 
/// Author:sylvain.guilbaud@intersystems.com
/// 
Class utils.functions
{

ClassMethod median(colname As %String = "age", tablename As %String = "sample.person") As %Numeric [ ExternalProcName = median, SqlProc ]
{
    Try {
    set median="",sc=$$$OK
    $$$sql("SELECT count("_colname_") nb")
    $$$sql("FROM "_tablename)
    set result=##class(%SQL.Statement).%ExecDirect(,.sql)
    if result.%SQLCODE=0 {
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
        $$$sql("SELECT "_colname_" data ")
        $$$sql("FROM "_tablename)
        $$$sql("WHERE "_colname_" IS NOT NULL")
        $$$sql("ORDER BY "_colname)
        set result=##class(%SQL.Statement).%ExecDirect(,.sql)
        if result.%SQLCODE=0 {
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
        }
    }
    }
    Catch ex {
        Set sc=ex.AsStatus()
    }
	return median
}

ClassMethod test() As %Status
{
    set age=..median()
    write "median age for sample.person is :",age,!
    do ##class(Sample.Person).Populate(1)
    set age=..median()
    write "after 1 new person:",!
    write "median age for sample.person is :",age,!
    do ##class(Sample.Employee).Populate(2)
    set salary=..median("salary","sample.employee")
    write "median salary for sample.employee is :",salary,!
    do ##class(Sample.Employee).Populate(1)
    set salary=..median("salary","sample.employee")
    write "after 1 new employees:",!
    write "median salary for sample.employee is :",salary,!
    return $$$OK
}

}
