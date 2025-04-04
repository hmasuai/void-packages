#!/bin/bash
#
# xpkgdiff.sh

set -e

export XBPS_TARGET_ARCH="$2"
export DIFF='diff --unified=0 --report-identical-files --suppress-common-lines
 --color=always --label REPO --label BUILT'
ARGS="-a $2 -R https://repo-ci.voidlinux.org/current"

while read -r pkg; do
	for subpkg in $(xsubpkg $pkg); do
		if xbps-query --repository=hostdir/binpkgs/bootstrap \
					  --repository=hostdir/binpkgs \
					  --repository=hostdir/binpkgs/nonfree \
					  -i "$subpkg" >&/dev/null; then
			/bin/echo -e "\x1b[34mFile Diff of $subpkg:\x1b[0m"
			xpkgdiff $ARGS -f $subpkg
			/bin/echo -e "\x1b[34mMetadata Diff of $subpkg:\x1b[0m"
			xpkgdiff $ARGS -S $subpkg
			/bin/echo -e "\x1b[34mDependency Diff of $subpkg:\x1b[0m"
			xpkgdiff $ARGS -x $subpkg
		else
			/bin/echo -e "\x1b[33m$subpkg wasn't found\x1b[0m"
		fi
	done
done < /tmp/templates
