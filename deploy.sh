#!/bin/bash
glob="build/app/outputs/apk/release/app-*release.apk"
flutter build apk --split-per-abi --bundle-sksl-path flutter_01.sksl.json --split-debug-info=debug
for f in $glob
do
  sha256sum $f > $f.sha256
  scp $f srv:/srv/files/projects/dict2229/.
  scp $f srv:/srv/files/projects/dict2229/.
done
