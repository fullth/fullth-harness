#!/usr/bin/env node
import { Command } from 'commander';
import { z } from 'zod';
import { greet } from './lib/greet.js';

const program = new Command();

program
  .name('<<PROJECT_NAME>>')
  .description('<<PROJECT_NAME>> CLI')
  .version('0.1.0');

// 샘플 명령. 실제 도메인 로직으로 교체한다.
program
  .command('hello')
  .description('샘플 명령')
  .argument('<name>', '인사 대상')
  .action((name: string) => {
    const parsed = z.string().min(1).parse(name);
    console.log(greet(parsed));
  });

program.parseAsync(process.argv).catch((err: unknown) => {
  console.error(`오류: ${err instanceof Error ? err.message : String(err)}`);
  process.exit(1);
});
