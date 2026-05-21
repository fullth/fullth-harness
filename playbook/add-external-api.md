# 외부 API 어댑터 추가

외부 API(시세·뉴스·LLM·메신저 등) 를 호출하는 모듈은 항상 같은 패턴으로
작성한다. 키 없이도 부팅·테스트가 가능해야 한다. stock-brief 회고에서
검증된 패턴이다.

## 의존성

```bash
npm install @nestjs/axios @nestjs/config axios rxjs
```

`@nestjs/config` 는 환경변수 조회용. 이미 있으면 생략.

## 모듈 구조

```
src/<adapter>/
├── <adapter>.module.ts
├── <adapter>.service.ts     # 어댑터 본체
├── <adapter>.service.spec.ts
└── <adapter>.types.ts       # 응답 타입
```

## 어댑터 본체 패턴

```ts
@Injectable()
export class FooService {
  private readonly logger = new Logger(FooService.name);
  private readonly apiKey: string;
  private readonly useMock: boolean;

  constructor(
    private readonly httpService: HttpService,
    private readonly configService: ConfigService,
  ) {
    this.apiKey = this.configService.get<string>('FOO_API_KEY') ?? '';
    this.useMock = this.apiKey.trim().length === 0;
    if (this.useMock) {
      this.logger.log('FOO_API_KEY 없음 — 목업 모드로 동작');
    }
  }

  async fetch(): Promise<FooResult> {
    if (this.useMock) {
      return this.mock();
    }
    try {
      return await this.fetchReal();
    } catch (error) {
      this.logger.warn(`실 API 실패 — 목업으로 대체: ${this.errorMessage(error)}`);
      return this.mock();
    }
  }

  private async fetchReal(): Promise<FooResult> { /* ... */ }
  private mock(): FooResult { /* ... */ }
  private errorMessage(e: unknown) { return e instanceof Error ? e.message : String(e); }
}
```

## 핵심 원칙

- **키 미설정 → 목업 폴백**. CI/데모/로컬 부팅이 키 없이 가능해진다.
- **실 API 실패 → 목업 폴백 + 경고 로그**. 외부 장애로 앱 전체가 죽지 않는다.
- **응답 매핑은 service 안에서**. 외부 스키마와 내부 타입을 분리한다.
- **URL 도 환경변수로**. 기본값을 코드에 두되 `FOO_API_URL` 로 덮어쓸 수 있게 한다. (테스트·다른 호환 서비스 대응)
- **여러 어댑터를 모으는 흐름**(예: briefing)은 각 호출을 try/catch 로 감싸 부분 실패를 허용한다. 한 소스가 죽어도 나머지가 결과를 만든다.

## 테스트

spec 은 목업 모드와 실 API 모드(httpService 모킹) 둘 다 검증한다.

```ts
it('키 없을 때 목업을 반환한다', async () => {
  configService.get.mockReturnValue('');
  expect(await service.fetch()).toEqual(expectedMock);
  expect(httpService.get).not.toHaveBeenCalled();
});

it('실 API 호출 시 응답을 내부 타입으로 매핑한다', async () => {
  configService.get.mockReturnValue('test-key');
  httpService.get.mockReturnValue(of({ data: { /* 외부 스키마 */ } }));
  expect(await service.fetch()).toEqual(/* 내부 타입 */);
});
```

## 환경변수 명명

- `<NAME>_API_KEY` — 인증
- `<NAME>_API_URL` — 베이스 URL (기본값 덮어쓰기용)
- `<NAME>_MODEL`, `<NAME>_REGION` 등 — 옵션
