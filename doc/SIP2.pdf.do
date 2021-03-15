#!/usr/bin/env bash

set -x

original_url="http://mws9.3m.com/mws/mediawebserver.dyn?6666660Zjcf6lVs6EVs66S0LeCOrrrrQ-"
archive_url="https://web.archive.org/web/20110707063609id_/${original_url}"

curl --fail --no-progress-meter "$archive_url" > $3