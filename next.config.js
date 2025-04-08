const IsStandalone = process.env.BUILD_STANDALONE == "true";

/** @type {import('next').NextConfig} */
const nextConfig = {
  typescript: {
    ignoreBuildErrors: true,
  },
  output: IsStandalone ? "standalone" : undefined,
};

module.exports = nextConfig;
