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

#resample

#I'll use the SMOTE algorithm to produce a balanced dataset. 
set.seed(123)

#factor levels have to be renamed for C.per parameter of SMOTE algorithm to work
red$quality <- factor(red$quality, levels = c(3, 4, 5, 6, 7, 8), 
                       labels = c("three", "four", "five", "six", "seven", "eight")) 

res_red <- SmoteClassif(quality ~.,red, 
                        C.perc=list(three=(70/10), four=(70/53),
                                    five=(70/681), six=(70/638), 
                                    seven=(70/199), eight=(70/18)), 
                                    dist="HVDM") #"Euclidean" doesn't work with nominal features

table(res_red$quality)
levels(res_red$quality) <- c("1","2","3","4","5","6")

table(res_red$quality)
#table(res_red$quality) %>% prop.table()

### train/test split

makesplit <- initial_split(res_red, prop=0.8, strata="quality")
traindata <- training(makesplit)
testdata <- testing(makesplit)

### shuffle observations

train_data <- traindata[sample(1:nrow(traindata)),]
test_data <- testdata[sample(1:nrow(testdata)),]

#save data
write.table(train_data,file=here("data/preprocessed_data/OF_traindata.dat"))
write.table(test_data,file=here("data/preprocessed_data/OF_testdata.dat"))
