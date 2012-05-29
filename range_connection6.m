function [connection] = range_connection1(range, spikes, inh, sizem)

    spikes = spikes .* inh;
    connection = spikes;
    rangei = range;
    rangej = range;
    m = sizem;
    
    while rangei > 0
        while rangej > 0
            
            indexi = (m-rangei+1):m;
            indexj = 1:rangej;
        
            w = [indexi 1:m-rangei];
            s = [(rangej+1):m indexj];
            
            connection = spikes(s,w) + connection;
            
            rangej = rangej - 1;
        end
        rangej = range;
        rangei = rangei - 1;
    end