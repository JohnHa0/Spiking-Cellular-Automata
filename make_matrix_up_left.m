function make_matrix_up_left(range, sizen)

rangei = range
rangej = range

%%
while rangei > 0
    while rangej > 0
        
        Ri = rangei : -1 : 0
        Rj = rangej : -1 : 0
    %%   
        Si = sizen * ones(size(Ri))
        Sj = sizen * ones(size(Rj))
    %%
        up_size = (Si - Ri)
        left_size = (Sj - Rj)
    %%
        matrix_up_left = rand(sizen)
    %%    
        indexi = [up_size, 1 : sizen - (rangei + 1)]
        indexj = [left_size, 1 : sizen - (rangej + 1)]
    %%    
        connect_range = matrix_up_left(indexi, indexj)

        rangej = rangej - 1
 
    end
    rangej = range
    rangei = rangei - 1
end
           
    