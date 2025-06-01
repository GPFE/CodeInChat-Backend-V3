### **CodeInChat Backend README – Ruby on Rails API**

# CodeInChat — Backend API

API backend for **CodeInChat**, supporting user authentication, group chat, and interactive programming task cards.

## 🛠️ Tech Stack

- 🧱 Ruby on Rails API mode
- 🍪 Cookie-based Authentication (Switched from JWTs for security)
- 🔐 session management

## 📦 Setup
- **frontend:** https://github.com/GPFE/CodeInChat-Frontend
```bash
git clone https://github.com/GPFE/CodeInChat-Backend-V3.git
cd CodeInChat-Backend-V3
bundle install
rails db:create db:migrate
rails s
```
## 📌 TODO
- Add background jobs (e.g. chat notifications)
- Rate limiting & throttling
- Admin panel (RailsAdmin or ActiveAdmin)
