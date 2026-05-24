from airflow import DAG
from airflow.operators.python import PythonOperator

from datetime import datetime, timedelta
from heart_disease.utils import *


default_args = {
    'owner': 'airflow',
    'start_date': datetime(2022,7,30),
    'retries' : 1, 
    'retry_delay' : timedelta(seconds=30)
}


ML_inference_dag = DAG(
                dag_id = 'Heart_Disease_ML_dag',
                default_args = default_args,
                description = 'Dag to run inferences on predictions of heart disease patients',
                schedule_interval = '@hourly'
)

load_task = PythonOperator(
            task_id = 'load_task',
            python_callable = get_inference_data,
            dag = ML_inference_dag)

encode_task = PythonOperator(
            task_id = 'encode_task',
            python_callable = encode_features,
            dag = ML_inference_dag)

normalize_task = PythonOperator(
            task_id = 'normalize_task', 
            python_callable = normalize_data,
            dag = ML_inference_dag)

predict_task = PythonOperator(
            task_id = 'predict_task',
            python_callable = predict_data,
            dag = ML_inference_dag)

load_task >> encode_task >> normalize_task >> predict_task

