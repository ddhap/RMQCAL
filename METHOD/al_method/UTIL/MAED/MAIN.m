
%http://www.cad.zju.edu.cn/home/dengcai/Data/ActiveLearning.html
%Two circles data with noise
clear;	
	%rand('twister',5489);
    rng('default');
[fea, gnd] = GenTwoNoisyCircle();
split = gnd ==1;
%split = zeros(400,1);
%split(1:20,1)=1;
%split=logical(split);
figure(1);
plot(fea(split,1),fea(split,2),'.k',fea(~split,1),fea(~split,2),'.b');

%Actively select 8 examples using TED
options = [];
options.KernelType = 'Gaussian';
options.t = 0.5;
options.ReguBeta = 0;
%MAED boils down to TED when ReguBeta = 0;
[smpRank,VAL] = MAED(fea,100,options);
figure(2);
plot(fea(split,1),fea(split,2),'.k',fea(~split,1),fea(~split,2),'.b');
hold on;
for i = 1:length(smpRank)
  plot(fea(smpRank(i),1),fea(smpRank(i),2),'*r');
  text(fea(smpRank(i),1),fea(smpRank(i),2),['\fontsize{16} \color{red}',num2str(i)]);
end
hold off;

%Actively select 8 examples using MAED
options = [];
options.KernelType = 'Gaussian';
options.t = 0.5;
options.ReguBeta = 100;
[smpRank,VAL] = MAED(fea,100,options);
figure(3);
plot(fea(split,1),fea(split,2),'.k',fea(~split,1),fea(~split,2),'.b');
hold on;
for i = 1:length(smpRank)
  plot(fea(smpRank(i),1),fea(smpRank(i),2),'*r');	
  text(fea(smpRank(i),1),fea(smpRank(i),2),['\fontsize{16} \color{red}',num2str(i)]);
end
hold off;
