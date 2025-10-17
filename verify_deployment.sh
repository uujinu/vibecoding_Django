#!/bin/bash

# 배포 설정 검증 스크립트
# 이 스크립트는 배포 준비가 완료되었는지 확인합니다.

set -e

echo "=== 메모짱 배포 검증 스크립트 ==="
echo ""

# 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 체크 함수
check_item() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
        return 0
    else
        echo -e "${RED}✗${NC} $1"
        return 1
    fi
}

# 1. 필수 파일 확인
echo "📄 필수 파일 확인 중..."
test -f "manage.py"
check_item "manage.py 파일 존재"

test -f "requirements.txt"
check_item "requirements.txt 파일 존재"

test -f ".env.example"
check_item ".env.example 파일 존재"

test -f "gunicorn.conf.py"
check_item "gunicorn.conf.py 파일 존재"

test -f "nginx.conf"
check_item "nginx.conf 파일 존재"

test -f "DEPLOYMENT.md"
check_item "DEPLOYMENT.md 파일 존재"

test -f "deploy.sh"
check_item "deploy.sh 스크립트 존재"

echo ""

# 2. Python 패키지 확인
echo "📦 Python 패키지 확인 중..."
python -c "import django" 2>/dev/null
check_item "Django 설치됨"

python -c "import gunicorn" 2>/dev/null
check_item "Gunicorn 설치됨"

python -c "import decouple" 2>/dev/null
check_item "python-decouple 설치됨"

python -c "import whitenoise" 2>/dev/null
check_item "WhiteNoise 설치됨"

echo ""

# 3. Django 설정 확인
echo "⚙️  Django 설정 확인 중..."
python manage.py check > /dev/null 2>&1
check_item "Django 시스템 체크 통과"

test -d "apps/memos"
check_item "memos 앱 존재"

test -d "apps/users"
check_item "users 앱 존재"

test -d "templates"
check_item "templates 디렉토리 존재"

test -d "static"
check_item "static 디렉토리 존재"

echo ""

# 4. 데이터베이스 확인
echo "🗄️  데이터베이스 확인 중..."
python manage.py showmigrations --plan | grep -q "\[X\]"
check_item "마이그레이션 적용됨"

echo ""

# 5. 정적 파일 확인
echo "📁 정적 파일 확인 중..."
test -d "staticfiles"
check_item "staticfiles 디렉토리 존재"

if [ -d "staticfiles" ] && [ "$(ls -A staticfiles)" ]; then
    echo -e "${GREEN}✓${NC} 정적 파일 수집됨"
else
    echo -e "${YELLOW}⚠${NC} 정적 파일이 수집되지 않음 (python manage.py collectstatic 실행 필요)"
fi

echo ""
echo "=== 검증 완료 ==="
echo ""
echo "다음 단계:"
echo "1. 개발 서버 테스트: python manage.py runserver"
echo "2. Gunicorn 테스트: gunicorn -c gunicorn.conf.py memojjang.wsgi:application"
echo "3. 프로덕션 배포: DEPLOYMENT.md 문서 참고"
