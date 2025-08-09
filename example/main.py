# Sends 'A' every 2 seconds via USB HID (keyboard)
# Note: The exact usb_hid API can vary across MicroPython builds.

import time
try:
    import usb_hid
except Exception as e:
    print("usb_hid not available:", e)
    usb_hid = None

KEY_A = 0x04  # HID keycode for 'a'

def send_key(keycode):
    report = bytes([0x00, 0x00, keycode, 0x00, 0x00, 0x00, 0x00, 0x00])
    try:
        # Some builds expose usb_hid.send_report()
        if hasattr(usb_hid, "send_report"):
            usb_hid.send_report(report)
            usb_hid.send_report(bytes([0]*8))
        else:
            # Or a device with write()/send_report
            dev = usb_hid.devices[0]
            if hasattr(dev, "send_report"):
                dev.send_report(report)
                dev.send_report(bytes([0]*8))
            else:
                dev.write(report)
                dev.write(bytes([0]*8))
    except Exception as e:
        print("HID report error:", e)

if usb_hid:
    while True:
        send_key(KEY_A)
        time.sleep(2)
else:
    print("HID not enabled in this firmware.")
