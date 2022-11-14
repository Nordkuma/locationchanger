# Location Changer

*Please note, this is a fork of the original [Location Changer](https://github.com/eprev/locationchanger) by Anton Eprev.*

*Location Changer* automatically changes the macOS [network location](https://support.apple.com/en-us/HT202480) based on the name of the Wi-Fi network or a manually configured Location.
It can also run a custom script to performadditional actions when changing the Location.

## Installation & Updates

1. Clone/Download this project: `git clone https://github.com/srkm1a1/locationchanger.git`
1. `cd locationchanger`
1. `./install.sh`

This will install the script to the configured `INSTALL_DIR` (usr/local/bin by default) and copy the configuration files to the specified locations.
The `.plist`-file sets up a LaunchAgent that will run the script on network changes.

You must be an Administrator to install *Location Changer* and it will ask you for your password.

## Basic Usage

Basic usage of *Location Changer* involves having Location names that match your Wi-Fi Network SSIDs (e.g. a macOS Location with the name `Home Wi-Fi` will correspond to the Wi-Fi Network SSID `Home Wi-Fi`).
When joining a Wi-Fi network, *Location Changer* will look for a Location whose name matches that of the SSID and will switch accordingly.

If *Location Changer* is unable to find a Location name matching the SSID, it will default to 'Automatic'.
The default Location name can be changed by editing the `DEFAULT_LOCATION` variable in the config file.

## Advanced Usage

*Location Changer* will select the Location to change to using the following precedence:

1. A manually configured Location
2. A Location name that matches the SSID
3. The default Location

### Manually Configuring Locations

*Location Changer* includes support for manually mapping Locations to Wi-Fi SSIDs.
This is useful, e.g., if you'd like to have a Location name that does not match the SSID or would like to use a Location for more than one SSID.

One example might be if your home Wi-Fi network is broadcasted on both 2.4GHz and 5GHz as `Home Wi-Fi` and `Home Wi-Fi 5G`, respectively.
Instead of maintaining Locations for each SSID, a user can manually configure the same Location to be used with both.

*Location Changer* can also be disabled for certain Locations.
This is useful, e.g., if you want to set Location manually and don't want it to be automatically changed back.

Configuration happens in `${HOME}/.locations/LocationChanger.conf` by default.
On installation a default config file is generated.
The config file is in ini-format and contains the sections: `General`, `Automatic` and `Manual`.

The `General` defines three configurable variables.
`DEFAULT_LOCATION` specifies the Location to use, if the current WiFi is not configured explicitly. 
The default is 'Automatic'.
`ENABLE_NOTIFICATIONS` specifies the notification behaviour. 
Set it to 1 to enable notifications. For verbose notifications, set to 2. 
To disable, set to 0.
`ENABLE_SCRIPTS` specifies the custom script behaviour.
To run script on Location changes, set to 1. To run on network changes, set to 2.
To disable, set to 0.

The `Automatic` section defines mapping for Wi-Fi Network SSIDs as key-value pairs in the following format.
Spaces are supported for both the SSID as well as the Location name, but all spaces around the `=` will be trimmed.
Additionally, do not enclose the SSID or Location in quotes.

The `Manual` section contains a list of Location names for which autodetection should be ignored.

```bash
[Automatic]
SSID=Location
Home Wi-Fi=Home
SSID With Spaces=Location Name With Spaces

[Manual]
Wi-Fi Only
```

### Running Custom Scripts When Changing Locations

*Location Changer* includes support for running custom scripts when switching Locations.
Scripts should be:

* installed into the directory `${HOME}/.locations/Scripts`
* named identically to the Location (e.g. `Home Wi-Fi` and not `Home Wi-Fi.sh`; if using manually configured Locations, please ensure the name matches the Location and not the SSID)
* be executable

When the script is run, the SSID gets passed as an argument, so can use it with `$1`.

By default, *Location Changer* will run custom scripts on Location changes.
This behavior can be changed by editing the `ENABLE_SCRIPTS` variable in the config file.
The following values are accepted:

* `0` - disable custom scripts
* `1` - enable custom scripts whenever the Location is changed
* `2` - enable custom scripts whenever a Wi-Fi network is joined, regardless of if the Location was changed

#### Examples

You may want to set your computer to require a password to unlock while at work.
By creating a script that matches the work Location name (e.g. `${HOME}/.locations/Scripts/Work`), this script can perform that configuration automatically when changing to the `Work` Location.

```bash
#!/usr/bin/env bash
exec 2>&1

# Require password immediately after sleep or screen saver begins
osascript -e 'tell application "System Events" to set require password to wake of security preferences to true'
```

You may also want to create a script that reverses those changes when you're at home, so you don't have to enter your password to unlock your computer.
You can save this as `${HOME}/.locations/Scripts/Home` if your home's SSID is `Home` or you have manually configured the `Home` Location to be used for your home's Wi-Fi SSID.
Alternatively, it could be saved to your default Location (`Automatic`, by default) if using the default Location at home: `${HOME}/.locations/Scripts/Automatic`.

```bash
#!/usr/bin/env bash
exec 2>&1

# Don’t require password immediately after sleep or screen saver begins
osascript -e 'tell application "System Events" to set require password to wake of security preferences to false'
```

### Notifications

*Location Changer* includes support for notifications through the macOS Notification system (via the AppleScript/osascript interface).
By default, *Location Changer* will display a notification whenever the Location is changed.
This behavior can be changed by editing the `ENABLE_NOTIFICATIONS` variable in the config file.
The following values are accepted:

* `0` - disable notifications
* `1` - enable notifications whenever the Location is changed
* `2` - enable notifications whenever a Wi-Fi network is joined, regardless of if the Location was changed

## Troubleshooting

Logging information is written to `${HOME}/Library/Logs/LocationChanger.log` by default.
Inspecting this log can be helpful when troubleshooting issues.

```bash
tail -f ~/Library/Logs/LocationChanger.log
```

Sample output:

```
[2018-03-05 06:23:18] Connected to 'Home Wi-Fi'
[2018-03-05 06:23:18] Will switch the Location to 'DHCP' (found in configuration file)
[2018-03-05 06:23:18] Changing the Location to 'DHCP'
[2018-03-05 06:23:18] CurrentSet updated to 3BA418DE-3C72-2EAB-A8A6-B71C42189204 (DHCP)
[2018-03-05 06:23:19] Running script: '/Users/username/.locations/DHCP'
```

## Uninstall

Running `./uninstall.sh` will remove all the copied files.
Be sure to check the paths if you modified them in the install script.
