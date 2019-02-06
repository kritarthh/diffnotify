# Requirements
  * CutyCapt
  * pillow
  * pyinstaller

# Installation
`git clone https://github.com/kritarthh/diffnotify`

`cd diffnotify`

`pip install pillow pyinstaller`

`pyinstaller --onefile imgtools.py && cp dist/imgtools .`

# Usage
`./diffnotify.sh <test | prod> <url-to-monitor-for-changes> <start-x-fraction> <start-y-fraction> <end-x-fraction> <end-y-fraction> [min-notify-threshold]`

`test` will save `[cropped_]<url-hash>.jpg` for you to check them manually

`prod` will start the main notification program

`link_history` contains all mappings from hash to the url

`archive/` directory contains old images which had changes in them

# Examples
`./diffnotify.sh test https://t.17track.net/en#nums=RP179606857CN 0 0 1 0.5` will create a top half cropped and a full image for manual check

`./diffnotify.sh prod https://t.17track.net/en#nums=RP179606857CN 0.5 0.5 1 1 6.623` will compare only the bottom right quarter and notify on changes of more than 6.623 %
