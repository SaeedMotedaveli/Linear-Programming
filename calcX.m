% @author = Saeed Motedaveli

function X = calcX()

linedata =  getlinedata();

busnum = 6;
B = zeros(busnum, busnum);

l = length(linedata);
for i = 1 : l
    from = linedata(i, 1);
    to = linedata(i, 2);
    x = linedata(i, 4);
    
    B(from, from) = B(from, from) + (1 / x);
    B(to, to) = B(to, to) + (1 / x);
    B(from, to) = -1 / x;
    B(to, from) = B(from, to);
end

% Remove Swing Bus Data (Swing Bus = 1)
B(1,:) = [];
B(:, 1) = [];

X(2:busnum, 2:busnum) = B^-1;
