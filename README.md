# Snivy: Real-Time Feature Orchestration Engine

Snivy is a storage-agnostic, event-driven feature management platform. It allows engineering teams to decouple **deployment** (shipping code) from **release** (enabling features), providing a remote "light switch" for application logic across distributed platforms.



---

##  Features

* **Reactive SSE Pipeline:** Real-time configuration updates pushed from server to client via Server-Sent Events (SSE), eliminating the need for inefficient polling.
* **Storage-Agnostic Caching:** Keep your "Truth" in SQLite, JSON, or memory; Snivy's engine abstracts the persistence layer for maximum flexibility.
* **Dynamic Terminal Control Plane:** Manage your production environment via a declarative Terminal User Interface (TUI). New switches can be added by simply updating a JSON configuration file—no code redeployment required.
* **Plug-and-Play SDK:** A modular Dart SDK that enables Flutter applications to consume feature states reactively with minimal integration overhead.

---

## Instructions to Compile & Run

### 1. Prerequisites
* **Python 3.14+**
* **Flutter SDK**
* **Git**

### 2. Backend Setup
The backend serves as the source of truth and the broadcast engine.
```bash
# Clone the repository
git clone <repository-url>
cd snivy/backend

# Install dependencies
pip install uvicorn fastapi

# Run the backend engine
python main.py
