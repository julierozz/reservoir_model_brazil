
function m2tabular(matname,headlines,headcols,SAVEDIR)

    if ~isdef("SAVEDIR")
        SAVEDIR="";
    end
    
    mat =evstr(matname)    
    // mat = matname

    mat(:,2:$) ="&"+ascii(9) + mat(:,2:$);
    mat(:,$) = mat(:,$) + " \\";
    mat(headlines,$) = mat(headlines,$) + " \midrule";

    nbcols = size(mat,2)-headcols;

    mat = [ "\begin{tabular}{"+(headcols*" l ")+(nbcols*" c ")+"} \toprule"; strcat(mat,"","c"); "\bottomrule \end{tabular}"]
    
    write_csv(mat,SAVEDIR+matname+".tex")
endfunction

