import psycopg2

def copy_csv_to_postgres(table_name, csv_file_path, db_config):
    try:
        conn = psycopg2.connect(
            host=db_config['host'],
            port=db_config['port'],
            dbname=db_config['dbname'],
            user=db_config['user'],
            password=db_config['password']
        )
        cursor = conn.cursor()

        with open(csv_file_path, 'r', encoding='utf-8') as f:
            cursor.copy_expert(
                sql=f"""
                    COPY {table_name}
                    FROM STDIN WITH CSV HEADER DELIMITER ','
                """,
                file=f
            )
        conn.commit()
        print(f"Data imported to: {table_name}")

    except Exception as e:
        print(f"Import error {table_name}: {e}")
    finally:
        if conn:
            cursor.close()
            conn.close()
