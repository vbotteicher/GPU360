function [v] = decode(r,g,b,a)

v = single(r)/(256*256*256) +single(g)/(256*256) + single(b)/256 + single(a)/1.0;