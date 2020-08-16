# pylint:disable=wildcard-import
from config.settings.base import *


DEBUG = False

ALLOWED_HOSTS = [
    '.ridibooks.com',
]

CORS_ALLOW_CREDENTIALS = True

CORS_ORIGIN_WHITELIST = [
    "https://select.ridibooks.com",
    "https://select-api.ridibooks.com"
]
