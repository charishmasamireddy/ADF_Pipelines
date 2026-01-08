# 🚀 Azure Data Factory: Dynamic Incremental Data Pipeline

## 📖 Overview
This project demonstrates a production-ready *Incremental Data Loading Pipeline* built in Azure Data Factory (ADF). Instead of reloading the entire dataset every time, this pipeline identifies and moves only the new or modified records from an *Azure SQL Database* to *Azure Data Lake Gen2 (ADLS)*.

## 🌟 Key Features
* *High-Watermark Logic:* Uses an external control file (cdc.json) to track the last processed timestamp, ensuring zero data duplication.
* *Fully Dynamic:* Built with pipeline parameters (SchemaName, TableName), allowing a single pipeline to handle incremental loads for any table in the database.
* *Resource Optimization:* Includes a pre-check logic that counts new records before triggering the copy activity. If no new data exists, the pipeline skips execution to save compute costs.
* *Backfill Capability:* Includes a "Backdated Refresh" parameter to manually re-process data from a specific past date if needed.

## 🛠️ Tech Stack
* *ETL Tool:* Azure Data Factory (ADF)
* *Source:* Azure SQL Database
* *Sink:* Azure Data Lake Storage Gen2 (Parquet Format)
* *Scripting:* SQL (for row counts and max value extraction)

## 🔄 Pipeline Logic (Step-by-Step)
1.  *Fetch Watermark:* A Lookup Activity reads the cdc.json file from ADLS to get the LastLoadDate.
2.  *Check for Updates:* A Script Activity runs a SQL query to count records where LastUpdatedDate > LastLoadDate.
3.  *Conditional Execution (If Condition):*
    * *If Count = 0:* The pipeline terminates (Success) to save resources.
    * *If Count > 0:*
        1.  *Copy Data:* Fetches only the delta records using the dynamic query.
        2.  *Get New Watermark:* Calculates the new Max(LastUpdatedDate) from the source.
        3.  *Update Watermark:* Overwrites cdc.json with the new timestamp for the next run.

## 📸 Screenshots
<img width="1416" height="517" alt="Ingestion_pipeline" src="https://github.com/user-attachments/assets/6e3a49eb-c9ba-430c-b86b-219b693cf751" />


## 🚀 How to Run
1.  Clone this repository.
2.  Deploy the ARM templates located in the ARM_Templates folder.
3.  Set the pipeline parameter BackDate to null for normal incremental runs, or provide a date (YYYY-MM-DD) for a historical reload.

---
Based on the advanced ADF guide by Ansh Lamba.
