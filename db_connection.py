from sqlalchemy import create_engine

db_config = {
    'host': 'HOST',
    'port': 5432,
    'dbname': 'DB_NAME',
    'user': 'USER',
    'password': 'PASSWORD'
}

sqlalchemy_engine = create_engine('postgresql+psycopg2://{user}:{password}@{host}:{port}/{dbname}')