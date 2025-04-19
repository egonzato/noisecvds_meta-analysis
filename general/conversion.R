# beforehand, load the dataset, clean it and rescale all estimates into unit measure of interest (i.e. 10dB)
library(pacman)
p_load(metafor,
       meta,
       gdata,
       dosresmeta)
# cat.ready is the dataset that contains all estimates that are associated to a single study and 
# need to be converted into continuous estimates
# grp is the identifier of each group of categorical estimates
cat.cont=cat.ready %>%
  group_by(grp)%>% 
  filter(row_number()==1) %>% 
  mutate()
# using the procedure pointed out in the dosresmeta package, 
# categorical estimates can be converted into a single continuous estimate
for (i in 1:length(unique(cat.ready$grp))) {
  
  # Filter data by group (study)
  cat.dos = cat.ready %>% 
    filter(grp == i) 
  
  # Define the study type
  typest = cat.ready$design
  
  # Extract cases and total people as vectors
  cases = as.vector(cat.dos$cases)   # Ensure you replace with the correct column name
  people = as.vector(cat.dos$people) # Ensure you replace with the correct column name
  
  # Define covariance matrices
  mine = lapply(unique(cat.dos$grp), function(grp_value) {
    with(subset(cat.dos, grp == grp_value), {
      if (any(is.na(cases) | is.na(people))) {
        diag(sebeta[sebeta != 0 & !is.na(sebeta)]^2, 
             nrow = sum(sebeta != 0 & !is.na(sebeta)))
      } else {
        covar.logrr(cases = cases, n = people, y = beta, v = I(sebeta^2), 
                    type = typest, covariance = "gl")
      }
    })
  })
  
  # Fit the model
  fit = dosresmeta(formula = beta ~ noiselevel, id = grp, se = sebeta,
                          Slist = mine, 
                          cases = cases,      # Number of cases
                          n = people,         # Total sample size
                          type = typest,      # Type of study design
                          data = cat.dos, covariance = "user") # Use "gl" for generalized least squares
  
  # Predict the continuous hazard ratio
  yy = predict(fit, delta = 10, se.incl = TRUE, expo = TRUE)
  
  # Use model-provided standard error instead of recalculating
  yy2 = yy %>%
    mutate(beta = log(yy$pred),
           sebeta = yy$se) # Use the predicted standard error
  
  # Store the results in cat.cont
  cat.cont[i, 'beta'] = yy2$beta
  cat.cont[i, 'sebeta'] = yy2$sebeta
}
# at the end of the loop all continuous estimates will be store in a dataset, 
# which will then be binned to the one that contains the other continuous estimates