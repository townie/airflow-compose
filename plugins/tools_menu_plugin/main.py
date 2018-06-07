# This is the class you derive to create a plugin
from airflow.plugins_manager import AirflowPlugin

from flask import Blueprint
from flask_admin import BaseView, expose
from flask_admin.base import MenuLink

CATEGORY='Tools'

rbbt = MenuLink(
    category=CATEGORY,
    name='RabbitMQ',
    url='http://localhost:15672/')

mysql = MenuLink(
    category=CATEGORY,
    name='MySql',
    url='http://localhost:3306/')


flwr = MenuLink(
    category=CATEGORY,
    name='Flower',
    url='http://localhost:5555/')

af = MenuLink(
    category=CATEGORY,
    name='Airflow',
    url='http://localhost:8080/')

# Defining the plugin class
class ToolsMenuPluglin(AirflowPlugin):
    name = "atools_menu"
    operators = []
    hooks = []
    executors = []
    macros = []
    admin_views = []
    flask_blueprints = []
    menu_links = [af, flwr, rbbt, mysql]