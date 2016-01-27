% @author: Saeed Motedaveli

function busdata = getbusdata()

%         |Bus | Type | Vsp | theta | PGi | QGi | PLi | QLi |  Qmin | Qmax |
busdata =  [1     1    1.05    0       0     0     0     0       0       0;
            2     2    1.05    0      50     0     0     0       0       0;
            3     2    1.07    0      60     0     0     0       0       0;
            4     3    1.0     0       0     0     70    70      0       0;
            5     3    1.0     0       0     0     70    70      0       0;
            6     3    1.070   0       0     0     70    70      0       0];
