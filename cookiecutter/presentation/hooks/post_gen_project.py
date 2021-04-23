#!/usr/bin/env python
import os
import subprocess

PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)


def remove_file(filepath):
    os.remove(os.path.join(PROJECT_DIRECTORY, filepath))


if __name__ == "__main__":

    if "Not open source" == "{{ cookiecutter.open_source_license }}":
        remove_file("LICENSE")

    if "{{ cookiecutter.create_git }}" == "y":
        subprocess.call(["git", "init"])
        subprocess.call(["git", "add", "*"])
        subprocess.call(["git", "commit", "-m", "Initial commit"])
