
%read in csv file for values
T = readtable('tester.csv');
%extract x and y values respectivley
x = table2array(T(:,"x"));
y = table2array(T(:,"y"));
%expand x values
neg_x = x.*-1;
dub_x = x.*2;
full_x = cat(1, neg_x, x, dub_x);
%plot motion path on it's own
figure(1)
plot(x, y);
grid on;
%open up another plot, used to check fulcrum point appears correct
figure(2)
plot(x, y);
xlim([0 400]);
ylim([0 400]);
grid on;
hold on;
%FIND TANGENTS TO LINE
dy = gradient(y,x); %find the numerical derivative
%find coordinates to draw tangents at
[min_x, min_index] = min(x);
min_y = y(min_index);
min_dy = dy(min_index);
[max_x, max_index] = max(x);
max_y = y(max_index);
[low_y, low_index] = min(y);
low_x = x(low_index);
max_dy = (max_y - low_y)/(max_x - low_x);
%find tangent lines and plot
min_tang_y = min_dy*full_x+(min_y - dy(min_index)*min_x);
plot(full_x, min_tang_y);
max_tang_y = max_dy*full_x+(max_y - max_dy*max_x);
plot(full_x, max_tang_y);
%plot perpendicular lines
min_perp_dy = -1/min_dy;
min_perp_c = min_y - min_perp_dy*min_x;
min_perp_y = min_perp_dy*full_x+min_perp_c;
plot(full_x, min_perp_y);
max_perp_dy = -1/max_dy;
max_perp_c = max_y - max_perp_dy*max_x;
max_perp_y = max_perp_dy*full_x+max_perp_c;
plot(full_x, max_perp_y);
%find the perpendicular lines intersect to get the fulcrum
fulc_x = (max_perp_c - min_perp_c)/(min_perp_dy - max_perp_dy);
fulc_y = max_perp_dy*fulc_x+max_perp_c;
plot(fulc_x,fulc_y,'o-','MarkerFaceColor','red','MarkerEdgeColor','red')
xlabel("x displacment (pixels)");
ylabel("y displacment (pixels)");
%find the angle between the lines
m1 = min_perp_dy;
m2 = max_perp_dy;
ang_dis = 180-atand((m1-m2)/(1+m1*m2));
%get video time and forearm length for velocity calc
vid_time = input("Enter length (in seconds) of the video clip being analysed: ");
forearm_length = input("Enter length (in m) of the forearm of the user in the video: ");
%generate velocities
vect_size = size(x);
vect_l = vect_size(1);
step = vid_time/vect_l;
v = zeros(vect_size);
v(1) = 0;
for i=2:size(x)
    v(i) = (x(i)-x(i-1))/step;
end
%scale to be in metres
forearm_pix = 0.5*(sqrt((min_x-fulc_x)^2+(min_y-fulc_y)^2)+sqrt((max_x-fulc_x)^2+(max_y-fulc_y)^2));
scale_fact = forearm_length/forearm_pix;
v = v.*scale_fact;
%plot graph
t_axis = transpose([0:1:vect_l-1]*step);
figure(3);
plot(t_axis,v);
%apply a median filter to remove some of the spikes due to video processing
plot(t_axis,medfilt1(v));
grid on;
hold on;
xlabel("Time (s)");
ylabel("End effector velocity (m/s)");