%% Simulation of (leaky) integrate-and-fire neuron
 clear; clf;

%% parameters of the model
 m = 101;
 dt=0.1;       % integration time step [ms]
 tau=10;       % time constant [ms]
 E_L=-65*ones(m, m);      % resting potential [mV]
 theta=-55;    % firing threshold [mV]
 %RI_ext = input('input current');     % constant external input [mA/Ohm]


%%

   
   X = sparse(m,m);
   
   p = -1:1;
   for count=1:5000,
      kx=floor(rand*(m-4))+2; 
      ky=floor(rand*(m-4))+2; 
      X(kx+p,ky+p)=(rand(3)>0.1);
   end;
   
   X = X.*rand(m, m).*(-55);
   spike = X;
   
   
   % The "find" function returns the indices of the nonzero elements.
   [i,j] = find(spike);
   
   z = i.*0;
   
   figure(gcf);
     plothandle = plot3(i,j,z,'.', ...
      'Color','blue', ...
      'MarkerSize',12);
   axis([0 m+1 0 m+1]);
 %%  
   % Whether cells stay alive, die, or generate new cells depends
   % upon how many of their eight possible neighbors are alive.
   % Here we generate index vectors for four of the eight neighbors.
   % We use periodic (torus) boundary conditions at the edges of the universe.
   
   n = [m 1:m-1];
   e = [2:m 1];
   s = [2:m 1];
   w = [m 1:m-1];
   a = 0;
   for t = 0:dt:1000;
       a = a + 1;
      % How many of eight neighbors are alive.
      spike = X(n,:) + X(s,:) + X(:,e) + X(:,w) + ...
         X(n,e) + X(n,w) + X(s,e) + X(s,w);
      
      spike = spike > -55;
     
      % A live cell with two live neighbors, or any cell with three
      % neigbhors, is alive at the next time step.
      
      RI_ext = spike .* 15;
      
      X=spike.*E_L+(ones(m, m)-spike)*(X-dt/tau.*((X-E_L)-RI_ext));
      
      % Update plot.
      [i,j] = find(spike);
      z = i.*0 + 1;
      z = z.*a;
      
      set(plothandle,'xdata',i,'ydata',j, 'zdata',z)
      
      
      drawnow
     

   end
   
   % ====== End of Demo
