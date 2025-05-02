import requests
import time
from playwright.sync_api import sync_playwright
import re

DISCORD_WEBHOOK_URL = "" #
items = [ "2070004" ]

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

def extract_price(text):
    regex = re.compile(r'\d{1,3}(,\d{3})*$')

    price = regex.search(text)

    return int(price[0].replace(',', '')) if price else None

def check_item(item):
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)

        page = browser.new_page()
        page.goto(f"https://mapleland.gg/item/{item}", timeout=60000)
        page.wait_for_timeout(8000)

        container = page.locator("div.bg-gray-200.dark\\:bg-zinc-900.rounded.p-2").first  # 또는 정확한 외부 wrapper class

        cards = container.locator("div.rounded.p-2.mb-2")
        count = cards.count()

        for i in range(count):
            text = cards.nth(i).inner_text()

            lines = text.split('\n')

            price = extract_price(lines[2])
            minutes = extract_minutes(lines[3])

            if minutes is None or minutes > 2:
                continue

            if price is None or price > 140000:
                continue

            payload = {
                    "content": f"```{text}```"
            }

            requests.post(DISCORD_WEBHOOK_URL, json=payload)

        browser.close()

while True:
    try:
        for item in items:
            check_item(item)

    except Exception as e:
        print(f"[ERROR] {e}")

    time.sleep(60)
