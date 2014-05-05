exec("preambule.sce");

scenarios=read_db("scenario_matrix.csv",",",".")

smallag=csvRead(OUTPUT+"smallag.csv");
bigag=csvRead(OUTPUT+"bigag.csv");
urbout=csvRead(OUTPUT+"urbout.csv");
volume=csvRead(OUTPUT+"volume.csv");
outflow=csvRead(OUTPUT+"outflow.csv");

agg_conso_bigag=sum(bigag(2:$,:),"c");
pensize=3;
myfontSize=3
n_histo=200;
plot_histo(agg_conso_bigag,"blue")
xlabs("agg conso downstream agri")

export_fig("agg_conso_downstream_agri","pdf")