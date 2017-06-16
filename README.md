gpxgapsplit
==========

Command line tool to split GPX file by specified gap.

```
#example
#today.gpx <- 9:00-11:00 13:00-17:00

gpxgapsplit 1h split- < today.gpx

#result
#split-0.gpx #9:00-11:00
#split-1.gpx #13:00-17:00
```

## Install

```
sudo npm install -g gpxgapsplit
```

## Usage

```
@PARTPIPE@|dist/cli.js -h

!!SEE NPM README!!

@PARTPIPE@
```

## Use as module(rxjs)

```
Rx=require('rxjs');
GpxGapSplit=require('gpxgapsplit');

gapSeconds=3600;

Rx.Observable.from("<xml><gpx>...</gpx>")
.flatMap(function(gpxxml){GpxGapSplit(gpxxml,gapSeconds)})
.subscribe(function(r){
	console.log("=PART=");
	console.log(r);
});
```

## Change Log

- 0.1.x:first release
