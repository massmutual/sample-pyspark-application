import os
import subprocess


PROJECT_ROOT_DIR = (
    os.path.dirname(
        os.path.dirname(
            os.path.realpath(__file__))))


def test_flake8():
    ret = subprocess.call(['flake8'], cwd=PROJECT_ROOT_DIR)
    assert ret == 0
