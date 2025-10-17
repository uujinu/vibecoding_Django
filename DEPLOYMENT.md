# 배포 가이드

이 문서는 메모짱(memojjang) Django 애플리케이션을 프로덕션 환경에 배포하는 방법을 설명합니다.

## 목차
1. [개발 서버 실행](#개발-서버-실행)
2. [프로덕션 환경 준비](#프로덕션-환경-준비)
3. [Gunicorn 설정](#gunicorn-설정)
4. [Nginx 설정](#nginx-설정)
5. [정적 파일 수집](#정적-파일-수집)
6. [보안 설정](#보안-설정)

---

## 개발 서버 실행

개발 환경에서 애플리케이션을 테스트하려면:

```bash
# 1. 가상환경 생성 및 활성화
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# 2. 의존성 설치
pip install -r requirements.txt

# 3. 데이터베이스 마이그레이션
python manage.py migrate

# 4. 개발 서버 실행
python manage.py runserver
```

서버가 실행되면 `http://127.0.0.1:8000`에서 애플리케이션에 접근할 수 있습니다.

---

## 프로덕션 환경 준비

### 1. 환경 변수 설정

`.env` 파일을 생성하고 필요한 환경 변수를 설정합니다:

```bash
# .env.example 파일을 복사하여 .env 파일 생성
cp .env.example .env
```

`.env` 파일을 편집하여 실제 값으로 변경:

```env
SECRET_KEY=your-production-secret-key-here
DEBUG=False
ALLOWED_HOSTS=your-domain.com,www.your-domain.com
DATABASE_NAME=db/db.sqlite3
STATIC_URL=/static/
STATIC_ROOT=staticfiles/
```

### 2. 시크릿 키 생성

안전한 시크릿 키를 생성하려면:

```python
from django.core.management.utils import get_random_secret_key
print(get_random_secret_key())
```

또는:

```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

### 3. 데이터베이스 마이그레이션

```bash
python manage.py migrate
```

---

## 정적 파일 수집

프로덕션 환경에서는 정적 파일을 한 곳에 모아야 합니다:

```bash
# 정적 파일 수집
python manage.py collectstatic

# 확인 프롬프트에서 'yes' 입력
```

이 명령은 모든 정적 파일을 `STATIC_ROOT`에 지정된 디렉토리(`staticfiles/`)로 복사합니다.

---

## Gunicorn 설정

### 1. Gunicorn 실행

기본 실행:

```bash
gunicorn memojjang.wsgi:application
```

설정 파일을 사용하여 실행:

```bash
gunicorn -c gunicorn.conf.py memojjang.wsgi:application
```

### 2. Systemd 서비스 설정 (권장)

`/etc/systemd/system/memojjang.service` 파일 생성:

```ini
[Unit]
Description=Memojjang Gunicorn daemon
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/path/to/vibecoding_Django
Environment="PATH=/path/to/vibecoding_Django/venv/bin"
ExecStart=/path/to/vibecoding_Django/venv/bin/gunicorn \
          -c /path/to/vibecoding_Django/gunicorn.conf.py \
          memojjang.wsgi:application

[Install]
WantedBy=multi-user.target
```

서비스 시작 및 활성화:

```bash
sudo systemctl start memojjang
sudo systemctl enable memojjang
sudo systemctl status memojjang
```

---

## Nginx 설정

### 1. Nginx 설정 파일 복사

```bash
# nginx.conf 파일을 Nginx 설정 디렉토리로 복사
sudo cp nginx.conf /etc/nginx/sites-available/memojjang

# 파일 내의 경로를 실제 경로로 수정
sudo nano /etc/nginx/sites-available/memojjang
```

주요 수정 사항:
- `server_name`: 실제 도메인으로 변경
- `/path/to/vibecoding_Django`: 실제 프로젝트 경로로 변경

### 2. 심볼릭 링크 생성

```bash
sudo ln -s /etc/nginx/sites-available/memojjang /etc/nginx/sites-enabled/
```

### 3. Nginx 설정 테스트 및 재시작

```bash
# 설정 테스트
sudo nginx -t

# Nginx 재시작
sudo systemctl restart nginx
```

---

## 보안 설정

### 1. HTTPS 설정 (Let's Encrypt)

```bash
# Certbot 설치
sudo apt-get install certbot python3-certbot-nginx

# SSL 인증서 발급
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

### 2. 방화벽 설정

```bash
# UFW 방화벽 설정
sudo ufw allow 'Nginx Full'
sudo ufw allow OpenSSH
sudo ufw enable
```

### 3. 보안 체크리스트

- [x] `DEBUG=False` 설정
- [x] 강력한 `SECRET_KEY` 사용
- [x] `ALLOWED_HOSTS` 설정
- [x] HTTPS 활성화
- [x] 보안 헤더 설정 (HSTS 등)
- [x] 정기적인 보안 업데이트
- [x] 데이터베이스 백업 설정

---

## 문제 해결

### Gunicorn 로그 확인

```bash
# Systemd 서비스 로그
sudo journalctl -u memojjang -f

# Gunicorn 직접 실행 시 로그
gunicorn -c gunicorn.conf.py memojjang.wsgi:application --log-level debug
```

### Nginx 로그 확인

```bash
# 액세스 로그
sudo tail -f /var/log/nginx/memojjang-access.log

# 에러 로그
sudo tail -f /var/log/nginx/memojjang-error.log
```

### 정적 파일이 로드되지 않을 때

```bash
# collectstatic 재실행
python manage.py collectstatic --clear --noinput

# Nginx 및 Gunicorn 재시작
sudo systemctl restart memojjang
sudo systemctl restart nginx
```

---

## 추가 리소스

- [Django 배포 체크리스트](https://docs.djangoproject.com/en/stable/howto/deployment/checklist/)
- [Gunicorn 문서](https://docs.gunicorn.org/)
- [Nginx 문서](https://nginx.org/en/docs/)
- [Let's Encrypt 문서](https://letsencrypt.org/docs/)
