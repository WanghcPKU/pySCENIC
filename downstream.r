library(SCopeLoomR)
library(AUCell)
library(SCENIC)


loom <- open_loom("result.loom")
regulons_incidMat <- get_regulons(loom, column.attr.name="Regulons")
regulons <- regulonsToGeneLists(regulons_incidMat)
regulonAUC <- get_regulons_AUC(loom,column.attr.name='RegulonsAUC')
regulonAucThresholds <- get_regulon_thresholds(loom)
embeddings <- get_embeddings(loom) 

###regulon cytoscape
df2 <- data.frame()
for(i in 1:length(regulons)){
df1 <- as.data.frame(regulons[i])
colnames(df1) <- "target"
df1$regulon <- gsub("\\([^\\)]+\\)","",names(regulons[i]))
df2 <- rbind(df2,df1)

}
df2
write.csv(df2, "./regulon.csv")


fold <- as.data.frame(regulonAucThresholds)
fold$auc <- rownames(fold)
rownames(fold) <- fold[,1]

df3 <- as.data.frame(regulonAUC@assays@data@listData$AUC)

df3 <- df3[rownames(fold),]
binary <- as.data.frame(lapply(df3, function(column) {
  as.numeric(column > fold$auc)
}))
rownames(binary) <- rownames(df3)

write.csv(binary,"binary_matrix.csv") 

anno_df <- data.frame(df$group)
unique(cm.ana$group)
rownames(anno_df) <- rownames(df@meta.data)
binary_filter <- binary[rowSums(binary) > 200, ] ###过滤一下
pdf("./binary_heatmap.pdf",width=10 ,height=20)
pheatmap(binary,annotation_col=anno_df,
show_colnames=F,cluster_cols = FALSE)
dev.off()

###regulon correlation heatmap
library(scFunctions)
csi <- calculate_csi(regulonAUC, calc_extended = FALSE, verbose = FALSE)

matrix_data <- reshape2::acast(csi, regulon_1 ~ regulon_2, value.var = "CSI")
head(matrix_data)
matrix_data[matrix_data < 0.8] <- 0
pdf("csi.pdf",width=20,height=20)
pheatmap(matrix_data, 
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean", 
         clustering_method = "complete", 
         color = colorRampPalette(c("white", "blue"))(50),
         main = "Regulon Correlation Heatmap")
dev.off()
