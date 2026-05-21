import { describe, expect, it } from 'vitest';
import { greet } from './greet.js';

describe('greet', () => {
  it('이름으로 인사 문자열을 만든다', () => {
    expect(greet('판교')).toBe('안녕, 판교');
  });
});
