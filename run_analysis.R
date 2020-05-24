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
