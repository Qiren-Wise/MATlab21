clc;  % 模拟退火
clear;
close all;

CostFunction = @(x) fun3(x);
nVar = 5;
VarSize = [1,nVar];
VarMin = -10;
VarMax = 10;

MaxIt = 1000;
MaxSubIt = 20; %最大子迭代次数  多方向选择
T0 = 0.1;
alpha = 0.09;
nPop = 10;
nMove = 5;
mu = 0.5;
sigma = 0.1*(VarMax - VarMin);

empty_individual.Position = [];
empty_individual.Cost = [];
pop = repmat(empty_individual,nPop,1); %定义数组 10个

BestSol.Cost = inf;
 
for i = 1 : nPop   %初始化 随机生成
    pop(i).Positon = unifrnd(VarMin,VarMax,VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
    if pop(i).Cost <= BestSol.Cost
        BestSol = pop(i);
    end
end

BestCost = zeros(MaxIt,1);
T = T0;

for it = 1 : MaxIt
    for subit = 1 : MaxSubIt  %增加扰动
        newpop = repmat(empty_individual,nPop,nMove);
        for i = 1 : nPop
            for  j = 1 : nMove  %每个例子增加扰动  列Move 行npop交叉相乘
                newpop(i,j).Position = Mutate(pop(i).Position,mu,sigma,VarMin,VarMax);
                newpop(i,j).Cost = CostFunction(newpop(i,j).Position);
              
            end
        end
        
        newpop = newpop(:);
        
        [~,SortOrder] = sort([newpop.Cost]);
        newpop = newpop(SortOrder);
        for i = 1 : nPop
             if newpop(i).Cost <= pop(i).Cost %新目标函数值比较好
                 pop(i) = newpop(i);
             else
                 DELTA = newpop(i).Cost - pop(i).Cost;  %接受概率  公式
                 P = exp(-DELTA / A);
                 if rand <= P
                     pop(i) = newpop(i);
                 end
             end
             if   pop(i).Cost <= BestSol.Cost  %更新目标函数
                 BestSol = pop(i); 
             end
        end 
    end
      BestCost(it) = BestSol.Cost;
      disp(['Iteration' num2str ' : Best Cost = ' num2str(BestCost(it))]);
      
      T = alpha * T; %成比例缩小
      sigma = 0.98 * sigma;
end

figure;
plot(BestCost,'LineWidth',2);
xlabel('Itration');
ylabel('Best Cost');
grid on;