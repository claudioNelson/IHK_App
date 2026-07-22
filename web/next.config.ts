import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  async redirects() {
    return [
      {
        source: "/pruefung",
        destination: "/pruefungen",
        permanent: true,
      },
    ];
  },
};

export default nextConfig;
