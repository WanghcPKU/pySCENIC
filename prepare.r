
df <- subset(df, downsample = 1000)
df.count_matrix <- df@assays$RNA@counts %>% as.matrix()

df.count_matrix_filtered <- df.count_matrix[rowSums(df.count_matrix) > 10, ]

write.csv(t(df.count_matrix_filtered),file = "./df.csv")
