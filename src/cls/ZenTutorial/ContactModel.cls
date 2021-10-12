Class ZenTutorial.ContactModel Extends %ZEN.DataModel.ObjectDataModel
{

Property Name As %String;

Property ContactType As %String(ZENSQL = "SELECT DISTINCT %EXACT ContactType from ZenTutorial.Contact");

Property Street As %String;

Property City As %String;

Property State As %String;

Property Zip As %String;

/// Load an instance of the source object for this DataModel.
Method %OnOpenSource(pID As %String) As %RegisteredObject
{
    	Set pStatus = $$$OK
    	Quit ##class(ZenTutorial.Contact).%OpenId(pID)
}

/// This callback method does the actual work of loading values 
/// from the source object.
Method %OnLoadModel(pSource As ZenTutorial.Contact) As %Status
{
    Set ..Name = pSource.Name
    Set ..ContactType = pSource.ContactType
    Set ..Street = pSource.Address1.Street
    Set ..City = pSource.Address1.City
    Set ..State = pSource.Address1.State
    Set ..Zip = pSource.Address1.Zip
    
    Quit $$$OK
}

/// Load an instance of the source object for this DataModel.
Method %OnSaveSource(pSource As ZenTutorial.Contact) As %Status
{
	Set tSC = pSource.%Save()
	Set ..%id = pSource.%Id()
	Quit tSC
}

/// This callback method does the actual work of storing values into
/// the source object.
Method %OnStoreModel(pSource As ZenTutorial.Contact) As %Status
{
    Set pSource.Name = ..Name
    Set pSource.ContactType = ..ContactType
    Set pSource.Address1.Street = ..Street
    Set pSource.Address1.City = ..City
    Set pSource.Address1.State = ..State
    Set pSource.Address1.Zip = ..Zip
    
    Quit pSource.%Save()
}

/// Delete instance of associated source object.
ClassMethod %OnDeleteSource(pID As %String) As %Status
{
	Quit ##class(ZenTutorial.Contact).%DeleteId(pID)
}

/// Load an instance of a new (unsaved) source object for this DataModel.
Method %OnNewSource(Output pSC As %Status = {$$$OK}) As %RegisteredObject
{
	Quit ##class(ZenTutorial.Contact).%New()
}

}
