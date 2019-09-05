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
Can we predict snowfall in March based on current year's snowfall? To do this, let's create a regression model that attempts to predict March snowfall based on a combination of linear predictors of OCT,NOV,DEC,JAN, and FEB (the months that precede March). Because of these differences between early and late eras, we know we probably shouldn't use the oldest data, so let's make one model for the entire data set, and a second model for just the modern era.

Now, after creating the model and looking at the summary() we see that overall model is interesting, but not very encouraging. The reliability of the parameters seems to improve as we get closer to March, and February is the only one that is reliable. It would be good to get rid of some of these other predictors to give us more stable estimates.
![mar_snow](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/mar_snow.PNG)

Let's do that for a model that uses only the late-era data and compare them all with ANOVA table. Each model provides a fit no worse than the model one parameter bigger. as a check, I also compared the smallest model with the biggest, which showed that there is no reliable difference between these two models.
So can we place confidence regions around our prediction? The predict function will report two kinds of confidence regions for us and the results disagree substantially, and neither seems very appropriate. This is an area of research where there is no consensus.

### Predictions based on el nino and sunspots records
The only thing we can do to improve the model is to add more predictors. Monthly records of the the South Pacific El Nino/La Nina oscillation activity go back to the 1880s. Also, monthly records of sunspot counts go back hundreds of years. Maybe knowing about these predictors will be helpful?
![cor](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/cor.PNG)

Comparison of snowfall, sunspots, and el nino activity across years
![compare_3](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/compare_3.PNG)

It would be nice to fit the annual trend as a polynomial, to hopefully factor the mean level out.
![sum_model](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/sum_model.PNG)

R-squared is .52 with just year-polynomial. Now, trying different models.

![model2a](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/model2a.PNG)
R-squared is almost same as the above model.

![model2b](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/model2b.PNG)
R-squared improves to 0.573, but is it fair? So I calculated the correlation and it came out to be 0.529 so, not really an improvement.

Let's look at the residuals, and we see that residuals are highly correlated with annual elnino, but not previous summer's.
![resid](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/resid.PNG)

Maybe we can gain a little by using the information we have.  We will continue to make two separate models.
![com3ab](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/com_3ab.PNG)

Looks like there are normal periodic devations
![npd](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/npd.PNG)

The master prediction with three reliable predictors
![anova1](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/anova1.PNG)
![anova2](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/anova2.PNG)

Finally the prediction of 2019 Snowfall

![2019](https://github.com/prateekkr94/Exploratory-Data-Analysis/blob/master/Predicting%20Snowfall/Snaps/2019.PNG)

The R-square value is found to be 0.8167, hence the model is nearly accurate.
