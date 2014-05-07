MODEL = get_absolute_file_path("preambule.sce");
LIB=MODEL+"lib\";
DATA=MODEL+"data\";
DATA_scenar=MODEL+"scenar_data\";
OUTPUT=MODEL+"outputs\";
mkdir(DATA);
mkdir(OUTPUT);
mkdir(DATA_scenar);
getd(MODEL);
getd(LIB);
cd(MODEL);

if evstr(part(getversion(),8:10))<5.5
csvDefault("eol","linux")
end
