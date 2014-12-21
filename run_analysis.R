
# Step 1: Merges the training and the test sets to create one data set.
dir = "UCI HAR Dataset"
mpath = function(file){paste(dir, file, sep="/")}

f_labels = read.table(mpath("features.txt"))
f_labels = as.character(f_labels$V2)

mydata = data.frame()

for(set in c("train", "test")){


  Xdata = read.table(mpath(paste(set, "/X_", set, ".txt", sep="")))
  colnames(Xdata) = features
  
  activities = read.table(mpath(paste(set, "/y_", set, ".txt", sep = "")))
  colnames(activities) = c("Activity")
  
  subjects = read.table(mpath(paste(set, "/subject_", set, ".txt", sep= "")))
  colnames(subjects) = c("Subject")
  
  mydata = rbind(mydata, cbind(subjects, activities, Xdata))

}

# Step 2: Extracts only the measurements on the mean and standard deviation for each measurement.

n_labels1 = grep("-mean", colnames(mydata))
n_labels2 = grep("-std", colnames(mydata))
n_labels = sort(c(1, 2, n_labels1, n_labels2))

mydata = mydata[, n_labels]

# Step 5: creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data = aggregate(mydata, list(mydata$Subject, mydata$Activity), FUN="mean")
tidy_data = tidy_data[, 3:83]
act_labels = read.table(mpath("activity_labels.txt"))
colnames(act_labels) = c("Activity", "Activity_Name")
tidy_data = merge(tidy_data, act_labels, by = "Activity")
tidy_data = tidy_data[, c(2, 82, 3:81)]
write.table(tidy_data, "tidy_dataset.txt", row.name=FALSE)


