#!/bin/bash
set -e

# Wait for Postgres
echo "Waiting for postgres..."
until pg_isready -h postgres -p 5432 -U "$POSTGRES_USER"; do
  echo "Postgres is unavailable - sleeping"
  sleep 2
done
echo "Postgres is up!"

# Install plugins from requirements.txt if it exists
if [ -f /deploy/requirements.txt ]; then
    echo "Installing plugins from requirements.txt..."
    pip install -r /deploy/requirements.txt
fi

# Initialize Trac environment if it doesn't exist
if [ ! -d "$TRAC_ENV/conf" ]; then
    echo "Initializing Trac environment at $TRAC_ENV..."
    trac-admin "$TRAC_ENV" initenv "$TRAC_PROJECT_NAME" "$DB_URL"
    
    # Create default admin user
    echo "Creating default admin user..."
    if [ -z "$TRAC_ADMIN_USER" ]; then
        TRAC_ADMIN_USER="admin"
    fi
    if [ -z "$TRAC_ADMIN_PASS" ]; then
        TRAC_ADMIN_PASS="admin"
    fi
    # Create a htpasswd file
    htpasswd -cb "$TRAC_ENV/htpasswd" "$TRAC_ADMIN_USER" "$TRAC_ADMIN_PASS"
    
    # Grant TRAC_ADMIN permission
    trac-admin "$TRAC_ENV" permission add "$TRAC_ADMIN_USER" TRAC_ADMIN
    
    echo "Trac environment initialized."
fi

# Ensure htpasswd exists (idempotency)
if [ ! -f "$TRAC_ENV/htpasswd" ]; then
    echo "Creating missing htpasswd file..."
    htpasswd -cb "$TRAC_ENV/htpasswd" "${TRAC_ADMIN_USER:-admin}" "${TRAC_ADMIN_PASS:-admin}"
fi

# Start Trac
echo "Starting Trac..."
# We use --basic-auth to use the htpasswd file we created
tracd --port 8000 --basic-auth="*,$TRAC_ENV/htpasswd,realm" "$TRAC_ENV"
