Xml2Js=require 'xml2js'
XmlParser=new Xml2Js.Parser()
XmlBuilder=new Xml2Js.Builder()
Rx=require 'rxjs'
_=require 'lodash'

class Target
	constructor:(@observer,@template)->
		@init()

	init:->
		@data=_.cloneDeep @template
		@lastTime=null
		@startTime=null
		@lats=[]
		@lons=[]

	flush:->
		trkpts=@data.gpx.trk[0].trkseg[0].trkpt
		if @data.gpx.time? and @startTime?
			@data.gpx.time=@startTime

		if @data.gpx.bounds?[0]?
			@data.gpx.bounds[0].$.maxlat=_.max @lats
			@data.gpx.bounds[0].$.maxlon=_.max @lons
			@data.gpx.bounds[0].$.minlat=_.min @lats
			@data.gpx.bounds[0].$.minlon=_.min @lons

		@observer.next @data

gpxGapSplit=(gpxString,gapSeconds)->
	Rx.Observable.of gpxString
	.flatMap (gpxxml)->Rx.Observable.bindNodeCallback(XmlParser.parseString)(gpxxml)
	.flatMap (gpx)->
		Rx.Observable.create (observer)->
			template=_.cloneDeep gpx
			template.gpx.trk=[
				{trkseg:[
					{trkpt:[]}
				]}
			]

			target=new Target(observer,template)

			for i in _.range gpx.gpx.trk.length
				for j in _.range gpx.gpx.trk[i].trkseg.length
					for k in _.range gpx.gpx.trk[i].trkseg[j].trkpt.length
						current=gpx.gpx.trk[i].trkseg[j].trkpt[k].time?[0]
						currentTime=if current then new Date(current).getTime()/1000 else null
						pt=gpx.gpx.trk[i].trkseg[j].trkpt[k]
						if target.lastTime and currentTime
							diff=currentTime-target.lastTime
							if diff>=gapSeconds
								target.flush()

						target.lastTime=currentTime
						target.startTime?=current
						target.lats.push pt.$.lat if pt.$.lat?
						target.lons.push pt.$.lon if pt.$.lon?

						target.data.gpx.trk[0].trkseg[0].trkpt.push gpx.gpx.trk[i].trkseg[j].trkpt[k]

					target.flush()
			return

	.map (gpx)->XmlBuilder.buildObject gpx

module.exports=gpxGapSplit
