##Reading activity labels and features
activitylabels<-read.table("activity_labels.txt",header = FALSE)
features<-read.table("features.txt",header = FALSE)

##Reading test data
subject_test<-read.table("subject_test.txt",header = FALSE)
X_test<-read.table("X_test.txt",header = FALSE)
y_test<-read.table("y_test.txt",header = FALSE)

##reading training data
subject_train<-read.table("subject_train.txt",header = FALSE)
X_train<-read.table("X_train.txt",header = FALSE)
y_train<-read.table("y_train.txt",header = FALSE)


##Giving column names to test data
colnames(activitylabels)<-c('activityID','activity')
colnames(subject_test)<-'subID'
colnames(X_test)<-features[,2]
colnames(y_test)<-"activityID"

##Giving column names to training data
colnames(subject_train)<-'subID'
colnames(X_train)<-features[,2]
colnames(y_train)<-"activityID"

##Combining all test data
test_data<-cbind(subject_test, X_test, y_test)

##Combining all training data
training_data<-cbind(subject_train, X_train, y_train)

##Merging test and training data
final_dataset<-rbind(training_data, test_data)
columns<-colnames(final_dataset)

extractvar<-(grepl(".-mean().", columns)&!grepl("-meanFreq().", columns)|grepl(".-std().", columns)|grepl('activity..', columns)|grepl("sub..", columns))

##Subsetting data with mean and standard deviation columns 
final_dataset<-final_dataset[extractvar]

##Descriptive activity names
final_dataset$activityID<-factor(final_dataset$activityID,labels=activitylabels$activity, levels= activitylabels$activityID)

##Descriptive variable names
names(final_dataset)<-gsub("^t","Time ", names(final_dataset))
names(final_dataset)<-gsub("Acc"," Accelerometer ", names(final_dataset))
names(final_dataset)<-gsub("Gyro"," Gyroscope ", names(final_dataset))
names(final_dataset)<-gsub("^f","Frequency ", names(final_dataset))
names(final_dataset)<-gsub("Mag"," Magnitude ", names(final_dataset))
names(final_dataset)<-gsub("BodyBody","Body", names(final_dataset))

##Creating tidy data
Tidy_data<-aggregate(.~ subID + activityID, final_dataset, mean )

##Writing tidy data into text file
write.table(Tidy_data, file = "Tidy_data.txt",row.names = FALSE, sep = "\t")