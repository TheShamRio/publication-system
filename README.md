# System to track publications made by university department

## Stack for backend
- Python
- FastAPI
- sqlalchemy
- postgres
- ELK для логов
- alembic для миграций
- ?aiogram bot
- uv для управления зависимостями
- pytest для unit тестов

## Stack for frontend
- JS
- React
- MaterialUI
- Axios

## Structure
- backend - Fastapi + aiogram bot
- frontend - React client
- nginx - nginx configuration for proxy
- kibana - kibana configuration
- keycloak - keycloak configuration
- postgres - folder with script to initialize databases
- filebet - filebeat configuration
- logstash - logstash configuration


## Run project

- if u have some errors when running, make sure to delete all exisging related containers and volumes
- make sure u have `.env` file in the root directory. See example in `.env.sample`
- `run docker compose up` in the root directory of the project
- install dependencies in the `backend` folder. for example u can run `uv sync`(needed for alembic)
- in another terminal window run migrations from `backend` directory with `alembic upgrade head` command