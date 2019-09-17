#! /usr/bin/env python3

import os
import datetime
import platform
import inspect
import sys
from pathlib import Path
from subprocess import check_output, CalledProcessError  # nosec

from gitignore_parser import parse_gitignore
from logzero import logger, logging, loglevel

home_path = Path(os.environ['HOME'])
script_path = Path(os.path.dirname(os.path.realpath(__file__)))
gitignore = parse_gitignore(script_path / '.gitignore')
system = platform.system()


# Gets the expected directory for pictures, depending on the OS
def picture_path():
    if system == "Linux":
        return home_path / "pictures"
    elif system == "Darwin":
        return home_path / "Pictures"
    else:
        logger.error("Unknown OS: {}".format(system))
        sys.exit(1)


# Gets the expected directory for pictures, depending on the OS
def doc_path():
    if system == "Linux":
        return home_path / "docs"
    elif system == "Darwin":
        return home_path / "Documents"
    else:
        logger.error("Unknown OS: {}".format(system))
        sys.exit(1)


# Gets the expected directory for config files, depending on the OS
def config_path():
    if system == "Linux":
        return home_path / ".config"
    elif system == "Darwin":
        return home_path / ".config"
    else:
        logger.error("Unknown OS: {}".format(system))
        sys.exit(1)


# Gets the expected directory for config files, depending on the OS
def bin_path():
    if system == "Linux":
        return home_path / "bin"
    elif system == "Darwin":
        return home_path / "bin"
    else:
        logger.error("Unknown OS: {}".format(system))
        sys.exit(1)


# Mapping for configuration files
config_mapping = {
    "Xresources": home_path / ".Xresources",
    "alacritty": config_path() / "alacritty",
    "dracut.conf": Path("/etc/dracut.conf"),
    "fstab": Path("/etc/fstab"),
    "genkernel.conf": Path("/etc/genkernel.conf"),
    "grub": Path("/etc/default/grub"),
    "gopass": config_path() / "gopass",
    "i3": config_path() / "i3",
    "i3status-rs.toml": config_path() / "i3status-rs.toml",
    "make.conf": Path("/etc/portage/make.conf"),
    "mako": config_path() / "mako",
    "nvim": config_path() / "nvim",
    "rofi": config_path() / "rofi",
    "sway": config_path() / "sway",
    "swaylock": config_path() / "swaylock",
    "tlp.conf": Path("/etc/tlp.conf"),
    "tmux": config_path() / "tmux",
    "vconsole.conf": Path("/etc/vconsole.conf"),
    "xinitrc": home_path / ".xinitrc",
    "zshrc": home_path / ".zshrc",
}

# Mapping scripts
bin_mapping = {
    "aim": bin_path() / "aim",
    "menu": bin_path() / "menu",
    "bimp": bin_path() / "bimp",
    "checkiommu": bin_path() / "checkiommu",
    "fixhd": bin_path() / "fixhd",
    "fuzzylock": bin_path() / "fuzzylock",
    "nker": bin_path() / "nker",
    "passmenu": bin_path() / "passmenu",
    "prtsc": bin_path() / "prtsc",
    "testfonts": bin_path() / "testfonts",
    "wm": bin_path() / "wm",
}

# Mapping for dotfiles (root) directory.
# Semantic map:
# None - Ignore
# Path - Copy
# dict - Handle as (nested) mapping
root_mapping = {
    ".gitignore": None,
    ".gitattributes": None,
    "LICENSE": None,
    "Pipfile": None,
    "README.md": None,
    "bin": bin_mapping,
    "config": config_mapping,
    "update.py": None,
    "kernel": None,
    "walls": picture_path() / "walls",
    "papers": doc_path() / "papers"
}


def run(cmd):
    logger.debug(cmd)
    try:
        output = check_output(cmd)  # nosec
        logger.debug(output)
        return True
    except CalledProcessError:
        return False


def git_pull():
    """
        Pulls git origin
    """
    cmd = ["git", "pull"]
    return run(cmd)


def git_add(path):
    """
        Stages file in `path`
    """
    cmd = ["git", "add", str(path)]
    return run(cmd)


def git_commit(msg):
    """
        Commits with `msg`
    """
    cmd = ["git", "commit", "-m", str(msg)]
    return run(cmd)


def git_push():
    """
        Pushes to git origin
    """
    cmd = ["git", "push"]
    return run(cmd)


def handle_copy(src, dst):
    """
        Copies file or directory. In the latter it will delete files in the
        destination not in the source.
    """
    # Work around the fact that rsync is weird
    if Path(src).is_dir():
        src = str(src) + '/'
    # Construct the command, ignore links and purge outdated files
    cmd = ["rsync", "-Pav", "--no-links", "--delete", str(src),
           str(dst)]
    return run(cmd)


def update_mapping(root, mapping):
    """
        Transverse a mapping, copying leaf nodes to their destination
    """
    # Mildly nasty
    if len(inspect.stack()) == 2:
        logger.info("Updating root mapping")
    logger.debug(">>>> Mapping with root {}".format(root))
    # Recursively iterate over the mapping
    for node in mapping:
        value = mapping[node]
        if isinstance(value, dict):
            logger.info("Updating {} mapping".format(node))
            new_root = Path(root) / str(node)
            update_mapping(new_root, value)
        elif isinstance(value, Path):
            logger.debug("Copying {}".format(node))
            # Skip & report broken nodes
            if not value.exists():
                continue
            # Construct node & value paths
            node_path = Path(root) / str(node)
            value_path = Path(value)
            if value_path.is_dir():
                value_path.mkdir(parents=True, exist_ok=True)
            # Finaly perform the copy
            ok = handle_copy(value_path, node_path)
            if not ok:
                logger.error("Update failed for {}".format(node))
        else:
            logger.debug("Skipping {}".format(node))


def verify_mapping(root, mapping):
    """
        Transverse root, enforcing all files in repo are represented in
        mappings.
    """
    # Mildly nasty
    if len(inspect.stack()) == 2:
        logger.info("Verifying root mapping")
    for elem in Path(root).iterdir():
        # Make sure we're only verifying valid files
        if gitignore(elem) or elem.parts[-1] == '.git':
            continue
        # The node names are just the last element in the path
        node = elem.parts[-1]
        # Warns about a file with no mapping
        if node not in mapping:
            logger.error(
                "'{}' is not represented in any mapping!".format(node))
            continue
        if isinstance(mapping[node], dict):
            logger.info("Verifying {} mapping".format(node))
            new_root = Path(root) / node
            verify_mapping(new_root, mapping[node])


def sync_mapping(root, mapping):
    """
        Transverse mapping, staging changes to mapped files and syncing them to
        git.
    """
    if len(inspect.stack()) == 2:
        logger.info("Syncing root mapping")
    for node in mapping:
        value = mapping[node]
        if isinstance(value, dict):
            logger.info("Syncing {} mapping".format(node))
            new_root = Path(root) / str(node)
            sync_mapping(new_root, value)
        elif isinstance(value, Path):
            node_path = Path(root) / str(node)
            root_path_length = len(script_path.parts)
            object_path = Path("/".join(node_path.parts[root_path_length:]))
            ok = git_add(object_path)
            if not ok:
                continue
            now = datetime.datetime.now().strftime("%Y-%m-%d-%H:%M:%S-%Z")
            category = str(node_path.parts[-2])
            name = str(node_path.parts[-1])
            msg = "{}/{}: sync @ {}".format(category, name, now)
            git_commit(msg)
        else:
            logger.debug("Skipping {}".format(node))


def update_kernel(root, mapping):
    """
        Detect currently available kernel sources, copies, and syncs them to
        the tree.
    """
    logger.info("Updating kernel")
    pass


loglevel(level=logging.INFO)
update_mapping(script_path, root_mapping)
verify_mapping(script_path, root_mapping)
sync_mapping(script_path, root_mapping)

if system == "Linux":
    update_kernel(script_path, root_mapping)
