function [connection] = range_connection8(range, spikes, inh, sizem)

    m = sizem;
    spikes = spikes .* inh;
    connection = zeros(m);
    rangei = range;
    rangej = range;
    
    
    while rangei > 0
        while rangej > 0
            
            indexi = (m-rangei+1):m;
            indexj = 1:rangej;
         
            e = [(rangei+1):m indexi];
            s = [(rangej+1):m indexj];
            
            connection = spikes(s, e) + connection;
            
            rangej = rangej - 1;
        end
        rangej = range;
        rangei = rangei - 1;
    end