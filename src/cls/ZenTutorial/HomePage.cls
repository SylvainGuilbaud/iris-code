Class ZenTutorial.HomePage Extends %ZEN.Component.page
{

/// Class name of application this page belongs to.
Parameter APPLICATION = "ZenTutorial.Application";

/// Displayed name of this page.
Parameter PAGENAME = "HomePage";

/// Domain used for localization.
Parameter DOMAIN;

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
body {
	font-family: arial;
}

/* Style classes for use on this page */

/* Table Styeles */
table.tpTable caption{
		 
	background: transparent;
	font-size: 1.4em;
	font-weight: bold;
	text-align: left;
    border: none;
		
	}
	
	/*even rows*/
	.tpEven {
	color: black;
	background: #ebf3ff;
    }
    
    /*odd rows*/
   .tpOdd {
	color: black;
	background: white;
	}
	
	/* this is a selected row */
	table.tpTable tr.tpSelected {
	background: #3d80df;
	color: white;
	}
	
	tr.tpOdd:hover,tr.tpEven:hover {
	background-color: #3d80df;
	color: #ffffff;
	}
	

	/*table header style */
table.tpTable th {
	border-right: 1px solid gray;
	border-bottom: 1px solid gray;
	background: #C5D6D6;
	color: black;
	font-weight: bold;
	text-align: left;
	padding: 2px;
	overflow: hidden;
}

/* selected column header (th) */
table.tpTable th.tpHdrSelected {
	background: #3d80df;
}

table.tpFilterLayout td {
	border: none;
	background: #C5D6D6;
}

/*Caption and form border */
.fieldset{
	background: #FFFFFF;
	border: solid 5px #C5D6D6;
	color: #000000;
	font-size: 1em;
	font-family: arial;
		
}
/* text control styles */
.text
{
	font-size: .8em;
	font-family: arial;
    color: #000000;
    background-color: #ffffff;
    padding: 2px;
    border: solid 1px grey;
    margin-right: 0px;
    margin-bottom: 0px;
    height: 25px;
		
}	

/* datacombo styles */
.comboboxInput  {
    font-size: .8em;
    font-family: arial;
    color: #000000;  
    padding: 2px;
    border: solid 1px grey;
    margin-right: 0px;
    margin-bottom: 0px;
    height: 20px;
 }	
</style>
}

/// This XML block defines the contents of this page.
XData Contents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<page title="Zen Contacts" xmlns:zentutorial="http://www.intersystems.com/ZenTutorial" xmlns="http://www.intersystems.com/zen">
    <zentutorial:MenuComposite width="100%"/>
    
    <hgroup width="100%" >
    
        <vgroup width="5%">
        </vgroup>
        
        <vgroup width="90%">  
            <tableNavigator id="contactNav" tablePaneId="contactTable"/>
              <link align="left" caption="new contact" href="javascript:zenPage.newContact();"/>
            <hgroup>
                <!--Contacts Table -->

                
                <tablePane
                    width="900px"
                    id="contactTable" 
                    tableName="ZenTutorial.Contact"
                    maxRows="1000" 
                    pageSize="10" 
                    showRowNumbers="true"
                    showZebra="true" 
                    useSnapshot="true"
                    extraColumnWidth="5%"
                    onselectrow="zenPage.clearPhones();zenPage.hideContactForm();"
                    caption="US Contacts"
                    valueColumn="ID"
                    >
                   	
                    <column colName="ID" hidden="true"/>		 
                    <column header="Name" width="20%" colName="Name" filterType="text"/>
                    <column header="Type" width="9%" colName="ContactType"/>	
                    <column header="Street" width="20%" colName="Address1_Street"/>
                    <column header="City" width="12%" colName="Address1_City"/>		 
                    <column header="State" width="5%" colName="Address1_State"/>	
                    <column header="Zip" width="7%" colName="Address1_Zip"/>
                    <column header=""	width="5%" linkCaption="edit" link="javascript:zenPage.showContactForm('#(%query.ID)#');"/>		
                    <column header="" width="12%" linkCaption="view phones" link="javascript:zenPage.displayPhones('#(%query.ID)#', '#(%query.Name)#');"/>			
                </tablePane>
                <spacer width=".5em"/>
				
              <dataController id="contactData" 
               	modelClass="ZenTutorial.ContactModel"
               	 modelId="" />
                <fieldSet id="contactFormGroup" hidden="true" legend="Edit Contact">
                <form id="contactForm" controllerId="contactData" 
                layout="vertical"
                          cellStyle="padding: 2px; padding-left: 5px; padding-right: 5px;">
  					<text label="Name" dataBinding="Name" required="true" size="25" />
  					 <spacer height=".5"/>
  					 <dataCombo label="Type" name="ContactType" id="ContactType" size="25"
                                       dropdownHeight="150px"
                                       editable="false"
                                       unrestricted="true"
                  					   dataBinding="ContactType" />                                 
        			<spacer height=".5"/>
  					<text label="Street" dataBinding = "Street" size="25"/>
  					<spacer height=".5"/>
  					<text label="City" dataBinding = "City" size="25"/>
  					<spacer height=".5"/>
  					<hgroup>
  					<text label="State" dataBinding = "State" required="true" onvalidate="return zenPage.validateState(zenThis);" invalidMessage="State must contain 2 capital letters" size="2"/>
  					<spacer width="5"/>
  					<text label="Zip" dataBinding = "Zip" required="true" onvalidate="return zenPage.validateZip(zenThis);" invalidMessage="Zip must be 5 digits" size="10"/>
  					</hgroup>
  					<spacer height=".5"/>
  					<hgroup>
  					<button caption="Save" onclick="zenPage.saveContact();" />
  					<spacer width="5"/>
  					<button caption="Delete" onclick="zenPage.deleteContact();" />		
					</hgroup>
				</form>
				</fieldSet>
            </hgroup>
            
            <spacer  height="2"/>
   	
   			<vgroup hidden="true" id="phoneDisplay">
   			 <link  caption="new phone" align="left" href="javascript:zenPage.newPhone();"/>
            <hgroup>
                <!-- Phone Table -->
                <tablePane
                    width="300px"
                    id="phoneTable"
                    enclosingClass="FormGroup"
                    hidden="false"
                    maxRows="1000"  
                    showRowNumbers="true" 
                    showZebra="true" 
                    useSnapshot="false"	
                    caption=""	
                    sql="SELECT ID,Number, PhoneNumberType From ZenTutorial.PhoneNumber Where Contact=?"		
                    extraColumnWidth="10"
                    onselectrow="zenPage.hidePhoneForm();"         
                >
                    <parameter value="0" />
                    <column colName="ID" hidden="true"/>
                    <column colName="Number" width="55" />
                    <column header="Type" width="35" colName="PhoneNumberType"/>
                    <column header=""	width="15" linkCaption="edit" link="javascript:zenPage.showPhoneForm('#(%query.ID)#');"/>		
                </tablePane>
           
                <!--Phone Form -->
                <dataController id="phoneData" 
               	modelClass="ZenTutorial.PhoneNumberModel"
               	 modelId=""/>
                <fieldSet id="phoneFormGroup" 
                          enclosingClass="FormGroup" hidden="true"  legend="Edit Phone Number">   
                     <form id="phoneForm" controllerId="phoneData" >
  					<text id = "txtNumber" label="Number" dataBinding="Number" required="true" onvalidate="return zenPage.validatePhoneNumber(zenThis);"  invalidMessage="Number must be 'nnn-nnn-nnnn'" />
  					  <spacer height=".5"/>
  					  <dataCombo label="Type:" name="PhoneNumberType" id="PhoneNumberType" size="25"
                                       dropdownHeight="150px"
                                       editable="false"
                                       unrestricted="true"
                  					   dataBinding="PhoneNumberType" />                                 
        
  					<spacer height=".5"/>
  						<hgroup>
  					<button caption="Save" onclick="zenPage.savePhone();" />
  					<button caption="Delete" onclick="zenPage.deletePhone();"/>	
  					<spacer width="5"/>	
  							
					</hgroup>
				</form>
                     
                </fieldSet>	
            </hgroup>
            </vgroup>
        </vgroup> 
        <vgroup width="5%">
        </vgroup>
    </hgroup>
</page>
}

ClientMethod showContactForm(id) [ Language = javascript ]
{
	
	var controller = zenPage.getComponentById('contactData');
	controller.setProperty('modelId',id);
	var contactFormGroup=zenPage.getComponentById("contactFormGroup");
	contactFormGroup.setProperty('hidden',false);
}

ClientMethod showPhoneForm(id) [ Language = javascript ]
{
	
	var controller = zenPage.getComponentById('phoneData');
	controller.setProperty('modelId',id);
	var phoneFormGroup=zenPage.getComponentById('phoneFormGroup');	
	phoneFormGroup.setHidden(false);
	var phoneDisplay=zenPage.getComponentById('phoneDisplay');
	phoneDisplay.setHidden(false);
}

ClientMethod validateState(comp) [ Language = javascript ]
{
	
	//State value must be exactly two capital letters
	return (/^[A-Z]{2}$/.test(comp.getValue()));
}

ClientMethod validateZip(comp) [ Language = javascript ]
{
	//Zip value must be exactly 5 digits
	return (/^\d{5}$/.test(comp.getValue()));
}

/// displayPhones
ClientMethod displayPhones(id, name) [ Language = javascript ]
{
	
	var phoneDisplay=zenPage.getComponentById('phoneDisplay');	
	var phoneTable=zenPage.getComponentById('phoneTable');
	phoneTable.setProperty('parameters',1, id);
	phoneTable.setHidden(false);
	phoneDisplay.setProperty('hidden',false);
}

ClientMethod validatePhoneNumber(comp) [ Language = javascript ]
{
	//Phone number must be nnn-nnn-nnnn
	return (/^\d{3}-\d{3}-\d{4}$/.test(comp.getValue()));
}

ClientMethod hideContactForm() [ Language = javascript ]
{
	var contactForm=zenPage.getComponentById('contactForm');
	contactForm.reset();
	var contactFormGroup=zenPage.getComponentById('contactFormGroup');
	contactFormGroup.setHidden(true);
}

ClientMethod hidePhoneForm() [ Language = javascript ]
{
	var phoneForm=zenPage.getComponentById('phoneForm');
	phoneForm.reset();
	var phoneFormGroup=zenPage.getComponentById('phoneFormGroup');
	phoneFormGroup.setHidden(true);
}

ClientMethod clearPhones() [ Language = javascript ]
{
	var phoneTable=zenPage.getComponentById("phoneTable");
	var phoneDisplay=zenPage.getComponentById("phoneDisplay");
	if (phoneTable !=null)
	{
		phoneTable.setHidden(true);
		phoneDisplay.setProperty('hidden',true);
		
				
	}
	this.hidePhoneForm();
}

/// save contact model to database
ClientMethod saveContact() [ Language = javascript ]
{
	// validate and save form
	var form = zenPage.getComponentById('contactForm');
	var id = form.save();
	var table=zenPage.getComponentById('contactTable');
	//refresh data in contact table
	table.executeQuery();
}

/// save phone model to database
ClientMethod savePhone() [ Language = javascript ]
{
	// validate and save form
	var form = zenPage.getComponentById('phoneForm');
	form.save();
	var table=zenPage.getComponentById('phoneTable');
	//refresh data in phone table
	table.executeQuery();
}

/// Delete current item from database
ClientMethod deleteContact() [ Language = javascript ]
{
	var controller = zenPage.getComponentById('contactData');
	controller.deleteId(controller.getModelId());

	var table = zenPage.getComponentById('contactTable');
	table.executeQuery(true);
	controller.update();
	zenPage.clearPhones();
}

/// Create new object via dataModel
ClientMethod newContact() [ Language = javascript ]
{
	var controller = zenPage.getComponentById('contactData');
	var contactFormGroup=zenPage.getComponentById("contactFormGroup");
	contactFormGroup.setProperty('hidden',false);
	controller.createNewObject();
	zenPage.clearPhones();
}

/// Delete current item from database
ClientMethod deletePhone() [ Language = javascript ]
{
	
	var controller = zenPage.getComponentById('phoneData');
	controller.deleteId(controller.getModelId());
	
	var table = zenPage.getComponentById('phoneTable');
	table.executeQuery(true);
	controller.update();
	zenPage.hidePhoneForm();
}

/// Create new object via dataModel
ClientMethod newPhone() [ Language = javascript ]
{
	
	var table=zenPage.getComponentById('contactTable');
	var id = table.getProperty('value');
	zenPage.showPhoneForm();
	var controller = zenPage.getComponentById('phoneData');
	controller.createNewObject();
	controller.setDataByName("ContactID",id);
}

}
