// src/main.rs
use std::thread;
use std::time::Duration;
use std::process::Command;
use reqwest;
use std::io::{self, Write};

fn check_internet() -> bool {
    reqwest::blocking::get("http://www.google.com").is_ok()
}

fn notify_user() {
    let script = r#"display notification "Your internet connection has been restored." with title "Internet Connection Restored""#;
    let _ = Command::new("osascript")
        .arg("-e")
        .arg(script)
        .output();
}

fn print_status(msg: &str) {
    print!("\r{msg}   ");
    io::stdout().flush().unwrap();
}

fn main() {
    println!("🌐 Internet Notifier CLI");
    println!("------------------------");
    println!("Waiting for the internet to go down... (Press Ctrl+C to exit)");

    // Wait for the internet to go down before monitoring for restoration
    while check_internet() {
        print_status("Status: Connected. Monitoring...");
        thread::sleep(Duration::from_secs(2));
    }
    println!("\nStatus: Disconnected. Waiting for restoration...");

    // Now, wait for it to come back up and notify
    loop {
        if check_internet() {
            println!("Status: Connected! Sending notification...");
            notify_user();
            println!("✅ Internet connection restored! Exiting.");
            break;
        } else {
            print_status("Status: Still disconnected...");
        }
        thread::sleep(Duration::from_secs(2));
    }
}