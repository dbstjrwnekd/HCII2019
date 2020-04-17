library(reshape2)
library(dplyr)
library(ggplot2)


#phs <- read.csv("~/Downloads/pretest_?????????_201221114.csv", header = T, stringsAsFactors = F)
#pch <- read.csv("~/Downloads/pretest_?????????_201321099.csv", header = T, stringsAsFactors = F)
#yeo <- read.csv("~/Downloads/pretest_??????????????????.csv", header = T, stringsAsFactors = F)
#csm <- read.csv("~/Downloads/pretest_??????????????????.csv", header = T, stringsAsFactors = F)

#phs <- phs[1:4000, ]
#pch <- pch[1:4000, ]
#yeo <- yeo[1:4000, ]
#csm <- csm[1:4000, ]
setwd("C:/Users/USER/Desktop/Weapons/Project/석혜정_교수님/논문제출/fove_gaze_data/fove_gaze_data")

idx = c(1:31, 33:54)
test <- list()
for(i in idx) {
  print(i)
  test_dump <- read.csv(paste0("test", i, ".csv"), header = T, stringsAsFactors = F)
  test[[i]] <- test_dump
}

test[[32]]
#설문지 읽어오기
Before <- read.csv("C:/Users/USER/Desktop/Weapons/Project/석혜정_교수님/논문제출/before.csv", header=FALSE)
After <- read.csv("C:/Users/USER/Desktop/Weapons/Project/석혜정_교수님/논문제출/after.csv", header=FALSE)
Before[33:54, ] <- Before[32:53, ]
Before[32, ] <- NA
After[33:54, ] <- After[32:53, ]
After[32, ] <- NA

#유형별 문제 문항 수7,5,4,3
#해당열 12~30

####################남/여 구분##########################
male_idx=c()
fem_idx=c()
Before[32,]
for(i in c(1:54)){
  if(!is.na(Before[i,2])){
  if(Before[i, 2]=='남'){
    male_idx=c(male_idx,i)
  }
  else if(Before[i,2]=='여'){
    fem_idx=c(fem_idx,i)
  }
    }
  else
    print("null check")
    print(i)
}
male_idx
fem_idx

idx <- data.frame(male_idx)

cbind(idx,data.frame(fem_idx))

man_test = test[male_idx]
wom_test = test[fem_idx]
Before[33,]
min_nrow = 10000

#for man
for(i in 1:length(male_idx)) {
  print(i)
  if(min_nrow > nrow(man_test[[i]])) {
    min_nrow <- nrow(man_test[[i]])
  }
  print(i)
}
for(i in c(1:length(male_idx))) {
  man_test[[i]] <- man_test[[i]][1:min_nrow, ]
}
for(i in c(1:length(male_idx))) {
  man_test[[i]]$current_ray_data_ld.x = man_test[[i]]$current_ray_data_ld.x %>% as.numeric()
}

right_x_all_df <- NULL
right_y_all_df <- NULL
right_z_all_df <- NULL
left_x_all_df <- NULL
left_y_all_df <- NULL
left_z_all_df <- NULL
object_name_all_df <- NULL
for(i in c(1:length(male_idx))) {
  test_df <- man_test[[i]]
  right_ray_data_x <- test_df$current_ray_data_rd.x.1 + test_df$current_ray_data_rd.x
  left_ray_data_x <- test_df$current_ray_data_lo.x + test_df$current_ray_data_ld.x
  right_ray_data_y <- test_df$current_ray_data_rd.y.1 + test_df$current_ray_data_rd.y
  left_ray_data_y <- test_df$current_ray_data_lo.y + test_df$current_ray_data_ld.y
  right_ray_data_z <- test_df$current_ray_data_rd.z.1 + test_df$current_ray_data_rd.z
  left_ray_data_z <- test_df$current_ray_data_lo.z + test_df$current_ray_data_ld.z
  object_name <- test_df$object_name
  
  right_x_all_df <- cbind(right_ray_data_x, right_x_all_df)
  right_y_all_df <- cbind(right_ray_data_y, right_y_all_df)
  right_z_all_df <- cbind(right_ray_data_z, right_z_all_df)
  left_x_all_df <- cbind(left_ray_data_x, left_x_all_df)
  left_y_all_df <- cbind(left_ray_data_y, left_y_all_df)
  left_z_all_df <- cbind(left_ray_data_z, left_z_all_df)
  object_name_all_df <- cbind(object_name, object_name_all_df)
}

r_x_sd_df <- apply(right_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_y_sd_df <- apply(right_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_z_sd_df <- apply(right_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_x_sd_df <- apply(left_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_y_sd_df <- apply(left_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_z_sd_df <- apply(left_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame

max(r_x_sd_df)
min(r_x_sd_df)

write.csv(r_x_sd_df,"C:/Users/user/Desktop/sd.csv",row.names=TRUE)

ggplot() +
  geom_point(data = r_x_sd_df, aes(x=as.numeric(rownames(r_x_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray X-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane

#object names for man in 1150~2300 Frame
man_object <-NULL
for(i in 1:length(male_idx)){
  man_object <- rbind(man_object,man_test[[i]]$object_name[1150:2300])
}

sort(table(man_object),decreasing = TRUE)

#object names for man in 2300~3500 Frame
man_object <- NULL
for(i in 1:length(male_idx)){
  man_object <- rbind(man_object, man_test[[i]]$object_name[2300:3500])
}

sort(table(man_object), decreasing=TRUE)

#for women
for(i in 1:length(fem_idx)) {
  print(i)
  if(min_nrow > nrow(wom_test[[i]])) {
    min_nrow <- nrow(wom_test[[i]])
  }
  print(i)
}
for(i in c(1:length(fem_idx))) {
  wom_test[[i]] <- wom_test[[i]][1:min_nrow, ]
}
for(i in c(1:length(fem_idx))) {
  wom_test[[i]]$current_ray_data_ld.x = wom_test[[i]]$current_ray_data_ld.x %>% as.numeric()
}

right_x_all_df <- NULL
right_y_all_df <- NULL
right_z_all_df <- NULL
left_x_all_df <- NULL
left_y_all_df <- NULL
left_z_all_df <- NULL
object_name_all_df <- NULL
for(i in c(1:length(fem_idx))) {
  test_df <- wom_test[[i]]
  right_ray_data_x <- test_df$current_ray_data_rd.x.1 + test_df$current_ray_data_rd.x
  left_ray_data_x <- test_df$current_ray_data_lo.x + test_df$current_ray_data_ld.x
  right_ray_data_y <- test_df$current_ray_data_rd.y.1 + test_df$current_ray_data_rd.y
  left_ray_data_y <- test_df$current_ray_data_lo.y + test_df$current_ray_data_ld.y
  right_ray_data_z <- test_df$current_ray_data_rd.z.1 + test_df$current_ray_data_rd.z
  left_ray_data_z <- test_df$current_ray_data_lo.z + test_df$current_ray_data_ld.z
  object_name <- test_df$object_name
  
  right_x_all_df <- cbind(right_ray_data_x, right_x_all_df)
  right_y_all_df <- cbind(right_ray_data_y, right_y_all_df)
  right_z_all_df <- cbind(right_ray_data_z, right_z_all_df)
  left_x_all_df <- cbind(left_ray_data_x, left_x_all_df)
  left_y_all_df <- cbind(left_ray_data_y, left_y_all_df)
  left_z_all_df <- cbind(left_ray_data_z, left_z_all_df)
  object_name_all_df <- cbind(object_name, object_name_all_df)
}

r_x_sd_df <- apply(right_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_y_sd_df <- apply(right_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_z_sd_df <- apply(right_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_x_sd_df <- apply(left_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_y_sd_df <- apply(left_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_z_sd_df <- apply(left_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame


write.csv(r_x_sd_df,"C:/Users/user/Desktop/여성_표준편차.csv",row.names=TRUE)
max(r_x_sd_df)
min(r_x_sd_df)

ggplot() +
  geom_point(data = r_x_sd_df, aes(x=as.numeric(rownames(r_x_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray X-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane

#object names for woman in 1150~2300 Frame
wom_object <-NULL
for(i in 1:length(fem_idx)){
  wom_object <- rbind(wom_object,wom_test[[i]]$object_name[1150:2300])
}

sort(table(wom_object),decreasing = TRUE)

#object names for woman in 2300~3500 Frame
wom_object <- NULL
for(i in 1:length(fem_idx)){
  wom_object <- rbind(wom_object,wom_test[[i]]$object_name[2300:3500])
}

sort(table(wom_object), decreasing = TRUE)

ggplot() +
  geom_point(data = r_y_sd_df, aes(x=as.numeric(rownames(r_y_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray Y-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane


##성별별 설문조사##
sexs<-c()
for (i in c((1:31),(33:length(Before$V1)))){
  sex = Before[i,2]  
  if(sex == "남"){
    sexs <- c(sexs,"남")#남자
  }
  else if (sex == "여"){
    sexs <- c(sexs,"여")#여자
  }
}

sex = na.omit(After)
row.names(sex) <- 1:nrow(sex)
sex = cbind(sex,sexs)

sex$sexs


library(plyr)
revalue(sex$sexs, c('남'='male','여'='female'))


plot(revalue(sex$sexs, c('남'='male','여'='female')),(sex$V1+sex$V2+sex$V3+sex$V4)/4,xlab = "sex", ylab = "enjoyment")

#성별별 설문조사 결과
sex1 <- subset(sex,sex$sexs=="남")#남자 그룹
sex2 <- subset(sex,sex$sexs=="여")#여자 그룹


#그림
plot(sex1$V5,xlab="군인 수를 알고 있나요?",ylab="남성")
plot(sex2$V5,xlab="군인 수를 알고 있나요?",ylab="여성")


plot(sex1$V6,xlab="군인의 수는 총 몇 명 입니까?",ylab="남성")
plot(sex2$V6,xlab="군인의 수는 총 몇 명 입니까?",ylab="여성")

plot(sex1$V9,xlab="외계인 다리가 몇개인지 아시나요?",ylab="남성")
plot(sex2$V9,xlab="외계인 다리가 몇개인지 아시나요?",ylab="여성")

plot(sex1$V10,xlab="외계인 다리는 몇개입니까?",ylab="남성")
plot(sex2$V10,xlab="외계인 다리는 몇개입니까?",ylab="여성")

plot(sex1$V11,xlab="첫번째 군인은 어느 방향에서 나왔습니까?",ylab="남성")
plot(sex2$V11,xlab="첫번째 군인은 어느 방향에서 나왔습니까?",ylab="여성")

res3ss <- subset(res3, res3$V11=="뒤쪽")
res3ss

plot(res3ss$types,(res3ss$V1+res3ss$V2+res3ss$V3+res3ss$V4)/4,xlab = "type3subset", ylab = "enjoyment")
(res3ss$V1+res3ss$V2+res3ss$V3+res3ss$V4)/4


##########################

types <- c()
types <- c(types, "type")
#Before<-Before[2:30]
#모든 실험자들에 대하여 어떤 유형에 해당하는지 점수 분석
#각각의 문제들에 대한 점수의 합을 문제의 수로 나누어 평균을 낸 후
#가장 평균이 높은 유형을 그 사람의 파악.
#유형은 types열에 저장
PASE_idx = c()
PAEPP_idx = c()

for (i in c((1:31),(33:length(Before$V1)))){
  a =0;b=0;c=0;d=0
  a = (as.numeric(Before[i,11]) + as.numeric(Before[i,12])+ as.numeric(Before[i,13])+ as.numeric(Before[i,14])+ as.numeric(Before[i,15])+ as.numeric(Before[i,16])+ as.numeric(Before[i,17]))/7
  b = (as.numeric(Before[i,18]) + as.numeric(Before[i,19])+ as.numeric(Before[i,20])+ as.numeric(Before[i,21])+ as.numeric(Before[i,22]))/5
  c = (as.numeric(Before[i,23]) + as.numeric(Before[i,24])+ as.numeric(Before[i,25])+ as.numeric(Before[i,26]))/4
  d = (as.numeric(Before[i,27]) + as.numeric(Before[i,28])+ as.numeric(Before[i,29]))/3
  large = max(a,b,c,d)
  if(large == a){
    types <- c(types,1)#탈감각적 몰입
    PASE_idx <- c(PASE_idx,i)
  }
  else if (large == b){
    types <- c(types,2)#개인적 미디어 동등화형
  }
  else if (large == c){
    types <- c(types,3)#감각적 확장 가치 체험형
    PAEPP_idx <- c(PAEPP_idx,i)
  }
  else if (large == d){
    types <- c(types,4)#탈미디어 안주형
  }
}

PASE_idx
PAEPP_idx

type1 <- list()
type2 <- list()
type3 <- list()
type4 <- list()

for(i in (2:length(types))){
  if(i<33){
    if(types[i]=="1"){
      type1[length(type1)+1] = test[i-1]
    }else if(types[i]=="2"){
      type2[length(type2)+1] = test[i-1]
    }else if(types[i]=="3"){
      type3[length(type3)+1] = test[i-1]
    }else if(types[i]=="4"){
      type4[length(type4)+1] = test[i-1]
    }
  }
  else
  {
    if(types[i]=="1"){
      type1[length(type1)+1] = test[i]
    }else if(types[i]=="2"){
      type2[length(type2)+1] = test[i]
    }else if(types[i]=="3"){
      type3[length(type3)+1] = test[i]
    }else if(types[i]=="4"){
      type4[length(type4)+1] = test[i]
    }
  }
}

#for type1
min_nrow=10000
for(i in 1:length(type1)) {
  print(i)
  if(min_nrow > nrow(type1[[i]])) {
    min_nrow <- nrow(type1[[i]])
  }
  print(i)
}
for(i in c(1:length(type1))) {
  type1[[i]] <- type1[[i]][1:min_nrow, ]
}
for(i in c(1:length(type1))) {
  type1[[i]]$current_ray_data_ld.x = type1[[i]]$current_ray_data_ld.x %>% as.numeric()
}
right_x_all_df <- NULL
right_y_all_df <- NULL
right_z_all_df <- NULL
left_x_all_df <- NULL
left_y_all_df <- NULL
left_z_all_df <- NULL
object_name_all_df <- NULL
for(i in c(1:length(type1))) {
  test_df <- type1[[i]]
  right_ray_data_x <- test_df$current_ray_data_rd.x.1 + test_df$current_ray_data_rd.x
  left_ray_data_x <- as.numeric(test_df$current_ray_data_lo.x) + as.numeric(test_df$current_ray_data_ld.x)
  right_ray_data_y <- test_df$current_ray_data_rd.y.1 + test_df$current_ray_data_rd.y
  left_ray_data_y <- test_df$current_ray_data_lo.y + test_df$current_ray_data_ld.y
  right_ray_data_z <- test_df$current_ray_data_rd.z.1 + test_df$current_ray_data_rd.z
  left_ray_data_z <- test_df$current_ray_data_lo.z + test_df$current_ray_data_ld.z
  object_name <- test_df$object_name
  
  right_x_all_df <- cbind(right_ray_data_x, right_x_all_df)
  right_y_all_df <- cbind(right_ray_data_y, right_y_all_df)
  right_z_all_df <- cbind(right_ray_data_z, right_z_all_df)
  left_x_all_df <- cbind(left_ray_data_x, left_x_all_df)
  left_y_all_df <- cbind(left_ray_data_y, left_y_all_df)
  left_z_all_df <- cbind(left_ray_data_z, left_z_all_df)
  object_name_all_df <- cbind(object_name, object_name_all_df)
}

r_x_sd_df <- apply(right_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_y_sd_df <- apply(right_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_z_sd_df <- apply(right_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_x_sd_df <- apply(left_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_y_sd_df <- apply(left_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_z_sd_df <- apply(left_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame



write.csv(r_x_sd_df,"C:/Users/user/Desktop/PASE.csv",row.names=TRUE)
#min max
max(r_x_sd_df)
min(r_x_sd_df)


ggplot() +
  geom_point(data = r_x_sd_df, aes(x=as.numeric(rownames(r_x_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray X-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane

#object names for type1 in 1150~2300 Frame
type1_object <-NULL
for(i in 1:length(type1)){
  type1_object <- rbind(type1_object,type1[[i]]$object_name[1150:2300])
}

sort(table(type1_object),decreasing = TRUE)

#object names for type1 in 2300~3500 Frame
type1_object <- NULL
for(i in 1:length(type1)){
  type1_object <- rbind(type1_object, type1[[i]]$object_name[2300:3500])
}

sort(table(type1_object), decreasing=TRUE)


#####

#for type2
min_nrow=10000
for(i in 1:length(type2)) {
  print(i)
  if(min_nrow > nrow(type2[[i]])) {
    min_nrow <- nrow(type2[[i]])
  }
  print(i)
}
for(i in c(1:length(type2))) {
  type2[[i]] <- type2[[i]][1:min_nrow, ]
}
for(i in c(1:length(type2))) {
  type2[[i]]$current_ray_data_ld.x = type2[[i]]$current_ray_data_ld.x %>% as.numeric()
}
right_x_all_df <- NULL
right_y_all_df <- NULL
right_z_all_df <- NULL
left_x_all_df <- NULL
left_y_all_df <- NULL
left_z_all_df <- NULL
object_name_all_df <- NULL
for(i in c(1:length(type2))) {
  test_df <- type2[[i]]
  right_ray_data_x <- test_df$current_ray_data_rd.x.1 + test_df$current_ray_data_rd.x
  left_ray_data_x <- as.numeric(test_df$current_ray_data_lo.x) + as.numeric(test_df$current_ray_data_ld.x)
  right_ray_data_y <- test_df$current_ray_data_rd.y.1 + test_df$current_ray_data_rd.y
  left_ray_data_y <- test_df$current_ray_data_lo.y + test_df$current_ray_data_ld.y
  right_ray_data_z <- test_df$current_ray_data_rd.z.1 + test_df$current_ray_data_rd.z
  left_ray_data_z <- test_df$current_ray_data_lo.z + test_df$current_ray_data_ld.z
  object_name <- test_df$object_name
  
  right_x_all_df <- cbind(right_ray_data_x, right_x_all_df)
  right_y_all_df <- cbind(right_ray_data_y, right_y_all_df)
  right_z_all_df <- cbind(right_ray_data_z, right_z_all_df)
  left_x_all_df <- cbind(left_ray_data_x, left_x_all_df)
  left_y_all_df <- cbind(left_ray_data_y, left_y_all_df)
  left_z_all_df <- cbind(left_ray_data_z, left_z_all_df)
  object_name_all_df <- cbind(object_name, object_name_all_df)
}

r_x_sd_df <- apply(right_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_y_sd_df <- apply(right_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_z_sd_df <- apply(right_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_x_sd_df <- apply(left_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_y_sd_df <- apply(left_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_z_sd_df <- apply(left_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame


ggplot() +
  geom_point(data = r_x_sd_df, aes(x=as.numeric(rownames(r_x_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray X-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane



#object names for type2 in 1150~2300 Frame
type2_object <-NULL
for(i in 1:length(type2)){
  type2_object <- rbind(type2_object,type2[[i]]$object_name[1150:2300])
}

sort(table(type2_object),decreasing = TRUE)

#object names for type2 in 2300~3500 Frame
type2_object <- NULL
for(i in 1:length(type2)){
  type2_object <- rbind(type2_object, type2[[i]]$object_name[2300:3500])
}

sort(table(type2_object), decreasing=TRUE)



########################################
#for type3
min_nrow=10000
for(i in 1:length(type3)) {
  print(i)
  if(min_nrow > nrow(type3[[i]])) {
    min_nrow <- nrow(type3[[i]])
  }
  print(i)
}
for(i in c(1:length(type3))) {
  type3[[i]] <- type3[[i]][1:min_nrow, ]
}
for(i in c(1:length(type3))) {
  type3[[i]]$current_ray_data_ld.x = type3[[i]]$current_ray_data_ld.x %>% as.numeric()
}
right_x_all_df <- NULL
right_y_all_df <- NULL
right_z_all_df <- NULL
left_x_all_df <- NULL
left_y_all_df <- NULL
left_z_all_df <- NULL
object_name_all_df <- NULL
for(i in c(1:length(type3))) {
  test_df <- type3[[i]]
  right_ray_data_x <- test_df$current_ray_data_rd.x.1 + test_df$current_ray_data_rd.x
  left_ray_data_x <- as.numeric(test_df$current_ray_data_lo.x) + as.numeric(test_df$current_ray_data_ld.x)
  right_ray_data_y <- test_df$current_ray_data_rd.y.1 + test_df$current_ray_data_rd.y
  left_ray_data_y <- test_df$current_ray_data_lo.y + test_df$current_ray_data_ld.y
  right_ray_data_z <- test_df$current_ray_data_rd.z.1 + test_df$current_ray_data_rd.z
  left_ray_data_z <- test_df$current_ray_data_lo.z + test_df$current_ray_data_ld.z
  object_name <- test_df$object_name
  
  right_x_all_df <- cbind(right_ray_data_x, right_x_all_df)
  right_y_all_df <- cbind(right_ray_data_y, right_y_all_df)
  right_z_all_df <- cbind(right_ray_data_z, right_z_all_df)
  left_x_all_df <- cbind(left_ray_data_x, left_x_all_df)
  left_y_all_df <- cbind(left_ray_data_y, left_y_all_df)
  left_z_all_df <- cbind(left_ray_data_z, left_z_all_df)
  object_name_all_df <- cbind(object_name, object_name_all_df)
}

r_x_sd_df <- apply(right_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_y_sd_df <- apply(right_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_z_sd_df <- apply(right_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_x_sd_df <- apply(left_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_y_sd_df <- apply(left_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_z_sd_df <- apply(left_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame

write.csv(r_x_sd_df,"C:/Users/user/Desktop/PAEPP.csv",row.names=TRUE)

#min, max
max(r_x_sd_df)
min(r_x_sd_df)

ggplot() +
  geom_point(data = r_x_sd_df, aes(x=as.numeric(rownames(r_x_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray X-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane


#object names for type3 in 1150~2300 Frame
type3_object <-NULL
for(i in 1:length(type3)){
  type3_object <- rbind(type3_object,type3[[i]]$object_name[1150:2300])
}

sort(table(type3_object),decreasing = TRUE)

#object names for type3 in 2300~3500 Frame
type3_object <- NULL
for(i in 1:length(type3)){
  type3_object <- rbind(type3_object, type3[[i]]$object_name[2300:3500])
}

sort(table(type3_object), decreasing=TRUE)

##################################################################

##유형별 설문조사##
res = na.omit(After)
row.names(res) <- 1:nrow(res)
res = cbind(res,types[2:54])
colnames(res)[names(res) == "types[2:54]"] <- "types"
res

plot(res$types,(res$V1+res$V2+res$V3+res$V4)/4,xlab = "type", ylab = "enjoyment")
#안된다. subset이용해서 유형별로 나눈 다음 비교하는걸

install.packages("gdata")
library(gdata)

#유형별 설문조사 결과
res1 <- subset(res,res$types==1)
res2 <- subset(res,res$types==2)
res3 <- subset(res,res$types==3)

res12 <- subset(res,res$types!=2, levels=c("PAEPP","PASE"))
res12$types = gdata::drop.levels(res12$types)
res12$types
levels(res12$types) <- c("PAEPP","PASE")
plot(res12$types,(res12$V1+res12$V2+res12$V3+res12$V4)/4,xlab="type", ylab="enjoyment")

#그림
plot(res1$V5,xlab="군인 수를 알고 있나요?",ylab="type1")
plot(res2$V5,xlab="군인 수를 알고 있나요?",ylab="type2")
plot(res3$V5,xlab="군인 수를 알고 있나요?",ylab="type3")

plot(res1$V6,xlab="군인의 수는 총 몇 명 입니까?",ylab="type1")
plot(res2$V6,xlab="군인의 수는 총 몇 명 입니까?",ylab="type2")
plot(res3$V6,xlab="군인의 수는 총 몇 명 입니까?",ylab="type3")

plot(res1$V9,xlab="외계인 다리가 몇개인지 아시나요?",ylab="type1")
plot(res2$V9,xlab="외계인 다리가 몇개인지 아시나요?",ylab="type2")
plot(res3$V9,xlab="외계인 다리가 몇개인지 아시나요?",ylab="type3")

plot(res1$V10,xlab="외계인 다리는 몇개입니까?",ylab="type1")
plot(res2$V10,xlab="외계인 다리는 몇개입니까?",ylab="type2")
plot(res3$V10,xlab="외계인 다리는 몇개입니까?",ylab="type3")

plot(res1$V11,xlab="첫번째 군인은 어느 방향에서 나왔습니까?",ylab="type1")
plot(res2$V11,xlab="첫번째 군인은 어느 방향에서 나왔습니까?",ylab="type2")
plot(res3$V11,xlab="첫번째 군인은 어느 방향에서 나왔습니까?",ylab="type3")

res3ss <- subset(res3, res3$V11=="뒤쪽")
res3ss

plot(res3ss$types,(res3ss$V1+res3ss$V2+res3ss$V3+res3ss$V4)/4,xlab = "type3subset", ylab = "enjoyment")
(res3ss$V1+res3ss$V2+res3ss$V3+res3ss$V4)/4


ggplot() +
  geom_point(data = r_z_sd_df, aes(x=as.numeric(rownames(r_z_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray Z-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane

ggplot() +
  geom_point(data = l_x_sd_df, aes(x=as.numeric(rownames(l_x_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Left Ray X-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY")

ggplot() +
  geom_point(data = l_y_sd_df, aes(x=as.numeric(rownames(l_y_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Left Ray Y-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY")

ggplot() +
  geom_point(data = l_z_sd_df, aes(x=as.numeric(rownames(l_z_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Left Ray Z-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY")

write.csv(object_name_all_df, "~/Desktop/object_name_all.csv", row.names = F, col.names = F)

object_name_all_vector <- as.vector(t(object_name_all_df))
object_name_all_vector <- NULL
for (i in 1:nrow(object_name_all_df)) {
  print(as.vector(object_name_all_df[i, ]))
  object_name_all_vector <- c(object_name_all_vector, as.vector(object_name_all_df[i, ]))
}
object_name_all_vector[(53*200):(53*400)] %>% table()
object_name_all_vector[(53*600):(53*800)] %>% table()
object_name_all_vector[(53*1000):(53*1300)] %>% table()
object_name_all_vector[(53*1400):(53*1550)] %>% table()
object_name_all_vector[(53*1500):(53*1600)] %>% table()
object_name_all_vector[(53*1700):(53*1800)] %>% table()
object_name_all_vector[(53*2000):(53*2300)] %>% table()
object_name_all_vector[(53*2400):(53*2700)] %>% table()
object_name_all_vector[(53*3000):(53*3300)] %>% table()
object_name_all_vector[(53*3400):(53*3600)] %>% table()


#######################################################

for(i in idx) {
  if(min_nrow > nrow(test[[i]])) {
    min_nrow <- nrow(test[[i]])
  }
}
for(i in idx) {
  test[[i]] <- test[[i]][1:min_nrow, ]
}
for(i in idx) {
  test[[i]]$current_ray_data_ld.x = test[[i]]$current_ray_data_ld.x %>% as.numeric()
}

right_x_all_df <- NULL
right_y_all_df <- NULL
right_z_all_df <- NULL
left_x_all_df <- NULL
left_y_all_df <- NULL
left_z_all_df <- NULL
object_name_all_df <- NULL
for(i in idx) {
  test_df <- test[[i]]
  right_ray_data_x <- test_df$current_ray_data_rd.x.1 + test_df$current_ray_data_rd.x
  left_ray_data_x <- test_df$current_ray_data_lo.x + test_df$current_ray_data_ld.x
  right_ray_data_y <- test_df$current_ray_data_rd.y.1 + test_df$current_ray_data_rd.y
  left_ray_data_y <- test_df$current_ray_data_lo.y + test_df$current_ray_data_ld.y
  right_ray_data_z <- test_df$current_ray_data_rd.z.1 + test_df$current_ray_data_rd.z
  left_ray_data_z <- test_df$current_ray_data_lo.z + test_df$current_ray_data_ld.z
  object_name <- test_df$object_name
  
  right_x_all_df <- cbind(right_ray_data_x, right_x_all_df)
  right_y_all_df <- cbind(right_ray_data_y, right_y_all_df)
  right_z_all_df <- cbind(right_ray_data_z, right_z_all_df)
  left_x_all_df <- cbind(left_ray_data_x, left_x_all_df)
  left_y_all_df <- cbind(left_ray_data_y, left_y_all_df)
  left_z_all_df <- cbind(left_ray_data_z, left_z_all_df)
  object_name_all_df <- cbind(object_name, object_name_all_df)
}

r_x_sd_df <- apply(right_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_y_sd_df <- apply(right_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
r_z_sd_df <- apply(right_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_x_sd_df <- apply(left_x_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_y_sd_df <- apply(left_y_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame
l_z_sd_df <- apply(left_z_all_df, 1, sd, na.rm = TRUE) %>% as.data.frame

write.csv(r_x_sd_df,"C:/Users/user/Desktop/전체_사용자_sd.csv",row.names=TRUE)

ggplot() +
  geom_point(data = r_x_sd_df, aes(x=as.numeric(rownames(r_x_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray X-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane

ggplot() +
  geom_point(data = r_y_sd_df, aes(x=as.numeric(rownames(r_y_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray Y-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane

ggplot() +
  geom_point(data = r_z_sd_df, aes(x=as.numeric(rownames(r_z_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Right Ray Z-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY") +
  geom_vline(xintercept = 300, color = "green") + #dissappeared the plane -> focused to block3
  geom_vline(xintercept = 750, color = "green") + #shaking face to right direction -> focused to block2
  geom_vline(xintercept = 1150, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 1400, color = "blue") + #focused to back soldier
  geom_vline(xintercept = 2000, color = "blue") + #appeared the front of soldiers
  geom_vline(xintercept = 2300, color = "red") + #appeared the front of tripod
  geom_vline(xintercept = 3000, color = "red") + #rotate the front of tripod
  geom_vline(xintercept = 3400, color = "red") + #stopped the front of tripod
  geom_vline(xintercept = 3700, color = "green") #appeared the plane

ggplot() +
  geom_point(data = l_x_sd_df, aes(x=as.numeric(rownames(l_x_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Left Ray X-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY")

ggplot() +
  geom_point(data = l_y_sd_df, aes(x=as.numeric(rownames(l_y_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Left Ray Y-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY")

ggplot() +
  geom_point(data = l_z_sd_df, aes(x=as.numeric(rownames(l_z_sd_df)), .), stat = 'identity', alpha = 1/10, colour = "black") +
  scale_x_continuous(breaks=seq(0, 4000, 500)) + 
  ggtitle("Standard Deviation by Left Ray Z-axis Data")  +
  theme(plot.title = element_text(hjust = 0.5), panel.background = element_rect(fill='white'),
        panel.grid.major = element_line(colour="gray", size=0.5)) +
  labs(x = "Frames", y = "Standard Deviation") + 
  labs(caption = "Based on data from FOVE and UNITY")

write.csv(object_name_all_df, "~/Desktop/object_name_all.csv", row.names = F, col.names = F)

object_name_all_vector <- as.vector(t(object_name_all_df))
object_name_all_vector <- NULL
for (i in 1:nrow(object_name_all_df)) {
  print(as.vector(object_name_all_df[i, ]))
  object_name_all_vector <- c(object_name_all_vector, as.vector(object_name_all_df[i, ]))
}
object_name_all_vector[(53*200):(53*400)] %>% table()
object_name_all_vector[(53*600):(53*800)] %>% table()
object_name_all_vector[(53*1000):(53*1300)] %>% table()
object_name_all_vector[(53*1400):(53*1550)] %>% table()
object_name_all_vector[(53*1500):(53*1600)] %>% table()
object_name_all_vector[(53*1700):(53*1800)] %>% table()
object_name_all_vector[(53*2000):(53*2300)] %>% table()
object_name_all_vector[(53*2400):(53*2700)] %>% table()
object_name_all_vector[(53*3000):(53*3300)] %>% table()
object_name_all_vector[(53*3400):(53*3600)] %>% table()

#-----------------------------------------------------------------------
