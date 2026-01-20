# Secure CRUD System

A production-ready, multi-container CRUD application isolated behind a reverse proxy. This project demonstrates a secure, automated workflow using Docker, Nginx, Python (FastAPI), and PostgreSQL.

## 🏗 Architecture

The system consists of three distinct services running in a private Docker network:

1.  **Proxy (Nginx):** The "Gatekeeper". Receives all external traffic on Port 80 and routes it to the application.
2.  **App (FastAPI):** The "Brain". A high-performance Python API handling business logic and database interactions. Run as a non-root user for security.
3.  **Database (PostgreSQL):** The "Storage". Persists application data in a Docker volume.

## 🚀 Quick Start

### Prerequisites
-   Docker
-   Docker Compose

### Deployment
This project includes an automated deployment script that checks prerequisites, ensures a clean state, builds the images, and waits for health checks to pass.

1.  **Run the deployment script:**
    ```bash
    ./deploy.sh
    ```

2.  **Access the Application:**
    Once the script prints `[SUCCESS]`, the API is live at:
    -   **API Root:** `http://localhost/`
    -   **Interactive Documentation (Swagger UI):** `http://localhost/docs`
    -   **Alternative Docs (ReDoc):** `http://localhost/redoc`

## 📸 Screenshots

### 1. Deployment Success
<!-- Insert screenshot of the terminal showing the success message from ./deploy.sh -->
![Deployment Output](<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/6ea6d5fb-da44-4dfc-927d-a688403bf60a" />)

### 2. API Documentation (Swagger UI)
<!-- Insert screenshot of http://localhost/docs -->
![Swagger UI](<img width="1366" height="768" alt="image" src="https://github.com/user-attachments/assets/38a34310-40a3-4c07-a2fc-11a340f44b10" />)

## 📂 Project Structure

```plaintext
/
├── src/                # Application source code (FastAPI)
│   ├── main.py         # API Endpoints
│   ├── models.py       # Database Models
│   ├── schemas.py      # Pydantic Schemas
│   ├── database.py     # DB Connection Logic
│   └── requirements.txt
├── nginx/              # Nginx Configuration
│   └── nginx.conf
├── docker-compose.yml  # Orchestration file
├── Dockerfile          # App container instructions (Multi-stage, Non-root)
├── deploy.sh           # Automation script
└── README.md           # Documentation
```

## 🔌 API Endpoints

The application provides the following CRUD operations:

| Method | Endpoint | Description |
| :--- | :--- | :--- |
| `GET` | `/` | Root endpoint (Welcome message) |
| `GET` | `/health` | Health check |
| `POST` | `/todos/` | **Create** a new task |
| `GET` | `/todos/` | **Read** all tasks |
| `GET` | `/todos/{id}` | **Read** a specific task |
| `PUT` | `/todos/{id}` | **Update** a task |
| `DELETE` | `/todos/{id}` | **Delete** a task |

## 🛡 Security Features

-   **Network Isolation:** The Database and Application containers do not expose ports to the host machine. They communicate strictly over a private Docker network.
-   **Reverse Proxy:** Nginx acts as the single point of entry.
-   **Least Privilege:** The application runs inside the container as a non-root user (`appuser`).
-   **Minimal Image:** Built on `python:3.10-slim` to reduce attack surface.

## 💾 Persistence

Data is stored in a named Docker volume (`postgres_data`). This ensures that even if containers are destroyed or the machine is rebooted, your data remains intact.
