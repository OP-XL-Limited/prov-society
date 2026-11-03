import coreWebVitals from "eslint-config-next/core-web-vitals";
import typescript from "eslint-config-next/typescript";

const eslintConfig = [
  ...coreWebVitals,
  ...typescript,
  {
    ignores: [
      "node_modules/**",
      ".next/**",
      "out/**",
      "build/**",
      "next-env.d.ts",
      "src/lib/database.types.ts",
    ],
  },
  {
    // SECX-13: the service role key must never reach browser or shared code.
    files: ["src/**/*.{ts,tsx}"],
    ignores: ["src/server/**"],
    rules: {
      "no-restricted-syntax": [
        "error",
        {
          selector: "MemberExpression[property.name='SUPABASE_SERVICE_ROLE_KEY']",
          message: "Service role key is server-only; read it in a server module, not here.",
        },
      ],
    },
  },
];

export default eslintConfig;
