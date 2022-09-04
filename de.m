clc  %���
clear
close all

CostFunction = @(x) fun3(x);
nVar = 3;
VarSize = [1,nVar];
VarMin = -5;
VarMax = 5;

MaxIt = 1000;  %����������
nPop = 50;
beta_min = 0.2;
beta_max = 0.8;
pCR = 0.2; %�������

empty_individual.Position = []; %���߱�������
empty_individual.Cost = [];  %Ŀ�꺯��ֵ
BestSol.Cost = inf;
pop = repmat(empty_individual,nPop,1);

for i = 1:nPop   %��ʼ����Ⱥ
    pop(i).Position = unifrnd(VarMin,VarMax,VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
    if  pop(i).Cost < BestSol.Cost
        BestSol = pop(i);
    end
end

BestCost = zeros(MaxIt);

for it = 1 : MaxIt
    for  i = 1 : nPop
        x = pop(i).Position; %����
        A = randperm(nPop);
        A(A == i) = []; % ѡ���Լ���ȡ��
        a = A(1);   %������������
        b = A(2);
        c = A(3);
        beta = unifrnd(beta_min,beta_max,VarSize); %0.1-0.2 ���һ�� beta ֵ
         y = pop(a).Position + beta.*(pop(b).Position - pop(c).Position); %��ʽ �����ٶ���
         y = max(y,VarMin); %�� �ٶ��� ����
         y = min(y,VarMax);
         
         z = zeros(size(x));
         j0 = randi([1,numel(x)]);
         for j = 1 : numel(x)    %�������    ѡ��Ӹ������Ӵ��Ŵ�
             if j == j0 || rand <=pCR  %����һ���ǴӼٶ����Ŵ�
                 z(j) = y(j);
             else
                 z(j) = x(j);
             end
         end
         
         NewSol.Position = z;
         NewSol.Cost = CostFunction(NewSol.Position);
         
         if  NewSol.Cost < pop(i).Cost  %ѡ�����  �Ƚ�
             pop(i) = NewSol;
             if pop(i).Cost < BestSol.Cost
                 BestSol = pop(i);
             end
         end
    end
     BestCost(it) = BestSol.Cost;  %��������Ŀ�꺯��ֵ ������һ�ֵ���
     disp(['Iteration' num2str(it) ': Best Cost = ' num2str(BestCost(it))]);
end

figure;
plot(BestCost);
xlabel('Iteration');
ylabel('Best Cost');
grid on;