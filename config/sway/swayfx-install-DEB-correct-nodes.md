### Navigating SwayFX Installation on Debian 12: A Guide to Overcoming Outdated Dependencies

Users attempting to install the eye-candy-focused Sway compositor fork, swayfx, on Debian 12 "Bookworm" have reported difficulties due to outdated or incorrect package names in the official installation guide. This guide provides an updated set of instructions to successfully install swayfx by utilizing packages from Debian's `testing` and `experimental` repositories.

The primary challenge arises from the fact that the version of `wlroots`—a crucial library for Wayland compositors—available in Debian 12's stable repository is too old for swayfx. To resolve this and other dependency issues, you will need to enable and configure `apt` to pull specific packages from the `testing` and `experimental` branches.

#### **Updated Installation Steps for SwayFX on Debian 12**

Here is a revised guide with the correct package names and additional steps required to get swayfx running on your Debian 12 system.

**1. Enable `testing` and `experimental` repositories:**

First, you need to add the `testing` and `experimental` repositories to your system's package sources. Create a new file to manage these additional repositories:

```bash
sudo nano /etc/apt/sources.list.d/testing-experimental.list
```

Add the following lines to this file:

```
deb http://deb.debian.org/debian/ testing main
deb http://deb.debian.org/debian/ experimental main
```

**2. Configure APT pinning:**

To prevent a full system upgrade to the `testing` or `experimental` versions, you'll use `apt` pinning. This allows you to selectively install newer packages while keeping your system otherwise on the stable "Bookworm" release.

Create a new `apt` preferences file:

```bash
sudo nano /etc/apt/preferences.d/99-testing-experimental
```

Add the following configuration to prioritize packages from the stable repository, while allowing specific packages to be installed from `testing` and `experimental`:

```
Package: *
Pin: release a=stable
Pin-Priority: 900

Package: *
Pin: release a=testing
Pin-Priority: 750

Package: *
Pin: release a=experimental
Pin-Priority: 1
```

**3. Update package lists:**

Refresh your package lists to include the newly added repositories:

```bash
sudo apt update
```

**4. Install build dependencies:**

Now, install the essential tools and libraries required to compile swayfx. Several of these packages will be pulled from the `testing` and `experimental` repositories due to the pinning configuration.

```bash
sudo apt install -y build-essential cmake meson libwayland-dev wayland-protocols libegl-dev libgles2-dev libgbm-dev libinput-dev libxkbcommon-dev libgudev-1.0-dev libpixman-1-dev libsystemd-dev libseat-dev hwdata seatd
```

**5. Install `wlroots` from `experimental`:**

The version of `wlroots` in the stable and even testing repositories is often not recent enough. Therefore, you need to install `libwlroots-dev` specifically from the `experimental` repository.

```bash
sudo apt install -t experimental libwlroots-dev
```

**6. Install remaining dependencies:**

Install the other necessary dependencies for swayfx. These should be available in the standard Bookworm repositories or the `testing` repository you enabled.

```bash
sudo apt install -y libcairo2-dev libpango1.0-dev libjson-c-dev libpcre2-dev libgdk-pixbuf2.0-dev scdoc git
```

**7. Clone the swayfx repository and compile:**

With all the dependencies in place, you can now clone the swayfx source code and build it.

```bash
git clone https://github.com/WillPower3309/swayfx.git
cd swayfx
meson build
ninja -C build
sudo ninja -C build install
```

After these steps, swayfx should be successfully installed on your Debian 12 "Bookworm" system. This process highlights the flexibility of Debian's package management system, allowing for a stable base with the ability to incorporate newer software when needed.
