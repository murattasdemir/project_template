library(tidyverse)
library(ggplot2)
library(data.table)
library(ggpmisc)
library(ggthemes)
library(ggrepel)
library(Hmisc)
library(survey)
library(gtools)


setwd("~/gelir-yasam")

gy_1114_f <- read.csv2("data/raw/11121314/gyk11121314_p.csv", dec=".") 
gy_1114_fk<- read.csv2("data/raw/11121314/gyk11121314_pr.csv", dec=".")



# Select households interviewed in 2010-2011-2012-2013 ((Longitudinal weights only added to the latest year records.))

dt14 <- gy_1114_fk %>% filter(!is.na(FK060_4))
hh_4 <- dt14$PERS_ID 


dt13 <- gy_1114_fk %>% filter(FK010 == "2013") %>% filter(PERS_ID %in% c(hh_4))
dt12 <- gy_1114_fk %>% filter(FK010 == "2012") %>% filter(PERS_ID %in% c(hh_4))
dt11 <- gy_1114_fk %>% filter(FK010 == "2011") %>% filter(PERS_ID %in% c(hh_4))

data <- rbind(dt11,dt12,dt13,dt14) %>% filter(FK070 >= 16) %>% rename(YIL = FK010) 

dt14a <- gy_1114_f %>% filter(FB010 == "2014") %>% filter(PERS_ID %in% c(hh_4))
dt13a <- gy_1114_f %>% filter(FB010 == "2013") %>% filter(PERS_ID %in% c(hh_4))
dt12a <- gy_1114_f %>% filter(FB010 == "2012") %>% filter(PERS_ID %in% c(hh_4))
dt11a <- gy_1114_f %>% filter(FB010 == "2011") %>% filter(PERS_ID %in% c(hh_4))

data1 <- rbind(dt11a,dt12a,dt13a,dt14a) %>% rename(YIL = FB010) 


dt <- merge(data, data1, by=c("HH_ID","PERS_ID","YIL"))


# Duplicate FK060_4 for other years
#a <- dt14 %>% select(HH_ID, PERS_ID, FK060_4) %>% rename(AGIRLIK = FK060_4, HH = HH_ID)
#dt <- left_join(dt, a, by = "PERS_ID")


#######################################################################################################################


dt1 <- dt %>% mutate(worker = ifelse(FI020 == "1",1,0), 
                     formal = ifelse(FI020 == "1" & FI190 == "1",1,0), 
                     informal = ifelse(FI020 == "1" & FI190 == "1",1,0), 
                     w_45o = ifelse(worker == 1 & FK070 >= 46,1,0))

dt_1 <- dt1 %>% filter(w_45o != "1") # Exclude workers over 45 years old


#Select people in households with more than one workers
dt_1 <- dt_1 %>% group_by(HH_ID, YIL) %>% mutate(tot_w = sum(worker)) 
dt_1 <- dt_1 %>% group_by(HH_ID, YIL) %>% mutate(for_w = sum(formal), inf_w = sum(informal))



dt_1 <- dt_1 %>% group_by(HH_ID, YIL) %>% mutate(hh_type = case_when(inf_w == 0 ~ "all-for",
                                                                     for_w == 0 ~ "all-inf",
                                                                     inf_w != 0 & for_w != 0 ~ "for-inf",
                                                                     TRUE ~ NA_character_))



#Check yourself
View(dt_1[c("HH_ID","YIL","for_w","inf_w","tot_w","hh_type")])

#dt_1 <- dt_1 %>% filter(hh_type != "all-for") # Exclude people in households with all members working in formal jobs












