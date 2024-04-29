%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MOTION PLOT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%read in csv file for values
T = readtable('demo4Combi.csv');
%extract x and y values respectivley
x = medfilt1(table2array(T(:,"x")));
y = medfilt1(table2array(T(:,"y")));
%extract fulcrum values
f_x = medfilt1(table2array(T(:,"xFulc")));
f_y = medfilt1(table2array(T(:,"yFulc")));
%fulc_x = mean(f_x);
%fulc_y = mean(f_y);
x = x-(f_x);
y = -(y);
%find the curve ends
[min_y, min_index] = min(y); %set minimum at the point where the lowest value of x occurs
min_x = x(min_index);
[max_y, max_index] = max(y); %set maximum at the point where the highest value of y occurs
max_x = x(max_index);
%expand x values
neg_x = x.*-1;
dub_x = x.*2;
full_x = cat(1, neg_x, x);
%get video time and forearm length for calcs
vid_time = input("Enter length (in seconds) of the video clip being analysed: ");
forearm_length = input("Enter length (in m) of the forearm of the user in the video: ");
arm = input("Enter which arm was used (0 for right, 1 for left): ");
%flip graph if left arm used
if (arm==1)
    x = -x;
end
%min_y = y(1);
%min_x = x(1);
%scale pixels into meters
forearm_pix = 0.5*sqrt((max_x-min_x)^2+(max_y-min_y)^2);
scale_fact = forearm_length/forearm_pix;
fulc_x = 0;
fulc_y = 0;
x_m = (x.*scale_fact);
y_m = (y.*scale_fact);
%plot motion path on it's own
figure(1)
plot((x_m), (y_m));
grid on;
%find the curve ends
[min_y, min_index] = min(y_m); %set minimum at the point where the lowest value of x occurs
min_x = x_m(min_index);
[max_y, max_index] = max(y_m); %set maximum at the point where the highest value of y occurs
max_x = x_m(max_index);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ANGULAR ESTIMATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot lines from fulcrum to maximum and minimum
dy_upper = (fulc_y-max_y)/(fulc_x-max_x);
x_upper_vals = (fulc_x-0.02):0.1:(max_x+0.02);
y_upper = dy_upper*x_upper_vals+(max_y - dy_upper*max_x);
dy_lower = (fulc_y-min_y)/(fulc_x-min_x);
x_lower_vals = (fulc_x-0.02):0.1:(min_x+0.02);
y_lower = dy_lower*x_lower_vals+(min_y - dy_lower*min_x);
%find the angle between the lines
m1 = dy_lower;
m2 = dy_upper;
ang_dis = 180 - atand((m1-m2)/(1+m1*m2));
figure(2)
%motion plot
plot(x_m,y_m);
hold on;
%xlim([0 300])
%ylim([0 300])
grid on;
%plot estimation lines
plot(x_upper_vals, y_upper);
plot(x_lower_vals, y_lower);
%plot fulcrum
plot(fulc_x,fulc_y,'o-','MarkerFaceColor','red','MarkerEdgeColor','red')
xlabel("x displacment (m)");
ylabel("y displacment (m)");
%plot max and min
plot(min_x*scale_fact,min_y*scale_fact,'x')
plot(max_x*scale_fact,max_y*scale_fact,'x')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%VELOCITY ESTIMATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generate velocities
vect_size = size(x);
vect_l = vect_size(1);
step = vid_time/vect_l;
v = zeros(vect_size);
v(1) = 0;
s_current = sqrt(x(1)^2+y(1)^2);
for i=2:size(x)
    s_old = s_current;
    s_current = sqrt((x(i-1)-x(i))^2+(y(i-1)-y(i))^2);
    y_direction = (sign(y(i)-y(i-1)));
    x_direction = (sign(x(i)-x(i-1)));
    if (y_direction == -1)
        direction = -1;
    elseif (x_direction == -1)
        direction = -1;
    elseif (y_direction == 1)
        direction = 1;
    elseif (x_direction == 1)
        direction = 1;
    else 
        direction = 0;
    end
    v(i) = (s_current/step)*direction;
    %if v(i)==0
        %v(i)= v(i-1);
    %end
end
%take local means
v_mean = movmean(v, 5);
%scale to be in metres
v = v.*scale_fact;
v_mean = v_mean.*scale_fact;
%plot graph
t_axis = transpose([0:1:vect_l-1]*step);
figure(3);
%apply a median filter to remove some of the spikes due to video processing
scatter(t_axis,v);
hold on;
%exclude first and last 10 points due to tracker instability
plot(t_axis(10:size(x)-5), medfilt1(v_mean(10:size(x)-5)), LineWidth = 3);
grid on;
ylim([-0.5 0.5]);
xlabel("Time (s)");
ylabel("End effector velocity (m/s)");
legend("Unfiltered data", "Filtered data");
