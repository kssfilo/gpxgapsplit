#!/usr/bin/env bats

@test "1d" {
	[ "$(rm hoge*.gpx;cat test/hiking.gpx|dist/cli.js 1d hoge;cat hoge*.gpx|shasum)" = "34b8cb853085112678c9044c965d1c1791ae018c  -" ]
}

@test "2d" {
	[ "$(rm hoge*.gpx;cat test/hiking.gpx|dist/cli.js 2d hoge;cat hoge*.gpx|shasum)" = "d1495e972ff17146353cb82974faae1e02f53bcd  -" ]
}

@test "notimestamp" {
	[ "$(rm hoge*.gpx;cat test/notimestamp.gpx|dist/cli.js 2d hoge;cat hoge*.gpx|shasum)" = "cfa33b994de8544e2f3b1b6597c33e58d965a692  -" ]
}

@test "defaultPrefix" {
	[ "$(rm hoge*.gpx;cat test/hiking.gpx|dist/cli.js 1d ;cat gpxgapsplit-*.gpx|shasum)" = "34b8cb853085112678c9044c965d1c1791ae018c  -" ]
}
