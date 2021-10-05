#!/system/bin/sh

# Check if this script should trigger, exit quietly otherwise.
if [ ! -f /data/userdata_automation/trigger ]; then
    echo >&2 "+++ SKIPPING automation adb setup for ATS. Trigger not set. +++"
    exit 0
fi

# Move supplied adb public key to correct directory
# Must run under system user to match owner of /data/misc/adb/.
mv -v /data/userdata_automation/adb_keys /data/misc/adb/adb_keys
chown -v 1000:2000 /data/misc/adb/adb_keys
# Enable adb, system property part
setprop persist.sys.usb.config adb

echo >&2 "+++ TRIGGERING AUTOMATION ADB SETUP FOR ATS DONE +++"
