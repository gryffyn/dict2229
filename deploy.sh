#!/bin/bash
flutter build apk --split-per-abi --bundle-sksl-path flutter_01.sksl.json --split-debug-info=debug
for f in build/app/outputs/flutter-apk/app-*release.apk; do sha256sum $f > $f.sha256; done
scp build/app/outputs/flutter-apk/app-*release.apk{,.sha256} srv:/srv/files/projects/dict2229/.
