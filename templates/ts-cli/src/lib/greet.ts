/** 순수 로직은 lib 로 분리해 네트워크 없이 단위테스트한다. */
export function greet(name: string): string {
  return `안녕, ${name}`;
}
