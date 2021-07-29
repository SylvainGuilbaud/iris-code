Class admin.tasks.buildIndices Extends %SYS.Task.Definition
{

Property classname As %String(MAXLEN = 250) [ InitialExpression = "PackageName.ClassName" ];

Method OnTask() As %Status
{
    set sc=$CLASSMETHOD(..classname,"%BuildIndices")
    return sc
}

}
