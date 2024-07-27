pyscenic ctx \
df.tsv \
mm10_10kbp_up_10kbp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather \
--annotations_fname  motifs-v10nr_clust-nr.mgi-m0.001-o0.0.tbl \
--expression_mtx_fname df.loom \
--mode "dask_multiprocessing" \
--output df_reg.csv \
--num_workers 10 \
--mask_dropouts
