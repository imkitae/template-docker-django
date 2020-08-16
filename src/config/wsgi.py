import os
import sentry_sdk
from sentry_sdk.integrations.django import DjangoIntegration
from django.core.wsgi import get_wsgi_application


ENVIRONMENT = os.environ['ENVIRONMENT']
SENTRY_DSN = os.environ['SENTRY_DSN']

if SENTRY_DSN:
    sentry_sdk.init(
        integrations=[DjangoIntegration()],
        dsn=SENTRY_DSN,
        environment=ENVIRONMENT,
    )

    with sentry_sdk.configure_scope() as scope:
        scope.set_tag('app_name', 'template-docker-django')

os.environ.setdefault('DJANGO_SETTINGS_MODULE', f'config.settings.{ENVIRONMENT}')

application = get_wsgi_application()
