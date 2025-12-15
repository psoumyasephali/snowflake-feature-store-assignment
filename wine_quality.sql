-- select the database where you uploaded the data
use database wine_quality_db;

-- select the schema (usually public)
use schema public;

-- Extract and Prepare Data

-- create a clean table called 'wine_prep'
create or replace table wine_prep as
select 
    -- create a unique id number for every row
    row_number() over (order by null) as wine_id,
    * from wine_quality_table;

-- check if the data looks good
select * from wine_prep limit 5;

-- Feature Engineering & Feature Store
-- create the feature store table
create or replace table wine_feature_store as
select 
    wine_id,
    alcohol,
    sulphates,
    -- calculate the acidity ratio
    (fixed_acidity / nullif(volatile_acidity, 0)) as acidity_ratio,
    -- create the target: 1 if quality is 7 or higher, else 0
    case 
        when quality >= 6 then 1 
        else 0 
    end as is_good_quality
from wine_prep;

-- check your engineered features
select * from wine_feature_store limit 5;


-- train the model 
create or replace snowflake.ml.classification wine_quality_model(
    input_data => system$reference('table', 'wine_feature_store'),
    target_colname => 'is_good_quality',
    config_object => {'ON_ERROR': 'SKIP'}
);



-- calculate the accuracy 
select 
    -- compare actual vs prediction (casted to integer)
    sum(case when is_good_quality = prediction:class::int then 1 else 0 end) / count(*) as accuracy_score
from (
    select 
        is_good_quality,
        wine_quality_model!predict(
            object_construct(
                'alcohol', alcohol, 
                'sulphates', sulphates, 
                'acidity_ratio', acidity_ratio
            )
        ) as prediction
    from wine_feature_store
);