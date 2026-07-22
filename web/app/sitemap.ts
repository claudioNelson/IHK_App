import type { MetadataRoute } from "next";

export default function sitemap(): MetadataRoute.Sitemap {
  const baseUrl = "https://lernarena.app";
  const now = new Date();

  const lernThemen = [
    "subnetting",
    "ip-adressen",
    "osi-modell",
    "raid",
    "zahlensysteme",
    "sql",
    "er-diagramm",
    "normalisierung",
    "sortieralgorithmen",
    "nutzwertanalyse",
  ];

  return [
    {
      url: baseUrl,
      lastModified: now,
      changeFrequency: "weekly",
      priority: 1.0,
    },
    {
      url: `${baseUrl}/pruefungen`,
      lastModified: now,
      changeFrequency: "weekly",
      priority: 0.9,
    },
    {
      url: `${baseUrl}/lernen`,
      lastModified: now,
      changeFrequency: "weekly",
      priority: 0.9,
    },
    ...lernThemen.map((slug) => ({
      url: `${baseUrl}/lernen/${slug}`,
      lastModified: now,
      changeFrequency: "monthly" as const,
      priority: 0.8,
    })),
    {
      url: `${baseUrl}/impressum`,
      lastModified: now,
      changeFrequency: "yearly",
      priority: 0.3,
    },
    {
      url: `${baseUrl}/datenschutz`,
      lastModified: now,
      changeFrequency: "yearly",
      priority: 0.3,
    },
    {
      url: `${baseUrl}/agb`,
      lastModified: now,
      changeFrequency: "yearly",
      priority: 0.3,
    },
  ];
}
