Class doc.command
{

ClassMethod order() As %Status
{
    set sc=$$$OK
    set key=""
    do {
        set key=$ORDER(^data.testD(key),1,data)
        zwrite key,data
        write !
    } while key'=""     
    return sc
}

ClassMethod query(globalName As %String) As %Status
{
    set sc=$$$OK
    if globalName="" {
        set sc=$system.Status.Error(5001,"globalName is required")
    } else {
        set key=$QUERY(@globalName@(""),1,data)
        do {
            #; write key,":",!
            zwrite key,data
            write !
            set key=$QUERY(@key,1,data)
        } while key'=""
        
    }
    return sc
}

}
