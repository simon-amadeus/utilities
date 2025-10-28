# Net Alert

**Net Alert** is a simple Rust CLI tool that notifies you when your internet connection is restored after going down. It uses native macOS notifications (via `osascript`) and requires no external dependencies.

## Features

- Monitors your internet connection status
- Notifies you with a native macOS notification when the connection is restored
- User-friendly terminal output
- No external dependencies (other than Rust and macOS built-in tools)

## Usage

1. **Build the project:**

   ```sh
   cargo build --release
   ```

2. **Run the program:**

   ```sh
   cargo run
   ```

   Or run the built binary directly:

   ```sh
   ./target/release/net-alert
   ```

3. **How it works:**
   - Start the program while you are connected to the internet.
   - When your internet goes down, the tool waits for it to come back up.
   - As soon as the connection is restored, you will receive a native notification and the program will exit.

## Requirements

- Rust (https://rustup.rs)
- macOS (uses `osascript` for notifications) -> allow notifications for 'Script Editor' in settings.

## Example Output

```
🌐 Internet Notifier CLI
------------------------
Waiting for the internet to go down... (Press Ctrl+C to exit)
Status: Connected. Monitoring...
Status: Disconnected. Waiting for restoration...
Status: Connected! Sending notification...
✅ Internet connection restored! Exiting.
```

## License

MIT

---
Enjoy!