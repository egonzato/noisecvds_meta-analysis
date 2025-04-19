# beforehand, load dataset containing continuous and categorical 
# estimates for a specific noise source in this case 'miregr' will be the dataset that contains my estimates
# libraries
library(pacman)
p_load(metafor,
       meta,
       splines,
       dplyr,
       ggplot2,
       dosresmeta)
# fit splines to the continuous level of the exposure
spline_basis=ns(miregr$noiselevel, df = 3)
# fit meta regression using the splines explicited before
res_spline=rma(yi = beta, sei = sebeta, 
               mods = spline_basis, 
               data = miregr, 
               method = "REML")
# create sequence values of exposure to predict risk
new_exposure=seq(min(miregr$noiselevel),
                 max(miregr$noiselevel), length.out = 100)
# fit splines to the new exposure
new_spline_basis=ns(new_exposure, df = 3)
# predict over the new exposures
pred_spline=predict(res_spline, newmods = new_spline_basis)
# create dataset
dfsplines=data.frame(pred=pred_spline$pred,
                      lower=pred_spline$ci.lb,
                      upper=pred_spline$ci.ub,
                      exposure=new_exposure)
# plot exposure levels against predictions over the actual points
ggplot(miregr,aes(x=noiselevel,y=beta))+
  geom_point(aes(x=noiselevel,y=beta,size=sebeta),alpha=.5,col="#005c99")+
  #geom_label_repel()+
  guides(size='none')+
  labs(x='Noise Exposure',
       y='Log Relative Risk')+
  scale_x_continuous(breaks=seq(45,80,5))+
  geom_line(data=dfsplines,aes(x=exposure,y=pred), col="#66a3ff")+
  geom_ribbon(data=dfsplines,aes(x=exposure,y=pred,ymin = lower, ymax = upper),
              alpha = 0.2, col="#66a3ff",fill="#66a3ff") +  # Add confidence intervals
  theme_bw()+
  geom_hline(yintercept = 0,lty=2,col='black')