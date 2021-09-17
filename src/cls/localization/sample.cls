Include %occMessages

Class localization.sample
{

ClassMethod init() As %Status
{
    w $$$Text("OK ?","app")
    w $$$Text("Yes","app")
    w $$$Text("No","app")
    w $$$Text("Please confirm","app")
    w $$$Text("Press ENTER to confirm","app")

    zw ^IRIS.Msg("app","en")
 
    return $$$OK
}

ClassMethod translate(language As %String = "fr") As %Status
{
    set ^IRIS.Msg("app",language,1303016265)="Oui"
    set ^IRIS.Msg("app",language,2735826691)="Veuillez confirmer SVP"
    set ^IRIS.Msg("app",language,1823235743)="Veuillez Confirmer SVP"
    set ^IRIS.Msg("app",language,3172924617)="D'accord ?"
    set ^IRIS.Msg("app",language,4063104189)="Non"
    set ^IRIS.Msg("app",language,4177907702)="Appuyez sur ENTRÉE pour confirmer"

    zw ^IRIS.Msg("app",language)
    return $$$OK
}

ClassMethod show(language As %String = "fr") As %Status
{
    write $$$Text("Yes","app",language),!
    write $$$Text("No","app",language),!
    write $$$Text("OK ?","app",language),!
    write $$$Text("Please Confirm","app",language),!
    write $$$Text("Please confirm","app",language),!
    write $$$Text("Press ENTER to confirm","app",language),!
    write !
    return $$$OK
}

}
