FROM ghcr.io/diploi/odoo-template

# Install application code
WORKDIR /app
COPY . .

RUN npm install
RUN npm run build