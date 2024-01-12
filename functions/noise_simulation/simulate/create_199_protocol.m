function [bval_199, bvec_199] = create_199_protocol()

x = 1 / sqrt(2);

n1= [1;0;0];
n1plus = [0; x;  x ];
n1minus = [0; x; -x];

n2= [0;1;0];
n2plus = [x; 0;  x ];
n2minus = [x; 0; -x];


n3= [0;0;1];
n3plus = [x; x;  0 ];
n3minus = [x; -x; 0];

nzero = [0;0;0];

bvecs_199_shell = [n1,n1plus,n1minus, n2,n2plus,n2minus, n3, n3plus, n3minus ];

bvec_199 =[nzero,bvecs_199_shell,bvecs_199_shell];

bval0 = 0;
bval1 = 1.1*ones(1,9);
bval2 = 2.5*ones(1,9);

bval_199 = [bval0,bval1,bval2];

end