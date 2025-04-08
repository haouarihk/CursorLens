#!/bin/sh

# Run migrations
npx prisma migrate deploy

# Seed the database
npx prisma db seed

# Start the application
node server.js