addpath('C:\Users\bryan\Desktop\mattlabutil/matlab_utils')

close all
clc
figure('position', [850, 300, 450, 350])
theta ={0,90,0,30,90,0};
q ={};
for i = 1:6
    q{i} = deg2rad(theta{i});
end


S ={};
S{1} = zeros(6,1); S{1}(3) = 1;
S{2} = zeros(6,1); S{2}(2) = 1;
S{3} = zeros(6,1); S{3}(2) = 1;
S{4} = zeros(6,1); S{4}(1) = 1;
S{5} = zeros(6,1); S{5}(2) = 1;
S{6} = zeros(6,1); S{6}(1) = 1;

p ={};
p{1} = [0; 0; 0.15 ];
p{2} = [0.3; 0; 0 ];
p{3} = [0.15; 0; 0 ];
p{4} = [0.1; 0; 0 ];
p{5} = [0.07; 0; 0 ];
p{6} = [0.05; 0; 0 ];



T_des = SE3(ZYXRot(pi/2,0,0), [0.2; 0.31; 0.2]);
figure
hold on
num_step = 1;
for step = 1:num_step
    T0 = make_SE3_wrt_global(q,p);
    J = zeros(6,6);
    for i = 1:6
        J(:,i) = Adj(inv(inv(T0{i})*T0{7}))*S{i};
    end
    T07_rot = T0{7}
    T07_rot(1:3,4) = zeros(3,1)
    J = Adj(T07_rot)*J;
    err = zeros(6,1);
    err(1:3) = S03toso3vec(T_des(1:3,1:3)*T0{7}(1:3,1:3)');
    err(4:6) = T_des(1:3,4) - T0{7}(1:3,4);
    for i = 1:6
        q{i} = q{i} + 0.2*pinv(J)*err;
    end
    
    if norm(err) < 0.001
        break
    end
end
x  = {}

for i = 1: 6
    x{i}= T0{i}* [p{i};1];
end

drawLine3D([0,0,0],x{1}(1: 3));


for i = 2: 6
    drawLine3D(x{i-1}(1:3),x{i}( 1:3)) ;
end

xlabel('$x$','interpreter','latex','fontsize', 20)
ylabel('$y$','interpreter','latex','fontsize', 20)
zlabel('$z$','interpreter','latex','fontsize', 20)


view(100,100)






function x = SE3(r,t)
    row3 = [0,0,0,1];
    x = [r, t; row3];
end
function mat = ZYXRot(th_z,th_y,th_x)
    R_z = [cos(th_z), -sin(th_z), 0;
            sin(th_z), cos(th_z), 0;
            0, 0, 1];
    R_y = [cos(th_y), 0, sin(th_y);
            0, 1, 0;
            -sin(th_y), 0, cos(th_y)];

    R_x = [1, 0, 0;
           0, cos(th_x), -sin(th_x);
           0, sin(th_x), cos(th_x)];
    mat = R_z*R_y*R_x;
end
function y = SE3timesSE3(m1,m2)
    y = m1*m2;
end
function z = invertSE3(mat)
    z = inv(mat);
end
function mat = make_SE3_wrt_global(q,p) 

    T01 = SE3(ZYXRot(q{1},0,0),[0;0;0]);
    T12 = SE3(ZYXRot(0,q{2},0),p{1});
    T23 = SE3(ZYXRot(0,q{3},0),p{2});
    T34 = SE3(ZYXRot(0,0,q{4}),p{3});
    T45 = SE3(ZYXRot(0,q{5},0),p{4});
    T56 = SE3(ZYXRot(0,0,q{6}),p{5});
    Tee = SE3(ZYXRot(0,0,0),p{6});

    T0 ={};
    T0{1} = T01;
    T0{2} = T0{1} * T12;
    T0{3} = T0{2} * T23;
    T0{4} = T0{3} * T34;
    T0{5} = T0{4} * T45;
    T0{6} = T0{5} * T56;
    T0{7} = T0{6} * Tee; 
    mat = T0;
end
    