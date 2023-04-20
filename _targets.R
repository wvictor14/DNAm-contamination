# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(here)

# Set target options:
tar_option_set(
  packages = c("tibble", 'ewastools', 'minfi'), # packages that your targets need to run
  format = "rds"
)

# tar_make_clustermq() configuration (okay to leave alone):
options(clustermq.scheduler = "multiprocess")

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  
  # point to files ----
  tar_target(
    name = microsatellites_rgset_file,
    command = 
      here::here('data', 'microsatellites', '0-3_microsatellites-rgset.rds'),
    format = 'file'
  ),
  tar_target(
    name = microsatellites_ewastools_file,
    command = 
      here::here('data', 'microsatellites', '0-3_microsatellites-ewastools.rds'),
    format = 'file'
  ),
  
  # read data ----
  tar_target(
    name = microsatellites_rgset,
    command = readRDS(microsatellites_rgset_file)
  ),
  tar_target(
    name = microsatellites_ewastools,
    command = readRDS(microsatellites_ewastools_file)
  ),
  
  # apply tools ----
  tar_target(
    name = data_cs,
    command = estimateContaminationSex(
      et = microsatellites_ewastools, 
      rgset = microsatellites_rgset)
  ),
  tar_target(
    name = missing,
    command = data_cs %>% filter(is.na(prob_snp_outlier)) %>% pull(sample_id)
  )
)
