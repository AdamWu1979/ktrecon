function [paths,pathid]=studiesDetection(pr,rando)

%STUDIESDETECTION   Detects all studies for a specific project
%   PATHS=STUDIESDETECTION(PR)
%   * {PR} is the project for which to detect the studies. 1 for neonatal
%   dHCP (default) / 2 for fetal dHCP / 3 for toddlers / 4 for brain injury
%   * {RANDO} draws a given number of studies at random. It defaults to all
%   studies
%   * PATHS is an array with the detected paths
%   * PATHID is an array with the dhcp ids
%

if nargin<1 || isempty(pr);pr=1;end
if nargin<2;rando=[];end

[~,~,~,~,~,pathPr]=versRecCode;
pathPr=pathPr{pr};

%pathsp=[];
%paths=[];pathid=[];
if pr<3%FETAL OR NEONATAL
    structPath = dir(pathPr);%Returns all the files and folders in the directory
    structPath(ismember( {structPath.name}, {'.', '..'}))=[];
    structDir=structPath([structPath.isdir]);
    cont=1;
    for n=1:length(structDir)
        pathPrr=fullfile(pathPr,structDir(n).name);
        structPath = dir(pathPrr);%Returns all the files and folders in the directory
        structPath(ismember( {structPath.name}, {'.', '..'}))=[];
        structSubDir=structPath([structPath.isdir]);
        for m=1:length(structSubDir)
            pathsp{cont}=fullfile(structDir(n).name,structSubDir(m).name);
            structId=dir(fullfile(pathPr,pathsp{cont}));
            structId={structId.name};
            structId=structId(~cellfun(@isempty,regexp(structId,'.dhcp')));       
            if length(structId)==1
                a=strsplit(structId{1},'.');
                pathidp{cont}{1}=a{1};
                a=strsplit(pathsp{cont},'_');
                pathidp{cont}{2}=a{end};
            else
                error('More than one .dhcp files in folder %s',pathsp{cont});
            end
            cont=cont+1;
        end
    end
else
    fileID=fopen(pathPr);
    pathsp=textscan(fileID,'%s');
    pathidp=[];
    fclose(fileID);
    pathsp=pathsp{1};    
end
    
NF=length(pathsp);
if ~isempty(rando) && rando<NF
    u=randperm(NF);
    u=u(1:rando);
    paths=pathsp(u);
    pathid=pathidp(u);
else
    paths=pathsp;
    pathid=pathidp;
end