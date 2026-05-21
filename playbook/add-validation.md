# 입력 검증 추가

기본 NestJS 골격에 검증 라이브러리는 들어있지 않다. 사용자 입력을 받는
엔드포인트가 생기면 이 시점에 더한다.

## 권장: Zod

이유:

- 스키마와 TypeScript 타입을 한 번에 정의
- `parse` 가 에러 시 명확한 메시지
- 작은 의존성, 학습 비용 낮음

```bash
npm install zod
```

## 사용 패턴

`src/<feature>/dto/<feature>.schema.ts` 에 스키마와 타입을 둔다.

```ts
import { z } from 'zod';

export const createTickerSchema = z.object({
  symbol: z.string().min(1, 'symbol 은 1자 이상이어야 합니다'),
  note: z.string().optional(),
});

export type CreateTickerInput = z.infer<typeof createTickerSchema>;
```

컨트롤러 경계에서 parse 한다.

```ts
@Post('tickers')
create(@Body() body: unknown) {
  const input = createTickerSchema.parse(body);
  return this.service.create(input);
}
```

Zod `ZodError` 를 400 으로 매핑하려면 NestJS exception filter 한 줄로
처리한다. (코어 골격이 없으므로 도입 시 같이 추가)

## class-validator 대신 Zod 를 쓰는 이유

- class-validator 는 클래스·데코레이터 + DTO 클래스를 만들어야 한다. 보일러플레이트가 더 크다.
- 외부 API/DB 페이로드(snake_case)와 내부(camelCase) 경계에서 Zod 의 `transform` 으로 매핑까지 한 곳에서 처리 가능.

이미 class-validator 가 들어간 코드가 있다면 굳이 갈아엎지 않는다.

## 외부 API/DB 경계

외부에서 받은 데이터도 신뢰하지 않는다. 어댑터 안에서 응답을 Zod 로 parse
하면 스키마 변화 감지가 빨라진다. 단 사이드 프로젝트 단계에선 과할 수
있으므로 어댑터별로 판단.
