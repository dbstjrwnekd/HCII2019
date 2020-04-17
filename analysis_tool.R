#UR연구 설문조사지 분석툴

rm(list=ls())
library(dplyr)


#설문지 읽어오기
Before <- read.csv("C:/Users/USER/Desktop/before.csv", header=FALSE)
After <- read.csv("C:/Users/USER/Desktop/after.csv", header=FALSE)
#유형별 문제 문항 수7,5,4,3
#해당열 12~30
head(Before)
str(Before)



#각각의 실험자별 유형을 표시해줄 열을 생성
types <- c()
types <- c(types, "type")
#Before<-Before[2:30]
#모든 실험자들에 대하여 어떤 유형에 해당하는지 점수 분석
#각각의 문제들에 대한 점수의 합을 문제의 수로 나누어 평균을 낸 후
#가장 평균이 높은 유형을 그 사람의 파악.
#유형은 types열에 저장
for (i in 2:(length(Before$V1))){
  a =0;b=0;c=0;d=0
  a = (as.numeric(Before[i,12]) + as.numeric(Before[i,13])+ as.numeric(Before[i,14])+ as.numeric(Before[i,15])+ as.numeric(Before[i,16])+ as.numeric(Before[i,17])+ as.numeric(Before[i,18]))/7
  b = (as.numeric(Before[i,19]) + as.numeric(Before[i,20])+ as.numeric(Before[i,21])+ as.numeric(Before[i,22])+ as.numeric(Before[i,23]))/5
  c = (as.numeric(Before[i,24]) + as.numeric(Before[i,25])+ as.numeric(Before[i,26])+ as.numeric(Before[i,27]))/4
  d = (as.numeric(Before[i,28]) + as.numeric(Before[i,29])+ as.numeric(Before[i,30]))/3
  large = max(a,b,c,d)
  if(large == a){
    types <- c(types,1)
  }
  else if (large == b){
    types <- c(types,2)
  }
  else if (large == c){
    types <- c(types,3)
  }
  else if (large == d){
    types <- c(types,4)
  }
}
str(Before$V2)
 

str(Before)
str(types)
#원래의 데이터와 유형데이터 합치기
before <- cbind(Before,types)
before$V2 = factor(before$V2, order = TRUE,level = c('전혀 없다', '거의 없다', '없는 편이다','보통이다','조금 있다','많다'))
str(before$V2)
before$V2
combined <- cbind(before,After)
colnames(combined) <- c("V1","V2","V3","V4","V5","V6","V7","V8","V9","V10",
                        "V11","V12","V13","V14","V15","V16","V17","V18","V19",
                        "V20","V21","V22","V23","V24","V25","V26","V27","V28",
                        "V29","V30","types","V31","V32","V33","V34","V35","V36",
                        "V37","V38","V39","V40","V41","V42","V43","V44","V45",
                        "V46","V47","V48")
str(combined)
#합친 데이터를 유형별로 나눈다
type1 <- filter(combined, combined$types==1)
type2 <- filter(combined, combined$types==2)
type3 <- filter(combined, combined$types==3)
type4 <- filter(combined, combined$types==4)
type1$V2
#각 유형별 VR 경험
par(mfrow=c(2,2))
plot(type1$V2)
plot(type2$V2)
plot(type3$V2)
plot(type4$V2)
#각 유형별 성별
plot(type1$V3)
plot(type2$V3)
plot(type3$V3)
plot(type4$V3)

str(type1)


#PreTest에서의 4사람은 모두 "감각적 확장 가치 체험형"으로 분류되었다.
#이 유형의 특징은 부작용이 있다 하더라도 증강현실을 체험할 가치가 있다고
#생각하고, 다양한 경험의 폭을 넓히는 기회를 제공해 준다고 생각한다.
#4개의 유형 중 프레즌스 경향이 가장 낮은 분류이다.
#이 분류는 남성보다 여성이 더 많이 해당하는 경향이 있다.
#또한 나이는 25-29세의 비중이 가장 높다는 연구 결과가 있는 유형이다.
#이들은 욕구나 관심을 충족시키기위해 새로운 감각기관의 확장으로 가상현실을
#인식하게 되는데, 보다 강렬한 자극을 원하는 특성이 있다.
#이는 표본이 적어 확실하지는 않지만 모두 기존의 연구와 일치하는 분류결과를
#보인다.



par(mfrow=c(1,1))
#type별 현실이탈성 점수
(mean(as.numeric(type1$V4))+mean(as.numeric(type3$V5)))/2
(mean(as.numeric(type2$V4))+mean(as.numeric(type3$V5)))/2
(mean(as.numeric(type3$V4))+mean(as.numeric(type3$V5)))/2
(mean(as.numeric(type4$V4))+mean(as.numeric(type3$V5)))/2
#type별 집중경향 점수
(mean(as.numeric(type1$V6))+mean(as.numeric(type3$V7)))/2
(mean(as.numeric(type2$V6))+mean(as.numeric(type3$V7)))/2
(mean(as.numeric(type3$V6))+mean(as.numeric(type3$V7)))/2
(mean(as.numeric(type4$V6))+mean(as.numeric(type3$V7)))/2
#type별 감정이입 점수
mean(as.numeric(type1$V8))
mean(as.numeric(type2$V8))
mean(as.numeric(type3$V8))
mean(as.numeric(type4$V8))
#type별 공포경험 점수
mean(as.numeric(type1$V9))
mean(as.numeric(type2$V9))
mean(as.numeric(type3$V9))
mean(as.numeric(type4$V9))
#type별 몰입능력 점수
mean(as.numeric(type1$V10))
mean(as.numeric(type2$V10))
mean(as.numeric(type3$V10))
mean(as.numeric(type4$V10))
#type별 감정반응 점수
mean(as.numeric(type1$V11))
mean(as.numeric(type2$V11))
mean(as.numeric(type3$V11))
mean(as.numeric(type4$V11))

head(After)

#1.type별 즐거움, 흥미, 재미, 관심정도
#<type 1>
mean(as.numeric(type1$V32))
mean(as.numeric(type1$V33))
mean(as.numeric(type1$V34))
mean(as.numeric(type1$V35))

#<type 2>
mean(as.numeric(type2$V32))
mean(as.numeric(type2$V33))
mean(as.numeric(type2$V34))
mean(as.numeric(type2$V35))

#<type 3>
mean(as.numeric(type3$V32))
mean(as.numeric(type3$V33))
mean(as.numeric(type3$V34))
mean(as.numeric(type3$V35))

#<type 4>
mean(as.numeric(type4$V32))
mean(as.numeric(type4$V33))
mean(as.numeric(type4$V34))
mean(as.numeric(type4$V35))
#type3는 4개의 변수중 흥미에 가장 높은 점수를 보였다.

#그러나 재미의 경우 다른 변수들에 비해 가장 낮았으며
#즐거움과 관심정도는 다른 변수들의 중간 점수를 보였다.
#이는 새로운 가치를 추구하지만, 콘텐츠의 내용 자체가 이들의 욕구를
#전부 충족시키지는 못하고 있음을 나타낸다. 이는 기존의 연구와 일치하는
#부분이다.
#또한 실험이 끝난 후 4명 모두 "재미있어지려는데 끝나서 아쉽다"
#"이 후의 내용을 게임으로 만들어 플레이해보고싶다" 등의 내용을 언급한
#것을 생각해보면 이 역시 일치한다.
#이는 기존의 연구와 일치하는 결과이다.

#2.type별 기억정도
#<type 1>
sum(type1$V36=="예")
sum(type1$V37=="3명")

#<type 2>
sum(type2$V36=="예")
sum(type2$V37=="3명")
#이들은 모두 등장한 군인의 수를 알고 있다고 답하였고 모두 맞추었다.
#이는 쉬운문제에 해당한다.

#<type 3>
sum(type3$V36=="예")
sum(type3$V37=="3명")

#<type 4>
sum(type4$V36=="예")
sum(type4$V37=="3명")

#다음으로 상대적으로 어려운 다른색의 군인의 존재여부에 대한 답변이다.
#<type 1>
sum(type1$V38=="예")
sum(type1$V39=="파란색 계열")

#<type 2>
sum(type2$V38=="예")
sum(type2$V39=="파란색 계열")

#<type 3>
sum(type3$V38=="예")
sum(type3$V39=="파란색 계열")

#<type 4>
sum(type4$V38=="예")
sum(type4$V39=="파란색 계열")

#4명의 표본중 오직 한명만이 이를 기억한다고 답하였다.
After$V9
#이 한명은 다른 군인의 색을 알맞게 판단하였다. 하지만 나머지는
#전부 기억하지 못했다.
#이는 상대적으로 전체적인 몰입도가 떨어지는 감각적 확장 가치 체험형의
#특성으로 생각된다.


#위 둘에 대해 나눈걸로 비교 해야함
combined <- cbind(before,After)
colnames(combined) <- c("V1","V2","V3","V4","V5","V6","V7","V8","V9","V10",
                        "V11","V12","V13","V14","V15","V16","V17","V18","V19",
                        "V20","V21","V22","V23","V24","V25","V26","V27","V28",
                        "V29","V30","types","V31","V32","V33","V34","V35","V36",
                        "V37","V38","V39","V40","V41")
vr <- subset(combined, subset=combined$V2=="예")
nvr <- subset(combined, subset=combined$V2=="아니오")
head(vr)
head(nvr)
#보는 바와 같이 여성은 모두 vr경험이 없으며 남성은 모두 vr경험이 있음.
combined$V4
#남,여 간 현실 이탈성 점수
plot(combined$V3,(combined$V4+combined$V5)/2)
#남,여 간 집중경향 점수
plot(combined$V3,(combined$V6+combined$V7)/2)
#남, 여 간 감정이입 점수
plot(combined$V3,combined$V8)
#남, 여 간 공포경험 점수
plot(combined$V3,combined$V9)
#남, 여 간 몰입능력 점수
plot(combined$V3,combined$V10)
#남, 여 간 감정반응 점수
plot(combined$V3,combined$V11)
#남, 여간 몰입경향의 구성요소 중 몰입 능력을 제외한 모든 부문에서
#남성이 높은 점수를 보였다. 이는 컨텐츠에 대한 몰입경향이 여성보다 남성이
#더 높은 것을 보이는 것을 나타낸다. 다만 실제 몰입 능력의 경우
#여성이 더 높은 것으로 나타난다.

#남,여 간 즐거움, 흥미, 재미, 관심정도
plot(combined$V3,combined$V32)
plot(combined$V3,combined$V33)
plot(combined$V3,combined$V34)
plot(combined$V3,combined$V35)
#실험 후 실제로 느낀 즐거움, 흥미, 재미, 관심정도는 모두 여성이 더 높은
#것으로 판단되었다.
#이는 추후에 성별 문제인지 VR경험의 유/무에 따른 차이인지 확인할
#필요가 있다.

#남, 여간 기억력 판단

#군인의 수
vr$V36
nvr$V36
vr$V37
nvr$V37
#상대적으로 쉬운 군인의 수를 물어보는 문제의 경우 남, 여 모두 기억한다고
#대답하였으며 실제로 모두 문제를 맞추었다.

#군인의 색
vr$V38
nvr$V38
vr$V39
nvr$V39
#상대적으로 어려운 군인의 색을 물어보는 문제의 경우 여성은 모두 기억하지
#못한다고 대답하였으며, 남성은 한명의 남성이 기억한다고 하였고 정답을
#맞추었다.
#이는 성별에 따른 차이인지 VR경험에 따른 차이인지 추후의 연구가 필요하다.