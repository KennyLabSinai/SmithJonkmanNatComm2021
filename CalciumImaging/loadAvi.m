function [data, finfo] = loadAvi(fnames)
data = [];
finfo = struct();
if ~iscell(fnames)
    fnames = {fnames};
end

for fi=1:numel(fnames)
   v = VideoReader(fnames{fi});
    if fi == 1
        finfo = setProps2Struct(v);
    else
        finfo = cat(1,finfo,setProps2Struct(v));
    end
    while(hasFrame(v)) % https://www.mathworks.com/help/matlab/ref/videoreader.hasframe.html
        data = cat(3,data,readFrame(v));
    end
    
end


end

function st = setProps2Struct(v)
p = properties(v);
st = struct();
for i=1:numel(p)
   st.(p{i}) = v.(p{i});
end

end