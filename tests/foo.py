import time


def a(t0, t1):
    c(t0)
    d(t1)


def b():
    return a(1, 4)


def c(t):
    time.sleep(t)


def d(t):
    time.sleep(t)


if __name__ == "__main__":
    a(4, 1)
    b()
