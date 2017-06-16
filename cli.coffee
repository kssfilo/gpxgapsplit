#!/usr/bin/env coffee

Rx=require 'rxjs'
require('rxjs-exec').patch(Rx.Observable)
GpxGapSplit=require './gpxgapsplit'
Fs=require 'fs'

arg=process.argv[2]

if arg is '-h' or !arg or process.argv.length<4
	console.log """
		gpxgapsplit [-ht] <gap> [<output prefix>] < <gpxfile>
		
		Command line tool to split GPX file by specified gap.

		options:
			-t: test mode, displays information of expected result

		example:
			gpxgapsplit 1d < today.gpx  #split by 1 day gap(gpxgapsplit-0.gpx,gpxgapsplit-1.gpx...)
			gpxgapsplit 1h < today.gpx  #by + 1 hour blank
			gpxgapsplit 1d < today.gpx  #by + 1 day blank
			gpxgapsplit -t 1d < today.gpx  #test mode, displays expected result
			gpxgapsplit 1m split- < today.gpx  #specify prefix of output file(split-0.gpx,split-1.gpx...)
	"""
	process.exit 0

isTestMode=false
if arg is '-t'
	isTestMode=true
	process.argv.shift()
	arg=process.argv[2]

pa=arg.match /^(\d+)([hdms])$/
if !pa
	console.error "Invalid gap"
	process.exit 1

destPrefix=process.argv[3] ? 'gpxgapsplit-'

gap=parseInt(pa[1])*
	switch pa[2]
		when 's' then 1
		when 'h' then 3600
		when 'm' then 60
		when 'd' then 3600*24

index=0

Rx.Observable.exec 'cat',{stdin:true}
.toArray().map (x)->x.join ''
.flatMap (gpxxml)->GpxGapSplit(gpxxml,gap)
.catch (e)->console.error e
.subscribe (r)->
	if isTestMode
		console.log "gpx#{index}:size=#{r.length}"
	else
		Fs.writeFileSync "#{destPrefix}#{index}.gpx",r

	index++
