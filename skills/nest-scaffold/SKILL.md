---
name: nest-scaffold
description: NestJS 모듈·서비스·컨트롤러 골격을 만들 때 사용한다. 파일·폴더 kebab-case, facade/service 책임 분리, 외부 의존성 어댑터 패턴 등 컨벤션을 주입한다.
---

# Nest Scaffold

NestJS 기능 모듈 골격을 일관된 컨벤션으로 만든다. 기본 보일러플레이트는
영속 저장소·검증 라이브러리·외부 API 의존성을 포함하지 않는다. 필요해지면
playbook 가이드를 따라 추가한다.

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
├── foo.controller.ts    # HTTP 경계. 요청/응답 변환만 (필요 시)
├── foo.facade.ts        # 비즈니스 흐름·도메인 정책 (필요 시)
├── foo.service.ts       # 실제 로직
└── dto/foo.schema.ts    # 입력 스키마와 타입 (검증 도입 시)
```

## 책임 분리

- controller — HTTP 표현(상태코드, 직렬화)만. 도메인 로직 금지.
- facade — 흐름과 정책. 여러 service 를 조율한다. 단순 모듈은 생략.
- service — 한 가지 일을 하는 실제 로직.
- 한 파일이 커지면 책임이 섞인 신호다. 쪼갠다.

## 의존성 도입 가이드

기본 골격엔 다음이 없다. 필요해지는 시점에 playbook 을 따라 추가한다.
미리 더하지 않는다.

- 영속 저장소(MongoDB/PostgreSQL/Redis) → `playbook/add-persistence.md`
- 입력 검증 라이브러리(Zod 등) → `playbook/add-validation.md`
- 외부 API 어댑터 + 목업 폴백 패턴 → `playbook/add-external-api.md`

## 데이터 경계

- DB·외부 API 의 snake_case 와 내부 camelCase 는 매핑 계층에서 변환한다.
- 내부 타입은 camelCase, 외부 페이로드는 그쪽 스키마 그대로 받고 어댑터
  안에서 변환한다.
