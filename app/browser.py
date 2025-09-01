from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from urllib.parse import urlparse, parse_qs


def get_final_url_and_params(start_url: str, headless: bool = True):
    chrome_options = Options()
    if headless:
        chrome_options.add_argument("--headless")
        chrome_options.add_argument("--disable-gpu")
        chrome_options.add_argument("--no-sandbox")
        chrome_options.add_argument("--disable-dev-shm-usage")

    service = Service("/usr/local/bin/chromedriver")
    driver = webdriver.Chrome(service=service, options=chrome_options)

    try:
        driver.get(start_url)

        WebDriverWait(driver, 10).until(
            lambda d: d.current_url != start_url
        )

        final_url = driver.current_url

        parsed_url = urlparse(final_url)
        params = parse_qs(parsed_url.query)

        param_list = [{k: v} for k, v in params.items()]

        return final_url, param_list

    finally:
        driver.quit()


if __name__ == "__main__":
    url = input("Enter the Link: ")
    final_url, params = get_final_url_and_params(url, headless=True)
    print("Destination link: ", final_url)
    print("Params List: ", params)
