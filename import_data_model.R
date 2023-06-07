

# libraries ---------------------------------------------------------------

if(!require(RPostgres)) install.packages("RPostgres", repos = "http://cran.us.r-project.org")
if(!require(DBI)) install.packages("DBI", repos = "http://cran.us.r-project.org")

# connect to db -----------------------------------------------------------

# con <- dbConnect(RPostgres::Postgres()
#                  , host='localhost'
#                  , port='5432'
#                  , dbname='tfm_ecv_dwh'
#                  , user='postgres'
#                  , password='23111993.Andreu!')

con <- dbConnect(RPostgres::Postgres()
                 , host='am-mesio-tfm-ecv.cw0ma767gykn.eu-north-1.rds.amazonaws.com'
                 , port='5432'
                 , dbname='am_mesio_tfm_ecv_db'
                 , user='postgres'
                 , password='tfm_mesio_2023!')

# import data -------------------------------------------------------------

data_model <- DBI::dbGetQuery(con, "select * from bizecv.ecv_tx_f1_model")
pregunta_modulo <- DBI::dbGetQuery(con, "select * from crpecv.ecv_td_encuesta_pregunta")

# close connection --------------------------------------------------------

rm(con)