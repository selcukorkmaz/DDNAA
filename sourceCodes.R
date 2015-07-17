library(doParallel)
library(caret)

registerDoParallel(8)

ddimer = read.table(file = "ddimer.txt", header = T)
dim(ddimer)
class = ddimer[,1]
data.tmp = ddimer[,c(2,4)]

mu = colMeans(data.tmp)
sds = apply(data.tmp,2,sd)

###################################################
### chunk: Egitim ve test setlerinin olusturulmasi
###################################################
data = scale(data.tmp, center=TRUE, scale=TRUE)
inTrain = createDataPartition(class, p = 3/4, list = FALSE)
traindat = data[inTrain,]
testdat = data[-inTrain,]
traincl = class[inTrain]
testcl = class[-inTrain]
traincl = factor(traincl)
testcl = factor(testcl)
dim(traindat)
dim(testdat)

par(mfrow=c(1,2))
with(ddimer, plot(ddimer, lokosit, pch=21, bg=c("red","green")[grup + 1]))
with(ddimer, plot(ddimer, log(lokosit, 10), pch=21, bg=c("red","green")[grup + 1]))
legend("bottomright", legend=c("Not Needed", "Needed"), pch=21, pt.bg = c("red","green"))

ctrl = trainControl(method = "repeatedcv", number=10, repeats = 10)
nBoot = 101  ## number of bootstrap samples for bagging models

nb = train(traindat, traincl, method = "nb", tuneLength = 10, trControl = ctrl, 
           metric="Accuracy")
nb

rqda = train(traindat, traincl, method = "QdaCov", tuneLength = 10, trControl = ctrl, 
             metric="Accuracy")
rqda

#bagSVM <- train(traindat, traincl, method = "bag", B = 21, trControl = ctrl,
#               bagControl = bagControl(fit = svmBag$fit, predict = svmBag$pred, 
#                                       aggregate = svmBag$aggregate), tuneLength = 10)
#bagSVM

knn = train(traindat, traincl, method = "knn", tuneLength = 10, trControl = ctrl, 
             metric="Accuracy")
knn

## knn (bagging)
bagKNN.models = list()

for (b in 1:nBoot){
  print(paste("Bootstrap:  ", b, " / ", nBoot, sep=""))
  BRAW.OK = FALSE     ### Bootstrap örneklemine çıkan sınıf sayısı ile bootstrap çekilen 
  ### örneklemin sınıf sayısının eşit olmasını kontrol eden kısım.
  
  while (!BRAW.OK){
    sample.idx = sample(1:nrow(traindat), replace=TRUE)
    data.B = traindat[sample.idx,]
    cl.B = traincl[sample.idx]
    
    if (length(levels(cl.B)) == length(levels(traincl))){BRAW.OK = TRUE} 
  }
  
  train.B <- try(train(data.B, cl.B, method = "knn", tuneLength = 10, trControl = ctrl,
                       metric = "Accuracy"))
  
  bagKNN.models[[b]] <- train.B
}

## bagSVM
bagSVM.models = list()

for (b in 1:nBoot){
  print(paste("Bootstrap:  ", b, " / ", nBoot, sep=""))
  BRAW.OK = FALSE     ### Bootstrap örneklemine çıkan sınıf sayısı ile bootstrap çekilen 
  ### örneklemin sınıf sayısının eşit olmasını kontrol eden kısım.
  
  while (!BRAW.OK){
    sample.idx = sample(1:nrow(traindat), replace=TRUE)
    data.B = traindat[sample.idx,]
    cl.B = traincl[sample.idx]
    
    if (length(levels(cl.B)) == length(levels(traincl))){BRAW.OK = TRUE} 
  }
  
  train.B <- try(train(data.B, cl.B, method = "svmRadial", tuneLength = 15, trControl = ctrl,
                       metric = "Accuracy"))
  
  bagSVM.models[[b]] <- train.B
}

#model = list(NaiveBayes = nb, RobustQDA = rqda, BaggingSVM = bagSVM, kNearestNeighbour = knn)
model = list(NaiveBayes = nb, RobustQDA = rqda, kNearestNeighbour = knn)
save(bagKNN.models, file="bagKNN.rda")
save(bagSVM.models, file="bagSVM.rda")
save(model, file="model.rda")

test = matrix(c(2.09, log(20000, 10)), ncol=2)
test = (test - mu) / sds
colnames(test) = colnames(data.tmp)


### TRAIN / TEST ConfusionMatrix

trPred = lapply(model, prediction, traindat)
tsPred = lapply(model, prediction, testdat)

bagSVMs = bag.prediction(bagSVM.models, traindat)
bagSVM.pred.tr = apply(bagSVMs, 1, function(x) c("Not Needed","Needed")[which.max(table(x))])
bagSVM.pred.tr

bagSVMs = bag.prediction(bagSVM.models, testdat)
bagSVM.pred.ts = apply(bagSVMs, 1, function(x) c("Not Needed","Needed")[which.max(table(x))])
bagSVM.pred.ts

bagKNNs = bag.prediction(bagKNN.models, traindat)
bagKNN.pred.tr = apply(bagKNNs, 1, function(x) c("Not Needed","Needed")[which.max(table(x))])
bagKNN.pred.tr

bagKNNs = bag.prediction(bagKNN.models, testdat)
bagKNN.pred.ts = apply(bagKNNs, 1, function(x) c("Not Needed","Needed")[which.max(table(x))])
bagKNN.pred.ts


ref.tr = c("Not Needed", "Needed")[as.numeric(traincl)]
ref.ts = c("Not Needed", "Needed")[as.numeric(testcl)]
ref.tr
ref.ts

confusionMatrix(trPred$NaiveBayes, ref.tr)
confusionMatrix(trPred$RobustQDA, ref.tr)
confusionMatrix(trPred$kNearestNeighbour, ref.tr)
confusionMatrix(bagSVM.pred.tr, ref.tr)
confusionMatrix(bagKNN.pred.tr, ref.tr)

confusionMatrix(tsPred$NaiveBayes, ref.ts)
confusionMatrix(tsPred$RobustQDA, ref.ts)
confusionMatrix(tsPred$kNearestNeighbour, ref.ts)
confusionMatrix(bagSVM.pred.ts, ref.ts)
confusionMatrix(bagKNN.pred.ts, ref.ts)

################  FUNCTIONS  ##################

bag.prediction <- function(bagmodel, newdat){
  bagPreds = NULL
  for (i in 1:length(bagmodel)){
    pred.i = predict.train(bagmodel[[i]], newdata=newdat)
    bagPreds = cbind(bagPreds, pred.i)
  }
  return(bagPreds)
}

prediction <- function(model, newdat){
{if (model$method != "nb"){
  tmp = predict.train(model, newdata=newdat)
  pred = as.factor(c("Not Needed", "Needed")[(tmp)])
}

else if (model$method == "nb"){
  if (nrow(newdat) == 1){
    tmp = predict.train(model, newdata=rbind(newdat, newdat))
    pred = as.factor(c("Not Needed", "Needed")[(tmp)[1]])
  }
  if (nrow(newdat) != 1){
    tmp = predict.train(model, newdata=newdat)
    pred = as.factor(c("Not Needed", "Needed")[tmp])
  } 
}}
return(pred)
}
