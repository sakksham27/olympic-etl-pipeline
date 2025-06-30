Instructions to Run the Olympic Athlete ETL Pipeline
====================================================

Pre-requisites:
---------------
1. Docker installed (https://www.docker.com/products/docker-desktop)
2. Docker Compose (optional, if using)
3. Git installed
4. Python 3.10 (only if running DAG logic outside Docker)

Steps:
------

1. Clone the Repository:
------------------------
git clone https://github.com/your-username/olympic-etl-pipeline.git
cd olympic-etl-pipeline

2. Start PostgreSQL and Airflow (Docker):
-----------------------------------------
# Using Astro CLI 
astro dev start

Note: Ensure docker daemon is running

3. Load Initial Bronze Tables:
------------------------------
Run the batch ingestion DAG (e.g., `batch_load_athlete_biography`)
This will load staged subfiles into the bronze schema every 1 minute.

4. Run Transformation DAG:
--------------------------
Trigger the DAG `bronze_to_silver_pipeline` in the Airflow UI.
This will execute the SQL file: `transform_to_silver.sql`
and load cleaned data into the `silver` schema.

5. Inspect the Silver Layer:
----------------------------
Use any Postgres client (e.g., DBeaver, pgAdmin, or CLI):

psql -h localhost -p 5432 -U postgres -d Olympic_Data_Warehouse

SELECT * FROM silver.olympic_athlete_biography_cleaned;

Notes:
------
- You can modify the batch size and interval in the DAG parameters.
- All `.sql` files are stored in the `dags/sql/` directory.
- If new data is added to the `Data/staged` folder, it will be picked up by the DAGs.

