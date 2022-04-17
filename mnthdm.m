clear
clc 
%生成初始解
rfgd=xlsread('附件1 弱覆盖栅格数据(筛选).csv');
xyjz=xlsread('附件2 现网站址坐标(筛选).csv');
s1=rfgd(:,3);
% figure 
% plot(tra);
% title('各坐标业务量');
ywl=sort(s1,'ascend');
mm=ywl(fix(182807*0.95));%取99%为分界
[m1,n1]=size(rfgd);
for i=1:m1
    if s1(i)>=mm
        d(i,:)=rfgd(i,:);
    end
end
d(all(d == 0,2),:)=[];
[m2,n2]=size(d);
% 计算距离
for i=1:m1
    for j=1:m2
        dert(j)=sqrt((rfgd(i,1)-d(j,1))^2+(rfgd(i,2)-d(j,2))^2);
    end
    for j=1:m2
        if dert(j)==min(dert)
            dertx(i,1)=d(j,1);
            dertx(i,2)=d(j,2);
            dertx(i,3)=dert(j);
        end
    end
end
%需要额外建设的基站
for i=1:m1
    if dertx(i,3)>30
        bu(i,:)=dertx(i,:);
    end
end
bu(all(bu == 0,2),:)=[];

jizhanhong=30;%% 判断基站型号
jizhanwei =10;
dm=zeros(m2,1);
for i=1:m1
    for j=1:m2
        if dertx(i,1)==d(j,1);
            if d(j,1)
            dm=dm+1;
            end
        end
    end
end
sol_weijizhan=1;     %（1）解空间（初始解）
sol_hongjizhan=2-sol_weijizhan^3;
sol_current1 = sol_hongjizhan; 
sol_best1 = sol_hongjizhan;
sol_current2 = sol_weijizhan; 
sol_best2 = sol_weijizhan;
E_current = inf;
E_best = inf; 
rand('state',sum(clock)); %初始化随机数发生器
t=90; %初始温度
tf=89.9; %结束温度
a = 0.99; %温度下降比例
 while t>=tf%（7）结束条件   
 for r=1:1000 %退火次数              
  %产生随机扰动（3）新解的产生       
 sol_weijizhan=sol_weijizhan+rand*0.2;      
  sol_hongjizhan=sol_weijizhan+9;       
    %检查是否满足约束        
if sol_hongjizhan-sol_weijizhan>=0 && sqrt(sol_hongjizhan^2+sol_weijizhan^2)>10 
 else           
 sol_weijizhan=rand*2;            
sol_hongjizhan=sol_weijizhan+9;            
continue;       
 end               
 %退火过程        
E_new=sol_hongjizhan*10+sol_weijizhan*1;%（2）目标函数       
 if E_new<E_current%（5）接受准则                
E_current=E_new;                
sol_current1=sol_hongjizhan;               
 sol_current2=sol_weijizhan;               
 if E_new<E_best                   
 %把冷却过程中最好的解保存下来 
  E_best=E_new;                   
 sol_best1=sol_hongjizhan;                    
sol_best2=sol_weijizhan;               
 end        
else                
if rand<exp(-(E_new-E_current)/t)%（4）代价函数差                    
E_current=E_new;                    
sol_current1=sol_hongjizhan;                    
sol_current2=sol_weijizhan;               
 else                   
 sol_hongjizhan=sol_current1;                   
 sol_weijizhan=sol_current2;               
 end       
 end        
plot(r,E_best,'*')       
 hold on    
end    
t=t*a;%（6）降温
end 
disp('最优解为：')
disp(sol_best1)
disp(sol_best2)
disp('目标表达式的最小值等于：')
disp(E_best)


