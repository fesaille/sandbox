import pytest
import selenium


@pytest.mark.firefox_arguments("-headless")
def test_example(selenium):
    selenium.get("http://www.example.com")
