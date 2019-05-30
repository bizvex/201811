clc;
clear;
ACIR=0:5:40;
random=1;

avetpbefore_acir=zeros(1,length(ACIR));
edgetpbefore_acir=zeros(1,length(ACIR));
avetpafter_acir=zeros(1,length(ACIR));
edgetpafter_acir=zeros(1,length(ACIR));
mbsavetpafter_acir=zeros(1,length(ACIR));
mbsedgetpafter_acir=zeros(1,length(ACIR));
for i=1:length(ACIR)
    filename = sprintf('./result/4GHz_20MHz_snap200_UAV6_UE60_ACIR%d_random%d.mat',ACIR(i),random);
    tmp=load(filename);
    
    SE_before_set=tmp.SE_before_set;
    sum=0;
    for j=1:length(SE_before_set)
       sum=sum+SE_before_set(j); 
    end
    avetpbefore_acir(i)=sum/length(SE_before_set);
    
    SE_all_before_set=tmp.SE_all_before_set;
    sum=0;
    for j=1:length(SE_all_before_set)
       sum=sum+SE_all_before_set{j}(ceil(length(SE_all_before_set{j})*0.05)); 
    end
    edgetpbefore_acir(i)=sum/length(SE_all_before_set);
    
    SE_after_set=tmp.SE_after_set;
    sum=0;
    for j=1:length(SE_after_set)
       sum=sum+SE_after_set(j); 
    end
    avetpafter_acir(i)=sum/length(SE_after_set);
    
    SE_all_after_set=tmp.SE_all_after_set;
    sum=0;
    for j=1:length(SE_all_after_set)
       sum=sum+SE_all_after_set{j}(ceil(length(SE_all_after_set{j})*0.05)); 
    end
    edgetpafter_acir(i)=sum/length(SE_all_after_set);
    
    SE_MBS_after_set=tmp.SE_MBS_after_set;
    sum=0;
    for j=1:length(SE_MBS_after_set)
       sum=sum+SE_MBS_after_set{j}; 
    end
    mbsavetpafter_acir(i)=sum/length(SE_MBS_after_set);
    
    SE_MBS_all_after_set=tmp.SE_MBS_all_after_set;
    sum=0;
    for j=1:length(SE_MBS_all_after_set)
       sum=sum+SE_MBS_all_after_set{j}(ceil(length(SE_MBS_all_after_set{j})*0.05)); 
    end
    mbsedgetpafter_acir(i)=sum/length(SE_MBS_all_after_set);
end
avetpbefore_acir
edgetpbefore_acir
avetpafter_acir
edgetpafter_acir
mbsavetpafter_acir
mbsedgetpafter_acir