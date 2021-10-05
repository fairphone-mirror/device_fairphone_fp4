#!/system/bin/sh

# Check if this script should trigger, exit quietly otherwise.
if [ ! -f /data/userdata_automation/trigger ]; then
    echo >&2 "+++ SKIPPING automation setup for ATS. Trigger not set. +++"
    exit 0
fi

settings_put() {
    echo >&2 "[automation_setup] settings put $*"
    # -w: Wait for the service to be ready, as we're running in early boot
    cmd -w settings put "$@"
}

# Output on stderr, to be picked up via stdio_to_kmsg on kmsg.
echo >&2 "+++ TRIGGERING AUTOMATION SETUP FOR ATS +++"

# Following `settings put` calls must run as root from Android 11 on. The
# `system` user doesn't have enough permissions.

# Enable adb, system settings part
settings_put global development_settings_enabled 1
settings_put global verifier_verify_adb_installs 0
settings_put global adb_enabled 1

# Skip setupwizard
settings_put global device_provisioned 1
settings_put secure user_setup_complete 1

# Remove trigger so we don't run again
rm -v /data/userdata_automation/trigger

echo >&2 "+++ AUTOMATION: Waiting for late boot trigger. +++"
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    # Full boot can take a while, especially after factory reset.
    sleep 2
done

# Enable mobile data. Requires service `phone` to be running.
svc data enable

echo >&2 "+++ TRIGGERING AUTOMATION SETUP FOR ATS DONE +++"
