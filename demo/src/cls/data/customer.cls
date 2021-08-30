Class data.customer Extends %Persistent
{

Property firstName As %String(MAXLEN="");
Property lastName As %String(MAXLEN="");
Property city As %String(MAXLEN="");
Property category As %Integer(VALUELIST=",1,2,3,4,5",DISPLAYLIST=",diamond,platinum,gold,silver,bronze");
Property active as %Boolean[InitialExpression=1];
Property created As %TimeStamp[InitialExpression={$zdt($h,3)}];

Index firstNameIdx On firstName [ Type=index ];
Index lastNameIdx On lastName [ Type=index ];
Index categoryIdx On category [ Type=bitmap ];
Index cityIdx On city [ Type=bitmap ];
Index activeIdx On active [ Type=bitmap ];
Index createdIdx On created [ Type=index ];

}
