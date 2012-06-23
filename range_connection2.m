function [connection] = range_connection2(range, spikes, inh, sizem)

    m = sizem;
    spikes = spikes .* inh;
    connection = zeros(m);
    rangei = range;
    rangej = range;
    
    
    while rangei > 0
        while rangej > 0
            
            indexi = (m-rangei+1):m;
        
            n = [indexi 1:m-rangei];

            connection = spikes(n, :) + connection;
            
            rangej = rangej - 1;
        end
        rangej = range;
        rangei = rangei - 1;
    end