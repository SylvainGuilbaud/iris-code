Include %occMessages

Class User.a
{

ClassMethod getMsg(msg As %String) As %Status
{
    write $$$Text("Yes","app","fr"),!
    write $$$Text("No","app","fr"),!
    write $$$Text("OK ?","app","fr"),!
    write $$$Text("Please confirm","app","fr"),!
    write $$$Text("Press ENTER to confirm","app","fr"),!
    write !
    return $$$OK
}

ClassMethod init() As %Status
{
    w $$$Text("OK ?","app")
    w $$$Text("Yes","app")
    w $$$Text("No","app")
    w $$$Text("Please confirm","app")
    w $$$Text("Press ENTER to confirm","app")
    set ^IRIS.Msg("app","fr",1303016265)="Oui"
    set ^IRIS.Msg("app","fr",2735826691)="Veuillez confirmer SVP"
    set ^IRIS.Msg("app","fr",3172924617)="D'accord ?"
    set ^IRIS.Msg("app","fr",4063104189)="Non"
    set ^IRIS.Msg("app","fr",4177907702)="Appuyez sur ENTRÉE pour confirmer"
    return $$$OK
}

}
