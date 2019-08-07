library(tidyverse)
#library(ggplot2)
#library(ggrepel)

conditions <- list.files("../to_store/")
lookup_table <- data.frame()
for (my_condition in conditions){
  my_condition <- str_remove(my_condition, ".csv") #remove .csv from the file name in order to extract parameters without NA errors
  my_condition <- str_remove(my_condition, "results")
  # split the string
  my_split <- strsplit(my_condition, "_|\\=")[[1]]
  #print(my_split)
  # extract parameters
  strategy <- as.numeric(my_split[3])
  repair <-as.numeric(my_split[7])
  dimension <- as.numeric(my_split[5])
  num_males <- as.numeric(my_split[9])
  num_mar <- as.numeric(my_split[11])
  lookup_table <- rbind(lookup_table, data.frame(directory = my_condition,
                                                 strategy = strategy,
                                                 repair = repair,
                                                 dimension = dimension))
}

all_results  <- tibble()

for (my_condition in conditions){
   # read and load each result
 my_dir_results <- paste0("../to_store/", my_condition, "/results/")
 my_results <- list.files(my_dir_results)
 if (length(my_results) > 0){
   # process a single file
   for (my_file in my_results) {
     # extract the random seed
     my_rnd_seed <- strsplit(substr(my_file, 5, 1000), "D")[[1]][1]
     my_rnd_seed <- as.numeric(my_rnd_seed)
     tmp <- read_csv(paste0(my_dir_results, my_file)) %>% add_column(rnd_seed = my_rnd_seed, directory = my_condition)
     tmp <- tmp %>% select(id, probability_maraud, successful_mating,
                           foraging_hrs, staying_hrs, repairing_hrs, marauding_events, marauding_hrs, marauding_events, traveling_hrs, rnd_seed, directory, mar_attempts, mate_attempts)
     all_results <- rbind(all_results, tmp)
   }
 }
}

all_results <- all_results %>% inner_join(lookup_table)

##saves a csv for each condition (for example, with 100 male and 1,000 simulations, this results in 100,000 rows)
for (my_condition in conditions){
  name<-paste0("results", my_condition)
  assign(name,filter(all_results, directory == my_condition))
  write_csv(filter(all_results, directory == my_condition), path = paste0("results_2B",my_condition,'.csv'))
}

conditions <-str_replace(str_replace(conditions, "results_2B", ""), ".csv", "")

for(cond in conditions){
  my_split <- strsplit(cond, "_|\\=")[[1]]
  strat <- as.numeric(my_split[3])
  res <- filter(all_results,directory==cond)
  marauders <- filter(res, probability_maraud == strat)
  guarders <- filter(res, probability_maraud == 0.0)
  print(cond)
  tt <- t.test(marauders$successful_mating, guarders$successful_mating)
  print(tt)
}
