cm.age <- subset(cm.ana, group %in% c("iso-old","iso-young"))
deg_age <- read.csv("/lustre/user/taowlab/wanghc/work/lvwc/ytgs/zuhui/20240619/deg_age_all.csv")
cm_age <- subset(deg_age, cell_type == "CM")
cm_age_sign <- subset(cm_age, p_val_adj < 0.05 & abs(avg_log2FC)>0.25)$geneid


cm_age.matrix <-t(as.matrix(cm.age@assays$RNA@counts)[cm_age_sign,])

write.csv(cm_age.matrix,file = "./cm_age.csv")
