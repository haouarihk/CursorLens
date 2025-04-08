# This docker image does not build the application, it just runs it

FROM node:18-alpine

WORKDIR /app

RUN apk update
RUN apk add --no-cache libc6-compat openssl

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

USER nextjs

COPY --chown=nextjs:nodejs ./public ./public
COPY --chown=nextjs:nodejs ./.next/standalone ./
COPY --chown=nextjs:nodejs ./.next/static ./.next/static
COPY --chown=nextjs:nodejs ./scripts ./scripts
RUN chmod -R 777 .next

# Copy the Prisma schema.
COPY --chown=nextjs:nodejs ./prisma ./prisma

RUN npm install -g prisma


CMD ["sh", "scripts/_docker_run.sh"]