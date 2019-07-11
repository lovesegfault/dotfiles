#! /bin/env python3

import os
import platform
from logzero import logger

class UpdateError:
    """ Raised for errors during dotfile update process.

    Attributes:
        stage - Stage where the error happened
        message - Explanation
    """

    def __init__(self, stage, message):
        self.stage = stage
        self.message = message

def get_picture_dir():
    system = platform.system()
    if system == "Linux":
        return "{}/pictures".format(os.environ['HOME'])
    elif system == "Darwin":
        return "{}/Pictures".format(os.environ['HOME'])
    else:
        None

root_mapping = {
        "bin": "{}/bin".format(os.environ['HOME']),
        "walls": "{}/walls".format()
        }

logger.info('Starting dotfile update')


