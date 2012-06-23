function [connection] = range_connection1(range, spikes, inh, sizem)
    
    m = sizem;
    spikes = spikes .* inh;
    connection = zeros(m);
    rangei = range;
    rangej = range;
    
    
    while rangei > 0
        while rangej > 0
            
            indexi = (m-rangei+1):m;
            indexj = 1:rangej;

            n = [indexi 1:m-rangei];
            w = [indexj 1:m-rangej];
            
            connection = spikes(n, w) + connection;
            
            rangej = rangej - 1;
        end
        rangej = range;
        rangei = rangei - 1;
    end