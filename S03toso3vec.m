function res = S03toso3vec(S03)
    val = logm(S03);
    res = [val(3,2); val(1,3); val(2,1)];
end