#! /usr/bin/env python3

import os
import datetime
import platform
import inspect
import sys
import re
from pathlib import Path
from subprocess import check_output, CalledProcessError  # nosec

from gitignore_parser import parse_gitignore
from logzero import logger, logging, loglevel

timezone = datetime.datetime.now(datetime.timezone.utc).astimezone().tzname()
home_path = Path(os.environ["HOME"])
kernel_path = Path("/usr/src")
script_path = Path(os.path.dirname(os.path.realpath(__file__)))
gitignore = parse_gitignore(script_path / ".gitignore")
system = platform.system()


def picture_path():
    """
        Gets the expected directory for pictures, depending on the OS
    """
    if system == "Linux":
        return home_path / "pictures"
    elif system == "Darwin":
        return home_path / "Pictures"
    else:
        logger.error("Unknown OS: {}".format(system))
        sys.exit(1)


def doc_path():
    """
        Gets the expected directory for pictures, depending on the OS
    """
    if system == "Linux":
        return home_path / "docs"
    elif system == "Darwin":
        return home_path / "Documents"
    else:
        logger.error("Unknown OS: {}".format(system))
        sys.exit(1)


def config_path():
    """
        Gets the expected directory for config files, depending on the OS
    """
    if system == "Linux":
        return home_path / ".config"
    elif system == "Darwin":
        return home_path / ".config"
    else:
        logger.error("Unknown OS: {}".format(system))
        sys.exit(1)


def bin_path():
    """
        Gets the expected directory for config files, depending on the OS
    """
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
    "bbswitch.conf": Path("/etc/modprobe.d/bbswitch.conf"),
    "blacklist.conf": Path("/etc/modprobe.d/blacklist.conf"),
    "cfg80211.conf": Path("/etc/modprobe.d/cfg80211.conf"),
    "dracut.conf": Path("/etc/dracut.conf"),
    "dracut.conf.d": Path("/etc/dracut.conf.d"),
    "fstab": Path("/etc/fstab"),
    "genkernel.conf": Path("/etc/genkernel.conf"),
    "gitconfig": home_path / ".gitconfig",
    "gopass": config_path() / "gopass",
    "grub": Path("/etc/default/grub"),
    "i3": config_path() / "i3",
    "i3status-rs.toml": config_path() / "i3status-rs.toml",
    "libinput-gestures.conf": config_path() / "libinput-gestures.conf",
    "make.conf": Path("/etc/portage/make.conf"),
    "mako": config_path() / "mako",
    "modules-load.d": Path("/etc/modules-load.d"),
    "newsboat": home_path / ".newsboat" / "config",
    "newsboat-urls": home_path / ".newsboat" / "urls",
    "nvim": config_path() / "nvim",
    "resolved.conf": Path("/etc/systemd/resolved.conf"),
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


def handle_copy(src, dst):
    """
        Copies file or directory. In the latter it will delete files in the
        destination not in the source.
    """
    # Work around the fact that rsync is weird
    if Path(src).is_dir():
        src = str(src) + "/"
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
        if gitignore(elem) or elem.parts[-1] == ".git":
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
            now = datetime.datetime.now().strftime(
                "%Y-%m-%d-%H:%M:%S-{}"
                .format(timezone)
            )
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
    kernel_regex = re.compile(r"(linux)-(\d+\.\d+\.\d+)-gentoo\Z")
    for elem in kernel_path.iterdir():
        logger.debug("Checking {}".format(elem))
        if elem.is_file():
            continue
        if kernel_regex.fullmatch(elem.name):
            logger.info("Updating {} config".format(elem.name))
            config_path = elem / ".config"
            if not config_path.exists():
                logger.error("Config for {} does not exist".format(elem.name))
                continue
            store_path = root / "kernel" / elem.name
            handle_copy(config_path, store_path)
            ok = git_add(store_path)
            if not ok:
                continue
            now = datetime.datetime.now().strftime(
                "%Y-%m-%d-%H:%M:%S-{}"
                .format(timezone)
            )
            msg = "kernel/{}: sync @ {}".format(elem.name, now)
            git_commit(msg)


loglevel(level=logging.INFO)
update_mapping(script_path, root_mapping)
verify_mapping(script_path, root_mapping)
sync_mapping(script_path, root_mapping)

if system == "Linux":
    update_kernel(script_path, root_mapping)
