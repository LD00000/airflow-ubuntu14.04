# -*- coding: utf-8 -*-
# add authentication

import airflow
from airflow import models, settings
from airflow.contrib.auth.backends.password_auth import PasswordUser

user = PasswordUser(models.User())
user.username = 'k2data'
user.email = 'lidong@k2data.com.cn'
user.password = 'passw0rd'
session = settings.Session()
session.add(user)
session.commit()
session.close()
