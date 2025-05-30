FROM node:18-alpine

WORKDIR /app

RUN apk update
RUN apk add --no-cache libc6-compat openssl

# Install pnpm
RUN npm install -g pnpm

# Copy package.json and pnpm-lock.yaml
COPY package.json pnpm-lock.yaml ./

RUN pnpm fetch

# Copy the rest of the application
COPY . .

# Install dependencies
RUN pnpm install

# Generate Prisma Client
RUN pnpm prisma generate

# Build the application
RUN pnpm run build

# Expose the port the app runs on
EXPOSE 3000

# Start the application
CMD ["sh", "./start.sh"]