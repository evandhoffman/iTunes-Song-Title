#!/bin/sh
buildNumber=$(/usr/libexec/PlistBuddy -c "Print DDBuildNumber" iTunes_Current_Track-Info.plist)
buildNumber=$(($buildNumber + 1))
buildDate=`date +%Y-%m-%d-%H:%M:%S`
/usr/libexec/PlistBuddy -c "Set :DDBuildNumber $buildNumber" iTunes_Current_Track-Info.plist
/usr/libexec/PlistBuddy -c "Set :DDBuildDate $buildDate" iTunes_Current_Track-Info.plist

