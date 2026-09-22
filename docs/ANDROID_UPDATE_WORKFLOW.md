# Android Update Workflow

## Goal

During development, installing a new build should behave like an update instead of requiring an uninstall/reinstall cycle.

## Required identity

Package: com.shatteredrealms.reborn

Keep this package ID unchanged throughout development.

Android also requires a compatible signing identity for an update. Do not casually switch development keystores.

## Godot setup

1. Open the project in Godot.
2. Confirm the Android preset named Android is marked Runnable.
3. Configure the Android SDK and Java if Godot requests them.
4. Enable Developer Options and USB debugging on the test phone.
5. Connect by USB or configure wireless ADB.
6. Keep the clear-previous-install option disabled.
7. Use Godot's Android one-click deploy button.

Expected loop:

Edit
  |
Save
  |
One-click deploy
  |
Godot exports debug APK
  |
Android updates the installed app
  |
Game launches

## If Android says the app cannot be installed

The common cause for an update failure is a signing mismatch: the installed app and new APK use the same package ID but different signing keys.

If that happens, preserve the correct development signing identity rather than immediately changing the package ID.

## Production signing

When the game becomes a real release, create a dedicated release keystore and protect it outside Git. Increase the Android version code for every release.

Godot keeps confidential export credentials separate from the normal export preset configuration.
