---
title: "README"
date: "2020-05-25"
author: Ivan Dai
output: html_document
---

* * *


### Introduction to the Repo

This repo is using the data from the UCI data base. The repo include several files. The database is about the signals of human status. The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used.

However, the purpose of the repo is try to clean and summarise the data UCI provided. You can find **three data set** in this repo: "Each_activity_data_Set.txt", "Each_subject_data_Set.txt","Required_data_Set.txt". They are tidy and cleaned data set. Also, you can find this **README** file and a codebook to explain the features / variables in the *"Required_data_Set.txt"*.
* * *

### Introduction to the files in Repo

**README.md:**: Introduction to Repo, R scripts, and the other files.

**CodeBook.md:**: Introduce the vairable.

**run_script.R**: The process of cleaning the data.

**Each_activity_data_Set.txt**: The data set groups by activity.

**Each_subject_data_Set.txt**:The data set groups by subject.

**Required_data_Set.txt**:The data set groups by interaction of activity and sunject.


* * *

### run_anaylsis.R 


#### Loading Needed Package

library(dplyr)

library(data.table)


#### Import the Training Data

training_data = read.table("X_train.txt" )

training_actIndex = read.table("y_train.txt")

training_SubjectIndex = read.table("subject_train.txt")

#### Import the Testing Data

testing_data = read.table("X_test.txt" )

testing_actIndex = read.table("y_test.txt")

testing_SubjectIndex = read.table("subject_test.txt")

#### Import the columns names

col_names = read.table("features.txt")

#### Operaion on the training Data set:

col_names = col_names[,2]

col_names = as.character(col_names)

colnames(training_data)[] = col_names ## *Changing the columns names*

training_data = cbind(training_actIndex,training_SubjectIndex,training_data) ## *add the Index variables*

colnames(training_data)[c(1,2)] = c("Activity_Index","Subject_Index") ## *rename the new variables*


#### Operaion on the testing Data set:

colnames(testing_data)[] = col_names ## Changing the columns names

testing_data = cbind(testing_actIndex,testing_SubjectIndex,testing_data) ## *add the Index variables*

colnames(testing_data)[c(1,2)] = c("Activity_Index","Subject_Index") ## *rename the new variables*


#### Combining Two data Sets:

merged_data = rbind(training_data,testing_data)

#### Extract the variable about mean and std:

name = names(merged_data)

index = grep("[Mm]ean|std|Index",name)

extracted_data = merged_data[index]


#### Rename the activity index:

extracted_data$Activity_Index =factor(extracted_data$Activity_Index)

levels(extracted_data$Activity_Index) = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                                          "SITTING","STANDING","LAYING")

#### The mean of each activity

extracted_data = as.data.table(extracted_data)

Each_Activity = extracted_data[ ,!2]

Each_Activity = Each_Activity %>%

        group_by(Activity_Index) %>%
        
        summarise_all(list(MEAN = mean))

#### The mean of each subject

Each_Subject = extracted_data[,!1]

Each_Subject$Subject_Index = factor(Each_Subject$Subject_Index)

Each_Subject = Each_Subject %>%

        group_by(Subject_Index) %>%
        
        summarise_all(list(MEAN = mean))

#### Combining these two tables

Each_ACT_SUB = extracted_data

Each_ACT_SUB$Subject_Index = factor(Each_ACT_SUB$Subject_Index)

Each_ACT_SUB = Each_ACT_SUB %>%

        group_by(Activity_Index,Subject_Index) %>%
        
        summarise_all(list(MEAN = mean))

#### Output 

write.table(Each_Activity,row.names = FALSE,file = "Each_activity_data_Set.txt")

write.table(Each_Subject,row.names = FALSE,file = "Each_subject_data_Set.txt")

write.table(Each_ACT_SUB,row.names = FALSE,file = "Required_data_Set.txt")

read.table("Required_data_Set.txt",header = TRUE)



* * *

### Notes

Features are normalized and bounded within [-1,1].

Each feature vector is a row on the text file.

* * *

### License:

Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.



