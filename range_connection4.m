function [connection] = range_connection1(range, spikes, inh, sizem)

    spikes = spikes .* inh;
    connection = spikes;
    rangei = range;
    rangej = range;
    m = sizem;
    
    while rangei > 0
        while rangej > 0
            
            indexi = (m-rangei+1):m;
        
            w = [indexi 1:m-rangei];
            
            connection = spikes(:, w) + connection;
            
            rangej = rangej - 1;
        end
        rangej = range;
        rangei = rangei - 1;
    end