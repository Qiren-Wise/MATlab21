function y = fun2(x)
 y = 1/(62.17 * x(2) * sqrt(2 * x(2) *x(1) * sqrt(x(3))) * exp(x(4)));
 
 Sdown = (sqrt(3) / 4) * x(1) ^2 * 6;
 Sup = x(3) * Sdown; 
 V = (1/3) * x(2) * (Sup + Sdown + sqrt(Sup * Sdown));
 if V <=1 &&V >=0.01
     y = y;
 else
     y = y +10000;
 end