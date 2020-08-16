# template-docker-django

## To Install
```bash
# Clone this repo
git clone git@githib.com:/imkitae/template-docker-django.git
cd template-docker-django

# Install packages
poetry install

# Set environment variables
cp .env.template .env
```

## To run
```bash
poetry shell
python /app/src/manage.py runserver 0.0.0.0:8000
```

#### With Docker
```bash
docker-compose up -d    # Create a container in background mode
docker-compose logs -f  # Watch logs
docker-compose down     # Destroy the container
```

## To do
- [ ] Replace os.environment with decouple
- [ ] Set Test
- [ ] Set CI/CD
- [ ] Include external infrastructure resources
