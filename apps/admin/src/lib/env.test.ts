import { describe, expect, it } from "vitest";
import { readPublicEnv } from "./env";

describe("OPS-01 env validation", () => {
  it("accepts a valid public env", () => {
    const env = readPublicEnv({
      NEXT_PUBLIC_SUPABASE_URL: "http://127.0.0.1:54321",
      NEXT_PUBLIC_SUPABASE_ANON_KEY: "anon",
    });
    expect(env.NEXT_PUBLIC_SUPABASE_ANON_KEY).toBe("anon");
  });

  it("SECX-16 rejects a missing url", () => {
    expect(() => readPublicEnv({ NEXT_PUBLIC_SUPABASE_ANON_KEY: "anon" })).toThrow();
  });
});
