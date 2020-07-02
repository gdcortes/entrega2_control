%%
nyquist(tf([0 0 10],[1 1 5]))

%%
bode(tf([10 1],conv([1 1],[100 1])))

%%
[RE,IM,W] = nyquist(tf([0 10],[1 2],'InputDelay',0.3),logspace(-1,3,200));
RE=squeeze(RE);
IM=squeeze(IM);
plot(RE,IM)
grid
hold on
[RE,IM,W] = nyquist(tf([0 10],[1 2],'InputDelay',0),logspace(-1,3,1000));
RE=squeeze(RE);
IM=squeeze(IM);
plot(RE,IM,'r')
hold off