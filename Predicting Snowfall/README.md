# Predicting the Houghton County Snowfall
The project was for the university wide competition inorder to predict the snowfall for the year. This work was influenced by topics taught in PSY5210 Adv Stats Analysis & Design 1.
Website: https://www.mtu.edu/alumni/favorites/snowfall/

The available data set has snowfall each of 8 winter months (October through May) in inches, each year since 1890. It contains each year in a row, and each month in a column.

### Data reading, management. Graphing the major trends
For the weather data set, looking at the snowfall across months of the year. Helping residents better understand the the snowfall patterns in Houghton, both within a year and historically

![Ice Cover](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/Ice_cover.PNG)
![Ice by month](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/Ice_by_month.PNG)

Snowfall in each month over the past 120 years
![Snow each month](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/Snow_each_month.PNG)

![Snow1](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/Snow1.PNG)
![Snow2](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/Snow2.PNG)

How might a transform work?
![Snow Trans](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/Snow_trans.PNG)

Cumulative Snowfall in each month over the past 120 years
![Cum snow](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/Cumulative_snow.PNG)

I'd like to fill in the area, and use a color gradient to color each month-region separately.
![Annual snow](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/Annual_snow.PNG)

### Climate Change?
There appears to be a shift in snowfall patterns over the past century, with an increase happening around 1920. Let's two time eras, one for the 30 years before 1920, and one for the 91 years after 1920. I'd like to conduct statistical tests that tell me (at p=.05) whether snowfall increased in each month of the year, or just some of the months. Also, I'd like to show a plot of the means of the early and late era by month, and use some graphical means to indicate which values differ reliably
![month view](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/month_view.PNG)

Notice that the months early and late in the season do not differ reliably between eras, but December through March do. Plotting these means, we can compare the snowfall across months for two eras.
![comparison](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/comparison.PNG)

### Did the snowiest month change?
It appears that in the 'old' era, December tended to get more snow than January, but this has switched. Conducting an appropriate statistical test determining whether each of these are reliable. Are these differences reliable?
Since we are comparing months of the same year, and because we know the overall weather trend has changed over time, we want to use a paired t test.
![t_test1](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/t_test1.PNG)

We can see that there is no difference in the early era, but there is a difference in the late era (p < 0.05). 
In this case, since the difference went from +1.88 to -6.81 inches, we might be fairly confident; after all, if this new difference is less than zero, it must also be less than 1.88. But, we don't know whether the old value was positive, and it could easily have been negative. So, we should do a specific test for this, which we could do using a regression or anova model. Because these data are sort of equivalent to a cross-tabulation table, we might use a chisquared test.
![chisq1](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/chisq1.PNG)

We can clearly see that the p-value is less than 0.05 and also the X-squared value is more than the degrees of freedom, this indicates strong evidence against the null hypothesis. Henceforth, we confirm that distribution of the snowfall did indeed change by era.

### Highest snowfall month
Since there seems to be this switch between December and January, maybe the time of winter in which the peak snowfall arrives has also switched. I'd like to calculate which month received the highest snowfall in each winter, and tabulate that over the two eras.
The data look like It looks like the distribution of peak snowfall has shifted later. We can test this with a chi squared test.
![highmonth](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/highmonth.PNG)

### Prediction: March Snowfall
