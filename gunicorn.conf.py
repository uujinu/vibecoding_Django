# Gunicorn 설정 파일
# gunicorn.conf.py

import multiprocessing

# 서버 소켓
bind = "0.0.0.0:8000"
backlog = 2048

# Worker 프로세스
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "sync"
worker_connections = 1000
timeout = 30
keepalive = 2

# 로깅
accesslog = "-"
errorlog = "-"
loglevel = "info"

# 프로세스 명명
proc_name = "memojjang"

# 서버 메커니즘
daemon = False
pidfile = None
umask = 0
user = None
group = None
tmp_upload_dir = None

# SSL (필요시 활성화)
# keyfile = "/path/to/keyfile"
# certfile = "/path/to/certfile"
