import requests
import time
import re
import sys
import threading
from pathlib import Path
import tkinter as tk
from tkinter import messagebox
from pathlib import Path
import json

from playwright.sync_api import sync_playwright

stop_flag = threading.Event()
CONFIG_FILE = "config.json"
checking_active = False

def extract_minutes(text):
    match = re.search(r"(\d+)(분|시간|일)전", text)
    if not match:
        return 0 if text == "방금전" else None

    value, unit = int(match.group(1)), match.group(2)
    if unit == "분":
        return value
    elif unit == "시간":
        return value * 60
    elif unit == "일":
        return value * 1440

    return None

def get_chromium_path():
    if getattr(sys, 'frozen', False):
        base = Path(sys.executable).parent / "ms-playwright"
    else:
        base = Path(__file__).parent / "ms-playwright"

    for path in base.rglob("chrome.exe"):
        return str(path)
    
    raise FileNotFoundError("Chromium 실행 파일을 찾을 수 없습니다.")

def extract_price(text):
    regex = re.compile(r'\d{1,3}(,\d{3})*$')

    price = regex.search(text)

    return int(price[0].replace(',', '')) if price else None

def check_item(item_id, max_price, webhook_url):
    chromium_exec = get_chromium_path()
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True, executable_path=chromium_exec)

        page = browser.new_page()
        page.goto(f"https://mapleland.gg/item/{item_id}", timeout=60000)
        page.wait_for_timeout(8000)

        container = page.locator("div.bg-gray-200.dark\\:bg-zinc-900.rounded.p-2").first  # 또는 정확한 외부 wrapper class

        cards = container.locator("div.rounded.p-2.mb-2")
        count = cards.count()

        for i in range(count):
            text = cards.nth(i).inner_text()

            lines = text.split('\n')

            index_line = -1
            for line in lines:
                if line == '미리보기':
                    index_line = lines.index(line)

            if index_line == -1:
                continue

            price = extract_price(lines[index_line - 2])
            minutes = extract_minutes(lines[index_line - 1])

            if minutes is None or minutes > 2:
                continue

            if price is None or price > max_price:
                continue

            payload = {
                    "content": f"```{'\n'.join(lines[:-1])}```"
            }

            requests.post(webhook_url, json=payload)

        browser.close()

def save_config(item_id, max_price, webhook_url):
    data = {
        "item_id": item_id,
        "max_price": max_price,
        "webhook_url": webhook_url
    }
    with open(CONFIG_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f)

def load_config():
    if Path(CONFIG_FILE).exists():
        with open(CONFIG_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    return {}

def start_checking():
    global checking_active
    if checking_active:
        messagebox.showwarning("경고", "이미 실행 중입니다. 중지 후 다시 시도해주세요.")
        return
    
    messagebox.showinfo("알림", "트래킹이 시작되었습니다.")

    item_id = entry_item.get().strip()

    try:
        max_price = int(entry_price.get().replace(",", ""))
    except ValueError:
        messagebox.showerror("입력 오류", "가격은 숫자로 입력해주세요.")
        return
    
    webhook_url = entry_webhook.get().strip()
    if not webhook_url:
        messagebox.showerror("입력 오류", "Discord Webhook URL 을 입력해주세요.")
        return
    
    save_config(item_id, max_price, webhook_url)
    stop_flag.clear()
    checking_active = True
    
    def worker():
        try:
            while not stop_flag.is_set():
                check_item(item_id, max_price, webhook_url)
                for _ in range(60):
                    if stop_flag.is_set():
                        break
                        
                    time.sleep(1)
        except Exception as e:
            if not stop_flag.is_set():
                messagebox.showerror("오류", str(e))

    threading.Thread(target=worker, daemon=True).start()

def stop_checking():
    global checking_active
    stop_flag.set()
    checking_active = False

    messagebox.showinfo("알림", "트래킹이 중단되었습니다.")

if __name__ == '__main__':
    stop_flag.set()

    root = tk.Tk()
    root.title("Mapleland Item Checker")
    root.geometry("400x250")

    label_item = tk.Label(root, text="아이템 ID")
    label_item.pack(pady=5)
    entry_item = tk.Entry(root)
    entry_item.pack(pady=5)

    label_price = tk.Label(root, text="최대 가격")
    label_price.pack(pady=5)
    entry_price = tk.Entry(root)
    entry_price.pack(pady=5)

    label_webhook = tk.Label(root, text="Discord Webhook URL")
    label_webhook.pack(pady=5)
    entry_webhook = tk.Entry(root, width=50)
    entry_webhook.pack(pady=5)

    config = load_config()
    entry_item.insert(0, config.get("item_id", ""))
    entry_price.insert(0, str(config.get("max_price", "")))
    entry_webhook.insert(0, config.get("webhook_url", ""))

    button_frame = tk.Frame(root)
    button_frame.pack(pady=10)

    btn_start = tk.Button(button_frame, text="실행", command=start_checking)
    btn_start.pack(side=tk.LEFT, padx=10)
    
    btn_stop = tk.Button(button_frame, text="중지", command=stop_checking)
    btn_stop.pack(side=tk.LEFT, padx=10)

    button_frame.pack(pady=10)
    button_frame.pack_configure(anchor="center")

    root.mainloop()
