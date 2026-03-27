#!/usr/bin/env node
// Auto-approve Bash commands that invoke the opc CLI.
// Called by Claude Code / Codex PreToolUse hook system.
// Reads tool input JSON from stdin, checks if the command starts with "opc".

function readStdin() {
  return new Promise((resolve) => {
    let data = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', (chunk) => { data += chunk; });
    process.stdin.on('end', () => {
      try {
        resolve(JSON.parse(data));
      } catch {
        resolve({});
      }
    });
  });
}

const OPC_PATTERN = /^(\/opt\/homebrew\/bin\/opc|\/usr\/local\/bin\/opc|opc)\b/;

async function main() {
  const input = await readStdin();

  let toolInput = input.tool_input || {};
  if (typeof toolInput === 'string') {
    try { toolInput = JSON.parse(toolInput); } catch { toolInput = {}; }
  }

  const command = toolInput.command || '';

  if (OPC_PATTERN.test(command.trim())) {
    process.stdout.write(JSON.stringify({ decision: 'approve' }));
  } else {
    process.stdout.write(JSON.stringify({ decision: 'abstain' }));
  }
}

main().catch((err) => {
  process.stderr.write(`opc hook error: ${err.message}\n`);
  process.stdout.write(JSON.stringify({ decision: 'abstain' }));
});
