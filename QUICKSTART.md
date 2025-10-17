# 빠른 참조 가이드

## 개발 환경

### 개발 서버 시작
```bash
python manage.py runserver
```

### 새 마이그레이션 생성
```bash
python manage.py makemigrations
```

### 마이그레이션 적용
```bash
python manage.py migrate
```

### 슈퍼유저 생성
```bash
python manage.py createsuperuser
```

### Django 셸
```bash
python manage.py shell
```

---

## 프로덕션 배포

### 1. 환경 설정
```bash
# .env 파일 생성
cp .env.example .env

# .env 파일 편집
nano .env
```

필수 환경 변수:
- `SECRET_KEY`: 강력한 시크릿 키 (50자 이상)
- `DEBUG`: False로 설정
- `ALLOWED_HOSTS`: 실제 도메인 입력

### 2. 의존성 설치
```bash
pip install -r requirements.txt
```

### 3. 데이터베이스 마이그레이션
```bash
python manage.py migrate
```

### 4. 정적 파일 수집
```bash
python manage.py collectstatic --noinput
```

### 5. 배포 검증
```bash
./verify_deployment.sh
```

### 6. Gunicorn 실행
```bash
gunicorn -c gunicorn.conf.py memojjang.wsgi:application
```

---

## 자주 사용하는 명령어

### 정적 파일 다시 수집
```bash
python manage.py collectstatic --clear --noinput
```

### 배포 체크리스트 확인
```bash
python manage.py check --deploy
```

### 마이그레이션 상태 확인
```bash
python manage.py showmigrations
```

### 데이터베이스 초기화 (개발 환경에서만!)
```bash
rm db.sqlite3
python manage.py migrate
python manage.py createsuperuser
```

---

## 문제 해결

### Gunicorn이 실행되지 않을 때
```bash
# 설정 파일 확인
cat gunicorn.conf.py

# 직접 실행하여 에러 확인
gunicorn --bind 0.0.0.0:8000 memojjang.wsgi:application
```

### 정적 파일이 로드되지 않을 때
```bash
# collectstatic 재실행
python manage.py collectstatic --clear

# STATIC_ROOT 확인
python manage.py shell
>>> from django.conf import settings
>>> print(settings.STATIC_ROOT)
>>> print(settings.STATICFILES_DIRS)
```

### 마이그레이션 충돌
```bash
# 마이그레이션 상태 확인
python manage.py showmigrations

# 특정 앱의 마이그레이션 되돌리기
python manage.py migrate <app_name> <migration_number>
```

---

## 유용한 링크

- 프로젝트 저장소: https://github.com/uujinu/vibecoding_Django
- Django 공식 문서: https://docs.djangoproject.com/
- Gunicorn 문서: https://docs.gunicorn.org/
- WhiteNoise 문서: http://whitenoise.evans.io/
