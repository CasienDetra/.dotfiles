#!/bin/bash

# Script to clear browser cache

# Firefox
PROFILE_DIR="/home/user/.mozilla/firefox/xxxxxxxx.default-release" #Replace
if [ -d "$PROFILE_DIR/cache2" ]; then
	rm -rf "$PROFILE_DIR/cache2/*"
	echo "Firefox cache cleared."
else
	echo "Firefox cache directory not found.  Check the profile directory."
fi

# Chrome (dont use)
# CHROME_PROFILE_DIR="/home/user/.config/google-chrome/Default" #Replace
# if [ -d "$CHROME_PROFILE_DIR/Cache" ]; then
#     rm -rf "$CHROME_PROFILE_DIR/Cache/*"
#     echo "Chrome cache cleared."
# else
#     echo "Chrome cache directory not found. Check the profile directory."
# fi
# if [ -d "$CHROME_PROFILE_DIR/Media Cache" ]; then
#     rm -rf "$CHROME_PROFILE_DIR/Media Cache/*"
#     echo "Chrome Media Cache cleared."
# else
#     echo "Chrome Media Cache directory not found. Check the profile directory."
# fi
# Brave
BRAVE_PROFILE_DIR="/home/user/.config/BraveSoftware/Brave-Browser/Default" #Replace
if [ -d "$BRAVE_PROFILE_DIR/Cache" ]; then
	rm -rf "$BRAVE_PROFILE_DIR/Cache/*"
	echo "Brave cache cleared."
else
	echo "Brave cache directory not found. Check the profile directory."
fi
if [ -d "$BRAVE_PROFILE_DIR/Media Cache" ]; then
	rm -rf "$BRAVE_PROFILE_DIR/Media Cache/*"
	echo "Brave Media Cache cleared."
else
	echo "Brave Media Cache directory not found. Check the profile directory."
fi

echo "Cache clearing process complete."
