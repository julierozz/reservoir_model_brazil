clear all

exec("preambule.sce");

if ~isdef("scenario_number")
	scenario_number="last_run_scenario";
end

month_names=["Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec"];

exec("calibration.sce");

t1=size(inflow_scenar,"c");

for data=["bigag_scenar" "smallag_scenar" "urb_scenar" "evap"]
	execstr("ti=size("+data+",2);");
	if typeof(t1/ti)=="constant"
		for j=1:1:t1/ti-1
			execstr(data+"=["+data+","+data+"];")
		end
	end
end
tmax=t1;

nrows=1;

smallagin=eval(smallag_scenar(1:tmax));
bigagin  =eval(bigag_scenar(1:tmax));
urbin    =eval(urb_scenar(1:tmax));
inflowin =eval(inflow_scenar(1:tmax));
evapin=eval(evap(1:tmax));

smallagout =zeros(nrows,tmax);
bigagout   =zeros(nrows,tmax);
urbout     =zeros(nrows,tmax);
outflow    =zeros(nrows,tmax);
volume     =zeros(nrows,tmax);

volume(1)=vol0;

for i=1:1:tmax
	[flow,smag,bgag,ur]=allocation_rule(rulenumber,volume(:,i),smallagin(:,i),bigagin(:,i),urbin(:,i),criticalvol,minvol);
	outflow(:,i)=flow;
	smallagout(:,i)=smag;
	bigagout(:,i)=bgag;
	urbout(:,i)=ur;
	
	volume(i+1)=reservoir_dynamics(volume(i),inflowin(:,i),outflow(:,i),evapin(:,i),volmax);
end

xset("window",0)
clf
plot(volume,"k")
plot(evapin,"r")
plot(inflowin,"b")
plot(outflow,"m")
leg=legend("reservoir volume","evap","inflow","outflow")
leg.legend_location="in_upper_left"
myfontSize=4
ylabs("volume in m3")
xlabs("months")
export_fig("outputs_"+scenario_number,"pdf")


xset("window",1)
clf
plot(bigagout,"m")
plot(urbout,"y")
plot(evapin,"r")
leg=legend("agri downstream","urban","evaporation")
leg.legend_location="in_upper_left"
myfontSize=4
ylabs("volume in m3")
xlabs("months")
export_fig("outputs_ag_urb_"+scenario_number,"pdf")