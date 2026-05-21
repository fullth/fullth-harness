---
name: ts-cli-scaffold
description: TypeScript CLI 도구 골격을 만들 때 사용한다. commander + zod + tsx + vitest, lib/도메인 분리, 외부 데이터 수집 provider 패턴 컨벤션을 주입한다. 외부 API/웹 데이터를 다루는 일회성 요청-응답 도구에 적합. bash 로 충분한 시스템 자동화는 cli-scaffold 를 쓴다.
---

# TS CLI Scaffold

TypeScript CLI 도구를 일관된 컨벤션으로 만든다. `new-project.sh <name> --type ts-cli`
가 이 골격을 사용한다. NestJS(서버)·bash CLI 와 구분된다.

## 언제 ts-cli 인가

- 외부 API/웹 데이터를 fetch·파싱해 출력하는 일회성 요청-응답 도구.
- JSON 가공·타입 안전이 중요하고 bash 로는 버거운 로직.
- 서버 상시 구동·HTTP 엔드포인트·DB 가 필요 없을 때 (그러면 nest).
- 단순 시스템 명령 wrapper·.env 갱신 류는 bash `cli-scaffold` 가 가볍다.

## 골격

```
<project>/
├── src/
│   ├── cli.ts              # commander 진입점. 인자/검증/출력만.
│   ├── lib/                # 순수 로직 (네트워크 없이 단위테스트)
│   │   └── <topic>.ts
│   ├── domain/<x>.ts       # 도메인 타입·인터페이스 (외부 수집 시)
│   └── providers/<src>/    # 외부 소스별 어댑터 (멀티 소스 확장 시)
├── dist/                   # tsc 산출물 (gitignore)
├── PROBLEM.md / DESIGN.md / RETRO.md
└── .github/workflows/ci.yml   # docs + build-test
```

## 컨벤션

- ESM (`"type":"module"`). import 는 `.js` 확장자로 (TS ESM 규칙).
- `cli.ts` 는 표현(인자 파싱·출력)만. 도메인 로직은 `lib/`·`providers/`.
- 입력 검증은 zod 로 진입 경계에서 parse.
- 순수 함수는 `lib/` 로 분리해 네트워크 없이 vitest 로 테스트.
- 파일·폴더 kebab-case, 클래스/인터페이스 PascalCase, 변수/함수 camelCase.

## 외부 데이터 수집 시

웹/외부 API 에서 데이터를 가져오면 `web-scrape-provider` 스킬의 패턴을 따른다:
- `domain/` 공통 타입 + `Provider` 인터페이스 + 레지스트리(멀티 소스 확장점)
- `providers/<src>/{provider,schema,mapper}.ts` 로 fetch / zod 검증 / 매핑 분리
- 외부 페이로드(snake/camel)와 내부 타입 경계는 mapper 에서 변환

## 테스트

- vitest. `npm test` (= `vitest run`).
- 네트워크 의존 로직은 실제 응답 1건을 픽스처로 떠서 mapper/파서를 검증.
- 테스트 파일은 `*.test.ts`, 소스 옆에 둔다. tsconfig 에서 빌드 제외.

## CI

`templates/ci/ts-cli-ci.yml` 가 docs + build-test 2 잡. docker 없음(CLI 라).
서버·컨테이너가 필요해지면 nest 로 운영 모델을 재검토한다.

## 비범위

- 상시 서버·HTTP API (→ nest). 폰/원격 실행이 필요하면 `serverless-bot-deploy`.
- bash 로 충분한 시스템 도구 (→ cli-scaffold).
