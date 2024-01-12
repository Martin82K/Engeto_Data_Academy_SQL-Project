# Engeto SQL Research

## Introduction to the Project

In your analytical department of an independent company that deals with the standard of living of citizens, you have agreed to try to answer a few defined research questions that address the availability of basic food to the general public. Colleagues have already defined the basic questions to which they will try to answer and provide this information to the press department. This department will present the results at the following conference focused on this area.

They need you to prepare robust data bases in which it will be possible to see a comparison of food availability based on average incomes for a certain period of time.

As additional material, prepare a table with GDP, GINI coefficient, and the population of other European countries in the same period, as a primary overview for the Czech Republic.

### RESEARCH QUESTIONS:

1. Are wages increasing over the years in all sectors, or are they decreasing in some?
2. How many liters of milk and kilograms of bread can be bought for the first and last comparable period in the available data of prices and wages?
3. Which food category is getting more expensive the slowest (i.e., it has the lowest annual percentage increase)?
4. Is there a year in which the annual increase in food prices was significantly higher than wage growth (more than 10%)?
5. Does the level of GDP affect changes in wages and food prices? In other words, if GDP increases significantly in one year, will this be reflected in food prices or wages in the same or following year with a more significant increase?

### Data Preparation

First, we will create a dataset by combining the available data from the Engeto database. This will ensure proper functionality. Before running the scripts to answer the research questions, please run these scripts first:

```
primary_dataset.sql
secondary_dataset.sql
```

### ANSWER Q1:

To obtain the answer, we always compared the values with the previous year. In the case of a decrease, a condition about reduced salary was taken into account, according to which only those records were obtained where and in which year the decrease actually occurred.
![Q1 answer](images/A1_output_demo.png)

### ANSWER Q2:

### ANSWER Q3:

### ANSWER Q4:

### ANSWER Q5:
