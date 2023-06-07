

# libraries ---------------------------------------------------------------

if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(corrplot)) install.packages("corrplot", repos = "http://cran.us.r-project.org")
if(!require(data.table)) install.packages("data.table", repos = "http://cran.us.r-project.org")


# import custom functions -------------------------------------------------

source('../andreumeca/Documents/upc_msc_mesio/subjects/tfm/dev/modeling/custom_functions.R')


# import data -------------------------------------------------------------

source('../andreumeca/Documents/upc_msc_mesio/subjects/tfm/dev/modeling/import_data_model.R')


# data cleaning -----------------------------------------------------------

data_model <- data_model %>%
  # mutate(across(everything(), ~ifelse(.==" ", "", as.character(.))))%>%
  # mutate(across(everything(), ~ifelse(.=="", NA, as.character(.)))) %>% 
  mutate(across(everything(), 
                .fns = ~str_replace_all(., "  +", " "))) %>% 
  mutate(across(everything(), 
                .fns = ~str_replace_all(., "^ $+", NA_character_)))


# Datos faltantes ---------------------------------------------------------

data_na <- showNA(data_model %>%
                    mutate(across(everything(), ~ifelse(.=="", NA, as.character(.))))) %>% 
  mutate(feature = toupper(feature)) %>% 
  left_join(pregunta_modulo, by = c("feature" = "pk_pregunta")) %>% 
  mutate(feature = coalesce(des_pregunta_corta, tolower(feature)),
         des_serie = coalesce(des_serie, "Persona/Hogar"))

ggplot(data = data_na %>% 
         filter(value > 0) %>% 
         arrange(desc(value)), mapping = aes(x = fct_reorder(feature, value),
                                                           y = value)) +
  geom_col(data = data_na %>% 
             filter(value > 0) %>% 
             arrange(desc(value)), aes(fill = des_serie)) +
  coord_flip() +
  ylab(label = "% of NA") +
  xlab(label = "Variables")

na_test <- data_na %>% 
  as_tibble() %>% 
  filter(value > 10) %>% 
  select(value, feature) %>% 
  arrange(desc(value))

ggplot(data = data_na %>% 
         as_tibble() %>% 
         filter(value > 10) %>% 
         select(value, feature) %>% 
         arrange(desc(value)) %>% 
         unique(), mapping = aes(x = fct_reorder(feature, value), y = value)) +
  geom_col(fill = "blue") +
  coord_flip() +
  ylab(label = "% of NA") +
  xlab(label = "Variables") 

delete_features <- data_na %>%
  filter(value > 10) %>%
  select(feature)

data_fit <- data_model[,!(names(data_model) %in% delete_features$feature)]


# Correlación entre las variables descriptivas ----------------------------

corrdf <- data.frame(
  lapply(data_model,
         function(x) as.numeric(as.character(x))))

corr_simple(corrdf, sig = 0.9)

data_cor <- data_fit %>%
  pivot_longer(cols = pl040:hh091, names_to = 'cod_pregunta', values_to = 'cod_respuesta') %>%
  mutate(cod_pregunta = toupper(cod_pregunta)) %>%
  left_join(pregunta_modulo, by = c("cod_pregunta" = "pk_pregunta"))

for(i in 1:length(unique(data_cor$des_serie))){

  data_cor_serie <- data_cor %>%
    filter(des_serie == unique(pregunta_modulo$des_serie)[i]) %>%
    mutate(pk_anyo_persona = paste0(pk_anyo, pk_persona)) %>%
    select(pk_anyo_persona, cod_pregunta, cod_respuesta) %>%
    pivot_wider(names_from = 'cod_pregunta', values_from = 'cod_respuesta') %>%
    select(-pk_anyo_persona)

  corrdf <- data.frame(
    lapply(data_cor_serie,
           function(x) as.numeric(as.character(x)))) %>%
    select(where(~!all(is.na(.x))))

  if(length(corrdf) > 0){
    corr_simple(corrdf)

  }
}

# data_persona_corr_na <- data_model %>% 
#   select(-c("val_anyo_nacimiento", "td_anyomes_nacimiento", "hy022", "hy023", 
#             "hy140g", "imp_renta_unidad_consumo", "hy040g", "hy050g", "hy060g",
#             "hy080g", "hy090g", "hy110g", "hy130g", "hy010", "flg_pobreza_exclusion",
#             "cod_pobreza_exclusion"))
# 
# corrdf <- data.frame(
#   lapply(data_persona_corr_na,
#          function(x) as.numeric(as.character(x))))
# 
# corr_simple(corrdf, sig = 0.7)

# glimpse(data_persona_corr_na)
# 
# corr_simple(corrdf)
# 
# mcar_test(data_persona_corr_na[,pe040:hh091])
# 
# data_persona_corr_na$pe040
# 
# data_persona_corr_na %>% 
#   select(pe040:hh091) %>% 
#   mcar_test()

data_persona_corr <- data_fit %>%
  select(pk_anyo:cod_riesgo_pobreza) %>%
  select(-c("flg_carencia_material_severa", "flg_hogar_baja_intensidad_empleo",
            "flg_riesgo_pobreza", "flg_pobreza_exclusion", "flg_vacaciones"
            , "flg_comida", "flg_temperatura", "flg_gastos_imprevistos"
            , "flg_retraso_pago", "flg_coche", "flg_telefono", "flg_television"
            , "flg_lavadora", "pk_persona", "fk_hogar", "cod_pobreza_exclusion",
            "cod_riesgo_pobreza", "cod_hogar_baja_intensidad_empleo"
            , "cod_carencia_material_severa", "flg_riesgo_pobreza_longitudinal",
            "des_carencia_material_severa", "des_hogar_baja_intensidad_empleo",
            "des_riesgo_pobreza", "des_riesgo_pobreza", "des_pobreza_exclusion",
            "des_riesgo_pobreza_longitudinal", "flg_hogar_baja_intensidad_empleo",
            "hy022", "hy023", "hy140g"))

corrdf <- data.frame(
  lapply(data_persona_corr,
         function(x) as.numeric(as.character(x))))

# data_persona_corr <- data_persona_corr %>%
#   select(-c("val_anyo_nacimiento", "td_anyomes_nacimiento", "imp_renta_unidad_consumo",
#             "hy010", "hy040g", "hy050g", "hy060g", "hy070g", "hy080g", "hy090g",
#             "hy110g", "hy130g"))
# 
# corrdf <- data.frame(
#   lapply(data_persona_corr,
#          function(x) as.numeric(as.character(x))))

corr_simple(corrdf)


# datos resultantes -------------------------------------------------------

data_mod <- data_fit %>% 
  select(pk_anyo, pk_persona, val_anyo_rotacion, val_edad, des_sexo, flg_pobreza_exclusion, 
         des_region, des_riesgo_pobreza_exclusion_longitudinal, pl040, hy020, hy030n, 
         hy040n, hy050n, hy060n, hy070n, hy080n, hy090n, hy100n, hy110n, hy120n,
         hy130n, hy145n, hy170n, hs021, hs040, hs050, hs060, hs070, hs080, hs090,
         hs100, hs110, hs120, hs130, hs140, hh010, hh021, hh030, hh031, hh040, hh050,
         hh070, hh081, hh091) %>% 
  mutate(flg_riesgo_pobreza_exclusion_long = factor(case_when(des_riesgo_pobreza_exclusion_longitudinal == 'Sin riesgo de pobreza y/o exclusión social' ~ 0,
                                                  .default = 1)),
         pk_anyo = as.numeric(pk_anyo),
         val_edad = as.numeric(val_edad),
         hy020 = as.numeric(hy020),
         hy030n = as.numeric(hy030n),
         hs130 = as.numeric(hs130),
         hh030 = as.numeric(hh030),
         hh031 = as.numeric(hh031),
         hy040n = as.numeric(hy040n),
         hy050n = as.numeric(hy050n),
         hy060n = as.numeric(hy060n),
         hy070n = as.numeric(hy070n),
         hy080n = as.numeric(hy080n),
         hy090n = as.numeric(hy090n),
         hy100n = as.numeric(hy100n),
         hy110n = as.numeric(hy110n),
         hy120n = as.numeric(hy120n),
         hy130n = as.numeric(hy130n),
         hy145n = as.numeric(hy145n),
         hy170n = as.numeric(hy170n),
         hh070 = as.numeric(hh070)
  ) %>% 
  select(-c("des_riesgo_pobreza_exclusion_longitudinal"))

data_na <- showNA(data_mod %>%
                    mutate(across(everything(), ~ifelse(.=="", NA, as.character(.))))) %>%
  mutate(feature = toupper(feature)) %>%
  left_join(pregunta_modulo, by = c("feature" = "pk_pregunta")) %>%
  mutate(feature = coalesce(des_pregunta_corta, feature))

ggplot(data = data_na %>% filter(value > 0), mapping = aes(x = fct_reorder(feature, value), y = value)) +
  geom_col(fill = "blue") +
  coord_flip() +
  ylab(label = "% of NA") +
  xlab(label = "Variables")


# sampling de los datos ---------------------------------------------------

mcar_test(data_mod)



# data_mod %>% 
#   group_by(pk_anyo, val_anyo_rotacion, flg_pobreza_exclusion, flg_riesgo_pobreza_exclusion_long) %>% 
#   summarise(n = n())
