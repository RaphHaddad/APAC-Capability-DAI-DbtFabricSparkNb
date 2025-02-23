-- Use the `ref` function to select from other models
{{ config(materialized='incremental', incremental_strategy="insert_overwrite",file_format="delta") }}
with source_data as (

select 
a.PersonID as SalesPersonKey,
a.FullName,
row_number () over (
    partition by 
    a.PersonID,
    a.FullName
    order by
    a.ETL_Date desc
    ) as LatestRecord
from {{ ref('cf_people') }} a

)

select 
    SalesPersonKey,
    FullName
from source_data
where LatestRecord = 1