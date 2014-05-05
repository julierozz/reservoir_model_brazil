
function xlabs(str,myfontSize)

    if argn(2)<2
        myfontSize=4;
    end
    if part(str,1)~="$"
        str = "$\text{"+str+"}$"
    end

    //Writes str as the y_label on a plot
    a=get("current_axes")
    //a.y_label.font_style=8;
    a.x_label.font_size=myfontSize;
    a.x_label.text=str;
    a.x_ticks(3) = "$\text{"+unspace(a.x_ticks(3))+"}$"
endfunction

function str = unspace(stringnumer)
    str = strsubst(strsubst(stringnumer,ascii(194),""),ascii(160),"")
endfunction

function ylabs(str,myfontSize,remove_tick_option)
    //Writes str as the y_label on a plot
    if argn(2)<3
        remove_tick_option=%t;
    end

    if argn(2)<2
        // myfontSize=4;
    end
    if part(str,1)~="$"
        str = "$\text{"+str+"}$"
    end

    a=get("current_axes")
    a.y_label.font_size=myfontSize;
    a.y_label.text = str;
    try //requires that paf actually exists
        if csvIsnum(unspace(a.y_ticks(3))) // requires Scilab 5.4
            a.y_ticks(3) = "$\text{"+a.y_ticks(3)+"}$"
        end    
    catch
    end    

    if remove_tick_option
        a.sub_ticks(2) =0
    end
endfunction

function  bigtitle(str)
    //Plot title with a reasonable font size
    if part(str,1)~="$"
        str = "$\text{"+str+"}$"
    end

    a=get("current_axes")
    a.title.text=str;
    a.title.font_size=5;
endfunction


function export_fig(filename,exptype,winId)
    //Exports winId in croped pdf. Should not work but on my own PC    
    if argn(2)<3
        foo=gcf();
        winId =foo.figure_id
    end    
    if argn(2)<2
        export_fig(filename,"pdf",winId)
        export_fig(filename,"png",winId)
        return
    end

    filenameargu = strsubst(filename," ","_")
    select exptype

    case "png"
        filename = filenameargu+".png"
        filename = strsubst(filename,".png.png",".png");

        xs2png(winId,filename)
        disp("png done.")


    case "pdf"
        filename = filenameargu+".pdf"
        filename = strsubst(filename,".pdf.pdf",".pdf");

        xs2pdf(winId,"hop.pdf");
        disp("pdfcrop ...")
        unix("pdfcrop  --margins ""5"" hop.pdf "+filename);
        // unix("start "+filename);
        deletefile("hop.pdf");
        disp(filename+"...done.")
    end

    // move2paper(filenameargu)

endfunction

function move2paper(filenameargu)

    if isfile(filenameargu+".pdf")
        filename = filenameargu+".pdf"
        movefile(filename, PAPER+filename)
    end
    if isfile(filenameargu+".eps")
        filename = filenameargu+".eps"
        movefile(filename, PAPER+filename)
    end
    // if isfile(filenameargu+".png")
    // filename = filenameargu+".png"
    // movefile(filename, PAPER+filename)
    // end 

endfunction

function win()
    a=gca();  
    //win size left right top bottom
    a.margins =[0.18    0.06    0.03    0.17] ;
    // xset("wdim",600 ,450);
    f=gcf();
    f.axes_size=[600,450];
    a.font_size = myfontSize;
endfunction


function win_n_bound(bound1,bound2)
    win()
    if argn(2)<1
        bound1 = 0;
    end
    a=gca();
    a.data_bounds(1,2)=bound1;
    a.data_bounds(2,2)=bound2;
    a.tight_limits="on";    
    a.sub_ticks=[0, 0]
endfunction

function ccolor(colindex,G,B)
    try
    //changes color of last drawn line
    //generic pastel colors inspired by ms excel colors
    // collist = list([40 ,105,180],.. //bleu
    // [255,  0,  0],.. //rouge
    // [150,210, 80],.. //vert
    // [130,100,160],.. //violet
    // [085,180,210],.. //cyan
    // [250,150,070],.. //orange
    // [250,100,200]); //rose

    collist = [
    [100,210, 30]    //vert gp
    [110,50,160]    //violet
    [255,0,0]        //rouge gp
    [250,220,000]    //jaune gp
    [250,130,010]    //ora gp
    // [40 ,105,180]   //bleu
    [085,180,210] //cyan
    [250,100,200]]; //rose
    
    
    // collist = strip_card(hsvcolormap(10)*255,1);
    // collist = strip_card(collist,1);
    
    p=0.4  //p proche de 0: clair, proche de 1: foncé.

    collist =(1-p)*255 +p*collist
    e=gce(); p=e.children(1);
    select argn(2)
    case 1
        if typeof(colindex)=="string"
            p.foreground = color(colindex)
        else //
            colindex = modulo(colindex,size(collist,1))+1
            the_color = strcat(string(collist(colindex,:)),",")
            p.foreground=evstr("color("+the_color+")");
        end    
    case 3
        R = colindex;
        p.foreground=color(R,G,B)
    else
        error("ccolor : one (index) or three (R,G,B) arguments required")
    end               
    p.mark_foreground = p.foreground
    //changes thickness to pensize    
    p.thickness=pensize;
    catch
    // pause
    end
endfunction

function cthick(pensize)
    //changes thickness to pensize    
    e=gce(); p=e.children(1);
    p.thickness=pensize;

endfunction

function xticks
    a=gca()
    hop = a.x_ticks;
    hop.locations = t_ini:5:(t_ini+T);
    hop.locations(1)=[];
    hop.labels = ["$"+hop.locations+"$"];
    a.x_ticks =  hop;
    a.sub_ticks(1) =0
    // ylabs "$\text{Carbon price and expenses }(\$/\text{tCO}_{2})$"
endfunction	

function cmark(markstyle)
    e=gce();e=e.children(1);

    e.mark_mode = markstyle

    e.mark_size = 3*pensize
    e.mark_style = 4
    e.mark_foreground =  e.foreground              
    e.mark_mode = "on"
endfunction    

function cmsize(stylenb)
    e=gce();e=e.children(1);

    e.mark_size = stylenb
endfunction   

function cstyle(stylenb)
    e=gce();e=e.children(1);

    e.line_style = stylenb
endfunction    

function ccurve(index)

    index = modulo(index-1,7)+1;

    ccolor(index)
    cstyle(index)

endfunction

function csize(stylenb)
    e=gce();e=e.children(1);

    e.thickness = stylenb
endfunction   

function win_n_legend(legpos,actnames,myfontSize)

    win_n_bound();
    if part(actnames(1),1)~="$"
        actnames = "$\text{"+actnames+"}$"
    end
    //legend
    legend(actnames,legpos);
    e=gce();
    // e.font_size = myfontSize;
    e.line_mode="off";
    e.fill_mode="off";
endfunction

function puttick(pos,str)
    if part(str,1)~="$"
        str = "$\text{"+str+"}$"
    end

    a=get("current_axes")
    hop = a.x_ticks;

    hop.locations($+1) = pos
    hop.labels($+1) = ["$"+str+"$"]
    a.x_ticks = hop

endfunction

function putytick(pos,str)
    if part(str,1)~="$"
        str = "$\text{"+str+"}$"
    end

    a=get("current_axes")
    hop = a.y_ticks;

    hop.locations($+1) = pos
    hop.labels($+1) = ["$"+str+"$"]
    a.y_ticks = hop

endfunction


function plot_histo(data,mycolor)

    colorflag=%f;

    if argn(2)>1
        colorflag = %t;
    end

    if colorflag
        histplot(n_histo,data,style=color(mycolor));
    else    
        histplot(n_histo,data);
    end

    a=gca();
    a.children(:).children.thickness = pensize; 

    //virre la graduation de l'axe des ordonnées
    yticks = a.y_ticks;
    yticks.locations=[];
    yticks.labels=[];
    a.y_ticks = yticks

    ylabs ("$\mbox{frequency}$",myfontSize);

endfunction

function plot_avg(data,mycolor)

    colorflag=%f;
    if argn(2)>1
        colorflag = %t;
    end

    a=gca();
    m=mean(data);
    l=min(a.data_bounds(:,2))
    L=max(a.data_bounds(:,2))
    if colorflag
        plot([m,m],[l, L],"--","color",mycolor)
    else    
        plot([m,m],[l, L],"--")
    end    
endfunction

function myrarrox(t_arrow,tt,serie_haut,serie_bas,text)
    //dessine une flèche ayant pour abscisse t_arrow, entre serie_haut et serie_bas. tt est le vecteur des x sur lequels est fait le plot. text est l'étiquette de la flèche

    //trouve le x sur le plot
    pseudo_t = find(t_arrow==tt)
    //calcule les y
    yh = serie_haut(pseudo_t)
    yb = serie_bas (pseudo_t)

    //ajoute une marge
    yha = yb+0.95*(yh-yb)
    yba = yb+0.05*(yh-yb)

    //dessine la flèche
    xarrows([t_arrow;t_arrow],[yha;yba],10)

    //ecrit en tex automatiquement
    if part(text,1)~="$"
        text = "$\quad "+text+"$"
    end

    //etiquette
    xstring(t_arrow,(yha+yba)/2.1,text)
endfunction

function rxt
    //reomves x_ticks

    a=gca();

    hop = a.x_ticks;
    hop.locations = []
    hop.labels = []
    a.x_ticks =  hop;

endfunction

function ryt
    //reomves y_ticks

    a=gca();

    hop = a.y_ticks;
    hop.locations = []
    hop.labels = []
    a.y_ticks =  hop;

endfunction


function plotv(x,labelstr,stylestring)
    if argn(2)<3
        stylestring = "k--" 
    end


    ax=gca();
    M=ax.data_bounds($,$);
    plot([x x],[0 M],stylestring)


    hop = ax.x_ticks;
    hop.locations($+1) =x
    hop.labels($+1) =labelstr
    ax.x_ticks=hop;


endfunction

function curve_style(mycolor,mystyle,mythickness,mystylestyle,mysecondcolor,arrow)
//Choose color and style (line or mark)
//The two first arguments are compulsory, the others are optional
//To see the color list, help color_list
//mystyle is 'mark' or 'line'
//mythickness is the thickness of the line or mark
//mystylestyle is the style of the line (see help line_style) or the mark (see help mark_style)

	if ~isdef ( 'mycolor')
		mycolor='navy blue';
	end
	if ~isdef ( 'mystyle')
		mystyle='line';
	end
	if ~isdef ( 'mythickness')
		mythickness=3;
	end
	if ~isdef ( 'mystylestyle')
		mystylestyle=1;
	end
	if ~isdef ( 'mysecondcolor')
		mysecondcolor=mycolor;
	end
	if ~isdef ( 'arrow')
		arrow=%f;
	end
	if type(mythickness) 	~= 1	then error("Expecting a real input, got a " + typeof(mythickness));		end
	if type(mystylestyle) 	~= 1	then error("Expecting a real input, got a " + typeof(mystylestyle));		end
	if type(mystyle) 	~= 10	then error("Expecting a string input, got a " + typeof(mystyle));		end
	if type(mycolor) 	~= 10 then strcolor=%f; else strcolor=%t; end
	e=gce();
	p=e.children;
	if mystyle=='line'
		p.mark_mode = "off";
		p.line_mode = "on";
		p.line_style = mystylestyle;
		if strcolor
			p.foreground = color(mycolor);
		else
			p.foreground = mycolor;
		end
		p.thickness = mythickness;
		if arrow
			p.polyline_style=4;
			p.arrow_size_factor=0.7;
		end
	elseif mystyle=='mark'
		p.mark_mode = "on";
		p.line_mode = "off";
		p.mark_size_unit = "point";
		p.mark_style = mystylestyle;
		
		if strcolor
			p.mark_background = color(mycolor);
			p.mark_foreground = color(mysecondcolor);
		else
			p.mark_background = mycolor;
			p.mark_foreground = mysecondcolor;
		end
		p.mark_size = mythickness;
	else
		disp ( 'error in curve_style, mystyle should be ''line'' or ''mark''');
	end
	
endfunction

// function title(varargin)
// warning("title est desactive")
// endfunction
