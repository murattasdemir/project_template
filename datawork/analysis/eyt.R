
rm(list = ls()) # Bütün hafızayı sil (opsiyonel)
library(tidyverse)
library(survey)
library(rio)
library(data.table)
options(scipen = 999)
dt <- as.data.table(import("~/Google Drive/My Drive/DATASTOR/TUIK/GYKA/KESİT/2018/gyk18_f.csv"))
fk <- as.data.table(import("~/Google Drive/My Drive/DATASTOR/TUIK/GYKA/KESİT/2018/gyk18_fk.csv"))
dt <- dplyr::left_join(dt,fk,by = "FERT_ID")
#rm(fk)
#gc()
# Name variables
dt <- dt %>% mutate(year = FK010, #Survey year
                    age = FK070,
                    age2 = FK070^2,
                    male = FK090 == 1,
                    educ = FE030,
                    univ = ifelse(FE030>=7,1,0),
                    married = ifelse(FB100==1,1,ifelse(is.na(FB100),NA,0)),
                    start_age = FI320, #Age at first regular job
                    years_worked = FI330, #Yaers actually spent working since first job
                    main_job_status = FI120, #Status at main job
                    formal = ifelse(FI190 == 1, 1, ifelse(FI190 ==2,0,NA)),
                    months_worked = FI260, #Months spent working full time last year
                    annual_wage = FG010, #Net wage income last year
                    chronic = ifelse(FS020==1,1,ifelse(FS020==2,0,NA))
                    )
dt <- dt %>% mutate(salary = annual_wage/months_worked, log_salary = log(salary))
dt <- dt %>% mutate(lwage = ifelse(annual_wage == 0, NA, ifelse(is.na(annual_wage), annual_wage, log(annual_wage))))
dt <- dt %>% mutate(salary = ifelse(months_worked == 0, NA, ifelse(is.na(annual_wage), annual_wage, log(annual_wage))))


dt <- dt[main_job_status==1 & FI270 == 0,] #Keep Ücretli, Yevmiyeli, Maaşlı and Full time
#dt <- dt[(years_worked >25 & male == T) | (years_worked >20 & male == F)]
dt <- dt[ , syears := age-start_age]  #How many years ago started working
dt <- dt[ , eyt := ifelse(syears < (year -1999),1,0)] #EYT
dt <- dt[syears <= (year -1999+3) & syears>= (year -1999-3)]
table(dt[, .(eyt, male)])
summary(lm(lwage ~ male+eyt*syears+syears+eyt+age+formal+FE030, data=dt))
summary(lm(lwage ~ eyt+age+formal+FE030, data=dt[male==T]))
summary(lm(chronic ~ male+eyt+age+formal+FE030, data=dt))
summary(glm(chronic ~ eyt+age+age2+male+formal+FE030+married, data=dt, family = "binomial"))

summary(glm(chronic ~ eyt+eyt*syears+syears+age+age2+formal+FE030+married+as.factor(FI130), data=dt[male==T], family = "binomial"))
summary(glm(chronic ~ eyt+age+age2+formal+FE030+married+as.factor(FI130), data=dt[male==T], family = binomial(link="probit")))
summary(glm(chronic ~ eyt+age+age2+formal+univ+married, data=dt[male==T], family = "binomial"))

summary(lm(FS010 ~ eyt+eyt*syears+syears+age+age2+male+formal+univ+married+as.factor(FI130), data=dt[male==T] ))
