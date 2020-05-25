## Loading Needed Package

library(dplyr)
library(data.table)

## Import the Training Data

training_data = read.table("X_train.txt" )
training_actIndex = read.table("y_train.txt")
training_SubjectIndex = read.table("subject_train.txt")

## Import the Testing Data

testing_data = read.table("X_test.txt" )
testing_actIndex = read.table("y_test.txt")
testing_SubjectIndex = read.table("subject_test.txt")

## Import the columns names

col_names = read.table("features.txt")

## Operaion on the training Data set:

col_names = col_names[,2]
col_names = as.character(col_names)
colnames(training_data)[] = col_names ## Changing the columns names
training_data = cbind(training_actIndex,training_SubjectIndex,training_data) ## add the Index variables
colnames(training_data)[c(1,2)] = c("Activity_Index","Subject_Index") ## rename the new variables


## Operaion on the testing Data set:

colnames(testing_data)[] = col_names ## Changing the columns names
testing_data = cbind(testing_actIndex,testing_SubjectIndex,testing_data) ## add the Index variables
colnames(testing_data)[c(1,2)] = c("Activity_Index","Subject_Index") ## rename the new variables


## Combining Two data Sets:

merged_data = rbind(training_data,testing_data)

## Extract the variable about mean and std:

name = names(merged_data)
index = grep("[Mm]ean|std|Index",name)
extracted_data = merged_data[index]

## Rename the activity index:

extracted_data$Activity_Index =factor(extracted_data$Activity_Index)
levels(extracted_data$Activity_Index) = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                                          "SITTING","STANDING","LAYING")

## The mean of each activity

extracted_data = as.data.table(extracted_data)
Each_Activity = extracted_data[ ,!2]
Each_Activity = Each_Activity %>%
        group_by(Activity_Index) %>%
        summarise_all(list(MEAN = mean))

## The mean of each subject

Each_Subject = extracted_data[,!1]
Each_Subject$Subject_Index = factor(Each_Subject$Subject_Index)
Each_Subject = Each_Subject %>%
        group_by(Subject_Index) %>%
        summarise_all(list(MEAN = mean))

## Combining these two tables

Each_ACT_SUB = extracted_data
Each_ACT_SUB$Subject_Index = factor(Each_ACT_SUB$Subject_Index)
Each_ACT_SUB = Each_ACT_SUB %>%
        group_by(Activity_Index,Subject_Index) %>%
        summarise_all(list(MEAN = mean))

## Output 
write.table(Each_Activity,row.names = FALSE,file = "Each_activity_data_Set.txt")
write.table(Each_Subject,row.names = FALSE,file = "Each_subject_data_Set.txt")
write.table(Each_ACT_SUB,row.names = FALSE,file = "Required_data_Set.txt")
read.table("Required_data_Set.txt",header = TRUE)

