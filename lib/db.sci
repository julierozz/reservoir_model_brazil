
function [titles] = read_db(mat_path,sep,dec)
//reads a database. expects columns with titles.
//math path : string. e.g. "c:/mydb.tsv"
//values : string matrix
//titles : string row (titles)

if argn(2)<2
	sep=ascii(9)
end

if argn(2)<3
	dec=[]
end
    mat_path = stripblanks(mat_path)
    //lis les données brutes
    [values] = csvRead(mat_path,sep,dec,"string");
    //lis le nom des fields    
    //gere les espaces dans les noms des fields
    titles = strsubst(values(1,:),ascii(32),"_")
    //valeur des fields
    values(1,:)=[];
    values(values==emptystr(values))="Nan"
    
    disp("read_db found ["+strcat(titles,", ")+"] in "+mat_path)

    
    //boucle sur les fields de la DB
    for j=1:size(titles,2)
        //gere les espaces dans les noms des fields
        name = titles(1,j)
        disp("parsing name="+name)
        //field a valeur numeriques
        if csvIsnum(string(values(1,j)))
            execstr(name+"=csvStringToDouble(values(1:$,j))")
        else    
            execstr(name+"=values(1:$,j)") 
        end
        execstr(name+"_set=unique("+name+")''")
    end

    varnames = strcat(titles,",")+","+strcat(titles+"_set",",");
    
    //renvoie les variables locales dans la mémoire "globale"
    execstr("["+varnames+"]=return("+varnames+")");
 
endfunction
