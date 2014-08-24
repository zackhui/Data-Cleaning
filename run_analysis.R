#Download the file and unzip it
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl,destfile="dataset.zip",mode="wb")
unzip("dataset.zip")
dir()
setwd("./UCI HAR Dataset")
#Read the training set
train_label<-scan("./train/y_train.txt",sep=" ")
train_subject<-scan("./train/subject_train.txt",sep=" ")
train<-scan("./train/X_train.txt",sep=" ")
train<-train[!is.na(train)]
train<-data.frame(matrix(train,length(train)/561,561))
train$label<-train_label
train$subject<-train_subject
#Read the test set in a same way
test_label<-scan("./test/y_test.txt",sep=" ")
test_subject<-scan("./test/subject_test.txt",sep=" ")
test<-scan("./test/X_test.txt",sep=" ")
test<-test[!is.na(test)]
test<-data.frame(matrix(test,length(test)/561,561))
test$label<-test_label
test$subject<-test_subject
#Merge the data and name it with the 561 labels
mergeData<-rbind(train,test)
features<-scan("features.txt",what=character(),sep="\t")
colnames(mergeData)[1:561]<-features
#Replace the activity label's digits with strings
#and set it and as factor
activity_labels<-scan("activity_labels.txt",what=character(),sep="\t")
mergeData$label<-sapply(mergeData$label,function(x) x<-activity_labels[x],simplify=T)
mergeData$label<-as.factor(mergeData$label)
mergeData$subject<-as.factor(mergeData$subject)
#Extracts only the mean and standard deviations
mean_std<-mergeData[,grep("(.*mean[^Freq]|.*std)",names(mergeData))]
#Calculate the mean grouped by different subjects and labels
tidy_data<-data.frame("subject"=rep_len(mergeData$subject,180),"label"=rep_len(mergeData$label,180))
a<-sapply(1:561,function(x) by(mergeData[,x],mergeData[,562:563],mean))
tidy_data<-cbind(tidy_data,a)
colnames(tidy_data)[3:563]<-features
write.table(tidy_data,file="tidy_data.txt",sep=",",eol="\n",row.names=F)
