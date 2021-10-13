function result = Adj(Se3TO)
    result = zeros(6,6);
    S03toso3vec(Se3TO)
    So3 = logm(Se3TO);
    So3 = So3(1:3,4);
    So3 = SO3toso3(So3);
    result(4:6, 1:3) = So3 * Se3TO(1:3,1:3); 
    result(1:3, 1:3) = Se3TO(1:3,1:3);
    result(4:6, 4:6) = Se3TO(1:3,1:3); 
end
function so3 = SO3toso3(arr)
so3 = [0, -arr(3), arr(2);
       arr(3), 0, -arr(1);
       -arr(2), arr(1), 0];
end