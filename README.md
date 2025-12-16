# Wine Quality Prediction using Snowflake

## Project Overview
This project demonstrates an end-to-end Machine Learning workflow entirely within Snowflake using SQL.

## Objective
To predict whether a wine is of "Good Quality" (rating 6+) or "Bad Quality" based on chemical features like alcohol content, acidity, and sulphates.

## Workflow
1. **Data Ingestion:** Uploaded wine quality dataset to Snowflake.
2. **Feature Engineering:** Calculated `acidity_ratio` and created a `is_good_quality` target variable.
3. **Feature Store:** Created a dedicated table (`wine_feature_store`) to manage features.
4. **Model Training:** Used Snowflake Cortex ML (`snowflake.ml.classification`) to train a model inside the database.
5. **Evaluation:** Achieved an accuracy of ~75% on test data.


