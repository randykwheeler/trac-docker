FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    libpq-dev \
    postgresql-client \
    gcc \
    apache2-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir \
    Trac \
    psycopg2 \
    Babel \
    pygments \
    docutils \
    pytz

# Create directories
WORKDIR /var/trac
RUN mkdir -p /deploy/plugins

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Environment variables
ENV TRAC_ENV=/var/trac
ENV TRAC_PROJECT_NAME="My Project"

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
