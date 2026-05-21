---
name: web-scrape-provider
description: 웹사이트/비공식 API 에서 데이터를 수집하는 도구를 만들 때 사용한다. 합법성 사전 점검, 데이터 위치 탐색(SSR __NEXT_DATA__ / Nuxt devalue / 예약·결제 단계), UA 차단 우회, provider 인터페이스+레지스트리 구조, Zod 느슨검증, 단계별 비용 트레이드오프 컨벤션을 주입한다.
---

# Web Scrape Provider

웹/비공식 API 데이터 수집 도구의 공통 패턴. 무엇을 만들든 이 순서를 따른다.

## 0. 합법성 먼저 (코드 전에)

수집 대상이 정해지면 코드보다 먼저 확인한다:

- **공식 대안 우선**: 공공데이터(data.go.kr, TourAPI 등)·제휴 API 가 같은 데이터를
  주면 그걸 쓴다. 스크래핑은 마지막 수단.
- **robots.txt**: 대상 경로가 Disallow 인지 확인. 법적 강제는 아니나 의사표시.
- **ToS / 민사 리스크**: 한국은 형사(정보통신망법)보다 **민사 부정경쟁방지법**이
  실질 위험. 인증·IP차단 우회는 형사 위험을 키우고, 상업적·경쟁적 DB 복제는
  민사 배상(판례 ₩10억대) 위험. 개인 비공개·비상업·재배포 없음이면 위험은 낮다.
- 판단을 PROBLEM.md/DESIGN.md 에 한 줄로 남긴다 (왜 이 소스, 왜 합법).

## 1. 데이터 위치 탐색 (브라우저 네트워크 탭 + 페이지 소스)

원하는 값이 어디서 오는지 찾는 순서:

1. **클라이언트 XHR/fetch** — 네트워크 탭에 JSON API 가 보이면 가장 깔끔. 직접 호출.
2. **SSR 임베드** — XHR 이 없으면 SSR. 페이지 HTML 안:
   - Next.js: `<script id="__NEXT_DATA__">` (JSON) 또는 `_next/data/<buildId>/*.json`
   - Nuxt: `<script id="__NUXT_DATA__">` (devalue flat 배열 — 인덱스 역참조 필요)
3. **다음 단계 페이지** — 검색·상세에 없는 값이 예약/결제(checkout) 단계에만 있을 수
   있다. 그 단계 URL 을 직접 GET 하면 SSR 데이터에 들어있는 경우가 많다.
   (stay-finder: 대실 종료시각이 checkout `product.checkoutDate` 에만 있었다.)

값이 안 보이면 정형 필드가 없는 것 — 산문 텍스트 추출은 오탐 많으니 신뢰도를 의심한다.

## 2. 차단 우회 (정당한 범위)

- 다수 사이트가 **User-Agent 없는 요청을 403** 으로 막는다. 브라우저 UA 헤더만
  붙이면 통과하는 경우가 흔하다. `accept-language` 도 같이.
- 인증/IP차단을 우회하지 않는다 (형사 위험 + 비신사적). 저빈도로 호출한다.
- CORS: 브라우저(폰) 직접 호출은 막힌다. 수집은 항상 서버측(CLI/Worker)에서.

## 3. 구조 (멀티 소스 확장점)

```
src/
├── domain/<x>.ts            # 공통 도메인 타입 + Provider 인터페이스
├── registry.ts              # 소스명 → provider 조회
└── providers/<src>/
    ├── <src>.provider.ts    # fetch 오케스트레이션
    ├── <src>.schema.ts      # Zod 응답 스키마 (.nullish() 로 느슨하게)
    └── <src>.mapper.ts      # raw → 도메인 매핑 (snake/camel 경계 변환)
```

- 한 소스만 만들어도 인터페이스+레지스트리는 둔다. 다른 소스는 미구현(YAGNI).
- Zod 는 모르는 필드 무시하되 핵심 필드 부재는 조기에 드러나게.
- 실제 응답 1건을 픽스처로 떠서 mapper/파서를 네트워크 없이 단위테스트.

## 4. 비용 트레이드오프 (단계별 데이터)

값이 깊은 단계(상세·checkout)에 있으면 요청 수가 늘어난다:

- 검색 리스트 1요청 → 상세 N요청 → 객실/항목별 checkout N×M요청.
- 상위 N건만 보강(`enrichTop`)해 요청 수를 제한한다. CLI 옵션·env 로 노출.
- 서버리스 배포 시 subrequest 한도(예: Cloudflare 무료 50/요청)를 고려해 N 을 잡는다.

## 5. 깨짐 대비

비공식 경로는 언제든 바뀐다:

- 파싱 실패는 치명적이지 않게 — 해당 필드만 비우고 나머지는 계속.
- buildId·payload 구조 의존부는 한 곳에 모아 교체 쉽게.
- 추측 추출(산문 정규식)은 오정보를 만드니, 신뢰 안 되면 그 기능을 빼는 게 낫다.

## 런타임

TS 도구면 `ts-cli-scaffold`, 폰/원격 실행이면 `serverless-bot-deploy` 와 함께 쓴다.
