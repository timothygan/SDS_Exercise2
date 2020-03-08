Exercise\_2
================

## GitHub Documents

This is an R Markdown format used for publishing markdown documents to
GitHub. When you click the **Knit** button all R code chunks are run and
a markdown file (.md) suitable for publishing to GitHub is generated.

## KNN Practice

We wil be using the K-nearest neighbors technique to predict the price
of Mercedes S Class vehicles based on gas mileage. We will be
distinguishing these S Class vehicles by trim. In particular, we will be
focusing on just two values of trim: 350 and 65 AMG, and finding optimal
values of K for predicting the price of each.

### KNN functions for 350 trim vehciles

    ## [1] 416  17

![](Exercise_2_files/figure-gfm/sclass_350-1.png)<!-- -->

    ## [1] 12840.47

![](Exercise_2_files/figure-gfm/sclass_350-2.png)<!-- -->

    ## [1] 11145.72

![](Exercise_2_files/figure-gfm/sclass_350-3.png)<!-- -->

    ## [1] 10836.89

Here we plot the average RMSE for each value of K from 3 to 250, and
find that the optimal value of K is 40

![](Exercise_2_files/figure-gfm/sclass_350_2-1.png)<!-- -->

### 65 AMG

    ## [1] 292  17

![](Exercise_2_files/figure-gfm/sclass_65-1.png)<!-- -->

    ## [1] 21548.25

![](Exercise_2_files/figure-gfm/sclass_65-2.png)<!-- -->

    ## [1] 18415.24

![](Exercise_2_files/figure-gfm/sclass_65-3.png)<!-- -->

    ## [1] 21996.04

Here we plot the average RMSE for each value of K from 3 to 200, and
find that the optimal value of K is 22

![](Exercise_2_files/figure-gfm/sclass_65_2-1.png)<!-- -->

### Conclusion

The optimal value of K is larger for the 350 trim vehicles than the 65
AMG. One explanation for this is that the sample set of 350 trim
vehichles is also larger than the set of 65 AMG vehicles. As the value
of K gets closer to the size of the entire sample, KNN becomes less
useful in estimating the price for a specific mileage value.
