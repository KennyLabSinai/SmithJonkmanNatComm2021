%Richard M. O'Connor
%this function creates plots of traces read from a .csv file 
%csv file needs to be set up in the following format
%Row_1 contains the ROI number (minus the top left value - this is blank)
%All subsequent rows contain ROI flourescent values
%Column_1 contains the corresponding time stamp for each ROI flourescent
%value
%All subsequent columns are individual ROIs
%The x axis limits are set by user using the input arguments t1 and t2
%line to be drawn at a specific time point are set by the user using th3
%argument event

function tp3(file_name, t1, t2, event)


%Read the file and create an array x containg the data from the .csv file
x = csvread(file_name, 0,0);
%Creates a vector containing all ROI numbers
y = x(1,2:end);
%Removes the first row from the array x
x(1,:)=[];

%Creates an offset allowing indivdual ROIs to be seen on the same plot
%Values increasing by 10 are added to each subsequent ROI so that ROI_n =
%ROI_n + n*10
%e.g. ROI_1 = ROI_1 + 0*10, ROI_2 = ROI_2 + 1*10, ROI_3 = ROI_3 + 2*10 etc.
for i = y
    x(1:1:end, i) =  x(1:1:end, i) + (i*10);
end


%Specificies the first column (time as the x-axis)
xaxis = x(:,1);

%Specifiy which columns to plot
% plot(x(:,2:1:end)) will plot all ROIs
plot(xaxis, x(:,2:1:end));

%Specify the axis boundries [x1,x2,y1,y2]
%t1 and t2 sets the time boundries (x-axis)
%'inf' allows MATLAB to automatically set the y axis limit



axis([t1,t2,-2, inf]);



%This draws a line at the tme set by argument event
%*Need to figure out how to automatically set the limit of the line
line([event event], [-2,750]);


%This line removes the x and y axis and the border from the figure
%set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])

%This block creates a smaller offset figure to creat the axis
%Needs to be modified to match the main figure axis - posibly by matching
%the plot to a specified amount of the larger figure e.g. 0.2
uistack(axes('Position',[.1 .05 .2 .2]), 'down')
plot(x(:,2:1:end))
axis([0,5,0, 5]);


end