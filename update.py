#! /bin/env python3

import os
import platform
from pathlib import Path
from subprocess import check_output

from gitignore_parser import parse_gitignore
from logzero import logger, logging, loglevel

home_dir = Path(os.environ['HOME'])
script_dir = Path(os.path.dirname(os.path.realpath(__file__)))
gitignore = parse_gitignore(script_dir / '.gitignore')
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


# Gets the expected directory for pictures, depending on the OS
def get_picture_dir():
    if system == "Linux":
        return home_dir / "pictures"
    elif system == "Darwin":
        return home_dir / "Pictures"
    else:
        raise UpdateError("root-mapping", "Unknown OS: {}".format(system))


# Gets the expected directory for config files, depending on the OS
def get_config_dir():
    if system == "Linux":
        return home_dir / ".config"
    elif system == "Darwin":
        return home_dir / ".config"
    else:
        raise UpdateError("config-mapping", "Unknown OS: {}".format(system))


# Mapping for configuration files
config_mapping = {
    "Xresources": home_dir / ".Xresources",
    "alacritty": get_config_dir() / "alacritty",
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
    "zshrc": home_dir / ".zshrc",
}

# Mapping for dotfiles (root) directory.
# Semantic map:
# None - Ignore
# Path - Copy
# dict - Handle as (nested) mapping
root_mapping = {
    ".gitignore": None,
    "LICENSE": None,
    "Pipfile": None,
    "README.md": None,
    "bin": home_dir / "bin",
    "config": config_mapping,
    "kernel": None,
    "update.py": None,
    "walls": get_picture_dir() / "walls",
}

# Copies file or directory. In the latter it will delete files in the
# destination not in the source.
def handle_copy(src, dst):
    cmd = ["rsync", "-Pav", "--no-links", "--delete", str(src),
            str(dst)]
    logger.debug(cmd)
    output = check_output(cmd)
    logger.debug(output)

# Transverse a mapping, copying leaf nodes to their destination
def handle_mapping(root, mapping):
    for key in mapping:
        value = mapping[key]
        if isinstance(value, dict):
            logger.debug("Handling {} as mapping".format(key))
            handle_mapping(str(key) + '/', value)
        elif isinstance(value, Path):
            logger.debug("Handling {} as copy".format(key))
            if value.is_file():
                append = ''
            elif value.is_dir():
                append = '/'
            else:
                logger.error("Skipping nonextant file/dir '{}'".format(value))
                return
            handle_copy(str(value) + append, str(root) + str(key) + append)
        else:
            logger.debug("Skipping {}".format(key))

def verify_mapping(root, mapping):
    for elem in Path(root).iterdir():
        if gitignore(elem) or elem.parts[-1] == '.git':
            continue
        node = elem.parts[-1]
        if node not in mapping:
            logger.error("'{}' is not represented in any mapping!".format(node))
            continue
        if isinstance(mapping[node], dict):
            verify_mapping(Path(root) / node, mapping[node])


loglevel(level=logging.INFO)
logger.info("Updating dotfiles")
handle_mapping(script_dir, root_mapping)
logger.info("Verifying")
verify_mapping(script_dir, root_mapping)
logger.info("DONE")
