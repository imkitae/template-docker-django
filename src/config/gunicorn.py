import os
import multiprocessing
from tempfile import mkdtemp


# Process
proc_name = 'gunicorn'
pidfile = None
daemon = False

user = None
group = None
initgroups = False
umask = 0

workers = multiprocessing.cpu_count() * 2 + 1
worker_connections = 1000 * workers
worker_class = 'gevent'


# Connection
bind = f"unix:{os.environ['GUNICORN_SOCKET']}"
backlog = 2048
max_requests = 1000
max_requests_jitter = 50
keepalive = 2
timeout = 30
graceful_timeout = 30


# Debug
spew = False
check_config = False
reload = False


# Security
limit_request_line = 4094
limit_request_fields = 100
limit_request_field_size = 8190
proxy_protocol = False


# Server Mechanic
preload_app = False
reuse_port = False
sendfile = False
tmp_upload_dir = None
worker_tmp_dir = mkdtemp()
chdir = ''


# Logging
loglevel = os.environ['GUNICORN_DEBUG_LEVEL']
logger_class = 'gunicorn.glogging.Logger'
accesslog = None
errorlog = '-'
syslog = False


# Hook
def post_fork(server, worker):
    server.log.info('Worker spawned (pid: %s)', worker.pid)

def pre_fork(server, worker):
    pass

def pre_exec(server):
    server.log.info('Forked child, re-executing.')

def when_ready(server):
    server.log.info('Server is ready. Spawning workers')

def worker_int(worker):
    worker.log.info('worker received INT or QUIT signal')

    # pylint: disable=import-outside-toplevel, multiple-imports
    import threading, sys, traceback
    id2name = {th.ident: th.name for th in threading.enumerate()}
    code = []
    for threadId, stack in sys._current_frames().items():
        code.append('\n# Thread: %s(%d)' % (id2name.get(threadId, ''), threadId))
        for filename, lineno, name, line in traceback.extract_stack(stack):
            code.append("File: '%s', line %d, in %s" % (filename, lineno, name))
            if line:
                code.append('  %s' % (line.strip()))

    worker.log.debug('\n'.join(code))

def worker_abort(worker):
    worker.log.info('worker received SIGABRT signal')
