library(rio)
library(data.table)
library(ggplot2)
library(ggpubr)
library(lemon)
library(ggthemr)
ggthemr('light')

ds <- here::here("Analyses", "Results", "Petersen")
datasets <- rio::import_list(list.files(ds, full.names = T))
datasetsP <- datasets[-grep(" CI", names(datasets))]

ds <- here::here("Analyses", "Results", "Anderson_Full")
datasets <- rio::import_list(list.files(ds, full.names = T))
datasetsA <- datasets[-grep(" CI", names(datasets))]


datasetsP <- rbindlist(datasetsP, idcol = "Model", fill = TRUE)
datasetsA <- rbindlist(datasetsA, idcol = "Model", fill = TRUE)

datasets <- rbindlist(list("Petersen" = datasetsP,
                           "Anderson" = datasetsA), 
                      idcol = "Dataset", 
                      fill = TRUE)


datasets$Model <- factor(datasets$Model,
                               levels = c("Bayesian model no errors", 
                                          "Bayesian model with errors",
                                          "Bayesian mixed w errors",
                                          "Linear regression",
                                          "Inverse linear regression",
                                          "Deming regression", 
                                          "York regression") ,
                               labels = 
                                 c("B-SL", "B-SL-E", "B-LMM", "OLS", "W-OLS", "D", "Y")
)

datasets <- datasets[,c("Dataset", "Model", "alpha", "beta")]
datasets <- na.omit(datasets)

aggregated <- aggregate(. ~ Dataset + Model, datasets, function(x) c(mean = mean(x), sd = sd(x)/sqrt(length(x))))
aggregated <- data.frame(aggregated)
aggregated <- do.call("data.frame", aggregated)

reference <- data.frame(Dataset = c("Petersen","Anderson"), 
           Model = "Reference", 
           alpha.mean = c(0.258, 0.154),   
           alpha.sd = c(1.70E-05, 4.00E-03), 
           beta.mean  = c(0.0383, 0.0391) ,   
           beta.sd = c(1.70E-06, 4.00E-04)
           )

aggregated <- rbind(aggregated, reference)


aggregated$Dataset <- factor(aggregated$Dataset,
                         levels = c("Petersen", 
                                    "Anderson")
                         )
aggregated$fishape <- ifelse(aggregated$Model == "Reference", 1, 16)

p1 <- 
  ggplot(aggregated, aes(x = alpha.mean, y = beta.mean, color = Model)) + 
  geom_errorbar(aes(ymin = beta.mean - beta.sd,ymax = beta.mean + beta.sd), size = .6) + 
  geom_errorbarh(aes(xmin = alpha.mean - alpha.sd,xmax = alpha.mean + alpha.sd), size =.6) +
  geom_point(shape = aggregated$fishape, size = 2)+
  facet_wrap(~(Dataset), scales = "free") +
  ylab(expression(beta))+ 
  xlab(expression(alpha))+ 
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.background = element_blank(), #axis.line = element_line(colour = "black"),
        axis.ticks = element_line(colour = "black"),
        panel.border = element_rect(color = "black", fill = NA, size = 1)
  )+ theme(text = element_text(size = 22))  +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        axis.title.x = element_text(colour = "black"),
        axis.title.y = element_text(colour = "black"),
        axis.text.y = element_text(colour="black"),
        axis.text.x = element_text(colour="black"),
        strip.text = element_text(colour = 'black'),
        panel.border = element_rect(colour = "black", fill=NA),
        axis.line.x.bottom=element_line(color="black", size=0.1),
        axis.line.y.left=element_line(color="black", size=0.1),
        legend.key = element_rect(fill = "white"),
        legend.text=element_text(color="black",size=15),
        legend.key.size = unit(7,"point"), 
        legend.title=element_blank())+ 
  theme(legend.position="bottom") +
  guides(colour = guide_legend(nrow = 1))+ 
  scale_color_brewer(palette = "Dark2")

p1



ggsave(plot = p1, filename= here::here("Figures","Plots",'Fig1.pdf'), device= cairo_pdf, width =  12, height =  6)


jpeg(here::here("Figures","Plots","Fig1.jpg"), 12, 6, units = "in", res=300)
print(p1)
dev.off()


