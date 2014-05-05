///SUMARY///
//read_matrice_indices
//get_nb_combis_etude

//combi2indices
//str2combi
//switch_indice_in_combi


//==============COMBIS and ETUDE management =================
//==============OUTPUT management (make_savedir and so)==

//==============COMBIS and ETUDE management =================

function [scenario_matrix, param_names] = read_matrice_indices( mat_path)
//[scenario_matrix, [param_names] ]= read_matrice_indices(  [mat_path] )

if argn(2)<1
    mat_path = "scenario_matrix.csv";
end

[scenario_matrix] = csvRead(mat_path,[],[],"string");
param_names = scenario_matrix(1,2:$)

endfunction

function nb_combis=get_nb_combis_etude(matrice_indices)
    //gets the number of possible scenarios, in order to create the adequate liste_savedir
    // [r c] = get_nb_combis_etude()
    // r = get_nb_combis_etude(1)
    // c = get_nb_combis_etude(2)

    nb_combis=max(matrice_indices(:,1));


endfunction

function strcombi = fit_combi(combi)
//transforme le nombre combi en une string avec des zeros au debut: 34->"034"; 123->"123"

    tmp = "";
    if combi<10 then tmp="00"; end
    if (combi<100)&(combi>=10) then tmp="0"; end
    strcombi=tmp+combi
    
endfunction

function [varargout ] = combi2indices(scenario_number, scenario_matrix)
    //from a given combi number, this function returns the corresponding values of indices

    if ~isdef("scenario_matrix") 
        scenario_matrix = read_matrice_indices();
    end
    for i=1:size(scenario_matrix,2)-1
        for j=1:size(scenario_number,1)
            a=scenario_matrix(scenario_matrix(:,1)==scenario_number(j),i+1);
            if a==[]
                hop(j,i)=%nan
            else
                hop(j,i)=a;
        end
    end
    end

    if argn(1)==1
        varargout(1)=hop
    else	
        for i=1:argn(1)
            varargout(i)=hop(:,i)
    end
    end
    
    if sum(isnan(hop))>0
        warning("combi2indices returned some nans")
    end
    
endfunction

function combi=str2combi(str,matrice_indices)
    //returns the scenario number from the string containing the indices
    combi = zeros(str)
    if argn(2)<2
        matrice_indices = read_matrice_indices();
    end
    tmp=string (matrice_indices);
    tmp2=strcat (tmp(:,2:$),"","c");
    tmp=[tmp(:,1),tmp2];
    for j=1:size(str,"*")
        combi(j)=evstr (tmp(find(tmp(:,2)==str(j),1)));
    end
endfunction

function combi_out = switch_indice_in_combi(combi_in,index_ranks,new_index_values,matrice_indices)
    //Returns combi_out representing same scenarios than combi_in, except for that indexes corresponding to index_ranks are turned to new_index_values. 
    //Useful for getting a baseline
    //Can also be used to get the same scenario but with an alternative assumption
    //INPUT : 
    //  combi_in : An integer column (n x 1). Combi numbers.
    //  index_ranks: Integers row (1 x m). Ranks of switched index in matrice_indices
    //  new_index_values (OPTIONAL) : Integer row (1 x m). New values for the index_rank_th indice.
    //              DEFAULT is (1-old_index_value), usefull for binary indices
    //  matrice_indices (OPTIONAL) a read_matrice_indices-like matrix (each row is a configuration of indexes)
    //              DEFAULT is read_matrice_indices()
    //
    //OUTPUT :  
    //  combi_out (n x 1) :  An integer column. Combi numbers. Can be empty.
    //
    //EXAMPLE (works when ETUDE is defined)
    // combi2indices((12:14)')
    // switch_indice_in_combi((12:14)',2)
    // combi2indices(switch_indice_in_combi((12:14)',2))
    // switch_indice_in_combi([1100; 1200],[1 4],[0 0]) //in study whenflexi, this would turn off climat and infra

    //PREMABULE 
    if size(combi_in,2)>1
        hc switch_indice_in_combi
        error("combi_in should be a column")
    end
    if size(index_ranks,1)>1 
        hc switch_indice_in_combi
        error("index_ranks should be a row")  
    end
    if argn(2)<4
        matrice_indices = read_matrice_indices() //this last function manages error with ETUDE
    end
    old_indexes = combi2indices(combi_in,matrice_indices)
    if argn(2)<3 //default value
        new_index_values = 1-old_indexes(:,index_ranks)
    else //checks size
        if or(size(new_index_values)~= size(index_ranks))
            hc switch_indice_in_combi //displays documentation of this function
            error("switch_indice_in_combi: improper argument size. Proper usage documented supra")
        end
    end


    //WORK
    new_indexes = old_indexes
    new_indexes(:,index_ranks) = ones(combi_in)*new_index_values  //the actual switch

    combi_out = str2combi( strcat(string(new_indexes),"","c"),matrice_indices)
    
    if combi_out==[]
        warning("combi_out is empty")
        disp(whereami())
    end
    if size(combi_out)~=size(combi_in)
        warning("some switched combis where not found. combi_out is NOT well ordered.")
        disp(whereami())
    end
    
endfunction

function [outputdata]=update_csv(inputcsvfile,newdata,scenario_number)
	if ~isfile(OUTPUT+inputcsvfile)
		mycsvdata=[];
	else
		mycsvdata=csvRead(OUTPUT+inputcsvfile,[],[],"string");
	end
	outputdata=[mycsvdata;[scenario_number,newdata]];
	csvWrite(outputdata,OUTPUT+inputcsvfile);
endfunction

function [outputdata]=get_scenar_from_data(inputcsvfile,scenariocharac,outputcsvname)
	mydata=csvRead(DATA+inputcsvfile,[],[],"string")
	datastarts=find(mydata(1,:)=="JAN",1)
	outputdata=mydata(mydata(:,1)==scenariocharac,datastarts:$);
	if outputdata==[]
		outputdata=mydata(mydata(:,1)==scenariocharac+" ",datastarts:$);
	end
	if outputdata==[]
		disp(outputcsvname+" is empty")
	end
	csvWrite(outputdata,DATA_scenar+outputcsvname)
endfunction
