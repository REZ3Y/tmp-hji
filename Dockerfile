FROM python:3.11-slim

RUN apt-get update && apt-get install -y \
    wget unzip gnupg curl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings \
    && wget -q -O /etc/apt/keyrings/google-linux-signing-key.gpg https://dl.google.com/linux/linux_signing_key.pub \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-linux-signing-key.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
       > /etc/apt/sources.list.d/google-chrome.list

RUN apt-get update && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}' | cut -d. -f1) \
    && DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") \
    && wget -q https://chromedriver.storage.googleapis.com/${DRIVER_VERSION}/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver_linux64.zip

WORKDIR /app

COPY app/ /app/

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "browser.py"]
