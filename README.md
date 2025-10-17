# 메모짱 (Memojjang)

Django 기반의 메모장 웹 애플리케이션

## 주요 기능

- 사용자 로그인 및 회원가입
- 메모 작성, 수정, 삭제
- 메모 목록 조회

## 기술 스택

### 프론트엔드
- Django 템플릿 엔진: HTML, CSS, JavaScript
- Bootstrap (선택 사항)

### 백엔드
- Django Framework 5.2.7
- Django Forms
- Django 내장 인증 시스템

### 데이터베이스
- SQLite

### 배포
- Gunicorn: WSGI HTTP 서버
- WhiteNoise: 정적 파일 서빙
- Nginx: 리버스 프록시 (프로덕션)

## 빠른 시작

### 1. 저장소 클론

```bash
git clone https://github.com/uujinu/vibecoding_Django.git
cd vibecoding_Django
```

### 2. 가상환경 생성 및 활성화

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

### 3. 의존성 설치

```bash
pip install -r requirements.txt
```

### 4. 환경 변수 설정

```bash
cp .env.example .env
# .env 파일을 편집하여 필요한 설정 변경
```

### 5. 데이터베이스 마이그레이션

```bash
python manage.py migrate
```

### 6. 개발 서버 실행

```bash
python manage.py runserver
```

브라우저에서 `http://127.0.0.1:8000`으로 접속하세요.

## 배포

프로덕션 환경 배포에 대한 자세한 내용은 [DEPLOYMENT.md](DEPLOYMENT.md)를 참고하세요.

### 빠른 배포

```bash
# 배포 스크립트 실행
./deploy.sh

# Gunicorn으로 실행
gunicorn -c gunicorn.conf.py memojjang.wsgi:application
```

## 프로젝트 구조

```
vibecoding_Django/
├── apps/                     # Django 앱들
│   ├── memos/               # 메모 앱
│   └── users/               # 사용자 앱
├── memojjang/               # 메인 프로젝트
│   ├── settings.py          # 설정
│   ├── urls.py              # URL 라우팅
│   └── wsgi.py              # WSGI 설정
├── static/                  # 정적 파일
│   ├── css/
│   └── js/
├── templates/               # Django 템플릿
├── db/                      # 데이터베이스 파일
├── .env.example             # 환경 변수 예제
├── requirements.txt         # Python 의존성
├── gunicorn.conf.py         # Gunicorn 설정
├── nginx.conf               # Nginx 설정 템플릿
├── memojjang.service        # Systemd 서비스 파일
├── deploy.sh                # 배포 스크립트
├── DEPLOYMENT.md            # 배포 가이드
└── manage.py                # Django 관리 스크립트
```

## 주요 명령어

### 개발

```bash
# 개발 서버 실행
python manage.py runserver

# 마이그레이션 생성
python manage.py makemigrations

# 마이그레이션 적용
python manage.py migrate

# 슈퍼유저 생성
python manage.py createsuperuser

# Django 셸
python manage.py shell
```

### 프로덕션

```bash
# 정적 파일 수집
python manage.py collectstatic

# 배포 체크
python manage.py check --deploy

# Gunicorn 실행
gunicorn -c gunicorn.conf.py memojjang.wsgi:application
```

## 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

## 기여

기여는 언제나 환영합니다! Pull Request를 보내주세요.
