from config.settings.base import * # pylint:disable=wildcard-import


DEBUG = True

ALLOWED_HOSTS = [
    '*',
]

CORS_ALLOW_CREDENTIALS = True

CORS_ORIGIN_REGEX_WHITELIST = [
    r"^https://\w+\.ridi\.io$",
]
