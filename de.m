clc  %差分
clear
close all

CostFunction = @(x) fun3(x);
nVar = 3;
VarSize = [1,nVar];
VarMin = -5;
VarMax = 5;

MaxIt = 1000;  %最大迭代次数
nPop = 50;
beta_min = 0.2;
beta_max = 0.8;
pCR = 0.2; %交叉概率

empty_individual.Position = []; %决策变量编码
empty_individual.Cost = [];  %目标函数值
BestSol.Cost = inf;
pop = repmat(empty_individual,nPop,1);

for i = 1:nPop   %初始化种群
    pop(i).Position = unifrnd(VarMin,VarMax,VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
    if  pop(i).Cost < BestSol.Cost
        BestSol = pop(i);
    end
end

BestCost = zeros(MaxIt);

for it = 1 : MaxIt
    for  i = 1 : nPop
        x = pop(i).Position; %父代
        A = randperm(nPop);
        A(A == i) = []; % 选到自己则取消
        a = A(1);   %三个其他个体
        b = A(2);
        c = A(3);
        beta = unifrnd(beta_min,beta_max,VarSize); %0.1-0.2 随机一个 beta 值
         y = pop(a).Position + beta.*(pop(b).Position - pop(c).Position); %公式 产生假儿子
         y = max(y,VarMin); %对 假儿子 修正
         y = min(y,VarMax);
         
         z = zeros(size(x));
         j0 = randi([1,numel(x)]);
         for j = 1 : numel(x)    %交叉操作    选择从父代或子代遗传
             if j == j0 || rand <=pCR  %至少一个是从假儿子遗传
                 z(j) = y(j);
             else
                 z(j) = x(j);
             end
         end
         
         NewSol.Position = z;
         NewSol.Cost = CostFunction(NewSol.Position);
         
         if  NewSol.Cost < pop(i).Cost  %选择操作  比较
             pop(i) = NewSol;
             if pop(i).Cost < BestSol.Cost
                 BestSol = pop(i);
             end
         end
    end
     BestCost(it) = BestSol.Cost;  %更新最优目标函数值 进入下一轮迭代
     disp(['Iteration' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end

figure;
plot(BestCost);
xlabel('Iteration');
ylabel('Best Cost');
grid on;