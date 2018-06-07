# -*- coding: utf-8 -*-
#

from airflow.operators import PythonOperator
from airflow.models import DAG
from datetime import datetime, timedelta
from airflow.models import Variable
import logging

args = {
    'owner': 'systems',
    'start_date': datetime.now() - timedelta(minutes=10),
}

dag = DAG(
    dag_id='lol',
    default_args=args,
    schedule_interval="2 * * * *")

def print_context(*args, **kwargs):
    print('lol')


run_this = PythonOperator(
    task_id='do_it_for_the_lolz',
    provide_context=True,
    python_callable=print_context,
    dag=dag)


# Generate 2 chill tasks, chilling from 0 to 1 seconds?
for i in range(2):
    task = PythonOperator(
        task_id='sleeping_on_job_for_' + str(i),
        python_callable=print_context,
        op_kwargs={'random_base': float(i)},
        dag=dag)

    run_this.set_downstream(task)



