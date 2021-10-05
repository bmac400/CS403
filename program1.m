


%%



addpath('C:\Users\bryan\Desktop\mattlabutil/matlab_utils')

close all
clc
figure('position', [850, 300, 450, 350])
basePoint = [0,0,0];
baseOri = orientm(0,0,0);
SE3Base = SE3(baseOri,[0;0;0;]);
%th1 = 0;
%th2 = 120;
%th3 = 0;
%th4 = 60;
%th5 = 90;
%th6 = 0;

th1 = 0;
th2 = 90;
th3 = 0;
th4 = 30;
th5 = 90;
th6 = 0;

%th1 = 0;
%th2 = 60;
%th3 = 45;
%th4 = 60;
%th5 = 90;
%th6 = 0;

%th1 = 0;
%th2 = 90;
%th3 = 90;
%th4 = 30;
%th5 = 90;
%th6 = 0;





%th1 = 0;
%th2 = 90;
%th3 = 0;
%th4 = 30;
%th5 = 90;
%th6 = 0;

l1 = 0.15;
l2 = 0.3;
l3 = 0.15;
l4 = 0.1; 
l5 = 0.07;
l6 = 0.05;

xlim([-5, 5])
ylim([-5, 5])
zlim([-5, 5])
%make orientation matrixs.
or1 = orientm(th1,0,0);
or2 = orientm(0,th2,0);
or3 = orientm(0,th3,0);
or4 = orientm(0,0,th4); 
or5 = orientm(0,th5,0);
or6 = orientm(0,0,th6);
%make the frames
SE2 = SE3(or2,[l2;0;0;]);
T01 = SE3(or1,[0;0;l1;]) * SE3Base;
T12 = SE2 * T01;
T123 = SE3(or3,[l3;0;0;]) * T12;
T1234 = SE3(or4,[l4;0;0;]) * T123;
T12345 = SE3(or5,[l5;0;0;]) * T1234
T123456 = SE3(or6,[l6;0;0;]) * T12345


drawLine3D(basePoint,T01(1:3,4));
hold on
drawLine3D(T01(1:3,4),T12(1:3,4));
drawLine3D(T12(1:3,4),T123(1:3,4));
drawLine3D(T123(1:3,4),T1234(1:3,4));
drawLine3D(T1234(1:3,4),T12345(1:3,4));
drawLine3D(T12345(1:3,4),T123456(1:3,4));




xlabel('x', 'fontsize',22);
ylabel('y', 'fontsize',22);
zlabel('z', 'fontsize',22);
    
   

   
function mat = orientm(th_z,th_y,th_x)
    R_z = [ cos(th_z), -sin(th_z), 0;
            sin(th_z), cos(th_z), 0;
            0, 0, 1];
    R_y = [ cos(th_y), 0, sin(th_y);
            0, 1, 0;
            -sin(th_y), 0, cos(th_y)];

    R_x = [1, 0, 0;
           0, cos(th_x), -sin(th_x);
           0, sin(th_x), cos(th_x)];
    mat = R_z*R_y*R_x;
end
function x = SE3(r,t)
    row3 = [0,0,0,1];
    x = [r, t; row3];
end
function y = SE3timesSE3(m1,m2)
    y = m1*m2;
end
function z = invertSE3(mat)
    z = inv(mat);
end

 
