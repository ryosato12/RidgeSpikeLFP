function sxr = eta(x,a)   
sxr = max(0,abs(x)-a)./(max(0,abs(x)-a)+a).*x; 
end 