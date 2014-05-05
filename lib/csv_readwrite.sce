
[u,t,n]=file();
i = grep(n',"/(?:.*\.sci|.*\.sce)$/","r");


if ~atomsIsInstalled("csv_readwrite")
	disp("trying to install csv_readwrite")
	r= atomsInstall("csv_readwrite")
	if r($)=="I"
		disp("csv_readwrite installed. restarting this script from "+n(i(1)))
		run_scilab(n(i(1)))
		sleep(1000)
		exit(0)
	else
		error("could not install csv_readwrite")
end
end

//auto restart when csv_read did not load
if execstr("csv_read","errcatch")<>77
    disp("csv_read didnt load. restarting this script from "+n(i(1)))
    sleep(50)
    run_scilab(n(i(1)))
    sleep(1000)
    exit(0)
end
csv_default("eol","linux"); //fixes http://forge.scilab.org/index.php/p/csv-readwrite/issues/673/
csv_default("separator",ascii(9));


clear i u t n r

 
csv_read = csvRead
csv_write = csvWrite
csvStringToDouble = csv_stringtodouble

