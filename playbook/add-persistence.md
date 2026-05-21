# 영속 저장소 추가

기본 NestJS 골격은 영속 저장소가 없다. 필요해진 시점에 이 문서를 따라 더한다.

## 추가 전 결정

다음 질문에 분명히 답할 수 있을 때만 더한다.

- 정말 영속 저장소가 필요한가? cron 발송형 / 함수형 프로젝트면 텔레그램 메시지·로그 자체가 이력 역할을 할 수 있다.
- 어떤 데이터를 저장하나? 사용자 입력, 발송 이력, 캐시, 세션 중 하나로 정리한다.
- 외부 서비스(Atlas, Upstash 등 무료 티어) 로 충분한가, 로컬 컨테이너가 필요한가?

YAGNI. "있으면 좋겠다"는 추가하지 않는다.

## MongoDB

### 의존성

```bash
npm install @nestjs/mongoose mongoose
```

### `AppModule` 에 등록

```ts
import { MongooseModule } from '@nestjs/mongoose';
import { ConfigService } from '@nestjs/config';

imports: [
  MongooseModule.forRootAsync({
    inject: [ConfigService],
    useFactory: (config: ConfigService) => ({
      uri: config.get<string>('MONGO_URI') ?? 'mongodb://localhost:27017/<db>',
    }),
  }),
]
```

### docker-compose 에 mongo 서비스 추가

```yaml
services:
  mongo:
    image: mongo:7
    ports:
      - "27017:27017"
    volumes:
      - mongo-data:/data/db
volumes:
  mongo-data:
```

기존 mongo 컨테이너가 27017 을 점유 중이면 충돌한다. 다른 포트로 매핑하거나
프로젝트별 고유 컨테이너 이름을 쓴다.

### 운영 (서버리스)

GH Actions cron 으로만 도는 프로젝트는 잡 종료 시 mongo service 가 휘발한다.
이력 유지가 필요하면 Mongo Atlas M0(영구 무료, 512MB) 를 쓰고 URI 를 secret
으로 주입한다.

## Redis

```bash
npm install @nestjs/cache-manager cache-manager cache-manager-redis-store
```

용도: 캐시, 세션, 분산 락. 단일 사용자 사이드 프로젝트엔 보통 과하다.

## PostgreSQL

```bash
npm install @nestjs/typeorm typeorm pg
```

복잡한 관계, 트랜잭션, SQL 분석이 필요할 때. 사이드 프로젝트엔 보통 mongo
보다 무거우므로 도입 전 한 번 더 검토.

## 제거

처음엔 필요했지만 운영 모델이 바뀌어 영속 저장소가 불필요해진다. 적극적으로
제거한다. 의존성·모듈·docker-compose·schema·spec 을 한 번에 들어낸다.
"이력은 텔레그램 메시지 자체" 같은 대체 흐름이 가능하면 그쪽이 더 가볍다.
