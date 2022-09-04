clc;  % ģ���˻�
clear;
close all;

CostFunction = @(x) fun3(x);
nVar = 5;
VarSize = [1,nVar];
VarMin = -10;
VarMax = 10;

MaxIt = 1000;
MaxSubIt = 20; %����ӵ�������  �෽��ѡ��
T0 = 0.1;
alpha = 0.09;
nPop = 10;
nMove = 5;
mu = 0.5;
sigma = 0.1*(VarMax - VarMin);

empty_individual.Position = [];
empty_individual.Cost = [];
pop = repmat(empty_individual,nPop,1); %�������� 10��

BestSol.Cost = inf;
 
for i = 1 : nPop   %��ʼ�� �������
    pop(i).Positon = unifrnd(VarMin,VarMax,VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
    if pop(i).Cost <= BestSol.Cost
        BestSol = pop(i);
    end
end

BestCost = zeros(MaxIt,1);
T = T0;

for it = 1 : MaxIt
    for subit = 1 : MaxSubIt  %�����Ŷ�
        newpop = repmat(empty_individual,nPop,nMove);
        for i = 1 : nPop
            for  j = 1 : nMove  %ÿ�����������Ŷ�  ��Move ��npop�������
                newpop(i,j).Position = Mutate(pop(i).Position,mu,sigma,VarMin,VarMax);
                newpop(i,j).Cost = CostFunction(newpop(i,j).Position);
              
            end
        end
        
        newpop = newpop(:);
        
        [~,SortOrder] = sort([newpop.Cost]);
        newpop = newpop(SortOrder);
        for i = 1 : nPop
             if newpop(i).Cost <= pop(i).Cost %��Ŀ�꺯��ֵ�ȽϺ�
                 pop(i) = newpop(i);
             else
                 DELTA = newpop(i).Cost - pop(i).Cost;  %���ܸ���  ��ʽ
                 P = exp(-DELTA / A);
                 if rand <= P
                     pop(i) = newpop(i);
                 end
             end
             if   pop(i).Cost <= BestSol.Cost  %����Ŀ�꺯��
                 BestSol = pop(i); 
             end
        end 
    end
      BestCost(it) = BestSol.Cost;
      disp(['Iteration' num2str ' : Best Cost = ' num2str(BestCost(it))]);
      
      T = alpha * T; %�ɱ�����С
      sigma = 0.98 * sigma;
end

figure;
plot(BestCost,'LineWidth',2);
xlabel('Itration');
ylabel('Best Cost');
grid on;