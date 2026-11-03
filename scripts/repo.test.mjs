// Repo-level acceptance tests for phase 0 requirements.
import { test } from "node:test";
import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import { existsSync, readFileSync, readdirSync } from "node:fs";
import { dirname, join, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const read = (rel) => readFileSync(join(root, rel), "utf8");
const workflows = readdirSync(join(root, ".github/workflows")).map((f) => ({ f, text: read(`.github/workflows/${f}`) }));

test("REPO-01 each app has its own path-filtered CI job", () => {
  for (const [file, folder] of [["mobile.yml", "apps/mobile/**"], ["admin.yml", "apps/admin/**"]]) {
    const text = read(`.github/workflows/${file}`);
    assert.match(text, new RegExp(folder.replace("*", "\\*")), `${file} filters on ${folder}`);
    assert.match(text, /supabase\/\*\*/, `${file} also runs when supabase/ changes`);
  }
  assert.ok(existsSync(join(root, ".github/workflows/supabase.yml")));
});

test("REPO-03 migrations exist and a CI job replays them from scratch", () => {
  assert.ok(readdirSync(join(root, "supabase/migrations")).some((f) => f.endsWith(".sql")));
  assert.match(read(".github/workflows/supabase.yml"), /supabase db reset/);
});

test("REPO-04 README lists commands for each app and the local Supabase stack", () => {
  const readme = read("README.md");
  for (const needle of ["flutter run", "npm run dev", "supabase start", "npm run tokens", "supabase test db"]) {
    assert.ok(readme.includes(needle), `README mentions ${needle}`);
  }
});

test("OPS-01 every app ships .env.example and real env files are git-ignored", () => {
  for (const p of ["apps/mobile/.env.example", "apps/admin/.env.example", "supabase/.env.example"]) {
    assert.ok(existsSync(join(root, p)), p);
  }
  for (const p of ["apps/mobile/.env", "apps/admin/.env.local", "supabase/.env"]) {
    execFileSync("git", ["check-ignore", "-q", p], { cwd: root });
  }
});

test("OPS-02 the key inventory is documented with mocks until supplied", () => {
  const all = ["apps/mobile/.env.example", "apps/admin/.env.example", "supabase/.env.example"].map(read).join("\n");
  for (const key of [
    "SUPABASE_URL", "SUPABASE_ANON_KEY", "SUPABASE_SERVICE_ROLE_KEY", "REVENUECAT_IOS_KEY", "REVENUECAT_ANDROID_KEY",
    "REVENUECAT_WEBHOOK_SECRET", "APPLE_WALLET_CERT", "GOOGLE_WALLET_ISSUER_ID", "APNS_KEY", "FCM_SERVICE_ACCOUNT", "EMAIL_PROVIDER_API_KEY",
  ]) {
    assert.ok(all.includes(key), `${key} listed in an .env.example`);
  }
});

test("SECX-03 the mobile build env holds no server secrets", () => {
  const mobile = read("apps/mobile/.env.example");
  for (const banned of ["SERVICE_ROLE", "WEBHOOK_SECRET", "P12", "P8", "PASSWORD", "SERVICE_ACCOUNT"]) {
    assert.ok(!mobile.includes(banned), `mobile env must not mention ${banned}`);
  }
});

test("SECX-07 workflows pin actions to commit SHAs and scan dependencies with OSV", () => {
  for (const { f, text } of workflows) {
    for (const m of text.matchAll(/uses:\s*([^\s@]+)@(\S+)/g)) {
      assert.match(m[2], /^[0-9a-f]{40}$/, `${f}: ${m[1]} is not pinned to a SHA`);
    }
  }
  assert.match(read(".github/workflows/security.yml"), /osv-scanner/);
  assert.match(read(".github/workflows/mobile.yml"), /flutter pub outdated/);
  assert.match(read(".github/workflows/mobile.yml"), /--enforce-lockfile/);
});

test("SECX-07 the OSV gate fails on high severity and passes on moderate", () => {
  const gate = (score) => {
    const { writeFileSync, mkdtempSync } = process.getBuiltinModule("node:fs");
    const dir = mkdtempSync(join(process.getBuiltinModule("node:os").tmpdir(), "osv-"));
    const file = join(dir, "r.json");
    writeFileSync(file, JSON.stringify({ results: [{ packages: [{ package: { name: "x", version: "1" }, groups: [{ ids: ["A"], max_severity: score }] }] }] }));
    try {
      execFileSync("node", [join(root, ".github/scripts/osv-gate.mjs"), file], { stdio: "pipe" });
      return 0;
    } catch (e) {
      return e.status;
    }
  };
  assert.equal(gate("5.3"), 0);
  assert.equal(gate("7.5"), 1);
  assert.equal(gate(""), 1, "unscored findings fail closed");
});

test("SECX-18 CI runs gitleaks over full history", () => {
  const text = read(".github/workflows/security.yml");
  assert.match(text, /gitleaks git/);
  assert.match(text, /fetch-depth: 0/);
});

test("WEBD-03 generated Dart and Tailwind tokens match tokens.json", () => {
  execFileSync("node", [join(root, "packages/tokens/build.mjs"), "--check"], { stdio: "pipe" });
});

test("ENG-09 every pull request workflow runs the design lint and tests", () => {
  assert.match(read(".github/workflows/mobile.yml"), /design_lint/);
  assert.match(read(".github/workflows/mobile.yml"), /flutter test/);
  assert.match(read(".github/workflows/admin.yml"), /npm test/);
});

test("ENG-07 admin is TypeScript strict and validates input with zod", () => {
  const ts = JSON.parse(read("apps/admin/tsconfig.json"));
  assert.equal(ts.compilerOptions.strict, true);
  assert.match(read("apps/admin/package.json"), /"zod"/);
});

test("ENG-08 every migration table enables row level security", () => {
  for (const f of readdirSync(join(root, "supabase/migrations"))) {
    const sql = read(`supabase/migrations/${f}`);
    const created = [...sql.matchAll(/create table (?:if not exists )?public\.(\w+)/gi)].map((m) => m[1]);
    for (const t of created) {
      assert.match(sql, new RegExp(`alter table public\\.${t} enable row level security`, "i"), `${f}: ${t} lacks RLS`);
    }
  }
});

test("REPO-02 type generators exist and outputs are committed", () => {
  assert.ok(existsSync(join(root, "scripts/gen-types.mjs")));
  assert.ok(existsSync(join(root, "apps/admin/src/lib/database.types.ts")));
  assert.ok(existsSync(join(root, "apps/mobile/lib/data/remote/models.g.dart")));
});
