# beforehand, load dataset containing continuous estimates for a specific noise source
# in this case 'meta' will be the dataset that contains my estimates
# libraries
library(pacman)
p_load(metafor,meta)
# from the complete dataset, filter for the disease of interest, in this case myocardial infarction
mi=meta %>% 
  filter(disease=='Acute myocardial infarction') %>% 
  arrange(studyid)
# compute meta-analysis
# fixed effects
fixed.mi=metagen(beta,sebeta,data=mi,
                 studlab=paste(author,sep=","),
                 comb.fixed=TRUE,comb.random=FALSE,sm="RR")
# random effects
random.mi=metagen(beta,sebeta,data=mi,
                  studlab=paste(author,sep=","),
                  comb.fixed=FALSE,comb.random=TRUE,
                  method.tau="PM",prediction=TRUE,hakn=TRUE,sm="RR")
# forest plot with specific columns that identify study characteristics
meta::forest(random.mi,
             sortvar=country,
             #fill='lightgrey',
             #layout = "BMJ",
             #type.study='circle',
             psize=rep(0.3,11),
             lty.equi = 2,
             cex = 0.3,
             #circlesize=0.8,
             #rightlabs=c('RR', "95% CI", "Weight"),
             header.line='both',
             weight.study='same',
             col.circle='black',
             #col.lines='black',
             ff.random='bold',
             ff.predict='bold',
             ff.hetstat='bold',
             ff.test.overall='bold',
             ff.random.labels = 'bold',
             col.diamond.random='navy',
             col.predict='red',
             leftcols=c("studlab", "year", "country","metric"),
             leftlabs = c("Study", "Year", "Country","Outcome"))