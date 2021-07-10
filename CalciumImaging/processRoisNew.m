function RP = processRoisNew(RP, data)
    traces = makeTrace(RP,data);
    for t=1:size(traces,2)
        RP(t).Trace = traces(:,t);
    end
end