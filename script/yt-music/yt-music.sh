#!/usr/bin/env bash
#
# Download YouTube Music playlist
#
# Usage: yt-dlmp <URL> ...

main() {
	# for downloading playlist thumbnail
	yt-dlp \
		--flat-playlist \
		--skip-download \
		--output "%(playlist_title)s/%(title)s.%(ext)s" \
		--write-thumbnail \
		"$@"

	# wait for https://github.com/yt-dlp/yt-dlp/issues/5635
	# --embed-subs \
	yt-dlp \
		--embed-metadata \
		--embed-thumbnail \
		--output "%(playlist_title)s/%(title)s.%(ext)s" \
		--audio-format m4a \
		--audio-quality 0 \
		--extract-audio \
		--write-subs \
		--convert-subs lrc \
		"$@"
}

main "$@"
