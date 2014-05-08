clear all

exec("preambule.sce");

if ~isdef("scenario_number")
	scenario_number="last_run_scenario";
end

exec("calibration.sce");

t1=size(inflow_scenar,"c");

for data=["bigag_scenar" "smallag_scenar" "urb_scenar" "evap" "precip_scenar"]
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
precipin=eval(precip_scenar(1:tmax));

smallagout =zeros(nrows,tmax);
bigagout   =zeros(nrows,tmax);
urbout     =zeros(nrows,tmax);
outflow    =zeros(nrows,tmax);
volume     =zeros(nrows,tmax);
availwater =zeros(nrows,tmax);

volume(1)=vol0;
availwater(1)=vol0-minvol;

for i=1:1:tmax
	[flow,smag,bgag,ur]=allocation_rule(rulenumber,volume(:,i),smallagin(:,i),bigagin(:,i),urbin(:,i),criticalvol,minvol);
	outflow(:,i)=flow;
	smallagout(:,i)=smag;
	bigagout(:,i)=bgag;
	urbout(:,i)=ur;
	
	if i<tmax
		volume(i+1)=reservoir_dynamics(volume(i),inflowin(:,i),precipin(:,i),outflow(:,i),evapin(:,i),volmax);
		availwater(i+1)=volume(i)+inflowin(:,i)+precipin(:,i)-evapin(:,i)-smallagout(:,i);
	end
end

if %f

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

end
