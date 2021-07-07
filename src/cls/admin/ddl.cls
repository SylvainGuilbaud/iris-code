Class admin.ddl
{

Parameter EXTENSION = ".sql";

ClassMethod export(ByRef message As %DynamicObject, verbose As %Boolean = 0, schema As %String = "*", table As %String = "*", directory As %String = "ddl", filename As %String = "export", users As %Boolean = 1, roles As %Boolean = 1, privileges As %Boolean = 1, systemPrivileges As %Boolean = 1)
{
    set sc=$$$OK
    Try {
        set directory=##class(%File).NormalizeDirectory($system.Util.DataDirectory()_directory)
        do:'##class(%File).DirectoryExists(directory) ##class(%File).CreateDirectoryChain(directory)
        set filename=directory_
                    filename_
                    "-"_schema_
                    "-"_table_
                    $case(roles,1:"-roles",0:"")_
                    $case(users,1:"-users",0:"")_
                    $case(privileges,1:"-privileges",0:"")_
                    $case(systemPrivileges,1:"-systemPrivileges",0:"")_
                    ..#EXTENSION
        /*
        qualifiers
            Specify any subset of the following arguments in in either dynamic object (e.g. {"FileOpenParam":"WNS","Roles":0}), json string (e.g. "{""FileOpenParam"":""WNS"",""Roles"":""0""}"), or legacy qualifier format (e.g. "/FileOpenParam=WNS/Roles=0"). All qualifier names are case insensitive. Note that variables can be embedded in dynamic objects with the format {"ParamName":(varName)}.
            FileOpenParam
            Parameters to use when opening the File. The default is "WNS".
            Definitions
            1/0 flag. Specify 1 to export the table/view definitions. The default is 1.
            Users
            1/0 flag. Specify 1 to export the User definition. The default is 1.
            Roles
            1/0 flag. Specify 1 to export the Role definition, and the GRANT statements to assign the Roles to the Users and Roles they have been granted to. The default is 1.
            Privileges
            1/0 flag. Specify 1 to export the Table and View privileges for the tables and views specified in the Schema specification. The default is 1.
            SQLSystemPrivileges
            1/0 flag. Specify 1 to export the SQL System privileges defined in the current namespace for the users and roles. The default is 1.
        */
        set qualifiers={}
        set qualifiers.Definitions=1
        set qualifiers.Users=users
        set qualifiers.Roles=roles
        set qualifiers.Privileges=privileges
        set qualifiers.SQLSystemPrivileges=systemPrivileges
        set message={}
        set message.filename=filename
        set sc=$system.SQL.Schema.ExportDDL(schema,table,filename,qualifiers)
        if sc {
            set file=##class(%File).%New(filename)
            do file.Open("R")
            set message.size=$num(file.Size/1024,2)_" KB"
            set message.result="DDL orders successfully exported"
            
            do file.Close()
        } else {
            set message.error=$system.Status.GetErrorText(sc)
            set message.code=$system.Status.GetErrorCodes(sc)
        }
        do:verbose message.%ToJSON()
    }
    Catch ex {
        set sc=ex.AsStatus()
    }

    return sc
}

}
