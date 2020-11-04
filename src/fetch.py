"""
This module is a utility to fetch data
"""
import json
import re
from datetime import datetime
from pathlib import Path

import bs4
import urllib3


def add_a2c(a: int, arg_b: int) -> int:
    """A doc to satisfy the linter"""
    return a + arg_b


def add_a2b(a: int, b: int) -> int:
    return a + b


def save_to_json_file(data, filename):
    """Save to json"""
    res = dict(
        data=data, last_update=datetime.now().strftime("%Y-%m-%d %H:%M:%SUTC")
    )

    with Path(f"{filename}.json").open("w") as out:
        data_json = json.dumps(res)
        out.write(data_json)


HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
        " (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"
    )
}


def fetch_head(pool: urllib3.PoolManager) -> bytes:

    resp = http.request(
        "HEAD", "https://www.worldometers.info/coronavirus/#nav-yesterday"
    )
    return resp


def fetch_data_coronavirus() -> bytes:

    http = urllib3.PoolManager(headers=HEADERS)
    resp = http.request(
        "GET",
        "https://www.worldometers.info/coronavirus/#nav-yesterday",
        headers=HEADERS,
    )

    return resp.data


if __name__ == "__main__":
    data: bytes = fetch_data_coronavirus()

    key = [
        "place",
        "Country",
        "Total Cases",
        "New Cases",
        "Total Deaths",
        "New Deaths",
        "Total Recovered",
        "New Recovered",
        "Active Cases",
        "Critical",
        "Total Cases/1M pop",
        "Deaths/1M pop",
        "Total Tests",
        "Tests/1M pop",
        "Population",
        "Region",
    ]

    soup = bs4.BeautifulSoup(data, "html.parser")
    tables = soup.find_all("tbody")
    table_rows = tables[0].find_all("tr")

    data = [
        dict(zip(key, re.split("\n", tr.text[1:].replace(" ", ""))[:-2]))
        for i, tr in filter(lambda args: args[0] > 6, enumerate(table_rows))
    ]

    save_to_json_file(data, "coronavirus")
