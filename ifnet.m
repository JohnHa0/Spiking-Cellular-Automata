%% Simulation of (leaky) integrate-and-fire neuron
 clear; clf;

%% parameters of the model
 m = 101;
 dt = 0.1;       % integration time step [ms]
 tau = 10;       % time constant [ms]
 E_L = -65*ones(m, m);      % resting potential [mV]
 theta = -55;    % firing threshold [mV]
 
%%
   
   X = zeros(m,m);
   
   p = -1:1;
   for count=1:500,
      kx=floor(rand*(m-4))+2; 
      ky=floor(rand*(m-4))+2; 
      X(kx+p,ky+p)=(rand(3)>0.1);
   end;
   
   X = (X ~= 0) .* (-55); + (X == 0) .* (-65);
   spike = X ~= 0;
   
   % The "find" function returns the indices of the nonzero elements.
   [i,j] = find(spike);
   
   z = i.*0;
   

   plot3(i,j,z,'.', ...
      'Color','blue', ...
      'MarkerSize',12);
   axis([0 m+1 0 m+1]);
   
   hold on
 %%  
   % Whether cells stay alive, die, or generate new cells depends
   % upon how many of their eight possible neighbors are alive.
   % Here we generate index vectors for four of the eight neighbors.
   % We use periodic (torus) boundary conditions at the edges of the universe.
   
   n = [m 1:m-1];
   e = [2:m 1];
   s = [2:m 1];
   w = [m 1:m-1];
 
   X = (X ~= 0) .* (-55) + (X == 0) .* (-65);
   
   for t = 1:1:3;
       
      % How many of eight neighbors are alive.
      spike = spike(n,:) + spike(s,:) + spike(:,e) + spike(:,w) + ...
         spike(n,e) + spike(n,w) + spike(s,e) + spike(s,w);
      
      % A live cell with two live neighbors, or any cell with three
      % neigbhors, is alive at the next time step.
      
      RI_ext = spike .* 100;
   
      X = X - ((dt/tau) .* ones(m, m)) .* ((X - E_L) - RI_ext);
      
      temp1 = X > -55;
      
      X = ~temp1 .* X + temp1 .* -65;
      
      spike = temp1;
      
      % Update plot.
      [i,j] = find(spike);
      z = i.*0 + 1;
      z = z.*t;
      
      plot3(i,j,z,'.', ...
      'Color','blue', ...
      'MarkerSize',12);
    
      
      drawnow
     

   end
