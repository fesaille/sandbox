import src.fetch


def test_add_a2b():
    res = src.fetch.add_a2b(1, 2)
    assert res == 4


def test_add_a2c():
    res = src.fetch.add_a2c(1, 2)
    assert res == 3
