---
name: serverless-bot-deploy
description: CLI/스크립트 도구를 폰이나 원격에서 호출할 수 있게 서버리스로 배포할 때 사용한다. Cloudflare Workers webhook + waitUntil 비동기 패턴, 시크릿 안전 주입, GitHub Actions 자동배포, 호출 채널(텔레그램 봇/HTTP/단축어) 선택, 비용·한도 가이드를 담는다.
---

# Serverless Bot Deploy

로컬 CLI 도구를 "폰에서 아무 때나 실행" 가능하게 만든다. 핵심 제약 두 개를
먼저 이해한다:

1. **폰은 직접 fetch 못 한다** — CORS·무거운 처리·사내망 차단. 수집/처리는
   서버가 대신해야 한다.
2. **서버리스는 공짜지만 실행시간 제한** — 느린 작업(다수 fetch)은 동기 응답
   안에 못 끝낸다. 비동기 패턴이 필요하다.

도구 자체(검색·수집 로직)는 그대로 두고, **얇은 서버 진입점**만 추가한다.

## 호출 채널 선택

- **텔레그램 봇** — 설치앱 불필요, 알림 자연스러움, 개인용 최적. webhook 으로 받음.
- **HTTP + 모바일 브라우저/단축어** — 봇 만들기 싫을 때. 토큰으로 접근 제한.
- 어느 쪽이든 서버가 fetch 를 수행한다는 점은 동일.

## Cloudflare Workers 패턴 (권장)

월 0원(저사용), `waitUntil` 로 비동기 지원, GitHub Actions 배포 쉬움.

```
worker/
├── index.ts        # webhook 진입. 즉시 200 + waitUntil(백그라운드 작업)
├── command.ts      # 입력 파싱 (순수 함수, 테스트)
└── telegram.ts     # 채널 API (sendMessage/editMessage)
```

핵심 흐름 (느린 작업 대응):

1. webhook 수신 → **즉시 "처리 중" 응답** 보내고 텔레그램엔 200 반환.
2. `ctx.waitUntil(handle())` 로 백그라운드에서 실제 작업.
3. 끝나면 `editMessageText` 로 "처리 중" 메시지를 결과로 **수정**.

이래야 webhook 타임아웃·중복 전송을 피한다. 검색 로직은 `src/` provider 를 그대로
import 한다 (Node 전용 API 없으면 Workers 호환).

## 접근 제한 (필수)

- 채널 id 화이트리스트 — 본인 chat id 만 허용, 나머지는 거부.
- webhook 경로에 secret_token (텔레그램 `x-telegram-bot-api-secret-token` 헤더 검증).

## 시크릿 — 절대 파일에 안 박는다

토큰을 코드·`wrangler.toml`·깃 어디에도 평문 저장 금지(프라이빗이라도).

- 로컬: `wrangler secret put <KEY>`
- 자동배포: GitHub Secrets → Actions 가 배포 시 `wrangler secret put` 으로 주입
- `.env` 는 gitignore. 노출되면 즉시 재발급(텔레그램 `/revoke`).

## GitHub Actions 자동배포

`worker/`·`src/` push 시 배포. 사내망에서 telegram/cloudflare 가 막혀도 GitHub
서버가 배포를 수행하므로 무관.

필요한 GitHub Secrets: `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`, 그리고
채널 토큰들(`TELEGRAM_BOT_TOKEN`, `ALLOWED_CHAT_ID`, `WEBHOOK_SECRET`).

## 비용·한도

- Workers 무료: 10만 요청/일. 개인 저사용은 0원.
- **subrequest 한도**: 무료 50 fetch/요청. 단계별 데이터(객실당 fetch 등)를
  많이 부르면 닥친다. `ENRICH_TOP` 류 env 로 보강 범위를 제한한다.
- 응답이 느린 작업은 반드시 `waitUntil` 비동기로.

## 배포 후 1회

- 채널 id 확인: 봇에 메시지 후 `getUpdates` 로 (사내망이면 폰 브라우저로 직접 열기).
- webhook 등록: `setWebhook?url=<worker>&secret_token=<SECRET>`.
