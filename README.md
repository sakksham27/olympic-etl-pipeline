# Olympic Athlete Data ETL Pipeline

This project demonstrates a production-grade batch ETL pipeline that ingests, transforms, and structures Olympic athlete data using Apache Airflow and PostgreSQL. The pipeline is designed to simulate real-world batch processing and follows a bronze–silver schema architecture common in modern data platforms.

## 📂 Project Overview

The pipeline handles structured ingestion and transformation of six large Olympic-related datasets. Each dataset has been split into 30–40 subfiles to emulate continuous data arrival. These subfiles are batch-loaded into a PostgreSQL data warehouse via Airflow and processed in scheduled intervals.

### Key Objectives
- Simulate batch-based data ingestion using subfile streaming
- Clean and transform raw semi-structured data
- Maintain data lineage using a bronze–silver layer design
- Orchestrate all steps using Apache Airflow on Docker


## 🧱 Tech Stack

| Component        | Tool/Tech               |
|------------------|--------------------------|
| Workflow Engine  | Apache Airflow           |
| Data Warehouse   | PostgreSQL (Dockerized)  |
| Orchestration    | Docker                   |
| Data Transformation | SQL (Postgres dialect) |
| Dev Environment  | VS Code + GitHub         |

## 🧪 Datasets & Processing

- **Datasets**: Six major Olympic datasets (e.g., athlete biography, event details)
- **Batch Simulation**: Each file is split into 30–40 subfiles for incremental loading
- **Transformation Logic**:
  - Regex-based parsing for date fields (`born`)
  - Normalization of weight ranges (e.g., `"70–75"` → `72.5`)
  - Whitespace trimming and casing corrections
  - Format validation for country/NOC codes


## 🧭 DAG Flow Details

1. **Batch Loader DAG** (runs every minute):
   - Loads 5 subfiles into the `bronze` schema
   - Ensures file traceability and idempotent ingestion

2. **Transformation DAG**:
   - Cleans and standardizes data via SQL
   - Loads clean records into `silver` schema
   - Handles malformed values, type casting, and formatting

## 🔒 Data Quality Considerations

- Null handling and validation on critical fields (e.g., `athlete_id`)
- Pattern recognition for corrupted or misformatted values
- Use of lateral joins and regex for advanced parsing

## 📌 Future Extensions

- Gold layer with analytics-ready tables
- Great Expectations or custom validation framework
- Metadata tracking and batch logging
- Integration with dashboarding tools (Looker, Superset)

## ✅ Status

The pipeline is functional and actively ingesting and transforming data. It serves as a complete example of modern batch-based ELT architecture using open-source tools and can be extended for production-level use.

---






