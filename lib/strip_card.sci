function y=strip_card(cardsmatrix,direction)

if argn(2)<2
    direction = "*"
end

s = size(cardsmatrix,direction)

[foo, neworder] = gsort(rand(1,s))

if direction==1 | direction=="l"
y= cardsmatrix(neworder,:)
elseif direction==2 | direction=="r"
y=cardsmatrix(:,neworder)
else
error("code it first")
end

endfunction