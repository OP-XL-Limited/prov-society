// Fails when OSV-Scanner JSON output contains any high (CVSS >= 7.0) or critical finding (SECX-07).
// Usage: node .github/scripts/osv-gate.mjs osv.json
import { readFileSync } from "node:fs";

const raw = readFileSync(process.argv[2], "utf8");
let report;
try {
  report = JSON.parse(raw);
} catch {
  console.error("osv-gate: report is not valid JSON, failing closed");
  process.exit(2);
}

const high = [];
let total = 0;
for (const result of report.results ?? []) {
  for (const pkg of result.packages ?? []) {
    for (const group of pkg.groups ?? []) {
      total++;
      const score = Number.parseFloat(group.max_severity ?? "");
      // Unscored findings are treated as high so they are reviewed, not ignored.
      if (Number.isNaN(score) || score >= 7.0) {
        high.push(`${pkg.package.name}@${pkg.package.version} ${group.ids?.[0] ?? ""} (${group.max_severity || "unscored"})`);
      }
    }
  }
}
console.log(`osv-gate: ${total} advisory group(s), ${high.length} high or unscored`);
if (high.length) {
  console.error(high.map((h) => ` - ${h}`).join("\n"));
  process.exit(1);
}
