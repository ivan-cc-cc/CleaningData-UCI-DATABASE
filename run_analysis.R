## Loading Needed Package

library(dplyr)

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
index = grep("mean|std|Index",name)
extracted_data = merged_data[index]

## Rename the activity index:

extracted_data$Activity_Index =factor(extracted_data$Activity_Index)
levels(extracted_data$Activity_Index) = c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                                          "SITTING","STANDING","LAYING")

## Second Table


