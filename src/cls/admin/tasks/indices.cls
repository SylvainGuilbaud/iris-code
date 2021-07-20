Class admin.tasks.indices Extends %SYS.Task.Definition
{

/// Description
Parameter LOGFILE = "ValidateIndices_";

Property classname As %String(MAXLEN = 250) [ InitialExpression = "PackageName.ClassName" ];

Property autocorrect As %Boolean [ InitialExpression = 1 ];

Method OnTask() As %Status
{
    /*
    https://docs.intersystems.com/irislatest/csp/documatic/%25CSP.Documatic.cls?&LIBRARY=%25SYS&CLASSNAME=%25SYSTEM.OBJ#ValidateIndices

    classmethod ValidateIndices(classname As %Library.String, idxList As %String = "", autoCorrect As %Boolean = 0, lockOption As %Integer = 1, multiProcess As %Boolean = 0, verbose As %Boolean = 1, ByRef errors As %String) as %Library.Status
    Validate indices for a class

    Parameters:
    classname
    Name of the persistent class to validate indices for.
    idxList
    Optional. "" to check all indices, or specify a $list of index names to check. Default=""
    autoCorrect
    Optional. If true, correct any errors found. Default=0
    lockOption
    Optional. Default = 1 0 - No locking is performed at all 1 - Shared locking as each row is checked 2 - exclusive lock on entire table for duration of the run
    multiProcess
    Optional. If true, parts of %ValidateIndices will use parallel processing when possible. Default=0
    verbose
    Optional. If true, display output to the current device. Default=1. When called for a sharded class, verbose is force to 0.
    errors
    Optional. Passed by reference. Returns an array of errors found in the index(es) validated. If autoCorrect=1, this is an array of issues corrected.
    Returns:

    Status Code
    */
    set directory=##class(%File).NormalizeDirectory($system.Util.InstallDirectory()_"tmp")
    do:'##class(%File).DirectoryExists(directory) ##class(%File).CreateDirectoryChain(directory)
    set sc=$$$OK,idxList="",lockOption=1,multiProcess=1,verbose=1,log=directory_..#LOGFILE_..classname_".log",ts=$zdt($h,3),start=$zh
    if $system.Version.GetISCProduct()<4 {
        // Caché or Ensemble or HealthShare
        open log:("NW") use log set sc=$SYSTEM.OBJ.ValidateIndices(..classname,idxList,..autocorrect,lockOption,multiProcess)
    }
    if $system.Version.GetISCProduct()>=4 {
        // IRIS
        open log:("NW") use log set sc=$SYSTEM.OBJ.ValidateIndices(..classname,idxList,..autocorrect,lockOption,multiProcess,verbose,.errors)
    }
    close log
    set ^admin.tasks.indices(..classname,ts,"status")=$system.Status.GetErrorText(sc)
    set elapse=$zh-start
    set ^admin.tasks.indices(..classname,ts,"duration")=$num(elapse,2)_" seconds"
    set ^admin.tasks.indices(..classname,ts,"log file")=log
    set file=##class(%File).%New(log)
    set sc=file.Open("RS")
    if sc {
        while 'file.AtEnd {
            set line=file.ReadLine()
            set:line'="" ^admin.tasks.indices(..classname,ts,"log",$i(^admin.tasks.indices(..classname,ts,"log")))=line
        }
        do file.Close()
    } else {
        set ^admin.tasks.indices(..classname,ts,$i(^admin.tasks.indices(..classname,ts)))="CANNOT OPEN "_log_":"_$system.Status.GetErrorText(sc)
    }
    merge ^admin.tasks.indices(..classname,ts,"ERRORS")=errors
    return sc
}

}
