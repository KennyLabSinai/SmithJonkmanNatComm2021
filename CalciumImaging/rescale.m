function traces = rescale(traces)
    traces = bsxfun(@rdivide, bsxfun(@minus,traces,min(traces)), max(traces)-min(traces));
end