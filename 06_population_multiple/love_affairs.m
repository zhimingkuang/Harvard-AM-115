% Phase portrait plots of love affairs from Strogatz 
% section 5.3 and corresponding questions at end of chapter.
% APM 115
% Authors: Eli Tziperman and Zhiming Kuang
clf; clear all
 
a=0;b=1;c=-0.5;d=0; %cycle of love and hate, Romeo loves J more when J loves R, but J does the opposite

i=0;
for J=-10:1:10
  i=i+1;
  j=0;
  for R=-10:1:10
    j=j+1;
    RR(i,j)=R;
    JJ(i,j)=J;
    u(i,j)=a*R+b*J;
    v(i,j)=c*R+d*J;
  end
end

A=[a b; c d];
[V,D] = eig(A);
V
D

% plot arrows in phase plane:
quiver(RR,JJ,u,v)
h(1)=title('Romeo and Juliete; red and green: the two eigenvectors');
h(2)=xlabel('R');
h(3)=ylabel('J');
h(4)=gca;
set(h,'FontSize',18)
hold on
vmax=12;
V=V*vmax;

% plot axes:
h=plot([0 0],[-vmax vmax]); set(h,'Color',[0.8 0.8 0.8],'LineWidth',5)
h=plot([-vmax vmax],[0 0]); set(h,'Color',[0.8 0.8 0.8],'LineWidth',5)
% plot eigenvectors:
hold on
plot(real([-V(1,1) V(1,1)]),real([-V(2,1) V(2,1)]),'g','LineWidth',2)
hold on
plot(real([-V(1,2) V(1,2)]),real([-V(2,2) V(2,2)]),'r','LineWidth',2)
axis([-vmax vmax -vmax vmax])