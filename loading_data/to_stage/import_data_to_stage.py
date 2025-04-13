import sql_scripts
import db_connection

sql_scripts.copy_csv_to_postgres('stage.lung_cancer_info1', '/data/lung_cancer_info1.csv',
                                 db_connection.db_config)
sql_scripts.copy_csv_to_postgres('stage.lung_cancer_info2', '/data/lung_cancer_info2.csv',
                                 db_connection.db_config)
sql_scripts.copy_csv_to_postgres('stage.survey_lung_cancer', '/data/survey_lung_cancer.csv',
                                 db_connection.db_config)
