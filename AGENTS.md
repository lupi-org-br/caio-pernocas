
## 🛠️ Coding Philosophy & Constraints
We follow a "Less is More" approach. Code must be self-documenting and modular.

### General Principles
- **No Comments:** Code must be expressive enough to explain itself. Use clear naming.
- **Fail Fast:** Use assertions during development (or `error` on Lua).
- **Static Scope:** In Lua, use `local` when possible.
- **Contextual Grouping:** Instead of making something like `wifi_connect`, `wifi_disconnect`, `wifi_reconnect`, `wifi_scan`, etc., group related code together in a folder `wifi`, with a `connect.lua`, `disconnect.lua`, `reconnect.lua`, `scan.lua`, etc. If three or more files have the same prefix, that prefix should be a folder.

### Lua Code Limits (Nice to have)
- **Max 125 lines** per file.
- **Max 25 lines** per function.
- **Max 8 functions** per file.