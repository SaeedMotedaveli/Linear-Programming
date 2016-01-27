% Calculate "Generation Shift Factors"
% @author: Saeed Motedaveli

function a = calcGSF()

X = calcX();

% get buses that have generator
busdata = getbusdata();
bustype = busdata(:, 2);

Ng = 0;
Bg = zeros(length(busdata(:, 1)), 1);
for n = 1 : length(busdata(:, 1))
    if bustype(n) == 1 || bustype(n) == 2
        Ng = Ng + 1;
        Bg(n) = busdata(n, 1);
    end
end

% get Line data
linedata = getlinedata();
Nl = length(linedata(:, 1));
from = linedata(:, 1);
to = linedata(:, 2);
X_line = linedata(:, 4);

a = zeros(Nl, Ng);

for n = 1 : Nl
    for j = 1 : Ng
        a(n, j) = (1 / X_line(n)) * (X(from(n), j) - X(to(n), j));
    end
end
