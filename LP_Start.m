% Power Generation Operation - Wood
% Solve Example 11-C
% @author: Saeed Motedaveli

clc;

% Lines with overload
%               Line        Pl0         Plmax
overloadLines = [2          41.6        36.0
                 9          44.9        40.0];

% Bus that have gnarator
%       unit    Pmin      P0      Pmax
units = [1      50.0      100     200
         2      37.5       50     150
         3      45.0       60     180];

% min 100ΔP1(+) + 100ΔP1(-) +100ΔP2(+) + 100ΔP2(-) + 100ΔP3(+) + 100ΔP3(-)
f = 100 * [1 1 1 1 1 1];

% s.t.  ΔP1(+) - ΔP1(-) + ΔP2(+) - ΔP2(-) + ΔP3(+) - ΔP3(-) = 0
Aeq = [1 -1 1 -1 1 -1];
beq = 0;

% s.t. (for line 2)    a1 * ΔP1(+) - a1 * ΔP1(-)
%                    + a2 * ΔP2(+) - a2 * ΔP2(-)
%                    + a3 * ΔP3(+) - a3 * ΔP3(-) <= Pmax - Pl0
%
%      (for line 9)    a1 * ΔP1(+) - a1 * ΔP1(-)
%                    + a2 * ΔP2(+) - a2 * ΔP2(-)
%                    + a3 * ΔP3(+) - a3 * ΔP3(-) <= Pmax - Pl0

a = calcGSF();
a2 = a(2, :);       % a for line 2
a9 = a(9, :);       % a for line 9

A = [a2(1) -a2(1) a2(2) -a2(2) a2(3) -a2(3)
     a9(1) -a9(1) a9(2) -a9(2) a9(3) -a9(3)];

b2 = overloadLines(1, 3) - overloadLines(1, 2);
b9 = overloadLines(2, 3) - overloadLines(2, 2);
b = [b2 b9];

% s.t.   0 <= ΔPi(+) <= Pi(max) - Pi(0)
%        0 <= ΔPi(-) <= Pi(0) - Pi(min)
P0 = units(:, 3);
Pmax = units(:, 4);
Pmin = units(:, 2);

lb = [0 0 0 0 0 0];
ub = [Pmax(1) - P0(1) P0(1) - Pmin(1) Pmax(2) - P0(2) P0(2) - Pmin(2) Pmax(3) - P0(3) P0(3) - Pmin(3)];

% x0
x0 = [];

% Calculate ΔPi(+) and ΔPi(-)
x = linprog(f,A,b,Aeq,beq,lb,ub,x0);

n = 1;
for i = 1 : length(x)
    if mod(i, 2) == 1
        fprintf(['\n  ΔP', int2str(n), '(+) = %0.4f'], x(i));
    else
        fprintf(['\tΔP', int2str(n), '(-) = %0.4f'], x(i));
        n = n + 1;
    end
end

fprintf('\n\n\n');
fprintf(' unit\t%8s\t%8s\t%8s', 'P(old)', 'ΔP', 'P(new)');
fprintf('\n---------------------------------------------------\n');

for i = 1 : length(units(:, 1))
    fprintf('   %d\t', units(i, 1));
    fprintf('%8.4f\t', units(i, 3));
    
    if floor(x(2 * (i-1) + 1)) > 0
        dp = x(2 * (i-1) + 1);
    else
        dp = -x(2 * i);
    end
    
    fprintf('%8.4f\t', dp);
    fprintf('%8.4f\n', units(i, 3) + dp);
end
fprintf('\n\n');
