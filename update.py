#! /bin/env python3

import os
import platform
from logzero import logger
from pathlib import Path
from subprocess import check_output

home_dir = Path(os.environ['HOME'])
script_dir = Path(os.path.dirname(os.path.realpath(__file__)))
system = platform.system()


class UpdateError(BaseException):
    """ Raised for errors during dotfile update process.

    Attributes:
        stage - Stage where the error happened
        message - Explanation
    """

    def __init__(self, stage, message):
        self.stage = stage
        self.message = message


def get_picture_dir():
    if system == "Linux":
        return home_dir / "pictures"
    elif system == "Darwin":
        return home_dir / "Pictures"
    else:
        raise UpdateError("root-mapping", "Unknown OS: {}".format(system))


def get_config_dir():
    if system == "Linux":
        return home_dir / ".config"
    elif system == "Darwin":
        return home_dir / ".config"
    else:
        raise UpdateError("config-mapping", "Unknown OS: {}".format(system))


config_mapping = {
    "alacritty.yml": get_config_dir() / "alacritty",
    "dracut.conf": Path("/etc/dracut.conf"),
    "fstab": Path("/etc/fstab"),
    "genkernel.conf": Path("/etc/genkernel.conf"),
    "grub": Path("/etc/default/grub"),
    "i3": get_config_dir() / "i3",
    "i3status-rs.toml": get_config_dir() / "i3status-rs.toml",
    "make.conf": Path("/etc/portage/make.conf"),
    "nvim": get_config_dir() / "nvim",
    "rofi": get_config_dir() / "rofi",
    "sway": get_config_dir() / "sway",
    "tmux.conf": home_dir / ".tmux.conf",
    "vconsole.conf": Path("/etc/vconsole.conf"),
    "xinitrc": home_dir / ".xinitrc",
    "Xresources": home_dir / ".Xresources",
    "zshrc": home_dir / ".zshrc",
}

root_mapping = {
    "bin": home_dir / "bin",
    "walls": get_picture_dir() / "walls",
    "config": config_mapping,
    "kernel": None
}

def rsync_copy_update(src, dst):
    cmd = ["rsync" "-Pav" "--no-links" "--delete" "--dry-run" src/"" dst/""]
    logger.debug(cmd)
    output = check_output([cmd])
    logger.debug(output)

def handle_copy(src, dst):
    rsync_copy_update(src,dst)


def handle_mapping(mapping):
    pass


logger.info("Starting dotfile update")
for key in root_mapping:
    value = root_mapping[key]
    if isinstance(value, dict):
        logger.info("Handling {} as mapping".format(key))
        handle_mapping(value)
    elif isinstance(value, Path):
        logger.info("Handling {} as copy".format(key))
        handle_copy(value, key)
    else:
        logger.info("Skipping {}".format(key))

