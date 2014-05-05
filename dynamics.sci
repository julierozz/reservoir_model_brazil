function [outflow,smallagout,bigagout,urbout]=allocation_rule(rulenumber,vol,smallag,bigag,urb,criticalvol,minvol)

if minvol>criticalvol
	disp("error: minvol higher than criticalvol");
end

intrulenumber=eval(rulenumber);

select intrulenumber
	case 1
		if vol>criticalvol
			smallagout=smallag;
			bigagout=bigag;
			urbout=urb;
		elseif vol<=criticalvol&vol>minvol
			urbout=urb;
			smallagout=smallag;
			// bigagout=min(bigag,max(0,minvol-urbout-smallagout));
			bigagout=0;
		elseif vol<=minvol
			urbout=0;
			smallagout=0;
			bigagout=0;
			say("urbout")
		end
	case 2
		if vol>criticalvol
			smallagout=smallag;
			bigagout=bigag;
			urbout=urb;
		elseif vol<=criticalvol&vol>minvol
			urbout=0.6*urb;
			smallagout=0.6*smallag;
			bigagout=min(bigag,max(0,minvol-urbout-smallagout));
		elseif vol<=minvol
			urbout=0;
			smallagout=0;
			bigagout=0;
		end
	else
		disp("rule "+rulenumber+" undefined");
		abort
	end
	outflow=smallagout+bigagout+urbout;
endfunction


function [newvol]=reservoir_dynamics(vol,inflow,outflow,evap,volmax)
	deltavol=inflow-outflow-evap;
	newvol=max(0,min(vol+deltavol,volmax));
endfunction
