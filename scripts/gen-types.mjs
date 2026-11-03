// REPO-02: generate TypeScript (admin) and Dart (mobile) types from the migrated schema.
// Requires the local stack: `supabase start`. Never hand-write duplicates of these types.
// Usage: node scripts/gen-types.mjs
import { execFileSync } from "node:child_process";
import { mkdirSync, writeFileSync } from "node:fs";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";

const root = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const write = (rel, text) => {
  const p = resolve(root, rel);
  mkdirSync(dirname(p), { recursive: true });
  writeFileSync(p, text);
  console.log(`wrote ${rel}`);
};

// ---- TypeScript ----
const ts = execFileSync("supabase", ["gen", "types", "typescript", "--schema", "public"], {
  cwd: root,
  encoding: "utf8",
});
write("apps/admin/src/lib/database.types.ts", ts);

// ---- Dart ----
const container = "supabase_db_provenance-society";
const sql = `select coalesce(json_agg(c order by c.table_name, c.ordinal_position), '[]'::json)
  from (select table_name, column_name, udt_name, is_nullable = 'YES' as nullable, ordinal_position
          from information_schema.columns
         where table_schema = 'public'
           and table_name in (select table_name from information_schema.tables
                               where table_schema = 'public' and table_type = 'BASE TABLE')) c`;
const raw = execFileSync("docker", ["exec", container, "psql", "-U", "postgres", "-d", "postgres", "-t", "-A", "-c", sql], {
  encoding: "utf8",
});
const cols = JSON.parse(raw);

const dartType = (udt) => {
  if (udt.startsWith("_")) return `List<${dartType(udt.slice(1))}>`;
  if (["int2", "int4", "int8"].includes(udt)) return "int";
  if (["float4", "float8", "numeric"].includes(udt)) return "double";
  if (udt === "bool") return "bool";
  if (["timestamptz", "timestamp", "date"].includes(udt)) return "DateTime";
  if (["json", "jsonb"].includes(udt)) return "Object";
  if (["uuid", "text", "varchar", "bpchar", "citext"].includes(udt)) return "String";
  return "Object";
};
const camel = (s) => s.replace(/_([a-z])/g, (_, c) => c.toUpperCase());
const pascal = (s) => camel(s).replace(/^./, (c) => c.toUpperCase());

const tables = new Map();
for (const c of cols) {
  if (!tables.has(c.table_name)) tables.set(c.table_name, []);
  tables.get(c.table_name).push(c);
}

const decode = (type, expr) => {
  if (type === "DateTime") return `DateTime.parse(${expr} as String)`;
  if (type === "double") return `(${expr} as num).toDouble()`;
  if (type.startsWith("List<")) return `List<${type.slice(5, -1)}>.from(${expr} as List<dynamic>)`;
  return `${expr} as ${type}`;
};
const encode = (type, name) => (type === "DateTime" ? `${name}.toUtc().toIso8601String()` : name);

let dart = `// GENERATED FILE. Run \`npm run types\` after changing supabase/migrations.
// dart format off
// ignore_for_file: type=lint

`;
for (const [table, tcols] of tables) {
  const cls = `${pascal(table)}Row`;
  dart += `class ${cls} {
  const ${cls}({
${tcols.map((c) => `    ${c.nullable ? "" : "required "}this.${camel(c.column_name)},`).join("\n")}
  });

  factory ${cls}.fromJson(Map<String, dynamic> json) => ${cls}(
${tcols
  .map((c) => {
    const t = dartType(c.udt_name);
    const e = `json['${c.column_name}']`;
    return `    ${camel(c.column_name)}: ${c.nullable ? `${e} == null ? null : ${decode(t, e)}` : decode(t, e)},`;
  })
  .join("\n")}
  );

${tcols.map((c) => `  final ${dartType(c.udt_name)}${c.nullable ? "?" : ""} ${camel(c.column_name)};`).join("\n")}

  Map<String, dynamic> toJson() => {
${tcols
  .map((c) => {
    const t = dartType(c.udt_name);
    const n = camel(c.column_name);
    return `    '${c.column_name}': ${c.nullable && t === "DateTime" ? `${n}?.toUtc().toIso8601String()` : encode(t, n)},`;
  })
  .join("\n")}
  };
}

`;
}
write("apps/mobile/lib/data/remote/models.g.dart", dart.trimEnd() + "\n");
