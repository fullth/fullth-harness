---
name: nest-scaffold
description: NestJS 모듈·서비스·컨트롤러 골격을 만들 때 사용한다. 파일·폴더 kebab-case, facade/service 책임 분리, Zod validation 등 컨벤션을 주입한다.
---

# Nest Scaffold

NestJS 기능 모듈 골격을 일관된 컨벤션으로 만든다.

## 명명 규칙

- 파일·폴더: kebab-case (`chat-message.service.ts`, `chat-message/`)
- 클래스·인터페이스: PascalCase (`ChatMessageService`)
- 변수·함수: camelCase
- 인터페이스 속성: snake_case (외부 API·DB 페이로드 경계)
- 상수: UPPER_SNAKE_CASE

## 모듈 골격

기능 `foo` 모듈은 다음으로 구성한다:

```
src/foo/
├── foo.module.ts        # 모듈 등록
├── foo.controller.ts    # HTTP 경계. 요청/응답 변환만
├── foo.facade.ts        # 비즈니스 흐름·도메인 정책 (필요 시)
├── foo.service.ts       # 실제 로직
└── dto/foo.schema.ts    # Zod 스키마와 타입
```

## 책임 분리

- controller — HTTP 표현(상태코드, 직렬화)만. 도메인 로직 금지.
- facade — 흐름과 정책. 여러 service 를 조율한다. 단순 모듈은 생략.
- service — 한 가지 일을 하는 실제 로직.
- 한 파일이 커지면 책임이 섞인 신호다. 쪼갠다.

## 검증

- 입력 검증은 Zod 스키마로. 컨트롤러 경계에서 parse 한다.
- DB·외부 API 의 snake_case 와 내부 camelCase 는 매핑 계층에서 변환한다.
