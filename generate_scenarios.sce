exec("preambule.sce");

param_of_interest=["criticalvol" "minvol" "rulenumber" "inflowscenarnumb"];

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
		for rulenumber=[1 2]
			for inflowscenarnumb=["Average" "drought" "drought2"]
				scenario_matrix=[scenario_matrix;[scenario_number,criticalvol,minvol,rulenumber,inflowscenarnumb]];
				scenario_number=scenario_number+1;
			end
		end
	end
end
csvWrite(scenario_matrix,"scenario_matrix.csv");


for scenario_number=["3"]
	[scenario_matrix, param_names] = read_matrice_indices( "scenario_matrix.csv")
	[criticalvol,minvol,rulenumber,inflowscenarnumb]=combi2indices(scenario_number,scenario_matrix);
	csvWrite(criticalvol,DATA_scenar+"criticalvol.csv");
	csvWrite(rulenumber,DATA_scenar+"rulenumber.csv");
	csvWrite(minvol,DATA_scenar+"minvol.csv");
	
	get_scenar_from_data("Reservoir_Inflows.csv",inflowscenarnumb,"inflows_scenar.csv")
	get_scenar_from_data("Average_Evaporation_Dam.csv","Average","evap.csv")
	get_scenar_from_data("Urban_Demand.csv","Average1992_2010","urb_scenar.csv")
	get_scenar_from_data("Upstream_Agric_Demand.csv","Total","smallag_scenar.csv")
	get_scenar_from_data("Downstream_Agric_Demand_SinProyecto.csv","Total","bigag_scenar.csv")
	
	exec("model.sce");
	
	update_csv("smallag.csv",smallagout,scenario_number)
	update_csv("bigag.csv",bigagout,scenario_number)
	update_csv("urbout.csv",urbout,scenario_number)
	update_csv("volume.csv",volume,scenario_number)	
	update_csv("outflow.csv",outflow,scenario_number)	
end
