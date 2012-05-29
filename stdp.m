function [new_weight] = stdp(time, weight)

    tau_p = 10;                             %postive tau
    tau_n = 10;                             %negtive tau
    
    [m, n] = size(weight);
    new_weight = zeros(m, n);
    del_weight = zeros(m, n);               %change of weight
    
    a_p = 1;                              %learning rate
    a_n = -1;                             %learning rate
    
    for i = 1:m
        for j = 1:n
            if time(i, j) > 0
                del_weight(i, j) = a_p * weight(i, j) * exp(-time(i, j)/tau_p);
            else
                del_weight(i, j) = a_n * weight(i, j) * exp(time(i, j)/tau_n);
            end
        end
    end
    
    new_weight = weight + del_weight;
end
             
    