Include utils

/// 
/// Author:sylvain.guilbaud@intersystems.com
/// 
Class utils.functions
{

ClassMethod getClassName(schema As %String = "", tablename As %String = "", ByRef sc As %Status, verbose As %Boolean = 1) As %String [ SqlProc ]
{
    Try {
        set ClassName=""
        set:schema="" schema=$SYSTEM.SQL.Schema.Default()
        set schema=$ZCVT(schema,"L")
        set tablename = $ZCVT(tablename,"L")
        if tablename'="" {
            set sql($i(sql))="SELECT"
            set sql($i(sql))="ID"
            set sql($i(sql))=",SqlSchemaName"
            set sql($i(sql))=",SqlTableName"
            set sql($i(sql))="FROM %Dictionary.CompiledClass"
            set sql($i(sql))="where LCASE(SqlSchemaName) = ? and LCASE(SqlTableName) = ?"
            set result=##class(%SQL.Statement).%ExecDirect(,.sql,schema,tablename)
            if result.%SQLCODE=0 {
                do result.%Next()
                if result.%SQLCODE=0 {
                    set ClassName = result.%Get("ID")
                    set SqlSchemaName = result.%Get("SqlSchemaName")
                    set SqlTableName = result.%Get("SqlTableName")
                    write:verbose ClassName, " is the ClassName for table ",SqlTableName," in schema ",SqlSchemaName,!
                } else {
                    write:verbose "No ClassName found for table ",tablename," in schema ",schema," (SQLCODE:",result.%SQLCODE,")",!
                }
            } 
        } else {
            set sc=$system.Status.Error("5001","tablename is required")
        }
    } catch ex {
        set sc=ex.AsStatus()
    }
    return ClassName
}

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
