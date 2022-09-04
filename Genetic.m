clc
clear

maxgen = 500;
size = 500;
pcross = 0.6;
pmutation = 0.01;
lenchrom = [1,1,1,1];
bound = [0.2,0.8;0.1,0.6;0.01,1;0.01,0.25]; %约束条件 edgeSize  height scale ratio  决策变量 X=[ e h s r]

individuals = struct('fitness',zeros(1,sizepop),'chrom',[]);
avgfitness = [];
bestfitness = [];
bestchrom = [];

for i = 1:sizepop
    individuals.chrom(i,:) = Code(lenchrom,bound);
    x = individuals.chrom(i,:);
    individuals.fitness(i) = fun2(x);
end

