function [connection] = range_connection7(range, spikes, inh, sizem)

    m = sizem;
    spikes = spikes .* inh;
    connection = zeros(m);
    rangei = range;
    rangej = range;
    
    
    while rangei > 0
        while rangej > 0
            
            indexj = 1:rangej;
        
            s = [(rangej+1):m indexj];
            
            connection = spikes(s, :) + connection;
            
            rangej = rangej - 1;
        end
        rangej = range;
        rangei = rangei - 1;
    end