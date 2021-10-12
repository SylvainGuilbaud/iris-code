Class ZenTutorial.PhoneNumberModel Extends %ZEN.DataModel.ObjectDataModel
{

Property ContactID As %String;

Property Number As %String;

Property PhoneNumberType As %String(ZENSQL = "SELECT DISTINCT %EXACT PhoneNumberType from ZenTutorial.PhoneNumber ORDER By PhoneNumberType");

Method %OnOpenSource(pID As %String) As %RegisteredObject
{
    	//Set pStatus = $$$OK
    	Quit ##class(ZenTutorial.PhoneNumber).%OpenId(pID)
}

/// This callback method does the actual work of loading values 
/// from the source object.
Method %OnLoadModel(pSource As ZenTutorial.PhoneNumber) As %Status
{
    Set ..Number = pSource.Number
    Set ..PhoneNumberType = pSource.PhoneNumberType
    
    if (pSource.Contact '="")
    {    
	    Set ..ContactID = pSource.Contact.%Id()	    
    
    }
    
    Quit $$$OK
}

/// This callback method does the actual work of storing values into
/// the source object.
Method %OnStoreModel(pSource As ZenTutorial.PhoneNumber) As %Status
{
    Set pSource.Number = ..Number
    Set pSource.PhoneNumberType = ..PhoneNumberType
    
    if (pSource.%Id()="")
    {
	    Set contact = ##class(ZenTutorial.Contact).%OpenId(..ContactID)
	    Set pSource.Contact=contact
	    Do contact.%Save()
	    
    }
    
    Quit pSource.%Save()
}

/// Load an instance of a new (unsaved) source object for this DataModel.
Method %OnNewSource(Output pSC As %Status = {$$$OK}) As %RegisteredObject
{
	Quit ##class(ZenTutorial.PhoneNumber).%New()
}

/// Delete instance of associated source object.
ClassMethod %OnDeleteSource(pID As %String) As %Status
{
	Quit ##class(ZenTutorial.PhoneNumber).%DeleteId(pID)
}

}
