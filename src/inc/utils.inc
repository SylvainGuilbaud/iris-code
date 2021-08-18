ROUTINE utils [Type=INC]
#define replaceSchema(%Arg) set %Arg=$replace($replace($replace(%Arg,"public.","lims."),$c(34),$c(34)_$c(34)),";","")
#define code(%Arg) do code.WriteLine(%Arg)
#define sql(%Arg) set sql($i(sql))=%Arg
#define addSchema(%Arg) set %Arg=$replace( ##Continue
                                 $replace( ##Continue
								 $replace( ##Continue
								 $replace( ##Continue
                                 $replace( ##Continue
								 $replace( ##Continue
                                 $replace( ##Continue
								 $replace( ##Continue
								 $replace( ##Continue
								 $replace( ##Continue
                                 $replace( ##Continue
								 $replace( ##Continue
								 $replace(%Arg,"From","from") ##Continue
								 ,"Join","join") ##Continue
								 ,"FROM","from") ##Continue
								 ,"JOIN","join") ##Continue
								 ,"from ","from "_..schema_".") ##Continue
							,"join ","join "_..schema_".") ##Continue
							,"from "_..schema_".dual","from dual") ##Continue
							,"join "_..schema_".(","join (") ##Continue
							,"sysdate - 1","sysdate - ?") ##Continue
							,..schema_"."_..schema,..schema) ##Continue
							,"from "_..schema_".(","from (") ##Continue
							,..schema_".DATA ","DATA ") ##Continue
							,";","")

#define showSQL set i="" ##Continue
	do { ##Continue
		set i=$order(sql(i),1,line) ##Continue
		quit:i="" ##Continue
        $$$TRACE(i_":"_line) ##Continue
	} while i'="" 

#define addMapItem 	do messageMap.Data.WriteLine("  <MapItem MessageType='"_..#PACKAGE_"."_package_".msg."_methodName_"'>") ##Continue
                    do messageMap.Data.WriteLine("      <Method>"_methodName_"</Method>") ##Continue
                    do messageMap.Data.WriteLine("  </MapItem>")
#define COUNTACTIVE 2

#define ACTIVE 6

#define DELETEACTIVE 8

#define PUBLISHED 10

#define INSERTPUBLISHED 11

#define INACTIVE 14

#define DELETEINACTIVE 16

#define SELECTTOTAL 18

#define INSERTTOTAL 20

#define QuerySeparator $c(10)