# Trac Docker Setup

A production-ready Trac ticket system with PostgreSQL backend, running in Docker containers with WSL2.

## Features

- 🎫 **Trac 1.6** - Modern project management and bug tracking
- 🐘 **PostgreSQL 15** - Reliable database backend
- 🔌 **Plugin Support** - Easy plugin installation via `requirements.txt`
- 💾 **Persistent Storage** - Data survives container restarts
- 🔒 **Basic Authentication** - Built-in user authentication
- 🚀 **Production Ready** - Database wait logic and proper error handling

## Quick Start

### Prerequisites

- Docker and Docker Compose
- WSL2 (Windows Subsystem for Linux)

### Installation

1. Clone this repository:

```bash
git clone <your-repo-url>
cd <repository-name>
```

1. Create required directories:

```bash
mkdir -p trac-data plugins
```

1. Start the services:

```bash
wsl bash -c "docker-compose up -d"
```

1. Access Trac at <http://localhost:8000>

### Default Credentials

- **Username**: `admin`
- **Password**: `admin`

⚠️ **Important**: Change these credentials before production use!

## Configuration

### Database Configuration

Edit `docker-compose.yml` to change database credentials:

```yaml
environment:
  - POSTGRES_USER=tracuser
  - POSTGRES_PASSWORD=tracpassword  # Change this!
  - POSTGRES_DB=tracdb
```

### Installing Plugins

1. Add plugin names to `requirements.txt`:

```
TracAccountManager
TracTags
```

1. Restart Trac:

```bash
wsl bash -c "cd /mnt/d/ai && docker-compose restart trac"
```

## Management Commands

### Start Services

```bash
wsl bash -c "docker-compose up -d"
```

### Stop Services

```bash
wsl bash -c "docker-compose down"
```

### View Logs

```bash
wsl bash -c "docker-compose logs -f trac"
```

### Backup Data

```bash
wsl bash -c "tar -czf trac-backup-$(date +%Y%m%d).tar.gz trac-data"
```

## Project Structure

```
.
├── docker/
│   └── trac/
│       ├── Dockerfile          # Trac container image
│       └── entrypoint.sh       # Startup script with DB wait logic
├── docker-compose.yml          # Service orchestration
├── requirements.txt            # Trac plugins
├── trac-data/                  # Persistent Trac data (gitignored)
└── plugins/                    # Custom plugin directory (gitignored)
```

## Production Recommendations

- **Use HTTPS**: Set up a reverse proxy (nginx/traefik) with SSL certificates
- **Environment Variables**: Move sensitive data to `.env` files
- **Regular Backups**: Schedule automated backups of `trac-data` and PostgreSQL
- **Email Notifications**: Configure SMTP in `trac-data/conf/trac.ini`
- **Monitoring**: Add health checks and monitoring

## Troubleshooting

### Container won't start

```bash
# Check logs
wsl bash -c "docker-compose logs trac"

# Restart services
wsl bash -c "docker-compose restart"
```

### Database connection errors

The entrypoint script includes wait logic, but if issues persist:

```bash
# Ensure PostgreSQL is ready
wsl bash -c "docker-compose logs postgres"
```

### Permission issues

```bash
# Fix permissions on trac-data
wsl bash -c "chmod -R 755 trac-data"
```

## License

This setup is provided as-is for deploying Trac. Trac itself is licensed under the [Modified BSD License](https://trac.edgewall.org/wiki/TracLicense).

## Resources

- [Trac Documentation](https://trac.edgewall.org/wiki/TracGuide)
- [Trac Plugin List](https://trac-hacks.org/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
