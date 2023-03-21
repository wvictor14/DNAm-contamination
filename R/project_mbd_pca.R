# project pca 
# projects new samples into the PCA
data <- bmiq_vm

project_mbd_pca <- function(data, project = FALSE) {
  
  library(tidyverse)
  
  # 1. load pca data
  pca_obj <- readRDS(here::here('data', 'r objects', '1-3_pca_obj.rds'))
  
  # load cpgs
  #dmcs_500 <- readRDS(here::here('data', 'r objects', '1-3_dmcs_500.rds'))
  
  #print # of cpgs in data
  meth_data <- readRDS(here::here('data', 'r objects', '1-3_meth-pca.rds'))
  
  
  print(
    paste0("There are ",
           sum(rownames(meth_data) %in% rownames(data)),
           "/", length(rownames(meth_data)),
           " cpgs present.")
  )
  
  
  if (project == FALSE) {
    library(irlba)
    
    # pca with all samples
    data_combined <-
      cbind(data[rownames(meth_data),], meth_data)
    
    
    set.seed(1)
    pca_dec <-  prcomp(t(data_combined), center = FALSE)
    pca_dec_var <- pca_dec$sdev^2 / sum(pca_dec$sdev^2)
    rotated <- pca_dec$rotation %>% 
      as_tibble() %>%
      bind_cols("Sample_Name" = names(pca_dec$center), .) %>%
      rename_at(vars(contains('PC')), ~paste0(., '_mbd500'))
    
  } else {
    
    # project on existing pca space
    rotated <- t(data[rownames(meth_data),]) %*% pca_dec$x
    
    predict(pca_dec, t(data[rownames(meth_data),]))
    
    rotated[,1:5]
    rotated <- rotated %>%
      as_tibble(rownames = 'Sample_Name') %>%
      rename_at(vars(contains('PC')), ~paste0(paste0(., '_mbd500')))
    
  }
  
  return(rotated)
  
}






           