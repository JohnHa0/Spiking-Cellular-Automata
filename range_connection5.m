function [connection] = range_connection5(range, spikes, inh, sizem)

    m = sizem;
    spikes = spikes .* inh;
    connection = zeros(m);
    rangei = range;
    rangej = range;
    
    
    while rangei > 0
        while rangej > 0
            
            indexj = 1:rangej;
            
            e = [(rangej+1):m indexj];
            
            connection = spikes(:, e) + connection;
            
            rangej = rangej - 1;
        end
        rangej = range;
        rangei = rangei - 1;
    end