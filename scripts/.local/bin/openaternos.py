from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time

# Path to Brave browser executable
brave_path = '/usr/bin/brave-browser'

# Path to Brave user profile
user_profile_path = str(Path.home() / ".config/BraveSoftware/Brave-Browser/Default")

# Set up Brave-specific options
chrome_options = Options()
chrome_options.binary_location = brave_path
chrome_options.add_argument('--headless')
# chrome_options.add_argument(f"--user-data-dir={Path.home()}/.config/BraveSoftware/Brave-Browser/")
# chrome_options.add_argument(r"--profile-directory=Profile 2")

# Initialize the WebDriver for Brave
driver = webdriver.Chrome(service=Service('/usr/local/bin/chromedriver'), options=chrome_options)

# Navigate to the Aternos login page
driver.get('https://aternos.org/go/')

import os
from pathlib import Path

def get_secret(key):
    val = os.environ.get(key)
    if val:
        return val
    secrets_path = Path.home() / ".config" / "dotfiles" / "secrets.env"
    if secrets_path.exists():
        for line in secrets_path.read_text().splitlines():
            line = line.strip()
            if line.startswith(f"{key}="):
                return line.split("=", 1)[1].strip("\"'")
    return None

aternos_user = get_secret("ATERNOS_USER")
aternos_pass = get_secret("ATERNOS_PASS")
if not aternos_user or not aternos_pass:
    raise RuntimeError("ATERNOS_USER and ATERNOS_PASS must be set in ~/.config/dotfiles/secrets.env")

username_input = driver.find_element(By.CLASS_NAME, 'username')
username_input.send_keys(aternos_user)

time.sleep(10)

pass_input = driver.find_element(By.CLASS_NAME, 'password')
pass_input.send_keys(aternos_pass)

time.sleep(10)

login_button = driver.find_element(By.CLASS_NAME, 'login-button')
login_button.click()

time.sleep(10)

driver.close()
