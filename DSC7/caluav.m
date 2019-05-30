clc;
clear;
loop=4:12;
random=2;

outagebefore=zeros(1,length(loop));
outageafter=zeros(1,length(loop));
SEbefore=zeros(1,length(loop));
SEafter=zeros(1,length(loop));
SEMBSafter=zeros(1,length(loop));
SE5before=zeros(1,length(loop));
SE5after=zeros(1,length(loop));
SE5MBSafter=zeros(1,length(loop));
for i=1:length(loop)
    filename = sprintf('./result/4GHz_20MHz_snap200_UAV%d_UE60_ACIR5_random%d.mat',loop(i),random);
    tmp=load(filename);
    
    %% outage
    outage_before_set=tmp.outage_before_set;
    sum=0;
    for j=1:length(outage_before_set)
        sum=sum+outage_before_set(j);
    end
    outagebefore(i)=sum/length(outage_before_set);
    
    outage_after_set=tmp.outage_after_set;
    sum=0;
    for j=1:length(outage_after_set)
        sum=sum+outage_after_set(j);
    end
    outageafter(i)=sum/length(outage_after_set);
    
    %% Æ½¾ùSE
    SE_before_set=tmp.SE_before_set;
    sum=0;
    for j=1:length(SE_before_set)
        sum=sum+SE_before_set(j);
    end
    SEbefore(i)=sum/length(SE_before_set);
    
    SE_after_set=tmp.SE_after_set;
    sum=0;
    for j=1:length(SE_after_set)
        sum=sum+SE_after_set(j);
    end
    SEafter(i)=sum/length(SE_after_set);
    
    SE_MBS_after_set=tmp.SE_MBS_after_set;
    sum=0;
    for j=1:length(SE_MBS_after_set)
        sum=sum+SE_MBS_after_set{j};
    end
    SEMBSafter(i)=sum/length(SE_MBS_after_set);
    
    %% ±ßÔµSE
    SE_all_before_set=tmp.SE_all_before_set;
    sum=0;
    for j=1:length(SE_all_before_set)
        sum=sum+SE_all_before_set{j}(ceil(length(SE_all_before_set{j})*0.05));
    end
    SE5before(i)=sum/length(SE_all_before_set);
    
    SE_all_after_set=tmp.SE_all_after_set;
    sum=0;
    for j=1:length(SE_all_after_set)
        sum=sum+SE_all_after_set{j}(ceil(length(SE_all_after_set{j})*0.05));
    end
    SE5after(i)=sum/length(SE_all_after_set);
    
    SE_MBS_all_after_set=tmp.SE_MBS_all_after_set;
    sum=0;
    for j=1:length(SE_MBS_all_after_set)
        sum=sum+SE_MBS_all_after_set{j}(ceil(length(SE_MBS_all_after_set{j})*0.05));
    end
    SE5MBSafter(i)=sum/length(SE_MBS_all_after_set);
    
    
end

outagebefore
outageafter
SEbefore
SEafter
SEMBSafter
SE5before
SE5after
SE5MBSafter