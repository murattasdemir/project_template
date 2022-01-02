library(tidyverse)
library(ggplot2)
library(data.table)
library(here)
#library(ggpmisc)
library(ggthemes)
library(ggrepel)
library(Hmisc)
library(rio)

if(!grepl("datawork/data/code",getwd())){
  setwd("datawork/data/code")
}


var <- c("FORMNO","REFERANS_YIL","DURUM","S1","S7","S6","S13","S34","S42")
#hia08<- rio::import("../hia/CSV/hia2008.csv") %>% mutate(REFERANS_YIL = 2008) %>% select(all_of(var))
hia09<- rio::import("../hia/CSV/hia2009.csv") %>% mutate(REFERANS_YIL = 2009) %>% select(all_of(var))
hia10<- rio::import("../hia/CSV/hia2010.csv") %>% mutate(REFERANS_YIL = 2010) %>% select(all_of(var))
hia11<- rio::import("../hia/CSV/hia2011.csv") %>% mutate(REFERANS_YIL = 2011) %>% select(all_of(var))
hia12<- rio::import("../hia/CSV/hia2012.csv") %>% mutate(REFERANS_YIL = 2012) %>% select(all_of(var))
hia13<- rio::import("../hia/CSV/hia2013.csv") %>% mutate(REFERANS_YIL = 2013) %>% select(all_of(var))

#Append and rename variables to match with data sets after 2014
hia1 <- rbind(hia09,hia10, hia11, hia12, hia13) %>% 
  rename(BIRIMNO = FORMNO, 
         FERTNO = S1, 
         YAS = S6, 
         DOGUM_YER = S7,
         OKUL_BITEN_K = S13,
         OZEL_KAMU = S34,
         KAYITLILIK = S42
         )
var14 <- names(hia1)
#rm(hia10,hia11,hia12,hia13) #Remove unused data to ease up on ram 
hia14<- rio::import("../hia/CSV/hia2014.csv") %>% select(all_of(var14)) 
hia15<- rio::import("../hia/CSV/hia2015.csv") %>% select(all_of(var14)) 
hia16<- rio::import("../hia/CSV/hia2016.csv") %>% select(all_of(var14))
hia17<- rio::import("../hia/CSV/hia2017.csv") %>% select(all_of(var14))
#Append 
hia <- rbind(hia1, hia14, hia15, hia16,hia17)
#rm(hia14,hia15,hia16,hia1) #Remove unused data to ease up on ram 
hia <- hia %>% 
  mutate(worker = ifelse(DURUM == "1",1,0),
         formal = ifelse(DURUM == "1" & KAYITLILIK == "1",1,0),
         informal = ifelse(DURUM == "1" & KAYITLILIK == "2",1,0),
         w_45o = ifelse(DURUM == "1" & YAS >= 46,1,0),
         kamu = ifelse(OZEL_KAMU==1,1,0),
         #Recode to harmonize OKUL_BITAN_K (education) variable
         educ_k = ifelse(OKUL_BITEN_K %in% c(0,1,2,3) & REFERANS_YIL<2014,
                0, ifelse(OKUL_BITEN_K %in% c(4,5) & REFERANS_YIL<2014,
                1, ifelse(OKUL_BITEN_K>5 & REFERANS_YIL<2014,
                2, ifelse(OKUL_BITEN_K %in% c(0,1,2) & REFERANS_YIL>=2014,
                0, ifelse(OKUL_BITEN_K %in% c(31,32) & REFERANS_YIL>=2014, 1, 2))))),
         college = ifelse(educ_k == 2, 1, 0)
         )
dt <- as.data.table(hia)

#Drop households with worker age > 45
dt <- dt %>% group_by(BIRIMNO, REFERANS_YIL) %>% 
  mutate(hh_45o = sum(w_45o)) %>% filter(hh_45o > 0)
#Drop households with at least one public employee
dt <- dt %>% group_by(BIRIMNO, REFERANS_YIL) %>% 
  mutate(hh_kamu = sum(kamu)) %>% filter(hh_kamu > 0)
#Drop households with at least one college graduate worker
dt <- dt %>% group_by(BIRIMNO, REFERANS_YIL) %>% 
  mutate(hh_college = sum(college)) %>% filter(hh_college > 0)

#Keep households with >=2 number of workers
dt <- dt %>% group_by(BIRIMNO, REFERANS_YIL) %>% 
   mutate(tot_w = sum(worker)) %>% filter(tot_w >= 1)
#Informality status
dt <- dt %>% group_by(BIRIMNO, REFERANS_YIL) %>% 
  mutate(for_w = sum(formal), inf_w = sum(informal), hh_b = n())
#Household types
dt <- dt %>% group_by(BIRIMNO, REFERANS_YIL) %>% 
  mutate(hh_type = case_when(for_w == tot_w ~ "Tamamı Kayıtlı", 
                             inf_w == tot_w ~ "Tamamı Kayıtsız",
                             for_w != tot_w & inf_w != tot_w ~ "Kayıtlı-Kayıtsız",
                             TRUE ~ NA_character_))

data <- dt %>% 
  select("BIRIMNO","REFERANS_YIL","for_w","inf_w","tot_w","hh_type") %>% 
  distinct()

data1 <- data %>% 
  group_by(hh_type, REFERANS_YIL) %>% 
  summarise(tot_hh = n()) %>% ungroup() %>% 
  group_by(REFERANS_YIL) %>%
  mutate(total = sum(tot_hh), 
         rate = round(tot_hh/total, digits = 3), 
         label = if_else(REFERANS_YIL=="2016",as.character(hh_type),NA_character_))



#Graphic

ggplot(data1, aes(x = as.factor(REFERANS_YIL), y = rate, group = as.factor(hh_type), colour = as.factor(hh_type))) + 
  geom_line(size= 1.5) + geom_point(size = 4, shape = 21, fill = "grey") + 
  geom_text(aes(label = round(rate, 2)) , vjust = 2 , hjust = "upward", show.legend = FALSE) + 
  theme_economist_white() + scale_color_manual(values = c("#01a2d9", "#014d64", "#00887d")) + 
  geom_label_repel(aes(label = label), nudge_x =0.2 , na.rm = TRUE) + 
  ylim(min(data1$rate), max(data1$rate)) + 
  ggtitle("Hanehalkı Türlerinin Yıllara Göre Oranı") + labs(x="", y="") +
  theme(
    plot.title = element_text(size=12, face= "bold", colour= "black", vjust = 2 ),
    axis.title.x = element_text(size=10, face="bold", colour = "black"),    
    axis.title.y = element_text(size=10, face="bold", colour = "black"),    
    axis.text.x = element_text(size=10, face="bold", colour = "black"), 
    axis.text.y = element_text(size=10, face="bold", colour = "black"), 
    strip.text.x = element_text(size = 10, face="bold", colour = "black" ),
    strip.text.y = element_text(size = 10, face="bold", colour = "black"),
    axis.line.x = element_line(color="black", size = 0.3),
    axis.line.y = element_line(color="black", size = 0.3)) +
  theme(legend.position = "none") + 
  labs(caption = "Kaynak: Hanehalkı İşgücü Anketi 
         \nDoğum yeri Türkiye olan 45 yaş ve altı en az 2 çalışanın bulunduğu hanehalkları dahil edilmiştir.
Hanehalkı türlerinin oranları, her bir hanehalkı türünün toplam sayısının o yıl içindeki toplam hanehalkı sayısına bölünerek hesaplanmıştır.") + 
  theme(plot.caption = element_text(hjust = 0, size = 8, face = "italic"))




