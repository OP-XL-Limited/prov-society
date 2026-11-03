import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Provenance Society",
  description: "A private society for serious fragrance collectors.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className="min-h-screen antialiased">{children}</body>
    </html>
  );
}
