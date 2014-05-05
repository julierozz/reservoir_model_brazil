cd(DATA_scenar)

inflow_scenar  =csvRead("inflows_scenar.csv");
smallag_scenar =csvRead("smallag_scenar.csv");
bigag_scenar   =csvRead("bigag_scenar.csv");
urb_scenar     =csvRead("urb_scenar.csv");

volmax=23500000;
vol0=6*10^6;
criticalvol=csvRead("criticalvol.csv");
minvol=csvRead("minvol.csv");
evap=csvRead("evap.csv");
rulenumber=csvRead("rulenumber.csv");

cd(MODEL)