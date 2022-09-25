here::i_am("data/preprocess.R", uuid = "02949f5a-2a6a-11ed-85a8-b55cd582192c")
library(here)

## Required Packages 
library(ordinalForest)
library(UBL) #dataset balancing with SMOTE
library(rsample) #train/test split
library(magrittr)

red <- read.table(here("data/raw_data/winequality-red.csv"), 
colClasses=c(rep("numeric", 11), "factor"), dec=".", sep=";", header=TRUE)

#inspect
str(red)
table(red$quality)

set.seed(123)

### train/test split

makesplit <- initial_split(red, prop=0.8, strata="quality")
traindata <- training(makesplit)
testdata <- testing(makesplit)

#I'll use the SMOTE algorithm to produce a balanced training dataset. 
#factor levels have to be renamed for the C.per parameter to work
traindata$quality <- factor(traindata$quality, levels = c(3, 4, 5, 6, 7, 8), 
                       labels = c("three", "four", "five", "six", "seven", "eight")) 

res_train <- SmoteClassif(quality ~.,traindata, 
                        C.perc=list(three=(70/10), four=(70/53),
                                    five=(70/681), six=(70/638), 
                                    seven=(70/199), eight=(70/18)), 
                                    dist="HVDM") #"Euclidean" doesn't work with nominal features

table(res_train$quality)
levels(res_train$quality) <- c("1","2","3","4","5","6")

table(res_train$quality)
#table(res_red$quality) %>% prop.table()

### shuffle observations

train_data <- res_train[sample(1:nrow(res_train)),]
test_data <- testdata[sample(1:nrow(testdata)),]

#save data
write.table(train_data,file=here("data/preprocessed_data/OF_traindata.dat"))
write.table(test_data,file=here("data/preprocessed_data/OF_testdata.dat"))
