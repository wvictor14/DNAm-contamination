
#' estimates genotype contamination and sex from ewastools
#' 
#' a wrapper using ewastools to obtain SNP contamination and sex info, and 
#' minfi to get detection p
#' @param et ewastools object
#' @param rgset rgset object
#' @export
estimateContaminationSex <- function(et, rgset) {
    
    predicted_sex <- check_sex(et %>% correct_dye_bias())
    
    # ewastools pipeline
    snps <- et$manifest[probe_type=="rs",index]
    et_betas <- ewastools::dont_normalize(et)
    snps <- et_betas[snps,]
    
    # fit mixture model to call genotypes
    snps_called <- ewastools::call_genotypes(snps, learn = T)
    
    #return about
    out_df <- tibble(
        sample_id = colnames(rgset),
        prob_snp_outlier = colMeans(snps_called$outliers, na.rm = T),
        prob_snp_outlier_logodds = ewastools::snp_outliers(snps_called),
        normalized_x_intensity = predicted_sex$X,
        normalized_y_intensity = predicted_sex$Y,
        controls_failed = ewastools::sample_failure(
            ewastools::control_metrics(et)),
        
        # detection p > 0.01,  failed in more than 5% of data?
        detp_05 = colMeans(minfi::detectionP(rgset) > 0.01) > 0.05)
    
    out_df
}
