/// This is a very simple example for settign up Row Level Security.
/// 
/// By changing the parameter ROWLEVELSECURITY to 1 RLS is turned on.  
/// 
/// A computed Hidden field called %ReaderList is create.
/// 
/// The computed field uses the Method %SecurityPolicy to be populated
/// 
/// A bit map index, %RLS is created mapping the Elements of %ReaderList
/// 
/// Using %Populate here is what the data looks like
/// 
/// ^SQLStorageD=10
/// ^SQLStorageD(1)="Doctor,Unit4^Van De Griek,Kyra H.^4)
///                                  2)="Doctor,Unit9^Goncharuk,Samantha Q.^9")
///                                  3)="Doctor,Unit6^Gallant,Mark B.^6")
///                                  4)="Doctor,Unit8^Adam,Ralph F.^8")
///                                  5)="Doctor,Unit2^Waterman,Barbara Z.^2")
///                                  6)="Doctor,Unit5^Long,Mark O.",5")
///                                  7)="Doctor,Unit10^Van De Griek,Roberta U.^10")
///                                  8)="Doctor,Unit5^Braam,Will H.^5")
///                                  9)="Doctor,Unit4^Xerxes,Josephine T.^4")
///                                 10)="Doctor,Unit4^Frith,Alexandra J.^4")
///  
/// Array: ^SQLStorageI
/// ^SQLStorageI("$Extent",1)=$c(157,1,2,0,0,0)/*$bit(01111111111)*/
/// ^SQLStorageI("%RLI"," DOCTOR",1)=$c(157,1,2,0,0,0)/*$bit(01111111111)*/
/// ^SQLStorageI("%RLI"," UNIT10",1)=$c(144,1,1,0,7,0)/*$bit(00000001)*/
/// ^SQLStorageI("%RLI"," UNIT2",1)=$c(146,1,1,0,5,0)/*$bit(000001)*/
/// ^SQLStorageI("%RLI"," UNIT4",1)=$c(149,1,2,0,1,0,9,0,10,0)/*$bit(01000000011)*/
/// ^SQLStorageI("%RLI"," UNIT5",1)=$c(151,1,2,0,6,0,8,0)/*$bit(000000101)*/
/// ^SQLStorageI("%RLI"," UNIT6",1)=$c(148,1,1,0,3,0)/*$bit(0001)*/
/// ^SQLStorageI("%RLI"," UNIT8",1)=$c(147,1,1,0,4,0)/*$bit(00001)*/
/// ^SQLStorageI("%RLI"," UNIT9",1)=$c(149,1,1,0,2,0)/*$bit(001)
/// */
Class Mapping.RowLevelSecurity Extends (%Persistent, %Populate) [ Inheritance = right, StorageStrategy = NewStorage1 ]
{

Property Name As %Name;

Property UnitNumber As %Integer(MAXVAL = 10, MINVAL = 1);

Property Id As %Integer;

/// ROWLEVELSECURITY = 1 | <property> means that row level security is active and the list
/// of users/roles for a given instance/row is contained in a generated property. If
/// the value of this parameter is a valid property name then that property will be
/// used as the reader list and only generated if not already defined.
Parameter ROWLEVELSECURITY = "ReaderList";

/// Doctors get to see all the Patients, so the Doctor role is added to every row
/// Nurses can only see Patients that are in the Unit they work, so a Role Based on UnitNumbber is also assigned
ClassMethod %SecurityPolicy(UnitNumber As %Integer) As %String [ SqlName = SQLSecurityPolicy, SqlProc ]
{
	
    QUIT "Doctor,Unit"_UnitNumber
}

Index Master On Id [ IdKey, Unique ];

Property ReaderList As %String(MAXLEN = 500) [ Private, SqlComputeCode = { s {*}=##class(RowLevelSecurity.SQLStorage).%SecurityPolicy({UnitNumber})}, SqlComputed ];

Storage NewStorage1
{
<SQLMap name="%RLI">
<Global>^SQLStorageI</Global>
<Subscript name="1">
<Expression>"%RLI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ReaderList(KEYS)}</Expression>
</Subscript>
<Type>bitmap</Type>
</SQLMap>
<SQLMap name="Extent">
<Global>^SQLStorageI</Global>
<Subscript name="1">
<Expression>"Extent"</Expression>
</Subscript>
<Type>bitmapextent</Type>
</SQLMap>
<SQLMap name="Map1">
<Data name="Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ReaderList">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="UnitNumber">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^SQLStorageD</Global>
<Subscript name="1">
<Expression>{Id}</Expression>
<StartValue>1</StartValue>
<StopValue>9999999999</StopValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^RowLevelSecurity.SQLStorageS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
