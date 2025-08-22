function [V,F]=Merge(Vt,Ft,Vs,Fs)

Fs = (Fs+max(max(Ft)));

V=[Vt;Vs];
F=[Ft;Fs];
