Class data.utils
{

ClassMethod generateCSV(nb As %Integer = 10) As %Status
{
    set sc=$$$OK
    set filename = "/tmp/iris/data/customer"_nb_".csv"
    set file=##class(%File).%New(filename)
    set sc=file.Open("WSN")
    for i=1:1:nb {
        set active=$RANDOM(2)
        set category=$RANDOM(5)+1
        set line=i_","_active_","_category_","_##class(%PopulateUtils).City()_","_$zdt($h-$RANDOM(1000)_","_$random(86400),3)_","_##class(%PopulateUtils).FirstName()_","_##class(%PopulateUtils).LastName()
        if file.WriteLine(line) {
            do $INCREMENT(inserted)
        }
    }
    do file.Close()
    write inserted," lines written in ",filename,!
    return sc
}

}
