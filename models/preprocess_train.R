here::i_am("models/preprocess_train.R", uuid = "02949f5a-2a6a-11ed-85a8-b55cd582192c")
library(here)

## Required Packages 
library(ordinalForest)
library(UBL) #dataset balancing with SMOTE
library(rsample) #train/test split
library(magrittr)

red <- read.table(here("models/raw_data/winequality-red.csv"), 
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
write.table(train_data,file=here("models/preprocessed_data/OF_traindata.dat"))
write.table(test_data,file=here("models/preprocessed_data/OF_testdata.dat"))

#train and save OF for class probability prediction with default settings
forest1 <- ordfor(depvar="quality", data=train_data, perffunction="probability")
save(forest1, file=here("models/forest1.rda"))

print("trained and saved forest1")

#train and save OF with "always.split.variables = c("residual.sugar")"
#This will force the algorithm to "consider" the parameter residual.sugar 
#at every split in addition to the mtry candidate parameters for splitting

forest2 <- ordfor(depvar="quality", data=train_data, perffunction="probability",
                  always.split.variables = c("residual.sugar"))
save(forest2, file=here("models/forest2.rda"))

print("trained and saved forest2")

