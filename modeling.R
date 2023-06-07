
rm(list = ls())

# set seed ----------------------------------------------------------------

set.seed(123)

# libraries ---------------------------------------------------------------

if(!require(furrr)) install.packages("furrr", repos = "http://cran.us.r-project.org")
if(!require(tidymodels)) install.packages("tidymodels", repos = "http://cran.us.r-project.org")
if(!require(xgboost)) install.packages("xgboost", repos = "http://cran.us.r-project.org")
if(!require(vip)) install.packages("vip", repos = "http://cran.us.r-project.org")
if(!require(glmnet)) install.packages("glmnet", repos = "http://cran.us.r-project.org")
# if(!require(krf)) install.packages("krf", repos = "http://cran.us.r-project.org")
if(!require(ranger)) install.packages("ranger", repos = "http://cran.us.r-project.org")
if(!require(agua)) install.packages("agua", repos = "http://cran.us.r-project.org")
if(!require(bonsai)) install.packages("bonsai", repos = "http://cran.us.r-project.org")
if(!require(stacks)) install.packages("stacks", repos = "http://cran.us.r-project.org")
if(!require(doParallel)) install.packages("doParallel", repos = "http://cran.us.r-project.org")
if(!require(LiblineaR)) install.packages("LiblineaR", repos = "http://cran.us.r-project.org")


# import data -------------------------------------------------------------

# load("~/Documents/upc_msc_mesio/subjects/tfm/treball/20230515.RData")
source('../andreumeca/Documents/upc_msc_mesio/subjects/tfm/dev/eda/eda.R')

rm(corrdf, data_cor, data_cor_serie, data_fit, data_model, data_na, 
   data_persona_corr, delete_features, corr_simple, showNA, i)

# modeling ----------------------------------------------------------------

data_modelz <- data_mod %>% 
  filter(val_anyo_rotacion == '1' & flg_pobreza_exclusion == '0',
         pk_anyo < max(data_mod$pk_anyo)) %>% 
  select(-c("flg_pobreza_exclusion", "val_anyo_rotacion"))
 
data_modelz <- data_modelz %>% 
  drop_na()

rm(data_mod)


# summary -----------------------------------------------------------------

summary(data_modelz$flg_riesgo_pobreza_exclusion_long)

# train and test sets -----------------------------------------------------

### train and test sets
set.seed(456)
modelz_split <- initial_split(data_modelz, strata = flg_riesgo_pobreza_exclusion_long)
modelz_train <- training(modelz_split)
modelz_test <- testing(modelz_split)


# cross-validation --------------------------------------------------------

k_folds <- vfold_cv(modelz_train, strata = flg_riesgo_pobreza_exclusion_long, prop = 0.75)


# metrics -----------------------------------------------------------------

model_metrics <- metric_set(yardstick::accuracy,
                            yardstick::roc_auc,
                            yardstick::f_meas,
                            yardstick::sensitivity,
                            yardstick::specificity)

model_control <- control_grid(save_pred = TRUE)


# model parameters --------------------------------------------------------


## auto-ml -----------------------------------------------------------------

auto_ml_sec <- 360

## logistic regression -----------------------------------------------------

set.seed(1)

glm_grid <- grid_regular(
  penalty(),
  levels = 50
  ) 


## random forest -----------------------------------------------------------

set.seed(2)

rf_grid <- grid_latin_hypercube(
  min_n(),
  finalize(mtry(), modelz_train %>% select(-c("pk_persona", "flg_riesgo_pobreza_exclusion_long"))),
  trees(),
  size = 50
)

## xgboost -----------------------------------------------------------------

set.seed(3)

xgb_grid <- grid_latin_hypercube(
  trees(),
  tree_depth(),
  min_n(),
  loss_reduction(),
  sample_size = sample_prop(),
  finalize(mtry(), modelz_train %>% select(-c("pk_persona", "flg_riesgo_pobreza_exclusion_long"))),
  learn_rate(),
  size = 100
)


## gbm ---------------------------------------------------------------------

set.seed(4)

gbm_grid <- grid_latin_hypercube(
  trees(),
  tree_depth(),
  min_n(),
  loss_reduction(),
  sample_size = sample_prop(),
  finalize(mtry(), modelz_train %>% select(-c("pk_persona", "flg_riesgo_pobreza_exclusion_long"))),
  learn_rate(),
  size = 100
)

## k-NN --------------------------------------------------------------------

set.seed(5)

knn_grid <- grid_regular(neighbors(), 
                         levels = 10
                         )


## support vector machines -------------------------------------------------

set.seed(6)

svm_grid <- grid_regular(cost(), 
                         rbf_sigma(), 
                         levels = 4
                         )


# parallelize -------------------------------------------------------------

# doParallel::registerDoParallel()

# modeling ----------------------------------------------------------------

## normalized -------------------------------------------------------------

### pre-processing --------------------------------------------------------

model_rec_norm <- recipe(flg_riesgo_pobreza_exclusion_long ~ ., 
                    data = modelz_train) %>% 
  step_rm(pk_persona) %>% 
  step_nzv(all_predictors()) %>% 
  # step_corr(all_numeric(), -all_outcomes()) %>% 
  step_lincomb(all_numeric(), -all_outcomes()) %>% 
  step_normalize(all_numeric(), -all_outcomes()) %>% 
  step_dummy(all_nominal(), -all_outcomes(), one_hot = TRUE)

### auto-ml -----------------------------------------------------------------

h2o_start()

auto_model_norm <- auto_ml() %>%
  set_engine("h2o"
             , max_runtime_secs = auto_ml_sec
             , exclude_algos = "StackedEnsemble") %>%
  set_mode("classification")

auto_wflow_norm <- workflow() %>%
  add_model(auto_model_norm) %>%
  add_recipe(model_rec_norm)

auto_fit_norm <- fit(auto_wflow_norm, data = modelz_train)

# autoplot(auto_fit_norm, type = "rank", metric = c("mae", "rmse")) +
#   theme(legend.position = "none")

h2o_end()

### logistic regression -----------------------------------------------------

glm_model_norm <- logistic_reg(
  penalty = tune(),
  mixture = 1) %>%
  set_mode("classification") %>% 
  set_engine("glmnet")

glm_tune_norm <- tune_grid(
  object = glm_model_norm, 
  preprocessor = model_rec_norm,
  grid = glm_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

glm_param_norm <- glm_tune_norm %>% 
  select_best(metric = "roc_auc")

glm_final_model_norm <- logistic_reg(
  penalty = glm_param_norm$penalty, 
  mixture = 1) %>%
  set_mode("classification") %>% 
  set_engine("glmnet")

glm_wf_final_model_norm <- workflow() %>% 
  add_model(glm_final_model_norm) %>% 
  add_recipe(model_rec_norm)

glm_final_res_norm <- last_fit(glm_wf_final_model_norm, modelz_split, 
                               metrics = model_metrics)

### random forest -----------------------------------------------------------

rf_model_norm <- rand_forest(
  mtry = tune(), 
  min_n = tune(),
  trees = tune()
  ) %>%
  set_mode("classification") %>% 
  set_engine("ranger")


rf_tune_norm <- tune_grid(
  object = rf_model_norm,
  preprocessor = model_rec_norm,
  grid = rf_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

rf_param_norm <- rf_tune_norm %>% 
  select_best(metric = "roc_auc")

rf_final_model_norm <- rand_forest(
  mtry = rf_param_norm$mtry, 
  min_n = rf_param_norm$min_n,
  trees = rf_param_norm$trees
) %>%
  set_mode("classification") %>% 
  set_engine("ranger", importance = "impurity")

rf_wf_final_model_norm <- workflow() %>% 
  add_model(rf_final_model_norm) %>% 
  add_recipe(model_rec_norm)

rf_final_res_norm <- last_fit(rf_wf_final_model_norm, modelz_split, 
                              metrics = model_metrics)

rf_final_res_norm %>% 
  extract_fit_parsnip() %>% 
  vip(num_features = 20)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

### xgboost -----------------------------------------------------------------

xgb_model_norm <- boost_tree(
  trees = tune(),
  tree_depth = tune(),
  min_n = tune(),
  loss_reduction = tune(),
  sample_size = tune(),
  mtry = tune(),
  learn_rate = tune()
) %>%
  set_engine("xgboost") %>% 
  set_mode("classification")

xgb_tune_norm <- tune_grid(
  xgb_model_norm,
  preprocessor = model_rec_norm,
  grid = xgb_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

xgb_param_norm <- xgb_tune_norm %>% 
  select_best(metric = "roc_auc")

xgb_final_model_norm <- boost_tree(
  trees = xgb_param_norm$trees,
  tree_depth = xgb_param_norm$tree_depth,
  min_n = xgb_param_norm$min_n,
  loss_reduction = xgb_param_norm$loss_reduction,
  sample_size = xgb_param_norm$sample_size,
  mtry = xgb_param_norm$mtry,
  learn_rate = xgb_param_norm$learn_rate
) %>%
  set_engine("xgboost") %>% 
  set_mode("classification")

xgb_wf_final_model_norm <- workflow() %>% 
  add_model(xgb_final_model_norm) %>% 
  add_recipe(model_rec_norm)

xgb_final_res_norm <- last_fit(xgb_wf_final_model_norm, modelz_split, 
                               metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

### gbm ---------------------------------------------------------------------

gbm_model_norm <- boost_tree(
  trees = tune(),
  tree_depth = tune(),
  min_n = tune(),
  loss_reduction = tune(),
  sample_size = tune(),
  mtry = tune(),
  learn_rate = tune()
) %>%
  set_engine("lightgbm") %>% 
  set_mode("classification")

gbm_tune_norm <- tune_grid(
  gbm_model_norm,
  preprocessor = model_rec_norm,
  grid = gbm_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics, 
)

gbm_param_norm <- gbm_tune_norm %>% 
  select_best(metric = "roc_auc")

gbm_final_model_norm <- boost_tree(
  trees = gbm_param_norm$trees,
  tree_depth = gbm_param_norm$tree_depth,
  min_n = gbm_param_norm$min_n,
  loss_reduction = gbm_param_norm$loss_reduction,
  sample_size = gbm_param_norm$sample_size,
  mtry = gbm_param_norm$mtry,
  learn_rate = gbm_param_norm$learn_rate
) %>%
  set_engine("lightgbm") %>% 
  set_mode("classification")

gbm_wf_final_model_norm <- workflow() %>% 
  add_model(gbm_final_model_norm) %>% 
  add_recipe(model_rec_norm)

gbm_final_res_norm <- last_fit(gbm_wf_final_model_norm, modelz_split, 
                               metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

### k-NN --------------------------------------------------------------------

knn_model_norm <- nearest_neighbor(neighbors = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("kknn")

knn_tune_norm <- tune_grid(
  knn_model_norm,
  model_rec_norm,
  grid = knn_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

knn_param_norm <- knn_tune_norm %>% 
  select_best(metric = "roc_auc")

knn_model_norm <- nearest_neighbor(
  neighbors = knn_param_norm$neighbors) %>% 
  set_mode("classification") %>% 
  set_engine("kknn")

knn_wf_final_model_norm <- workflow() %>% 
  add_model(knn_model_norm) %>% 
  add_recipe(model_rec_norm)

knn_final_res_norm <- last_fit(knn_wf_final_model_norm, modelz_split, 
                               metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

### support vector machines -------------------------------------------------

svm_model_norm <- svm_rbf(
  cost = tune(), 
  rbf_sigma = tune()) %>%
  set_mode("classification") %>%
  set_engine("kernlab")

svm_tune_norm <- tune_grid(
  svm_model_norm,
  model_rec_norm,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)
              
svm_param_norm <- svm_tune_norm %>% 
  select_best(metric = "roc_auc")

svm_model_norm <- svm_rbf(
  cost = svm_param_norm$cost, 
  rbf_sigma = svm_param_norm$rbf_sigma) %>%
  set_mode("classification") %>%
  set_engine("kernlab")

svm_wf_final_model_norm <- workflow() %>% 
  add_model(svm_model_norm) %>% 
  add_recipe(model_rec_norm)

svm_final_res_norm <- last_fit(svm_wf_final_model_norm, modelz_split, 
                               metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

## raw ----------------------------------------------------------------------

### pre-processing ----------------------------------------------------------

model_rec_raw <- recipe(flg_riesgo_pobreza_exclusion_long ~ ., 
                    data = modelz_train) %>% 
  step_rm(pk_persona) %>% 
  step_nzv(all_predictors()) %>% 
  # step_corr(all_numeric(), -all_outcomes()) %>% 
  step_lincomb(all_numeric(), -all_outcomes()) %>% 
  step_dummy(all_nominal(), -all_outcomes(), one_hot = TRUE)

### auto-ml -----------------------------------------------------------------

h2o_start()

auto_model_raw <- auto_ml() %>%
  set_engine("h2o"
             , max_runtime_secs = auto_ml_sec
             , exclude_algos = "StackedEnsemble") %>%
  set_mode("classification")

auto_wflow_raw <- workflow() %>%
  add_model(auto_model_raw) %>%
  add_recipe(model_rec_raw)

auto_fit_raw <- fit(auto_wflow_raw, data = modelz_train)

# autoplot(auto_fit_raw, type = "rank", metric = c("mae", "rmse")) +
#   theme(legend.position = "none")

h2o_end()


### logistic regression -----------------------------------------------------

glm_model_raw <- logistic_reg(
  penalty = tune(),
  mixture = 1) %>%
  set_mode("classification") %>% 
  set_engine("glmnet")

glm_tune_raw <- tune_grid(
  object = glm_model_raw,
  preprocessor = model_rec_raw,
  grid = glm_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

glm_param_raw <- glm_tune_raw %>% 
  select_best(metric = "roc_auc")

glm_final_model_raw <- logistic_reg(
  penalty = glm_param_raw$penalty, 
  mixture = 1) %>%
  set_mode("classification") %>% 
  set_engine("glmnet")

glm_wf_final_model_raw <- workflow() %>% 
  add_model(glm_final_model_raw) %>% 
  add_recipe(model_rec_raw)

glm_final_res_raw <- last_fit(glm_wf_final_model_raw, modelz_split, 
                              metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

### random forest -----------------------------------------------------------

rf_model_raw <- rand_forest(
  mtry = tune(), 
  min_n = tune(),
  trees = tune()
) %>%
  set_mode("classification") %>% 
  set_engine("ranger")


rf_tune_raw <- tune_grid(
  object = rf_model_raw,
  preprocessor = model_rec_raw,
  grid = rf_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

rf_param_raw <- rf_tune_raw %>% 
  select_best(metric = "roc_auc")

rf_final_model_raw <- rand_forest(
  mtry = rf_param_raw$mtry, 
  min_n = rf_param_raw$min_n,
  trees = rf_param_raw$trees
) %>%
  set_mode("classification") %>% 
  set_engine("ranger")

rf_wf_final_model_raw <- workflow() %>% 
  add_model(rf_final_model_raw) %>% 
  add_recipe(model_rec_raw)

rf_final_res_raw <- last_fit(rf_wf_final_model_raw, modelz_split, 
                             metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

### xgboost -----------------------------------------------------------------

xgb_model_raw <- boost_tree(
  trees = tune(),
  tree_depth = tune(),
  min_n = tune(),
  loss_reduction = tune(),
  sample_size = tune(),
  mtry = tune(),
  learn_rate = tune()
) %>%
  set_engine("xgboost") %>% 
  set_mode("classification")

xgb_tune_raw <- tune_grid(
  xgb_model_raw,
  preprocessor = model_rec_raw,
  grid = xgb_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

xgb_param_raw <- xgb_tune_raw %>% 
  select_best(metric = "roc_auc")

xgb_final_model_raw <- boost_tree(
  trees = xgb_param_raw$trees,
  tree_depth = xgb_param_raw$tree_depth,
  min_n = xgb_param_raw$min_n,
  loss_reduction = xgb_param_raw$loss_reduction,
  sample_size = xgb_param_raw$sample_size,
  mtry = xgb_param_raw$mtry,
  learn_rate = xgb_param_raw$learn_rate
) %>%
  set_engine("xgboost") %>% 
  set_mode("classification")

xgb_wf_final_model_raw <- workflow() %>% 
  add_model(xgb_final_model_raw) %>% 
  add_recipe(model_rec_raw)

xgb_final_res_raw <- last_fit(xgb_wf_final_model_raw, modelz_split, 
                              metrics = model_metrics)

extract_fit_parsnip(xgb_final_res_raw$.workflow[[1]]) %>%
  vip::vi() %>%
  arrange(desc(Importance)) %>%
  head(20) %>%
  mutate(Variable = toupper(Variable)) %>%
  left_join(pregunta_modulo, by = c("Variable" = "pk_pregunta")) %>%
  mutate(Variable = coalesce(des_pregunta_corta, Variable)) %>%
  select(Variable, Importance) %>%
  ggplot(aes(x = Variable, y = Importance)) +
  geom_segment(aes(x = reorder(Variable,Importance), xend = Variable, y = 0, yend = Importance)) +
  geom_point() +
  coord_flip()

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

### gbm ---------------------------------------------------------------------

gbm_model_raw <- boost_tree(
  trees = tune(),
  tree_depth = tune(),
  min_n = tune(),
  loss_reduction = tune(),
  sample_size = tune(),
  mtry = tune(),
  learn_rate = tune()
) %>%
  set_engine("lightgbm") %>% 
  set_mode("classification")

gbm_tune_raw <- tune_grid(
  gbm_model_raw,
  preprocessor = model_rec_raw,
  grid = gbm_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics, 
)

gbm_param_raw <- gbm_tune_raw %>% 
  select_best(metric = "roc_auc")

gbm_final_model_raw <- boost_tree(
  trees = gbm_param_raw$trees,
  tree_depth = gbm_param_raw$tree_depth,
  min_n = gbm_param_raw$min_n,
  loss_reduction = gbm_param_raw$loss_reduction,
  sample_size = gbm_param_raw$sample_size,
  mtry = gbm_param_raw$mtry,
  learn_rate = gbm_param_raw$learn_rate
) %>%
  set_engine("lightgbm") %>% 
  set_mode("classification")

gbm_wf_final_model_raw <- workflow() %>% 
  add_model(gbm_final_model_raw) %>% 
  add_recipe(model_rec_raw)

gbm_final_res_raw <- last_fit(gbm_wf_final_model_raw, modelz_split, 
                              metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

### k-NN --------------------------------------------------------------------

knn_model_raw <- nearest_neighbor(neighbors = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("kknn")

knn_tune_raw <- tune_grid(
  knn_model_raw,
  model_rec_raw,
  grid = knn_grid,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

knn_param_raw <- knn_tune_raw %>% 
  select_best(metric = "roc_auc")

knn_model_raw <- nearest_neighbor(
  neighbors = knn_param_raw$neighbors) %>% 
  set_mode("classification") %>% 
  set_engine("kknn")

knn_wf_final_model_raw <- workflow() %>% 
  add_model(knn_model_raw) %>% 
  add_recipe(model_rec_raw)

knn_final_res_raw <- last_fit(knn_wf_final_model_raw, modelz_split, 
                              metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")


### support vector machines -------------------------------------------------

svm_model_raw <- svm_rbf(
  cost = tune(),
  rbf_sigma = tune()) %>%
  set_mode("classification") %>%
  set_engine("kernlab")

svm_tune_raw <- tune_grid(
  svm_model_raw,
  model_rec_raw,
  resamples = k_folds,
  control = model_control,
  metrics = model_metrics
)

svm_param_raw <- svm_tune_raw %>% 
  select_best(metric = "roc_auc")

svm_model_raw <- svm_rbf(
  cost = svm_param_raw$cost, 
  rbf_sigma = svm_param_raw$rbf_sigma) %>%
  set_mode("classification") %>%
  set_engine("kernlab")

svm_wf_final_model_raw <- workflow() %>% 
  add_model(svm_model_raw) %>% 
  add_recipe(model_rec_raw)

svm_final_res_raw <- last_fit(svm_wf_final_model_raw, modelz_split, 
                              metrics = model_metrics)

save.image(file = "Documents/upc_msc_mesio/subjects/tfm/treball/20230516.RData")

# results ------------------------------------------------------------------


## normalized --------------------------------------------------------------


### auto-ml -----------------------------------------------------------------

# autoplot(auto_fit_norm, type = "rank", metric = c("mae", "rmse")) +
#   theme(legend.position = "none")


### logistic regression -----------------------------------------------------

glm_tune_norm %>% 
  collect_predictions() %>% 
  group_by(id) %>% 
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>%
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

glm_final_res_norm %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

glm_final_res_norm %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

glm_norm_metrics <- glm_tune_norm %>% 
  collect_metrics() %>% 
  filter(.config == glm_param_norm$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "Logistic Regression Normalized - Train") %>% 
  union_all(
    glm_final_res_norm %>%
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "Logistic Regression Normalized - Test")
  )

ggplot(data = glm_norm_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())


### random forest -----------------------------------------------------------

rf_tune_norm %>% 
  collect_predictions() %>% 
  group_by(id) %>% 
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>%
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

rf_final_res_norm %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

rf_final_res_norm %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

rf_norm_metrics <- rf_tune_norm %>% 
  collect_metrics() %>% 
  filter(.config == rf_param_norm$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "Random Forest Normalized - Train") %>% 
  union_all(
    rf_final_res_norm %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "Random Forest Normalized - Test")
  )

ggplot(data = rf_norm_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

### xgboost -----------------------------------------------------------------

xgb_tune_norm %>% 
  collect_predictions() %>% 
  group_by(id) %>% 
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>%
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

xgb_final_res_norm %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

xgb_final_res_norm %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

xgb_norm_metrics <- xgb_tune_norm %>% 
  collect_metrics() %>% 
  filter(.config == xgb_param_norm$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "XGBoost Normalized - Train") %>% 
  union_all(
    xgb_final_res_norm %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "XGBoost Normalized - Test")
  )

ggplot(data = xgb_norm_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

# extract_fit_parsnip(xgb_final_res_norm$.workflow[[1]]) %>% 
#   vip::vi() %>%
#   arrange(desc(Importance)) %>%
#   head(20) %>% 
#   mutate(Variable = toupper(Variable)) %>% 
#   left_join(pregunta_modulo, by = c("Variable" = "pk_pregunta")) %>% 
#   mutate(Variable = coalesce(des_pregunta_corta, Variable)) %>% 
#   select(Variable, Importance) %>% 
#   ggplot(aes(x = Variable, y = Importance)) +
#   geom_segment(aes(x = reorder(Variable,Importance), xend = Variable, y = 0, yend = Importance)) +
#   geom_point() +
#   coord_flip()

### gbm ---------------------------------------------------------------------

gbm_tune_norm %>% 
  collect_predictions() %>% 
  group_by(id) %>% 
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>%
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

gbm_final_res_norm %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

gbm_final_res_norm %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

gbm_norm_metrics <- gbm_tune_norm %>% 
  collect_metrics() %>% 
  filter(.config == gbm_param_norm$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "Gradient Boosting Normalized - Train") %>% 
  union_all(
    gbm_final_res_norm %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "Gradient Boosting Normalized - Test")
  )

ggplot(data = gbm_norm_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge()) 

lightgbm::lgb.importance(extract_fit_parsnip(gbm_final_res_norm)$fit) %>% 
  as_tibble() %>% 
  mutate(Feature = toupper(Feature)) %>%
  # mutate(Feature = str_split(Feature, "_")[[1]][1]) %>% 
  left_join(pregunta_modulo, by = c("Feature" = "pk_pregunta")) %>%
  mutate(Feature = coalesce(des_pregunta_corta, Feature)) %>% 
  select(Feature, Gain) %>%
  rename("Variable" = "Feature",
         "Importància" = "Gain") %>% 
  arrange(desc(Importància)) %>% 
  head(10) %>% 
  ggplot(aes(x = Variable, y = Importància)) +
  geom_segment(aes(x = reorder(Variable,Importància), xend = Variable, y = 0, yend = Importància)) +
  geom_point() +                           
  scale_x_discrete(labels = function(x) str_wrap(x, width = 50)) +
  coord_flip() +
  theme_minimal(base_size = 12) +
  theme(
    text = element_text(colour = mid_text),
    plot.title = element_text(colour = '#1A242F', family = "EnriquetaSB", size = rel(1.6), margin = margin(12, 0, 8, 0)),
    plot.subtitle = element_text(size = rel(1.1), margin = margin(4, 0, 0, 0)),
    axis.text.y = element_text(colour = light_text, size = rel(1)),
    axis.title.y = element_text(size = 12, margin = margin(0, 4, 0, 0)),
    axis.text.x = element_text(colour = mid_text, size = rel(1)),
    axis.title.x = element_text(size = 12, margin = margin(0, 4, 0, 0)),
    legend.position = "bottom",
    # legend.justification = 1,
    legend.direction = "vertical",
    panel.grid = element_line(colour = "#F3F4F5"),
    plot.caption = element_text(size = rel(0.8), margin = margin(8, 0, 0, 0)),
    plot.margin = margin(0.25, 0.25, 0.25, 0.25,"cm")
  )

### k-NN --------------------------------------------------------------------

knn_tune_norm %>% 
  collect_predictions() %>% 
  group_by(id) %>%  
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

knn_final_res_norm %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

knn_final_res_norm %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

knn_norm_metrics <- knn_tune_norm %>% 
  collect_metrics() %>% 
  filter(.config == knn_param_norm$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "k-NN Normalized - Train") %>% 
  union_all(
    knn_final_res_norm %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "k-NN Normalized - Test")
  )

ggplot(data = knn_norm_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

### support vector machines -------------------------------------------------

svm_tune_norm %>% 
  collect_predictions() %>% 
  group_by(id) %>%  
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

svm_final_res_norm %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

svm_final_res_norm %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

svm_norm_metrics <- svm_tune_norm %>% 
  collect_metrics() %>% 
  filter(.config == svm_param_norm$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "Support Vector Machines Normalized - Train") %>% 
  union_all(
    svm_final_res_norm %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "Support Vector Machines Normalized - Test")
  )

ggplot(data = svm_norm_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

## raw ---------------------------------------------------------------------

### auto-ml -----------------------------------------------------------------

# autoplot(auto_fit_raw, type = "rank", metric = c("mae", "rmse")) +
#   theme(legend.position = "none")


### logistic regression -----------------------------------------------------

glm_tune_raw %>% 
  collect_predictions() %>% 
  group_by(id) %>% 
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>%
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

glm_final_res_raw %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

glm_final_res_raw %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

glm_raw_metrics <- glm_tune_raw %>% 
  collect_metrics() %>% 
  filter(.config == glm_param_raw$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "Logistic Regression Raw - Train") %>% 
  union_all(
    glm_final_res_raw %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "Logistic Regression Raw - Test")
  )

ggplot(data = glm_raw_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

### random forest -----------------------------------------------------------

rf_tune_raw %>% 
  collect_predictions() %>% 
  group_by(id) %>% 
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>%
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

rf_final_res_raw %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

rf_final_res_raw %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

rf_raw_metrics <- rf_tune_raw %>% 
  collect_metrics() %>% 
  filter(.config == rf_param_raw$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "Random Forest Raw - Train") %>% 
  union_all(
    rf_final_res_raw %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "Random Forest Raw - Test")
  )

ggplot(data = rf_raw_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

### xgboost -----------------------------------------------------------------

xgb_tune_raw %>% 
  collect_predictions() %>% 
  group_by(id) %>% 
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>%
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

xgb_final_res_raw %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

xgb_final_res_raw %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

xgb_raw_metrics <- xgb_tune_raw %>% 
  collect_metrics() %>% 
  filter(.config == xgb_param_raw$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "XGBoost Raw - Train") %>% 
  union_all(
    xgb_final_res_raw %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "XGBoost Raw - Test")
  )

ggplot(data = xgb_raw_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

extract_fit_parsnip(xgb_final_res_raw$.workflow[[1]]) %>% 
  vip::vi() %>%
  arrange(desc(Importance)) %>%
  head(20) %>% 
  mutate(Variable = toupper(Variable)) %>% 
  left_join(pregunta_modulo, by = c("Variable" = "pk_pregunta")) %>% 
  mutate(Variable = coalesce(des_pregunta_corta, Variable)) %>% 
  select(Variable, Importance) %>% 
  ggplot(aes(x = Variable, y = Importance)) +
  geom_segment(aes(x = reorder(Variable,Importance), xend = Variable, y = 0, yend = Importance)) +
  geom_point() +
  coord_flip()

### gbm ---------------------------------------------------------------------

gbm_tune_raw %>% 
  collect_predictions() %>% 
  group_by(id) %>% 
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>%
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

gbm_final_res_raw %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

gbm_final_res_raw %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

gbm_raw_metrics <- gbm_tune_raw %>% 
  collect_metrics() %>% 
  filter(.config == gbm_param_raw$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "Gradient Boosting Raw - Train") %>% 
  union_all(
    gbm_final_res_raw %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "Gradient Boosting Raw - Test")
  )

ggplot(data = gbm_raw_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

### k-NN --------------------------------------------------------------------

knn_tune_raw %>% 
  collect_predictions() %>% 
  group_by(id) %>%  
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

knn_final_res_raw %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

knn_final_res_raw %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

knn_raw_metrics <- knn_tune_raw %>% 
  collect_metrics() %>% 
  filter(.config == knn_param_raw$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "k-NN Raw - Train") %>% 
  union_all(
    knn_final_res_raw %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "k-NN Raw - Test")
  )

ggplot(data = knn_raw_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())

### support vector machines -------------------------------------------------

svm_tune_raw %>% 
  collect_predictions() %>% 
  group_by(id) %>%  
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  ggplot(aes(1- specificity, sensitivity, color = id)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(show.legend = FALSE, alpha = 0.6, linewidth = 1.2) +
  coord_equal()

svm_final_res_raw %>% 
  collect_predictions() %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

svm_final_res_raw %>% 
  collect_predictions() %>% 
  f_meas(truth = flg_riesgo_pobreza_exclusion_long,
         estimate = .pred_class)

svm_raw_metrics <- svm_tune_raw %>% 
  collect_metrics() %>% 
  filter(.config == svm_param_raw$.config) %>% 
  select(.metric, mean) %>% 
  rename(".estimate" = "mean") %>% 
  mutate(model = "Support Vector Machines Raw - Train") %>% 
  union_all(
    svm_final_res_raw %>% 
      collect_metrics() %>% 
      select(.metric, .estimate) %>% 
      mutate(model = "Support Vector Machines Raw - Test")
  )

ggplot(data = svm_raw_metrics, mapping = aes(x = .metric, y = .estimate, fill = model)) +
  geom_col(position=position_dodge())


## comparison --------------------------------------------------------------


### normalized --------------------------------------------------------------

rs_roc_curve_norm <- glm_final_res_norm %>% 
  collect_predictions() %>% 
  select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  mutate(model = "Logistic Regression") %>% 
  union_all(
    rf_final_res_norm %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Random Forest") 
    ) %>% 
  union_all(
    xgb_final_res_norm %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "XGBoost") 
  ) %>% 
  union_all(
    gbm_final_res_norm %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Gradient-Boosting") 
  ) %>% 
  union_all(
    knn_final_res_norm %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "k-Nearest Neighbors") 
  ) %>% 
  union_all(
    svm_final_res_norm %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Support Vector Machines") 
  )

rs_roc_curve_norm %>% 
  group_by(model) %>%  
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  ggplot(aes(1- specificity, sensitivity, color = model)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(alpha = 0.6, linewidth = 1.2) +
  coord_equal()


### raw ---------------------------------------------------------------------


rs_roc_curve_raw <- glm_final_res_raw %>% 
  collect_predictions() %>% 
  select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  mutate(model = "Logistic Regression") %>% 
  union_all(
    rf_final_res_raw %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Random Forest") 
  ) %>% 
  union_all(
    xgb_final_res_raw %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "XGBoost") 
  ) %>% 
  union_all(
    gbm_final_res_raw %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Gradient-Boosting") 
  ) %>% 
  union_all(
    knn_final_res_raw %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "k-Nearest Neighbors") 
  ) %>% 
  union_all(
    svm_final_res_raw %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Support Vector Machines") 
  )

rs_roc_curve_raw %>% 
  group_by(model) %>%  
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  ggplot(aes(1- specificity, sensitivity, color = model)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(alpha = 0.6, linewidth = 1.2) +
  coord_equal()


### all ---------------------------------------------------------------------



rs_roc_curve_best <- xgb_final_res_raw %>% 
  collect_predictions() %>% 
  select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  mutate(model = "XGBoost Raw") %>% 
  union_all(
    rf_final_res_raw %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Random Forest Raw") 
  ) %>% 
  union_all(
    gbm_final_res_raw %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Gradient-Boosting Raw") 
  ) %>% 
  union_all(
    rf_final_res_norm %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Random Forest Norm") 
  ) %>% 
  union_all(
    xgb_final_res_norm %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "XGBoost Norm") 
  ) %>% 
  union_all(
    gbm_final_res_norm %>% 
      collect_predictions() %>% 
      select(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
      mutate(model = "Gradient-Boosting Norm") 
  )

rs_roc_curve_best %>% 
  group_by(model) %>%  
  roc_curve(flg_riesgo_pobreza_exclusion_long, .pred_0) %>% 
  ggplot(aes(1- specificity, sensitivity, color = model)) +
  geom_abline(lty = 2, color = "gray80", linewidth = 1.5) +
  geom_path(alpha = 0.6, linewidth = 1.2) +
  coord_equal()

metrics_train_table_all <- glm_norm_metrics %>% 
  union_all(rf_norm_metrics) %>% 
  union_all(xgb_norm_metrics) %>% 
  union_all(gbm_norm_metrics) %>% 
  union_all(knn_norm_metrics) %>% 
  union_all(glm_raw_metrics) %>% 
  union_all(rf_raw_metrics) %>% 
  union_all(xgb_raw_metrics) %>% 
  union_all(gbm_raw_metrics) %>% 
  union_all(knn_raw_metrics) %>% 
  union_all(svm_raw_metrics) %>% 
  filter(str_detect(model,"Train")) %>% 
  pivot_wider(names_from = .metric, values_from = .estimate)

metrics_test_table_all <- glm_norm_metrics %>% 
  union_all(rf_norm_metrics) %>% 
  union_all(xgb_norm_metrics) %>% 
  union_all(gbm_norm_metrics) %>% 
  union_all(knn_norm_metrics) %>% 
  union_all(svm_norm_metrics) %>% 
  union_all(glm_raw_metrics) %>% 
  union_all(rf_raw_metrics) %>%
  union_all(xgb_raw_metrics) %>%
  union_all(gbm_raw_metrics) %>%
  union_all(knn_raw_metrics) %>%
  union_all(svm_raw_metrics) %>%
  filter(str_detect(model,"Test")) %>% 
  pivot_wider(names_from = .metric, values_from = .estimate) %>% 
  arrange(desc(f_meas)) %>% 
  mutate(model = sapply(str_split(model, " - "), function(x) x[1])) %>% 
  pivot_wider(names_from = .metric, values_from = .estimate) %>% 
  arrange(desc(f_meas))



# ensemble ----------------------------------------------------------------


# model_control_ensemble <- control_grid(save_pred = TRUE, save_workflow = TRUE)
# 
# rf_tune_raw_ensemble <- tune_grid(
#   object = rf_model_raw,
#   preprocessor = model_rec_raw,
#   grid = rf_grid,
#   resamples = k_folds,
#   control = model_control_ensemble,
#   metrics = model_metrics
# )
# 
# xgb_tune_raw_ensemble <- tune_grid(
#   xgb_model_raw,
#   preprocessor = model_rec_raw,
#   grid = xgb_grid,
#   resamples = k_folds,
#   control = model_control_ensemble,
#   metrics = model_metrics
# )
# 
# gbm_tune_raw_ensemble <- tune_grid(
#   gbm_model_raw,
#   preprocessor = model_rec_raw,
#   grid = gbm_grid,
#   resamples = k_folds,
#   control = model_control_ensemble,
#   metrics = model_metrics, 
# )
# 
# ensemble_fit <- stacks() %>% 
#   add_candidates(rf_tune_raw_ensemble) %>% 
#   add_candidates(xgb_tune_raw_ensemble) %>% 
#   add_candidates(gbm_tune_raw_ensemble) %>% 
#   blend_predictions() %>% 
#   fit_members()

ensemble_stack <- rf_tune_norm %>% 
  collect_predictions() %>% 
  inner_join(rf_param_raw) %>% 
  select(id, randomforest = .pred_class, .row, flg_riesgo_pobreza_exclusion_long) %>% 
  left_join(gbm_tune_raw %>% 
              collect_predictions() %>% 
              inner_join(gbm_param_raw) %>% 
              select(id, gradientboosting = .pred_class, .row, flg_riesgo_pobreza_exclusion_long)) %>% 
  select(-c(id, .row))

ensemble_model <- logistic_reg(penalty = 0, mixture = 0) %>% 
  set_mode("classification") %>% 
  set_engine("glmnet") %>% 
  fit(flg_riesgo_pobreza_exclusion_long ~ ., data = ensemble_stack)

ensemble_model %>% tidy()

stack_final_df <- tibble("model" = list(rf_final_res_raw, gbm_final_res_raw),
                         "model_names" = c("randomforest", "gradientboosting")) %>% 
  mutate(pred = map(model, collect_predictions))

stack_final <- stack_final_df %>% 
  select(model_names, pred) %>% 
  unnest(pred) %>% 
  select(.row, model_names, .pred_class, flg_riesgo_pobreza_exclusion_long) %>% 
  pivot_wider(id_cols = c(.row, flg_riesgo_pobreza_exclusion_long), names_from = model_names, values_from = .pred_class) %>% 
  select(-c(.row))

predict(ensemble_model, stack_final) %>% 
  bind_cols(stack_final) %>% 
  rename("stack" = ".pred_class") %>% 
  pivot_longer(-flg_riesgo_pobreza_exclusion_long) %>% 
  group_by(name) %>% 
  yardstick::f_meas(truth = flg_riesgo_pobreza_exclusion_long, estimate = value)

ensemble_predict <- predict(ensemble_model, stack_final, type = "prob") %>% 
  bind_cols(stack_final) %>% 
  mutate(.pred_class = as_factor(if_else(.pred_0 > 0.5, 0, 1)))

ensemble_predict %>% 
  conf_mat(estimate = .pred_class, truth = flg_riesgo_pobreza_exclusion_long)

ensemble_metrics <- ensemble_predict %>% 
  metrics(truth = flg_riesgo_pobreza_exclusion_long, estimate = .pred_class, .pred_0) %>% 
  union_all(ensemble_predict %>% 
              f_meas(truth = flg_riesgo_pobreza_exclusion_long, estimate = .pred_class)) %>% 
  union_all(ensemble_predict %>% 
              sensitivity(truth = flg_riesgo_pobreza_exclusion_long, estimate = .pred_class)) %>% 
  union_all(ensemble_predict %>% 
              specificity(truth = flg_riesgo_pobreza_exclusion_long, estimate = .pred_class))

ensemble_metrics %>% 
  select(.metric, .estimate) %>% 
  filter(.metric %in% c("accuracy", "f_meas", "sensitivity", "specificity", "roc_auc")) %>% 
  pivot_wider(names_from = .metric, values_from = .estimate) %>% 
  mutate(model = "Stack Raw - Test")

metrics_test_table_all %>% 
  union_all(ensemble_metrics %>% 
              select(.metric, .estimate) %>% 
              filter(.metric %in% c("accuracy", "f_meas", "sensitivity", "specificity", "roc_auc")) %>% 
              pivot_wider(names_from = .metric, values_from = .estimate) %>% 
              mutate(model = "Stack Raw - Test")) %>% 
  arrange(desc(f_meas))


# class probability analytics ---------------------------------------------

gbm_final_res_norm %>% 
  collect_predictions() %>% 
  mutate(.pred = round(100*.pred_1/5)*5,
         flg_riesgo_pobreza_exclusion_long = case_when(flg_riesgo_pobreza_exclusion_long == 0 ~ 'Sin_Riesgo',
                                                       flg_riesgo_pobreza_exclusion_long == 1 ~ 'En_Riesgo')) %>% 
  select(-.pred_1) %>% 
  count(.pred, flg_riesgo_pobreza_exclusion_long) %>% 
  pivot_wider(names_from = flg_riesgo_pobreza_exclusion_long, values_from = n) %>% 
  mutate(prob = 100* (En_Riesgo / (En_Riesgo + Sin_Riesgo))) %>% 
  ggplot(aes(x = .pred, y = prob)) +
  geom_point() + 
  geom_smooth() +
  geom_abline()

ensemble_predict %>% 
  mutate(.pred = round(100*.pred_1/5)*5,
         flg_riesgo_pobreza_exclusion_long = case_when(flg_riesgo_pobreza_exclusion_long == 0 ~ 'Sin_Riesgo',
                                                       flg_riesgo_pobreza_exclusion_long == 1 ~ 'En_Riesgo')) %>% 
  select(-.pred_1) %>% 
  count(.pred, flg_riesgo_pobreza_exclusion_long) %>% 
  pivot_wider(names_from = flg_riesgo_pobreza_exclusion_long, values_from = n) %>% 
  mutate(prob = 100* (En_Riesgo / (En_Riesgo + Sin_Riesgo))) %>% 
  ggplot(aes(x = .pred, y = prob)) +
  geom_point() + 
  geom_smooth() +
  geom_abline()
  

library(ggplot2)

threshold_data <- threshold_data %>%
  filter(.metric != "distance") %>%
  mutate(group = case_when(
    .metric == "sens" | .metric == "spec" ~ "1",
    TRUE ~ "2"
  ))

max_j_index_threshold <- threshold_data %>%
  filter(.metric == "j_index") %>%
  filter(.estimate == max(.estimate)) %>%
  pull(.threshold)

ggplot(threshold_data, aes(x = .threshold, y = .estimate, color = .metric, alpha = group)) +
  geom_line() +
  theme_minimal() +
  scale_color_viridis_d(end = 0.9) +
  scale_alpha_manual(values = c(.4, 1), guide = "none") +
  geom_vline(xintercept = max_j_index_threshold, alpha = .6, color = "grey30") +
  labs(
    x = "'Good' Threshold\n(above this value is considered 'good')",
    y = "Metric Estimate",
    title = "Balancing performance by varying the threshold",
    subtitle = "Sensitivity or specificity alone might not be enough!\nVertical line = Max J-Index"
  )

gbm_final_res_norm %>% 
  collect_predictions() %>%
  ggplot( aes(x=flg_riesgo_pobreza_exclusion_long, y=.pred_1)) +
  geom_boxplot() +
  xlab("Valor Real de Futur Risc de Pobresa i/o Exclusió Social") +
  ylab("Probabilitat assignada pel model a valor 1") +
  theme_minimal(base_size = 12) +
  theme(
    text = element_text(colour = mid_text),
    plot.title = element_text(colour = '#1A242F', family = "EnriquetaSB", size = rel(1.6), margin = margin(12, 0, 8, 0)),
    plot.subtitle = element_text(size = rel(1.1), margin = margin(4, 0, 0, 0)),
    axis.text.y = element_text(colour = light_text, size = rel(1)),
    axis.title.y = element_text(size = 12, margin = margin(0, 4, 0, 0)),
    axis.text.x = element_text(colour = mid_text, size = rel(1)),
    axis.title.x = element_text(size = 12, margin = margin(0, 4, 0, 0)),
    legend.position = "right",
    legend.justification = 1,
    legend.direction = "vertical",
    panel.grid = element_line(colour = "#F3F4F5"),
    plot.caption = element_text(size = rel(0.8), margin = margin(8, 0, 0, 0)),
    plot.margin = margin(0.25, 0.25, 0.25, 0.25,"cm")
  )

rf_final_res_norm %>% 
  collect_predictions() %>%
  ggplot( aes(x=flg_riesgo_pobreza_exclusion_long, y=.pred_1)) +
  geom_boxplot() +
  xlab("Valor Real de Futur Risc de Pobresa i/o Exclusió Social") +
  ylab("Probabilitat assignada pel model a valor 1") +
  theme_minimal(base_size = 12) +
  theme(
    text = element_text(colour = mid_text),
    plot.title = element_text(colour = '#1A242F', family = "EnriquetaSB", size = rel(1.6), margin = margin(12, 0, 8, 0)),
    plot.subtitle = element_text(size = rel(1.1), margin = margin(4, 0, 0, 0)),
    axis.text.y = element_text(colour = light_text, size = rel(1)),
    axis.title.y = element_text(size = 12, margin = margin(0, 4, 0, 0)),
    axis.text.x = element_text(colour = mid_text, size = rel(1)),
    axis.title.x = element_text(size = 12, margin = margin(0, 4, 0, 0)),
    legend.position = "right",
    legend.justification = 1,
    legend.direction = "vertical",
    panel.grid = element_line(colour = "#F3F4F5"),
    plot.caption = element_text(size = rel(0.8), margin = margin(8, 0, 0, 0)),
    plot.margin = margin(0.25, 0.25, 0.25, 0.25,"cm")
  )

pregunta_modulo %>% 
  filter(tolower(pk_pregunta) %in% c("hy020", "hh070", "hy145n", "hy030n",
                                     "hh031", "hs130", "hy090n", "hs040")) %>% 
  select(pk_pregunta, des_pregunta_corta) %>% 
  rename("Pregunta" = "pk_pregunta",
         "Descripció" = "des_pregunta_corta")
