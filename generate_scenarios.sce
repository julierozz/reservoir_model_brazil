exec("preambule.sce");

param_of_interest=["criticalvol" "minvol" "rulenumber" "vol0" "inflowscenarnumb"];

if ~isfile("scenario_matrix.csv")
	scenario_matrix=["scenario_number",param_of_interest];
else
	[scenario_matrix, param_names] = read_matrice_indices("scenario_matrix.csv");
	if param_of_interest<>param_names
		disp("param_of_interest<>param_names")
	end
end
//for now on we re-write the matrix everytime
scenario_matrix=["scenario_number",param_of_interest];
scenario_number=1;

for criticalvol=[5*10^(6)]
	for minvol=[1*10^(6)]
		for rulenumber=[1]
			for vol0=[1 0.93 0.87 0.8 0.73 0.67 0.6 0.53 0.47 0.4]
				for inflowscenarnumb=[1:1:50]
					scenario_matrix=[scenario_matrix;[scenario_number,criticalvol,minvol,rulenumber,vol0,inflowscenarnumb]];
					scenario_number=scenario_number+1;
				end
			end
		end
	end
end
csvWrite(scenario_matrix,"scenario_matrix.csv");

for scenario_number=string([4:500])
	[scenario_matrix, param_names] = read_matrice_indices( "scenario_matrix.csv")
	[criticalvol,minvol,rulenumber,vol0,inflowscenarnumb]=combi2indices(scenario_number,scenario_matrix);
	csvWrite(criticalvol,DATA_scenar+"criticalvol.csv");
	csvWrite(rulenumber,DATA_scenar+"rulenumber.csv");
	csvWrite(minvol,DATA_scenar+"minvol.csv");
	csvWrite(vol0,DATA_scenar+"vol0.csv");
	
	get_scenar_from_data("Reservoir_Inflows_scenarios.csv",inflowscenarnumb,"inflows_scenar.csv","JUL")
	get_scenar_from_data("Average_Evaporation_Dam.csv","Average","evap.csv","JUL")
	get_scenar_from_data("Urban_Demand_updated.csv","Average1992_2010","urb_scenar.csv","JUL")
	get_scenar_from_data("Upstream_Agric_WeightedDemand_total.csv","Current","smallag_scenar.csv","JUL")
	get_scenar_from_data("Downstream_Agric_WeightedDemand_ConProyecto_Updated.csv","Current","bigag_scenar.csv","JUL")
	
	
	exec("model.sce");
	
	months=get_months_from_input("Reservoir_Inflows_scenarios.csv","JUL");
	
	update_csv("smallag.csv",smallagout,scenario_number,months)
	update_csv("bigag.csv",bigagout,scenario_number,months)
	update_csv("urbout.csv",urbout,scenario_number,months)
	update_csv("volume.csv",volume,scenario_number,months)	
	update_csv("outflow.csv",outflow,scenario_number,months)	
end
