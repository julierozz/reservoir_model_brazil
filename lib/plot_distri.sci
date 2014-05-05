///////////// Function graph distribution of models ////////////

/// call the data data, with first column dates and the following models


function plotdistri(truc)

    truc = data;
    n = size(data); n1= n(1); n2 = n(2); 
        
    themean      = nanmean(data(:,2:$),"c");
        
    bound = zeros(n1,2);
    for i = 1:n1
        vec = data(i,2:$);
        vec = vec(~isnan(vec));

        w = gsort(vec);
        bound(i,1) = w(2)
        bound(i,2) = w($-1);
    end
    
    clf(); drawlater()
    for i = 2:n2
        plot(t, data(:,i));
        ccolor(i);
        cstyle(2);
cstyle(1)
        cthick(1);
    end
      a = get("current_axes");
    if a.data_bounds(1,2)<-50
    plot(data(:,1), 0)
    ccolor(100,100,100);
    cthick(1.5);
    end
    a.font_size = myfontSize
    a.tight_limits="on"
    cstyle(1)

        xlabs(" ")
    ylabs("Carbon intensity (gCO$_2$/kWh)")
    
    plot(data(:,1),themean)
    // ccolor(20,40,230)
    ccolor("black")
    cstyle(1); cthick(3);
    plot(data(:,1),  bound(:,1))
    ccolor("black")
    cstyle(8); cthick(3);
    plot(data(:,1),  bound(:,2))
    ccolor("black")
    cstyle(8); cthick(3);
    

    formatwin
    a.sub_ticks=[1 0]

    drawnow()
endfunction

function formatwin

    a = get("current_axes");


    a.box = "off"
    a.sub_ticks=[0 0]
    a.margins=[0.250    0.125    0.125    0.125];


endfunction