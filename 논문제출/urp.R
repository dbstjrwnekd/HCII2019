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
setwd("C:/Users/USER/Desktop/Weapons")

idx = c(1:31, 33:54)
test <- list()
for(i in idx) {
  test_dump <- read.csv(paste0("test", i, ".csv"), header = T, stringsAsFactors = F)
  test[[i]] <- test_dump
}

#설문지 읽어오기
Before <- read.csv("C:/Users/USER/Desktop/Weapons/Project/석혜정 교수님/논문제출/before.xlsx", header=FALSE)
After <- read.csv("C:/Users/USER/Desktop/Weapons/Project/석혜정 교수님/논문제출/after.xlsx", header=FALSE)
#유형별 문제 문항 수7,5,4,3
#해당열 12~30

#남/여 구분



min_nrow = 10000
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

ggplot() + 
  geom_point(data = phs, aes(x=rownames(phs), current_ray_data_rd.z, colour = "phs"), 
             stat = 'identity', alpha = 1/10) + 
  geom_text(data = phs, aes(x=rownames(phs), current_ray_data_rd.z, label = object_name, colour = "phs"), alpha = 1/2) +
  
  geom_point(data = pch, aes(x=rownames(pch), current_ray_data_rd.z, colour = "pch"), 
             stat = 'identity', alpha = 1/10) + 
  geom_text(data = pch, aes(x=rownames(pch), current_ray_data_rd.z, label = object_name, colour = "pch"), alpha = 1/2) + 
  
  geom_point(data = yeo, aes(x=rownames(yeo), current_ray_data_rd.z, colour = "yeo"), 
             stat = 'identity', alpha = 1/10) + 
  geom_text(data = yeo, aes(x=rownames(yeo), current_ray_data_rd.z, label = object_name, colour = "yeo"), alpha = 1/2) + 

  geom_point(data = csm, aes(x=rownames(csm), current_ray_data_rd.z, colour = "csm"), 
           stat = 'identity', alpha = 1/10) + 
  geom_text(data = csm, aes(x=rownames(csm), current_ray_data_rd.z, label = object_name, colour = "csm"), alpha = 1/2) 


object_df <- cbind(phs$object_name, pch$object_name, yeo$object_name, csm$object_name)


rd_x_sd_df = cbind(phs$current_ray_data_rd.x, pch$current_ray_data_rd.x, yeo$current_ray_data_rd.x, csm$current_ray_data_rd.x)
rd_x_sd_df <- transform(rd_x_sd_df, rd_x_sd=apply(rd_x_sd_df, 1, sd, na.rm = TRUE))

rd_y_sd_df = cbind(phs$current_ray_data_rd.y, pch$current_ray_data_rd.y, yeo$current_ray_data_rd.y, csm$current_ray_data_rd.y)
rd_y_sd_df <- transform(rd_y_sd_df, rd_y_sd=apply(rd_y_sd_df, 1, sd, na.rm = TRUE))

rd_z_sd_df = cbind(phs$current_ray_data_rd.z, pch$current_ray_data_rd.z, yeo$current_ray_data_rd.z, csm$current_ray_data_rd.z)
rd_z_sd_df <- transform(rd_z_sd_df, rd_z_sd=apply(rd_z_sd_df, 1, sd, na.rm = TRUE))

ggplot() +
  geom_point(data = rd_x_sd_df, aes(x=rownames(rd_x_sd_df), rd_x_sd), stat = 'identity', alpha = 1/10)

rd_x_sd_df[order(-rd_x_sd_df$rd_x_sd), ]
rd_y_sd_df[order(-rd_y_sd_df$rd_y_sd), ]
rd_z_sd_df[order(-rd_z_sd_df$rd_z_sd), ]

phs[, 1] <- phs[, 1] %>% as.numeric()
pch[, 1] <- pch[, 1] %>% as.numeric()
yeo[, 1] <- yeo[, 1] %>% as.numeric()
csm[, 1] <- csm[, 1] %>% as.numeric()



df <- cbind(phs[, -13], pch[, -13], yeo[, -13], csm[, -13])
coord_x_idx = seq(1, ncol(df), 3)
coord_y_idx = seq(2, ncol(df), 3)
coord_z_idx = seq(3, ncol(df), 3)
coord_sd_df = NULL

for(i in 1:nrow(df)) {
  
  coord_x_sum = 0; coord_y_sum = 0; coord_z_sum = 0;
  coord_x_var = 0; coord_y_var = 0; coord_z_var = 0;
  
  for(x_idx in coord_x_idx) {
    coord_x_sum = coord_x_sum + df[i, x_idx]
  }
  coord_x_mean = coord_x_sum / length(coord_x_idx)
  
  for(y_idx in coord_y_idx) {
    coord_y_sum = coord_y_sum + df[i, y_idx]
  }
  coord_y_mean = coord_y_sum / length(coord_y_idx)
  
  for(z_idx in coord_z_idx) {
    coord_z_sum = coord_z_sum + df[i, z_idx]
  }
  coord_z_mean = coord_z_sum / length(coord_z_idx)
  
  
  for(x_idx in coord_x_idx) {
    coord_x_var = coord_x_var + (coord_x_mean - df[i, x_idx])^2
  }
  coord_x_sd = coord_x_var / length(coord_x_idx)
  
  for(y_idx in coord_y_idx) {
    coord_y_var = coord_y_var + (coord_y_mean - df[i, y_idx])^2
  }
  coord_y_sd = coord_y_var / length(coord_y_idx)
  
  for(z_idx in coord_z_idx) {
    coord_z_var = coord_z_var + (coord_z_mean - df[i, z_idx])^2
  }
  coord_z_sd = coord_z_var / length(coord_z_idx)
  
  coord_sd = c(coord_x_sd, coord_y_sd, coord_z_sd)
  
  coord_sd_df = rbind(coord_sd_df, coord_sd)
  
}

coord_sd_df <- coord_sd_df %>% as.data.frame()
rownames(coord_sd_df) <- seq(1:nrow(coord_sd_df))

ggplot() +
  geom_point(data = coord_sd_df, aes(x=rownames(coord_sd_df), V1), stat = 'identity', alpha = 1/10) + 
  geom_vline(xintercept = 1300, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 2500, color = "red") + #revealed the tripod
  geom_vline(xintercept = 3000, color = "red") + #tripod turn to player
  geom_vline(xintercept = 3500, color = "red") #tripod stopped

ggplot() +
  geom_point(data = coord_sd_df, aes(x=rownames(coord_sd_df), V2), stat = 'identity', alpha = 1/10) + 
  geom_vline(xintercept = 1300, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 2500, color = "red") + #revealed the tripod
  geom_vline(xintercept = 3000, color = "red") + #tripod turn to player
  geom_vline(xintercept = 3500, color = "red") #tripod stopped

ggplot() +
  geom_point(data = coord_sd_df, aes(x=rownames(coord_sd_df), V3), stat = 'identity', alpha = 1/10) + 
  geom_vline(xintercept = 1300, color = "blue") + #stopped the back soldier
  geom_vline(xintercept = 2500, color = "red") + #revealed the tripod
  geom_vline(xintercept = 3000, color = "red") + #tripod turn to player
  geom_vline(xintercept = 3500, color = "red") #tripod stopped

