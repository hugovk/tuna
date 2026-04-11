from . import cli
from .main import read_import_profile


def load_ipython_extension(ipython):
    from . import magics  # noqa: F401


__all__ = [
    "cli",
    "read_import_profile",
]
