#!/bin/bash

# 배포 스크립트
# 이 스크립트는 Django 애플리케이션을 프로덕션 환경에 배포하는 것을 돕습니다.

set -e

echo "=== 메모짱 배포 스크립트 ==="
echo ""

# 환경 확인
if [ ! -f ".env" ]; then
    echo "⚠️  .env 파일이 없습니다."
    echo "📝 .env.example을 복사하여 .env 파일을 생성하고 설정을 변경하세요."
    echo "   cp .env.example .env"
    exit 1
fi

# 의존성 설치
echo "📦 의존성 설치 중..."
pip install -r requirements.txt

# 데이터베이스 마이그레이션
echo "🗄️  데이터베이스 마이그레이션 실행 중..."
python manage.py migrate

# 정적 파일 수집
echo "📁 정적 파일 수집 중..."
python manage.py collectstatic --noinput

# 시스템 체크
echo "🔍 시스템 체크 실행 중..."
python manage.py check --deploy

echo ""
echo "✅ 배포 준비 완료!"
echo ""
echo "다음 단계:"
echo "1. 개발 서버 실행: python manage.py runserver"
echo "2. Gunicorn 실행: gunicorn -c gunicorn.conf.py memojjang.wsgi:application"
echo "3. 프로덕션 배포: DEPLOYMENT.md 문서를 참고하세요."
