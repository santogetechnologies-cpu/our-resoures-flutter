// 3D Globe Web Bridge for Flutter Web (MapLibre GL JS v5 — Token-Free)

window.mapboxGlobeInstances = window.mapboxGlobeInstances || {};
window.mapboxGlobeMarkers = window.mapboxGlobeMarkers || {};
window.mapboxGlobePendingCbs = window.mapboxGlobePendingCbs || {};   // queued marker calls

// ---------------------------------------------------------------------------
// RTL Text Plugin for MapLibre GL JS (Shapes and joins Arabic/RTL text)
// ---------------------------------------------------------------------------
function ensureRTLTextPlugin() {
  if (typeof maplibregl !== 'undefined' && maplibregl.setRTLTextPlugin) {
    try {
      if (maplibregl.getRTLTextPluginStatus() === 'unavailable') {
        maplibregl.setRTLTextPlugin(
          'https://unpkg.com/@mapbox/mapbox-gl-rtl-text@0.2.3/mapbox-gl-rtl-text.min.js',
          function (err) {
            if (err) console.error('[MapLibre RTL Text Plugin Error]:', err);
          },
          true
        );
      }
    } catch (e) {
      console.warn('[MapLibre RTL Text Plugin Init]:', e);
    }
  }
}
ensureRTLTextPlugin();

// ---------------------------------------------------------------------------
// Satellite + Labels base style (ArcGIS / Esri — fully public, no token)
// ---------------------------------------------------------------------------
const ESRI_SATELLITE_GLOBE_STYLE = {
  version: 8,
  name: 'Satellite 3D Globe',
  sources: {
    'esri-world-imagery': {
      type: 'raster',
      tiles: [
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
      ],
      tileSize: 256,
      attribution: '© Esri, Maxar, Earthstar Geographics'
    }
  },
  layers: [
    { id: 'imagery', type: 'raster', source: 'esri-world-imagery', minzoom: 0, maxzoom: 19 }
  ]
};

// ---------------------------------------------------------------------------
// Default Arabic Globe Base Style (100% Arabic place labels & satellite imagery)
// ---------------------------------------------------------------------------
const DEFAULT_ARABIC_GLOBE_STYLE = {"version":8,"name":"sahel","metadata":{"mapbox:type":"default","mapbox:trackposition":true,"mapbox:uiParadigm":"layers","mapbox:decompiler":{"id":"clpib93y500lx01r51fmcfk30","componentVersion":"18.0.0","strata":[{"id":"satellite-streets-v12","order":[["land-and-water","land"],["land-and-water","water"],["land-and-water","built"],["transit","built"],["satellite","land"],["walking-cycling","tunnels"],["road-network","tunnels"],["walking-cycling","surface"],["road-network","surface"],["transit","surface"],["walking-cycling","barriers-bridges"],["road-network","bridges"],["transit","bridges"],["admin-boundaries","admin"],["land-and-water","terrain-labels"],["road-network","road-labels"],["walking-cycling","walking-cycling-labels"],["transit","ferry-aerialway-labels"],["natural-features","natural-labels"],["point-of-interest-labels","poi-labels"],["transit","transit-labels"],["place-labels","place-labels"],"red","sea-1-77hgzg"]}],"overrides":{"satellite":{"background":{"paint":{"background-color":"hsl(222, 100%, 64%)"}}},"place-labels":{"country-label":{"layout":{"text-field":["coalesce",["case",["==",["get","name_ar"],"إسرائيل"],"فلسطين",["get","name_ar"]],["get","name"]]}}}},"components":{"road-network":"18.0.0","natural-features":"18.0.0","place-labels":"18.0.0","admin-boundaries":"18.0.0","point-of-interest-labels":"18.0.0","walking-cycling":"18.0.0","transit":"18.0.0","satellite":"18.0.0","land-and-water":"18.0.0"},"propConfig":{"road-network":{"roadsFont":["DIN Pro Medium","Arial Unicode MS Regular"],"colorRoad":"hsla(0, 0%, 80%, 0.8)","iconSaturation":-0.5,"roadNetwork":"Simple","construction":false,"colorRoadLabel":"hsl(0, 0%, 100%)","fadeOutRoadsOnZoom":true,"colorBase":"hsl(0, 0%, 0%)","labelDensity":10,"roadsSize":1.1,"colorMotorwayTrunk":"hsla(40, 90%, 70%, 0.8)","polygonFeatures":false,"language":"Arabic","colorPathOutline":"hsla(40, 95%, 90%, 0.8)","roadMarkings":true,"turningCircles":false,"colorRoadOutline":"hsla(0, 1%, 10%, 0.7)"},"natural-features":{"poiEtcFont":["DIN Pro Bold","Arial Unicode MS Bold"],"colorBase":"hsl(0, 0%, 0%)","colorWater":"hsl(240, 100%, 62%)","colorPoi":"hsl(0, 0%, 100%)","labelHalo":true,"poiIconScale":0.8,"language":"Arabic","labelStyle":"Text and icon"},"place-labels":{"continentsSize":1.1,"statesSize":1.1,"settlementsMinorSize":1.1,"continentsTransform":"uppercase","settlementsMajorSize":1.1,"colorPlaceLabel":"hsl(0, 0%, 100%)","settlementSubdivisionsSize":1.1,"colorBase":"hsl(0, 0%, 0%)","countriesSize":1.1,"language":"Arabic","settlementsMinorFont":["DIN Pro Medium","Arial Unicode MS Regular"],"settlementSubdivisionsFont":["DIN Pro Medium","Arial Unicode MS Regular"]},"admin-boundaries":{"admin0Width":1.5,"colorBase":"hsl(0, 0%, 0%)","colorAdminBoundary":"hsl(260, 15%, 80%)","admin0DashPattern":"Dash on zoom","admin2":true,"admin2Width":1},"point-of-interest-labels":{"colorPoiEducation":"hsl(30, 100%, 80%)","poiIconScale":0.8,"colorPoi":"hsl(0, 0%, 100%)","colorPoiParkLike":"hsl(110, 100%, 80%)","colorPoiMedical":"hsl(360, 100%, 80%)","poiIconBackground":"Circle","colorBase":"hsl(0, 0%, 0%)","controlDensityByClass":false,"language":"Arabic","poiEtcFont":["DIN Pro Bold","Arial Unicode MS Bold"]},"walking-cycling":{"roadsFont":["DIN Pro Medium","Arial Unicode MS Regular"],"colorRoad":"hsla(0, 0%, 80%, 0.8)","golfHoleLabelLine":false,"colorGreenspace":"hsl(94, 100%, 14%)","colorPoi":"hsl(0, 0%, 100%)","colorPoiParkLike":"hsl(110, 100%, 80%)","fadeOutPathsOnZoom":true,"walkingCyclingPisteBackground":false,"colorRoadLabel":"hsl(0, 0%, 100%)","colorBase":"hsl(0, 0%, 0%)","roadsSize":1.1,"language":"Arabic","poiEtcFont":["DIN Pro Bold","Arial Unicode MS Bold"],"colorPathOutline":"hsla(40, 95%, 90%, 0.8)","pedestrianPolygonFeatures":false,"colorRoadOutline":"hsla(0, 1%, 10%, 0.7)","labels":true},"transit":{"matchLabelAndIcon":false,"roadsFont":["DIN Pro Medium","Arial Unicode MS Regular"],"aeroways":false,"poiIconScale":0.8,"colorPoi":"hsl(0, 0%, 100%)","colorAirport":"hsl(0, 0%, 100%)","airportLabels":true,"colorTransit":"hsl(204, 100%, 80%)","poiIconBackground":"Rectangle","colorBase":"hsl(0, 0%, 0%)","colorWater":"hsl(240, 100%, 62%)","roadsSize":1.1,"railways":false,"worldview":"US","ferries":false,"language":"Arabic","poiEtcFont":["DIN Pro Bold","Arial Unicode MS Bold"],"colorRoadOutline":"hsla(0, 1%, 10%, 0.7)"},"satellite":{"satelliteStyle":"Standard"},"land-and-water":{"colorGreenspace":"hsl(94, 100%, 14%)","colorPoi":"hsl(0, 0%, 100%)","colorPoiParkLike":"hsl(110, 100%, 80%)","colorAirport":"hsl(0, 0%, 100%)","hillshade":true,"landuseDensity":14,"colorBase":"hsl(0, 0%, 0%)","colorWater":"hsl(240, 100%, 62%)","contours":true,"poiEtcFont":["DIN Pro Bold","Arial Unicode MS Bold"],"bathymetry":false}}},"mapbox:thumb":"data:image/webp;base64,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","mapbox:autocomposite":true,"mapbox:sdk-support":{"js":"latest","android":"11.0.0","ios":"11.0.0"},"mapbox:origin":"satellite-streets-v12","mapbox:groups":{"Transit, transit-labels":{"name":"Transit, transit-labels","collapsed":true},"Administrative boundaries, admin":{"name":"Administrative boundaries, admin","collapsed":true},"Land & water, built":{"name":"Land & water, built","collapsed":true},"Transit, bridges":{"name":"Transit, bridges","collapsed":true},"Land & water, land":{"name":"Land & water, land","collapsed":true},"Road network, bridges":{"name":"Road network, bridges","collapsed":true},"Road network, tunnels":{"name":"Road network, tunnels","collapsed":true},"Road network, road-labels":{"name":"Road network, road-labels","collapsed":true},"Natural features, natural-labels":{"name":"Natural features, natural-labels","collapsed":true},"Road network, surface":{"name":"Road network, surface","collapsed":true},"Walking, cycling, etc., barriers-bridges":{"name":"Walking, cycling, etc., barriers-bridges","collapsed":true},"Place labels, place-labels":{"name":"Place labels, place-labels","collapsed":true},"Point of interest labels, poi-labels":{"name":"Point of interest labels, poi-labels","collapsed":true},"Walking, cycling, etc., tunnels":{"name":"Walking, cycling, etc., tunnels","collapsed":true},"Land & water, terrain-labels":{"name":"Land & water, terrain-labels","collapsed":true},"Walking, cycling, etc., walking-cycling-labels":{"name":"Walking, cycling, etc., walking-cycling-labels","collapsed":true},"Walking, cycling, etc., surface":{"name":"Walking, cycling, etc., surface","collapsed":true},"Land & water, water":{"name":"Land & water, water","collapsed":true},"Satellite imagery, land":{"name":"Satellite imagery, land","collapsed":true},"Transit, ferry-aerialway-labels":{"name":"Transit, ferry-aerialway-labels","collapsed":true}}},"center":[47.07557034536546,22.692601033630382],"zoom":4.487375149315836,"bearing":0,"pitch":0,"light":{"anchor":"map"},"sources":{"mapbox://mapbox.satellite":{"type":"raster","tileSize":256,"tiles":["https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}.webp?access_token=sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA"]},"mapbox-dem":{"type":"raster-dem","tileSize":512,"tiles":["https://api.mapbox.com/v4/mapbox.mapbox-terrain-dem-v1/{z}/{x}/{y}.webp?access_token=sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA"],"encoding":"mapbox"},"composite":{"type":"vector","tiles":["https://api.mapbox.com/v4/mapbox.mapbox-streets-v8,mapbox.mapbox-terrain-v2,mshari-aljohani.5fb9cd8o,mshari-aljohani.765kyiye/{z}/{x}/{y}.vector.pbf?access_token=sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA"]}},"sprite":"https://api.mapbox.com/styles/v1/mshari-aljohani/clpib93y500lx01r51fmcfk30/1vt6p23fclggk7fiehl05bzi1/sprite?access_token=sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA","glyphs":"https://api.mapbox.com/fonts/v1/mapbox/{fontstack}/{range}.pbf?access_token=sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA","layers":[{"id":"land","type":"background","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, land"},"layout":{},"paint":{"background-color":["interpolate",["linear"],["zoom"],9,"hsl(0, 0%, 0%)",11,"hsl(0, 0%, 14%)"]}},{"id":"landcover","type":"fill","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, land"},"source":"composite","source-layer":"landcover","maxzoom":12,"filter":["match",["get","class"],["scrub","grass"],["step",["zoom"],true,8,false],true],"layout":{},"paint":{"fill-color":["match",["get","class"],"wood","hsla(99, 95%, 15%, 0.8)","snow","hsl(240, 70%, 87%)","hsl(94, 80%, 10%)"],"fill-opacity":["interpolate",["exponential",1.5],["zoom"],9,0.4,10,["match",["get","class"],"crop",0,0.4],11,["match",["get","class"],"crop",0,0.4],12,0],"fill-antialias":false}},{"id":"national-park","type":"fill","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, land"},"source":"composite","source-layer":"landuse_overlay","minzoom":5,"filter":["==",["get","class"],"national_park"],"layout":{},"paint":{"fill-color":"hsl(94, 52%, 12%)","fill-opacity":["interpolate",["linear"],["zoom"],5,0,6,0.6,12,0.2]}},{"id":"landuse","type":"fill","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, land"},"source":"composite","source-layer":"landuse","minzoom":5,"filter":["all",[">=",["to-number",["get","sizerank"]],0],["match",["get","class"],["agriculture","wood","grass","scrub","glacier","pitch","sand"],["step",["zoom"],false,11,true],"residential",["step",["zoom"],true,10,false],["park","airport"],["step",["zoom"],false,8,["case",["==",["get","sizerank"],1],true,false],10,true],"cemetery",["step",["zoom"],false,11,true],false],["<=",["-",["to-number",["get","sizerank"]],["interpolate",["exponential",1.5],["zoom"],12,0,18,14]],14]],"layout":{},"paint":{"fill-color":["interpolate",["linear"],["zoom"],15,["match",["get","class"],"wood","hsla(99, 95%, 15%, 0.8)","scrub","hsla(94, 92%, 16%, 0.6)","agriculture","hsla(94, 95%, 20%, 0.6)","park","hsl(94, 100%, 14%)","grass","hsla(94, 95%, 20%, 0.6)","airport","hsl(0, 0%, 10%)","cemetery","hsl(94, 70%, 19%)","glacier","hsl(240, 70%, 87%)","pitch","hsl(84, 100%, 16%)","sand","hsl(94, 100%, 20%)","residential","hsl(0, 0%, 10%)","hsl(0, 0%, 12%)"],16,["match",["get","class"],"wood","hsla(99, 95%, 15%, 0.8)","scrub","hsla(94, 92%, 16%, 0.6)","agriculture","hsla(94, 95%, 20%, 0.6)","park","hsl(94, 100%, 14%)","grass","hsla(94, 95%, 20%, 0.6)","airport","hsl(0, 0%, 10%)","cemetery","hsl(94, 70%, 19%)","glacier","hsl(240, 70%, 87%)","pitch","hsl(84, 100%, 16%)","sand","hsl(94, 100%, 20%)","hsl(0, 0%, 12%)"]],"fill-opacity":["interpolate",["linear"],["zoom"],8,["match",["get","class"],"residential",0.8,0.2],10,["match",["get","class"],"residential",0,1]],"fill-antialias":false}},{"id":"hillshade","type":"fill","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, land"},"source":"composite","source-layer":"hillshade","maxzoom":16,"filter":["all",["step",["zoom"],["==",["get","class"],"shadow"],11,true],["match",["get","level"],89,true,78,["step",["zoom"],false,5,true],67,["step",["zoom"],false,9,true],56,["step",["zoom"],false,6,true],94,["step",["zoom"],false,11,true],90,["step",["zoom"],false,12,true],false]],"layout":{},"paint":{"fill-color":["interpolate",["linear"],["zoom"],14,["match",["get","class"],"shadow","hsla(94, 52%, 0%, 0.06)","hsla(0, 0%, 37%, 0.12)"],16,["match",["get","class"],"shadow","hsla(94, 52%, 0%, 0)","hsla(0, 0%, 37%, 0)"]],"fill-antialias":false}},{"id":"contour-line","type":"line","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, land"},"source":"composite","source-layer":"contour","minzoom":11,"filter":["!=",["get","index"],-1],"layout":{},"paint":{"line-opacity":["interpolate",["linear"],["zoom"],11,["match",["get","index"],[1,2],0.15,0.3],13,["match",["get","index"],[1,2],0.3,0.5]],"line-color":"hsl(0, 0%, 10%)","line-width":["interpolate",["linear"],["zoom"],13,["match",["get","index"],[1,2],0.5,0.6],16,["match",["get","index"],[1,2],0.8,1.2]]}},{"id":"cliff","type":"line","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, land"},"source":"composite","source-layer":"structure","minzoom":15,"filter":["==",["get","class"],"cliff"],"layout":{"line-cap":"round","line-join":"round"},"paint":{"line-opacity":["interpolate",["linear"],["zoom"],15,0,15.25,1],"line-width":10,"line-pattern":"cliff"}},{"id":"pitch-outline","type":"line","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, land"},"source":"composite","source-layer":"landuse","minzoom":15,"filter":["==",["get","class"],"pitch"],"layout":{},"paint":{"line-color":"hsl(84, 100%, 9%)"}},{"id":"waterway-shadow","type":"line","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, water"},"source":"composite","source-layer":"waterway","minzoom":10,"layout":{"line-cap":["step",["zoom"],"butt",11,"round"],"line-join":["step",["zoom"],"miter",11,"round"]},"paint":{"line-color":"hsl(259, 100%, 61%)","line-width":["interpolate",["exponential",1.3],["zoom"],9,["match",["get","class"],["canal","river"],0.1,0],20,["match",["get","class"],["canal","river"],8,3]],"line-translate":["interpolate",["exponential",1.2],["zoom"],7,["literal",[0,0]],16,["literal",[-1,-1]]],"line-translate-anchor":"viewport","line-opacity":["interpolate",["linear"],["zoom"],8,0,8.5,1]}},{"id":"water-shadow","type":"fill","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, water"},"source":"composite","source-layer":"water","minzoom":10,"layout":{},"paint":{"fill-color":"hsl(259, 100%, 61%)","fill-translate":["interpolate",["exponential",1.2],["zoom"],7,["literal",[0,0]],16,["literal",[-1,-1]]],"fill-translate-anchor":"viewport"}},{"id":"waterway","type":"line","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, water"},"source":"composite","source-layer":"waterway","minzoom":8,"layout":{"line-cap":["step",["zoom"],"butt",11,"round"],"line-join":["step",["zoom"],"miter",11,"round"]},"paint":{"line-color":"hsl(240, 100%, 62%)","line-width":["interpolate",["exponential",1.3],["zoom"],9,["match",["get","class"],["canal","river"],0.1,0],20,["match",["get","class"],["canal","river"],8,3]],"line-opacity":["interpolate",["linear"],["zoom"],8,0,8.5,1]}},{"id":"water","type":"fill","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, water"},"source":"composite","source-layer":"water","layout":{},"paint":{"fill-color":"hsl(240, 100%, 62%)"}},{"id":"land-structure-polygon","type":"fill","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, built"},"source":"composite","source-layer":"structure","minzoom":13,"filter":["all",["==",["get","class"],"land"],["==",["geometry-type"],"Polygon"]],"layout":{},"paint":{"fill-color":["interpolate",["linear"],["zoom"],9,"hsl(0, 0%, 0%)",11,"hsl(0, 0%, 14%)"]}},{"id":"land-structure-line","type":"line","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, built"},"source":"composite","source-layer":"structure","minzoom":13,"filter":["all",["==",["get","class"],"land"],["==",["geometry-type"],"LineString"]],"layout":{"line-cap":"square"},"paint":{"line-width":["interpolate",["exponential",1.99],["zoom"],14,0.75,20,40],"line-color":["interpolate",["linear"],["zoom"],9,"hsl(0, 0%, 0%)",11,"hsl(0, 0%, 14%)"]}},{"id":"background","type":"background","metadata":{"mapbox:featureComponent":"satellite","mapbox:group":"Satellite imagery, land"},"layout":{},"paint":{"background-color":"hsl(222, 100%, 64%)"}},{"id":"satellite","type":"raster","metadata":{"mapbox:featureComponent":"satellite","mapbox:group":"Satellite imagery, land"},"source":"mapbox://mapbox.satellite","layout":{},"paint":{}},{"id":"tunnel-path","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., tunnels"},"source":"composite","source-layer":"road","minzoom":15,"filter":["all",["==",["get","structure"],"tunnel"],["==",["get","class"],"path"],["!=",["get","type"],"steps"],["==",["geometry-type"],"LineString"]],"layout":{},"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],15,1,18,4],"line-color":"hsla(40, 88%, 77%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[1,0]],15,["literal",[1.75,1]],16,["literal",[1,0.75]],17,["literal",[1,0.5]]]}},{"id":"tunnel-steps","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., tunnels"},"source":"composite","source-layer":"road","minzoom":15,"filter":["all",["==",["get","structure"],"tunnel"],["==",["get","type"],"steps"],["==",["geometry-type"],"LineString"]],"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],15,1,16,1.6,18,6],"line-color":"hsla(40, 88%, 77%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[1,0]],15,["literal",[1.75,1]],16,["literal",[1,0.75]],17,["literal",[0.3,0.3]]]}},{"id":"tunnel-pedestrian","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., tunnels"},"source":"composite","source-layer":"road","minzoom":15,"filter":["all",["==",["get","structure"],"tunnel"],["==",["get","class"],"pedestrian"],["==",["geometry-type"],"LineString"]],"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],14,0.5,18,12],"line-color":"hsla(40, 95%, 90%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[2,0.3]],15,["literal",[1,0.3]],16,["literal",[1,0.3]],17,["literal",[1,0.25]]]}},{"id":"tunnel-simple","type":"line","metadata":{"mapbox:featureComponent":"road-network","mapbox:group":"Road network, tunnels"},"source":"composite","source-layer":"road","minzoom":13,"filter":["all",["==",["get","structure"],"tunnel"],["step",["zoom"],["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","secondary","tertiary","street","street_limited","primary_link","track"],true,false],14,["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","primary_link","secondary","secondary_link","tertiary","tertiary_link","street","street_limited","service","track"],true,false]],["==",["geometry-type"],"LineString"]],"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],13,["match",["get","class"],["motorway","trunk","primary"],4,["secondary","tertiary"],2.5,["motorway_link","trunk_link","street","street_limited","primary_link"],1,0.5],18,["match",["get","class"],["motorway","trunk","primary"],32,["secondary","tertiary"],26,["motorway_link","trunk_link","street","street_limited","primary_link"],18,12],22,["match",["get","class"],["motorway","trunk","primary"],320,["secondary","tertiary"],260,["motorway_link","trunk_link","primary_link","street","street_limited"],180,120]],"line-color":"hsla(0, 0%, 73%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],13,1,15,0]}},{"id":"road-path","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., surface"},"source":"composite","source-layer":"road","minzoom":12,"filter":["all",["==",["get","class"],"path"],["step",["zoom"],["!",["match",["get","type"],["steps","sidewalk","crossing"],true,false]],16,["!=",["get","type"],"steps"]],["match",["get","structure"],["none","ford"],true,false],["==",["geometry-type"],"LineString"]],"layout":{"line-join":["step",["zoom"],"miter",14,"round"]},"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],13,0.5,14,1,15,1,18,4],"line-color":"hsla(40, 95%, 90%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[4,0.3]],15,["literal",[1.75,0.3]],16,["literal",[1,0.3]],17,["literal",[1,0.25]]]}},{"id":"road-steps","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., surface"},"source":"composite","source-layer":"road","minzoom":14,"filter":["all",["==",["get","type"],"steps"],["match",["get","structure"],["none","ford"],true,false],["==",["geometry-type"],"LineString"]],"layout":{"line-join":"round"},"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],15,1,16,1.6,18,6],"line-color":"hsla(40, 95%, 90%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[1,0]],15,["literal",[1.75,1]],16,["literal",[1,0.75]],17,["literal",[0.3,0.3]]]}},{"id":"road-pedestrian","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., surface"},"source":"composite","source-layer":"road","minzoom":12,"filter":["all",["==",["get","class"],"pedestrian"],["match",["get","structure"],["none","ford"],true,false],["case",["has","layer"],[">=",["get","layer"],0],true],["==",["geometry-type"],"LineString"]],"layout":{"line-join":["step",["zoom"],"miter",14,"round"]},"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],14,0.5,18,12],"line-color":"hsla(40, 95%, 90%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[2,0.3]],15,["literal",[1,0.3]],16,["literal",[1,0.3]],17,["literal",[1,0.25]]]}},{"id":"road-simple","type":"line","metadata":{"mapbox:featureComponent":"road-network","mapbox:group":"Road network, surface"},"source":"composite","source-layer":"road","minzoom":5,"filter":["all",["step",["zoom"],["match",["get","class"],["motorway","trunk"],true,false],6,["match",["get","class"],["motorway","trunk","primary"],true,false],8,["match",["get","class"],["motorway","trunk","primary","secondary"],true,false],10,["match",["get","class"],["motorway","trunk","primary","secondary","tertiary","motorway_link","trunk_link"],true,false],11,["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","secondary","tertiary","street"],true,false],12,["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","secondary","tertiary","street","street_limited","primary_link"],true,false],13,["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","secondary","tertiary","street","street_limited","primary_link","track"],true,false],14,["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","primary_link","secondary","secondary_link","tertiary","tertiary_link","street","street_limited","service","track"],true,false]],["match",["get","structure"],["none","ford"],true,false],["==",["geometry-type"],"LineString"]],"layout":{"line-cap":["step",["zoom"],"butt",14,"round"],"line-join":["step",["zoom"],"miter",14,"round"]},"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],5,["match",["get","class"],["motorway","trunk","primary"],0.75,["secondary","tertiary"],0.1,0],13,["match",["get","class"],["motorway","trunk","primary"],4,["secondary","tertiary"],2.5,["motorway_link","trunk_link","primary_link","street","street_limited"],1,0.5],18,["match",["get","class"],["motorway","trunk","primary"],32,["secondary","tertiary"],26,["motorway_link","trunk_link","primary_link","street","street_limited"],18,10],22,["match",["get","class"],["motorway","trunk","primary"],320,["secondary","tertiary"],260,["motorway_link","trunk_link","primary_link","street","street_limited"],180,100]],"line-color":["match",["get","class"],["primary_link","secondary_link","tertiary_link","street","street_limited","service","track"],"hsla(0, 0%, 77%, 0.8)","hsla(0, 0%, 80%, 0.8)"],"line-opacity":["interpolate",["linear"],["zoom"],13,1,15,0]}},{"id":"bridge-path","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., barriers-bridges"},"source":"composite","source-layer":"road","minzoom":14,"filter":["all",["==",["get","structure"],"bridge"],["==",["get","class"],"path"],["!=",["get","type"],"steps"],["==",["geometry-type"],"LineString"]],"layout":{},"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],15,1,18,4],"line-color":"hsla(40, 95%, 90%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[4,0.3]],15,["literal",[1.75,0.3]],16,["literal",[1,0.3]],17,["literal",[1,0.25]]]}},{"id":"bridge-steps","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., barriers-bridges"},"source":"composite","source-layer":"road","minzoom":14,"filter":["all",["==",["get","type"],"steps"],["==",["get","structure"],"bridge"],["==",["geometry-type"],"LineString"]],"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],15,1,16,1.6,18,6],"line-color":"hsla(40, 95%, 90%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[1,0]],15,["literal",[1.75,1]],16,["literal",[1,0.75]],17,["literal",[0.3,0.3]]]}},{"id":"bridge-pedestrian","type":"line","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., barriers-bridges"},"source":"composite","source-layer":"road","minzoom":13,"filter":["all",["==",["get","structure"],"bridge"],["==",["get","class"],"pedestrian"],["==",["geometry-type"],"LineString"]],"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],14,0.5,18,12],"line-color":"hsla(40, 95%, 90%, 0.8)","line-opacity":["interpolate",["linear"],["zoom"],17,1,18,0],"line-dasharray":["step",["zoom"],["literal",[2,0.3]],15,["literal",[1,0.3]],16,["literal",[1,0.3]],17,["literal",[1,0.25]]]}},{"id":"bridge-case-simple","type":"line","metadata":{"mapbox:featureComponent":"road-network","mapbox:group":"Road network, bridges"},"source":"composite","source-layer":"road","minzoom":13,"filter":["all",["==",["get","structure"],"bridge"],["step",["zoom"],["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","secondary","tertiary","street","street_limited","primary_link","track"],true,false],14,["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","primary_link","secondary","secondary_link","tertiary","tertiary_link","street","street_limited","service","track"],true,false]],["==",["geometry-type"],"LineString"]],"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],13,["match",["get","class"],["motorway","trunk","primary"],6,["secondary","tertiary"],4,["motorway_link","trunk_link","street","street_limited","primary_link"],2.5,1.25],18,["match",["get","class"],["motorway","trunk","primary"],36,["secondary","tertiary"],30,["motorway_link","trunk_link","street","street_limited","primary_link"],22,16],22,["match",["get","class"],["motorway","trunk","primary"],360,["secondary","tertiary"],300,["motorway_link","trunk_link","primary_link","street","street_limited"],220,160]],"line-color":"hsl(0, 0%, 14%)","line-opacity":["interpolate",["linear"],["zoom"],13,1,15,0]}},{"id":"bridge-simple","type":"line","metadata":{"mapbox:featureComponent":"road-network","mapbox:group":"Road network, bridges"},"source":"composite","source-layer":"road","minzoom":13,"filter":["all",["==",["get","structure"],"bridge"],["step",["zoom"],["match",["get","class"],["motorway","trunk"],true,false],13,["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","secondary","tertiary","street","street_limited","primary_link","track"],true,false],14,["match",["get","class"],["motorway","motorway_link","trunk","trunk_link","primary","primary_link","secondary","secondary_link","tertiary","tertiary_link","street","street_limited","service","track"],true,false]],["==",["geometry-type"],"LineString"]],"layout":{"line-cap":["step",["zoom"],"butt",14,"round"]},"paint":{"line-width":["interpolate",["exponential",1.5],["zoom"],13,["match",["get","class"],["motorway","trunk","primary"],4,["secondary","tertiary"],2.5,["motorway_link","trunk_link","street","street_limited","primary_link"],1,0.5],18,["match",["get","class"],["motorway","trunk","primary"],32,["secondary","tertiary"],26,["motorway_link","trunk_link","street","street_limited","primary_link"],18,12],22,["match",["get","class"],["motorway","trunk","primary"],320,["secondary","tertiary"],260,["motorway_link","trunk_link","primary_link","street","street_limited"],180,120]],"line-color":["match",["get","class"],["primary_link","secondary_link","tertiary_link","street","street_limited","service","track"],"hsla(0, 0%, 77%, 0.8)","hsla(0, 0%, 80%, 0.8)"],"line-opacity":["interpolate",["linear"],["zoom"],13,1,15,0]}},{"id":"aerialway","type":"line","metadata":{"mapbox:featureComponent":"transit","mapbox:group":"Transit, bridges"},"source":"composite","source-layer":"road","minzoom":12,"filter":["==",["get","class"],"aerialway"],"paint":{"line-color":"hsl(204, 100%, 80%)","line-width":["interpolate",["exponential",1.5],["zoom"],14,1,20,2],"line-dasharray":[4,1]}},{"id":"admin-2-boundary-bg","type":"line","metadata":{"mapbox:featureComponent":"admin-boundaries","mapbox:group":"Administrative boundaries, admin"},"source":"composite","source-layer":"admin","minzoom":7,"filter":["all",["==",["get","admin_level"],2],["==",["get","maritime"],"false"],["match",["get","worldview"],["all","US"],true,false]],"paint":{"line-color":"hsl(260, 45%, 0%)","line-width":["interpolate",["linear"],["zoom"],3,3,12,6],"line-opacity":["interpolate",["linear"],["zoom"],7,0,8,0.5],"line-dasharray":[1,0],"line-blur":["interpolate",["linear"],["zoom"],3,0,12,3]}},{"id":"admin-1-boundary-bg","type":"line","metadata":{"mapbox:featureComponent":"admin-boundaries","mapbox:group":"Administrative boundaries, admin"},"source":"composite","source-layer":"admin","minzoom":7,"filter":["all",["==",["get","admin_level"],1],["==",["get","maritime"],"false"],["match",["get","worldview"],["all","US"],true,false]],"paint":{"line-color":"hsl(260, 45%, 0%)","line-width":["interpolate",["linear"],["zoom"],3,3,12,6],"line-opacity":["interpolate",["linear"],["zoom"],7,0,8,0.5],"line-dasharray":[1,0],"line-blur":["interpolate",["linear"],["zoom"],3,0,12,3]}},{"id":"admin-0-boundary-bg","type":"line","metadata":{"mapbox:featureComponent":"admin-boundaries","mapbox:group":"Administrative boundaries, admin"},"source":"composite","source-layer":"admin","minzoom":1,"filter":["all",["==",["get","admin_level"],0],["==",["get","maritime"],"false"],["match",["get","worldview"],["all","US"],true,false]],"paint":{"line-width":["interpolate",["linear"],["zoom"],3,6,12,12],"line-color":"hsl(260, 45%, 0%)","line-opacity":["interpolate",["linear"],["zoom"],3,0,4,0.5],"line-blur":["interpolate",["linear"],["zoom"],3,0,12,3]}},{"id":"admin-2-boundary","type":"line","metadata":{"mapbox:featureComponent":"admin-boundaries","mapbox:group":"Administrative boundaries, admin"},"source":"composite","source-layer":"admin","minzoom":5,"filter":["all",["==",["get","admin_level"],2],["==",["get","maritime"],"false"],["match",["get","worldview"],["all","US"],true,false]],"layout":{},"paint":{"line-dasharray":["step",["zoom"],["literal",[3,2,5]],7,["literal",[2,1.5]]],"line-width":["interpolate",["linear"],["zoom"],3,0.3,12,1],"line-opacity":["interpolate",["linear"],["zoom"],5,0,6,1],"line-color":"hsl(260, 15%, 85%)"}},{"id":"admin-1-boundary","type":"line","metadata":{"mapbox:featureComponent":"admin-boundaries","mapbox:group":"Administrative boundaries, admin"},"source":"composite","source-layer":"admin","minzoom":2,"filter":["all",["==",["get","admin_level"],1],["==",["get","maritime"],"false"],["match",["get","worldview"],["all","US"],true,false]],"layout":{},"paint":{"line-dasharray":["step",["zoom"],["literal",[2,0]],7,["literal",[2,2,6,2]]],"line-width":["interpolate",["linear"],["zoom"],3,0.3,12,1.5],"line-opacity":["interpolate",["linear"],["zoom"],2,0,3,1],"line-color":"hsl(260, 15%, 85%)"}},{"id":"admin-0-boundary","type":"line","metadata":{"mapbox:featureComponent":"admin-boundaries","mapbox:group":"Administrative boundaries, admin"},"source":"composite","source-layer":"admin","minzoom":1,"filter":["all",["==",["get","admin_level"],0],["==",["get","disputed"],"false"],["==",["get","maritime"],"false"],["match",["get","worldview"],["all","US"],true,false]],"layout":{},"paint":{"line-color":"hsl(260, 15%, 80%)","line-width":["interpolate",["linear"],["zoom"],3,0.75,12,3],"line-dasharray":["step",["zoom"],["literal",[2,0]],7,["literal",[2,2,6,2]]]}},{"id":"admin-0-boundary-disputed","type":"line","metadata":{"mapbox:featureComponent":"admin-boundaries","mapbox:group":"Administrative boundaries, admin"},"source":"composite","source-layer":"admin","minzoom":1,"filter":["all",["==",["get","disputed"],"true"],["==",["get","admin_level"],0],["==",["get","maritime"],"false"],["match",["get","worldview"],["all","US"],true,false]],"paint":{"line-color":"hsl(260, 15%, 80%)","line-width":["interpolate",["linear"],["zoom"],3,0.75,12,3],"line-dasharray":["step",["zoom"],["literal",[3,2,5]],7,["literal",[2,1.5]]]}},{"id":"contour-label","type":"symbol","metadata":{"mapbox:featureComponent":"land-and-water","mapbox:group":"Land & water, terrain-labels"},"source":"composite","source-layer":"contour","minzoom":11,"filter":["all",["any",["==",["get","index"],10],["==",["get","index"],5]],true],"layout":{"text-field":["concat",["get","ele"]," m"],"symbol-placement":"line","text-pitch-alignment":"viewport","text-max-angle":25,"text-padding":5,"text-font":["DIN Pro Bold","Arial Unicode MS Bold"],"text-size":["interpolate",["linear"],["zoom"],15,9.5,20,12]},"paint":{"text-color":"hsl(0, 0%, 10%)","text-halo-width":1,"text-halo-color":"hsl(0, 0%, 20%)"}},{"id":"road-label-simple","type":"symbol","metadata":{"mapbox:featureComponent":"road-network","mapbox:group":"Road network, road-labels"},"source":"composite","source-layer":"road","minzoom":12,"filter":["all",["has","name"],["match",["get","class"],["motorway","trunk","primary","secondary","tertiary","street","street_limited"],true,false],true],"layout":{"text-size":["interpolate",["linear"],["zoom"],10,["match",["get","class"],["motorway","trunk","primary","secondary","tertiary"],11,9.9],18,["match",["get","class"],["motorway","trunk","primary","secondary","tertiary"],17.6,15.400000000000002]],"text-max-angle":30,"symbol-spacing":100,"text-font":["DIN Pro Medium","Arial Unicode MS Regular"],"symbol-placement":"line","text-padding":1,"text-rotation-alignment":"map","text-pitch-alignment":"viewport","text-field":["coalesce",["get","name_ar"],["get","name"]],"text-letter-spacing":0.01},"paint":{"text-color":"hsl(0, 0%, 100%)","text-halo-color":"hsla(0, 0%, 80%, 0.8)","text-halo-width":1}},{"id":"path-pedestrian-label","type":"symbol","metadata":{"mapbox:featureComponent":"walking-cycling","mapbox:group":"Walking, cycling, etc., walking-cycling-labels"},"source":"composite","source-layer":"road","minzoom":12,"filter":["all",["case",["has","layer"],[">=",["get","layer"],0],true],["step",["zoom"],["match",["get","class"],["pedestrian"],true,false],15,["match",["get","class"],["path","pedestrian"],true,false]],true],"layout":{"text-size":["interpolate",["linear"],["zoom"],10,["match",["get","class"],"pedestrian",9.9,7.15],18,["match",["get","class"],"pedestrian",15.400000000000002,14.3]],"text-max-angle":30,"text-font":["DIN Pro Medium","Arial Unicode MS Regular"],"symbol-placement":"line","text-padding":1,"text-rotation-alignment":"map","text-pitch-alignment":"viewport","text-field":["coalesce",["get","name_ar"],["get","name"]],"text-letter-spacing":0.01},"paint":{"text-color":"hsl(0, 0%, 100%)","text-halo-color":"hsl(0, 5%, 0%)","text-halo-width":1,"text-halo-blur":1}},{"id":"ferry-aerialway-label","type":"symbol","metadata":{"mapbox:featureComponent":"transit","mapbox:group":"Transit, ferry-aerialway-labels"},"source":"composite","source-layer":"road","minzoom":15,"filter":["all",["match",["get","class"],"aerialway",true,false],true],"layout":{"text-size":["interpolate",["linear"],["zoom"],10,7.15,18,14.3],"text-max-angle":30,"text-font":["DIN Pro Medium","Arial Unicode MS Regular"],"symbol-placement":"line","text-padding":1,"text-rotation-alignment":"map","text-pitch-alignment":"viewport","text-field":["coalesce",["get","name_ar"],["get","name"]],"text-letter-spacing":0.01},"paint":{"text-color":["match",["get","class"],"ferry","hsl(240, 68%, 94%)","hsl(204, 100%, 80%)"],"text-halo-color":["match",["get","class"],"ferry","hsl(240, 100%, 62%)","hsl(0, 0%, 10%)"],"text-halo-width":1,"text-halo-blur":1}},{"id":"waterway-label","type":"symbol","metadata":{"mapbox:featureComponent":"natural-features","mapbox:group":"Natural features, natural-labels"},"source":"composite","source-layer":"natural_label","minzoom":13,"filter":["all",["match",["get","class"],["canal","river","stream","disputed_canal","disputed_river","disputed_stream"],["match",["get","worldview"],["all","US"],true,false],false],true,["==",["geometry-type"],"LineString"]],"layout":{"text-font":["DIN Pro Italic","Arial Unicode MS Regular"],"text-max-angle":30,"symbol-spacing":["interpolate",["linear",1],["zoom"],15,250,17,400],"text-size":["interpolate",["linear"],["zoom"],13,12,18,18],"symbol-placement":"line","text-pitch-alignment":"viewport","text-field":["coalesce",["get","name_ar"],["get","name"]]},"paint":{"text-color":"hsl(240, 68%, 90%)","text-halo-color":"hsla(0, 0%, 0%, 0.5)","text-halo-width":1,"text-halo-blur":1}},{"id":"natural-line-label","type":"symbol","metadata":{"mapbox:featureComponent":"natural-features","mapbox:group":"Natural features, natural-labels"},"source":"composite","source-layer":"natural_label","minzoom":4,"filter":["all",["match",["get","class"],["glacier","landform","disputed_glacier","disputed_landform"],["match",["get","worldview"],["all","US"],true,false],false],["<=",["get","filterrank"],2],true,["==",["geometry-type"],"LineString"]],"layout":{"text-size":["step",["zoom"],["step",["get","sizerank"],18,5,12],17,["step",["get","sizerank"],18,13,12]],"text-max-angle":30,"text-field":["coalesce",["get","name_ar"],["get","name"]],"text-font":["DIN Pro Bold","Arial Unicode MS Bold"],"symbol-placement":"line-center","text-pitch-alignment":"viewport"},"paint":{"text-halo-width":0.5,"text-halo-color":"hsl(0, 0%, 0%)","text-halo-blur":0.5,"text-color":"hsl(0, 0%, 100%)"}},{"id":"natural-point-label","type":"symbol","metadata":{"mapbox:featureComponent":"natural-features","mapbox:group":"Natural features, natural-labels"},"source":"composite","source-layer":"natural_label","minzoom":4,"filter":["all",["match",["get","class"],["dock","glacier","landform","water_feature","wetland","disputed_dock","disputed_glacier","disputed_landform","disputed_water_feature","disputed_wetland"],["match",["get","worldview"],["all","US"],true,false],false],["<=",["get","filterrank"],2],true,["==",["geometry-type"],"Point"]],"layout":{"text-size":["step",["zoom"],["step",["get","sizerank"],18,5,12],17,["step",["get","sizerank"],18,13,12]],"icon-image":["case",["has","maki_beta"],["coalesce",["image",["get","maki_beta"]],["image",["get","maki"]]],["image",["get","maki"]]],"text-font":["DIN Pro Bold","Arial Unicode MS Bold"],"text-offset":["step",["zoom"],["step",["get","sizerank"],["literal",[0,0]],5,["literal",[0,0.55]]],17,["step",["get","sizerank"],["literal",[0,0]],13,["literal",[0,0.6000000000000001]]]],"text-anchor":["step",["zoom"],["step",["get","sizerank"],"center",5,"top"],17,["step",["get","sizerank"],"center",13,"top"]],"text-field":["coalesce",["get","name_ar"],["get","name"]]},"paint":{"icon-opacity":["step",["zoom"],["step",["get","sizerank"],0,5,1],17,["step",["get","sizerank"],0,13,1]],"text-halo-color":"hsl(0, 0%, 10%)","text-halo-width":0.5,"text-halo-blur":0.5,"text-color":"hsl(0, 0%, 100%)"}},{"id":"water-line-label","type":"symbol","metadata":{"mapbox:featureComponent":"natural-features","mapbox:group":"Natural features, natural-labels"},"source":"composite","source-layer":"natural_label","minzoom":1,"filter":["all",["match",["get","class"],["bay","ocean","reservoir","sea","water","disputed_bay","disputed_ocean","disputed_reservoir","disputed_sea","disputed_water"],["match",["get","worldview"],["all","US"],true,false],false],true,["==",["geometry-type"],"LineString"]],"layout":{"text-size":["interpolate",["linear"],["zoom"],0,["*",["-",16,["sqrt",["get","sizerank"]]],1],22,["*",["-",22,["sqrt",["get","sizerank"]]],1]],"text-max-angle":30,"text-letter-spacing":["match",["get","class"],"ocean",0.25,["sea","bay"],0.15,0],"text-font":["DIN Pro Italic","Arial Unicode MS Regular"],"symbol-placement":"line-center","text-pitch-alignment":"viewport","text-field":["coalesce",["get","name_ar"],["get","name"]]},"paint":{"text-color":["match",["get","class"],["bay","ocean","sea"],"hsl(240, 96%, 82%)","hsl(240, 68%, 90%)"],"text-halo-color":"hsla(0, 0%, 0%, 0.5)","text-halo-width":1,"text-halo-blur":1}},{"id":"water-point-label","type":"symbol","metadata":{"mapbox:featureComponent":"natural-features","mapbox:group":"Natural features, natural-labels"},"source":"composite","source-layer":"natural_label","minzoom":1,"filter":["all",["match",["get","class"],["bay","ocean","reservoir","sea","water","disputed_bay","disputed_ocean","disputed_reservoir","disputed_sea","disputed_water"],["match",["get","worldview"],["all","US"],true,false],false],true,["==",["geometry-type"],"Point"]],"layout":{"text-line-height":1.3,"text-size":["interpolate",["linear"],["zoom"],0,["*",["-",16,["sqrt",["get","sizerank"]]],1],22,["*",["-",22,["sqrt",["get","sizerank"]]],1]],"text-font":["DIN Pro Italic","Arial Unicode MS Regular"],"text-field":["coalesce",["get","name_ar"],["get","name"]],"text-letter-spacing":["match",["get","class"],"ocean",0.25,["bay","sea"],0.15,0.01],"text-max-width":["match",["get","class"],"ocean",4,"sea",5,["bay","water"],7,10]},"paint":{"text-color":["match",["get","class"],["bay","ocean","sea"],"hsl(240, 96%, 82%)","hsl(240, 68%, 90%)"],"text-halo-color":"hsla(0, 0%, 0%, 0.5)","text-halo-width":1,"text-halo-blur":1}},{"id":"poi-label","type":"symbol","metadata":{"mapbox:featureComponent":"point-of-interest-labels","mapbox:group":"Point of interest labels, poi-labels"},"source":"composite","source-layer":"poi_label","minzoom":6,"filter":["all",["<=",["get","filterrank"],["+",["step",["zoom"],0,16,1,17,2],3]],true],"layout":{"text-size":["step",["zoom"],["step",["get","sizerank"],18,5,12],17,["step",["get","sizerank"],18,13,12]],"icon-image":["case",["has","maki_beta"],["coalesce",["image",["get","maki_beta"]],["image",["get","maki"]]],["image",["get","maki"]]],"text-font":["DIN Pro Bold","Arial Unicode MS Bold"],"text-offset":["step",["zoom"],["step",["get","sizerank"],["literal",[0,0]],5,["literal",[0,0.8]]],17,["step",["get","sizerank"],["literal",[0,0]],13,["literal",[0,0.8]]]],"text-anchor":["step",["zoom"],["step",["get","sizerank"],"center",5,"top"],17,["step",["get","sizerank"],"center",13,"top"]],"text-field":["coalesce",["get","name_ar"],["get","name"]]},"paint":{"icon-opacity":["step",["zoom"],["step",["get","sizerank"],0,5,1],17,["step",["get","sizerank"],0,13,1]],"text-halo-color":"hsl(0, 0%, 10%)","text-halo-width":0.5,"text-halo-blur":0.5,"text-color":["match",["get","class"],"park_like","hsl(110, 100%, 85%)","education","hsl(30, 100%, 85%)","medical","hsl(0, 100%, 85%)","hsl(0, 0%, 100%)"]}},{"id":"transit-label","type":"symbol","metadata":{"mapbox:featureComponent":"transit","mapbox:group":"Transit, transit-labels"},"source":"composite","source-layer":"transit_stop_label","minzoom":12,"filter":["all",["step",["zoom"],["all",["<=",["get","filterrank"],4],["match",["get","mode"],"rail",true,"metro_rail",true,false],["!=",["get","stop_type"],"entrance"]],14,["all",["match",["get","mode"],"rail",true,"metro_rail",true,false],["!=",["get","stop_type"],"entrance"]],15,["all",["match",["get","mode"],"rail",true,"metro_rail",true,"light_rail",true,false],["!=",["get","stop_type"],"entrance"]],16,["all",["match",["get","mode"],"ferry",false,"bus",false,true],["!=",["get","stop_type"],"entrance"]],17,["all",["match",["get","mode"],"ferry",false,true],["!=",["get","stop_type"],"entrance"]],19,["match",["get","mode"],"ferry",false,true]],true],"layout":{"text-size":12,"icon-image":["get","network"],"text-font":["DIN Pro Bold","Arial Unicode MS Bold"],"text-justify":["match",["get","stop_type"],"entrance","left","center"],"text-offset":["match",["get","stop_type"],"entrance",["literal",[1,0]],["literal",[0,0.8]]],"text-anchor":["match",["get","stop_type"],"entrance","left","top"],"text-field":["step",["zoom"],"",13,["match",["get","mode"],["rail","metro_rail"],["coalesce",["get","name_ar"],["get","name"]],""],14,["match",["get","mode"],["bus","bicycle"],"",["coalesce",["get","name_ar"],["get","name"]]],18,["coalesce",["get","name_ar"],["get","name"]]],"text-letter-spacing":0.01,"text-max-width":["match",["get","stop_type"],"entrance",15,9]},"paint":{"text-halo-color":"hsl(0, 0%, 10%)","text-color":"hsl(204, 100%, 80%)","text-halo-blur":0.5,"text-halo-width":0.5}},{"id":"airport-label","type":"symbol","metadata":{"mapbox:featureComponent":"transit","mapbox:group":"Transit, transit-labels"},"source":"composite","source-layer":"airport_label","minzoom":8,"filter":["all",["match",["get","class"],["military","civil","disputed_military","disputed_civil"],["match",["get","worldview"],["all","US"],true,false],false],true],"layout":{"text-line-height":1.1,"text-size":["step",["get","sizerank"],18,9,12],"icon-image":["get","maki"],"text-font":["DIN Pro Bold","Arial Unicode MS Bold"],"text-offset":[0,0.8],"text-rotation-alignment":"viewport","text-anchor":"top","text-field":["step",["get","sizerank"],["case",["has","ref"],["concat",["get","ref"]," -\n",["coalesce",["get","name_ar"],["get","name"]]],["coalesce",["get","name_ar"],["get","name"]]],15,["get","ref"]],"text-letter-spacing":0.01,"text-max-width":9},"paint":{"text-color":"hsl(0, 0%, 100%)","text-halo-color":"hsl(0, 0%, 10%)","text-halo-width":1}},{"id":"settlement-subdivision-label","type":"symbol","metadata":{"mapbox:featureComponent":"place-labels","mapbox:group":"Place labels, place-labels"},"source":"composite","source-layer":"place_label","minzoom":10,"maxzoom":15,"filter":["all",["match",["get","class"],["settlement_subdivision","disputed_settlement_subdivision"],["match",["get","worldview"],["all","US"],true,false],false],["<=",["get","filterrank"],4],true],"layout":{"text-field":["coalesce",["get","name_ar"],["get","name"]],"text-transform":"uppercase","text-font":["DIN Pro Medium","Arial Unicode MS Regular"],"text-letter-spacing":["match",["get","type"],"suburb",0.15,0.05],"text-max-width":7,"text-padding":3,"text-size":["interpolate",["cubic-bezier",0.5,0,1,1],["zoom"],11,["match",["get","type"],"suburb",12.100000000000001,11.55],15,["match",["get","type"],"suburb",16.5,15.400000000000002]]},"paint":{"text-halo-color":"hsla(0, 5%, 0%, 0.75)","text-halo-width":1,"text-color":"hsl(0, 0%, 100%)","text-halo-blur":0.5}},{"id":"settlement-minor-label","type":"symbol","metadata":{"mapbox:featureComponent":"place-labels","mapbox:group":"Place labels, place-labels"},"source":"composite","source-layer":"place_label","minzoom":2,"maxzoom":13,"filter":["all",["<=",["get","filterrank"],3],["match",["get","class"],["settlement","disputed_settlement"],["match",["get","worldview"],["all","US"],true,false],false],["step",["zoom"],[">",["get","symbolrank"],6],4,[">=",["get","symbolrank"],7],6,[">=",["get","symbolrank"],8],7,[">=",["get","symbolrank"],10],10,[">=",["get","symbolrank"],11],11,[">=",["get","symbolrank"],13],12,[">=",["get","symbolrank"],15]],true],"layout":{"text-line-height":1.1,"text-size":["interpolate",["cubic-bezier",0.2,0,0.9,1],["zoom"],3,["step",["get","symbolrank"],12.100000000000001,9,11],6,["step",["get","symbolrank"],15.400000000000002,9,13.200000000000001,12,11],8,["step",["get","symbolrank"],17.6,9,15.400000000000002,12,13.200000000000001,15,11],13,["step",["get","symbolrank"],24.200000000000003,9,22,12,17.6,15,15.400000000000002]],"text-radial-offset":["step",["zoom"],["match",["get","capital"],2,0.6,0.55],8,0],"symbol-sort-key":["get","symbolrank"],"icon-image":["step",["zoom"],["case",["==",["get","capital"],2],"border-dot-13",["step",["get","symbolrank"],"dot-11",9,"dot-10",11,"dot-9"]],8,""],"text-font":["DIN Pro Medium","Arial Unicode MS Regular"],"text-justify":"auto","text-anchor":["step",["zoom"],["get","text_anchor"],8,"center"],"text-field":["coalesce",["get","name_ar"],["get","name"]],"text-max-width":7},"paint":{"text-color":"hsl(0, 0%, 95%)","text-halo-color":"hsl(0, 5%, 0%)","text-halo-width":1,"text-halo-blur":1}},{"id":"settlement-major-label","type":"symbol","metadata":{"mapbox:featureComponent":"place-labels","mapbox:group":"Place labels, place-labels"},"source":"composite","source-layer":"place_label","minzoom":2,"maxzoom":15,"filter":["all",["<=",["get","filterrank"],3],["match",["get","class"],["settlement","disputed_settlement"],["match",["get","worldview"],["all","US"],true,false],false],["step",["zoom"],false,2,["<=",["get","symbolrank"],6],4,["<",["get","symbolrank"],7],6,["<",["get","symbolrank"],8],7,["<",["get","symbolrank"],10],10,["<",["get","symbolrank"],11],11,["<",["get","symbolrank"],13],12,["<",["get","symbolrank"],15],13,[">=",["get","symbolrank"],11],14,[">=",["get","symbolrank"],15]],true],"layout":{"text-line-height":1.1,"text-size":["interpolate",["cubic-bezier",0.2,0,0.9,1],["zoom"],3,["step",["get","symbolrank"],14.3,6,12.100000000000001],6,["step",["get","symbolrank"],19.8,6,17.6,7,15.400000000000002],8,["step",["get","symbolrank"],22,9,17.6,10,15.400000000000002],15,["step",["get","symbolrank"],26.400000000000002,9,22,12,17.6,15,15.400000000000002]],"text-radial-offset":["step",["zoom"],["match",["get","capital"],2,0.6,0.55],8,0],"symbol-sort-key":["get","symbolrank"],"icon-image":["step",["zoom"],["case",["==",["get","capital"],2],"border-dot-13",["step",["get","symbolrank"],"dot-11",9,"dot-10",11,"dot-9"]],8,""],"text-font":["DIN Pro Medium","Arial Unicode MS Regular"],"text-justify":["step",["zoom"],["match",["get","text_anchor"],["left","bottom-left","top-left"],"left",["right","bottom-right","top-right"],"right","center"],8,"center"],"text-anchor":["step",["zoom"],["get","text_anchor"],8,"center"],"text-field":["coalesce",["get","name_ar"],["get","name"]],"text-max-width":7},"paint":{"text-color":"hsl(0, 0%, 95%)","text-halo-color":"hsl(0, 5%, 0%)","text-halo-width":1,"text-halo-blur":1}},{"id":"state-label","type":"symbol","metadata":{"mapbox:featureComponent":"place-labels","mapbox:group":"Place labels, place-labels"},"source":"composite","source-layer":"place_label","minzoom":3,"maxzoom":9,"filter":["all",["match",["get","class"],["state","disputed_state"],["match",["get","worldview"],["all","US"],true,false],false],true],"layout":{"text-size":["interpolate",["cubic-bezier",0.85,0.7,0.65,1],["zoom"],4,["step",["get","symbolrank"],9.9,6,8.8,7,7.700000000000001],9,["step",["get","symbolrank"],23.1,6,17.6,7,15.400000000000002]],"text-transform":"uppercase","text-font":["DIN Pro Bold","Arial Unicode MS Bold"],"text-field":["coalesce",["get","name_ar"],["get","name"]],"text-letter-spacing":0.15,"text-max-width":6},"paint":{"text-color":"hsl(0, 0%, 95%)","text-halo-color":"hsl(0, 5%, 0%)","text-halo-width":1,"text-opacity":0.5}},{"id":"country-label","type":"symbol","metadata":{"mapbox:featureComponent":"place-labels","mapbox:group":"Place labels, place-labels"},"source":"composite","source-layer":"place_label","minzoom":1,"maxzoom":10,"filter":["all",["match",["get","class"],["country","disputed_country"],["match",["get","worldview"],["all","US"],true,false],false],true],"layout":{"icon-image":"","text-field":["coalesce",["case",["==",["get","name_ar"],"إسرائيل"],"فلسطين",["get","name_ar"]],["get","name"]],"text-line-height":1.1,"text-max-width":6,"text-font":["DIN Pro Medium","Arial Unicode MS Regular"],"text-radial-offset":["step",["zoom"],0.6,8,0],"text-justify":["step",["zoom"],["match",["get","text_anchor"],["left","bottom-left","top-left"],"left",["right","bottom-right","top-right"],"right","center"],7,"auto"],"text-size":["interpolate",["cubic-bezier",0.2,0,0.7,1],["zoom"],1,["step",["get","symbolrank"],12.100000000000001,4,9.9,5,8.8],9,["step",["get","symbolrank"],24.200000000000003,4,20.900000000000002,5,18.700000000000003]]},"paint":{"icon-opacity":["step",["zoom"],["case",["has","text_anchor"],1,0],7,0],"text-color":"hsl(0, 0%, 95%)","text-halo-color":["interpolate",["linear"],["zoom"],2,"hsla(0, 5%, 0%, 0.75)",3,"hsl(0, 5%, 0%)"],"text-halo-width":1.25}},{"id":"continent-label","type":"symbol","metadata":{"mapbox:featureComponent":"place-labels","mapbox:group":"Place labels, place-labels"},"source":"composite","source-layer":"natural_label","minzoom":0.75,"maxzoom":3,"filter":["==",["get","class"],"continent"],"layout":{"text-field":["coalesce",["get","name_ar"],["get","name"]],"text-line-height":1.1,"text-max-width":6,"text-font":["DIN Pro Medium","Arial Unicode MS Regular"],"text-size":["interpolate",["exponential",0.5],["zoom"],0,11,2.5,16.5],"text-transform":"uppercase","text-letter-spacing":0.05},"paint":{"text-color":"hsl(0, 0%, 95%)","text-halo-color":["interpolate",["linear"],["zoom"],0,"hsla(0, 5%, 0%, 0.75)",3,"hsl(0, 5%, 0%)"],"text-halo-width":1.5,"text-opacity":["interpolate",["linear"],["zoom"],0,0.8,1.5,0.5,2.5,0]}},{"id":"red","type":"fill","source":"composite","source-layer":"red","layout":{},"paint":{"fill-color":"rgba(87, 173, 234, 0.73)"}},{"id":"sea-1-77hgzg","type":"fill","source":"composite","source-layer":"SEA_1-77hgzg","paint":{"fill-color":"#0073a8"}}],"id":"clpib93y500lx01r51fmcfk30"};

// ---------------------------------------------------------------------------
// Mapbox Access Token & Style Transformer for Vector Overlays
// ---------------------------------------------------------------------------
const MAPBOX_TOKEN = 'sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA';

function sanitizeExpr(val) {
  if (Array.isArray(val)) {
    if (val[0] === 'step' && Array.isArray(val[1]) && val[1][0] === 'pitch') return true;
    if (val[0] === 'pitch' || val[0] === 'distance-from-center' || val[0] === 'measure-light') return true;
    return val.map(sanitizeExpr);
  }
  if (typeof val === 'object' && val !== null) {
    const res = {};
    for (const k in val) {
      res[k] = sanitizeExpr(val[k]);
    }
    return res;
  }
  return val;
}

function transformMapboxStyle(styleInput) {
  let styleObj = styleInput;
  if (typeof styleObj === 'string') {
    try {
      styleObj = JSON.parse(styleObj);
    } catch (e) {
      console.warn('[Globe] Failed to parse style JSON:', e);
      return DEFAULT_ARABIC_GLOBE_STYLE;
    }
  }
  if (!styleObj || !styleObj.version) {
    return DEFAULT_ARABIC_GLOBE_STYLE;
  }

  let style;
  try {
    style = JSON.parse(JSON.stringify(styleObj));
  } catch (_) {
    style = styleObj;
  }

  // Transform sources so MapLibre can load Mapbox vector and raster tiles directly
  style.sources = style.sources || {};
  Object.keys(style.sources).forEach(key => {
    const src = style.sources[key];
    if (!src) return;

    if (src.type === 'raster') {
      const isMapboxSat = (src.url && src.url.includes('mapbox.satellite')) ||
        key.includes('mapbox.satellite') ||
        (src.tiles && src.tiles.some(t => t.includes('mapbox.satellite')));
      if (isMapboxSat) {
        delete src.url;
        src.tiles = ['https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}.webp?access_token=' + MAPBOX_TOKEN];
        src.tileSize = 256;
      } else if (!src.tiles) {
        delete src.url;
        src.tiles = [
          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
        ];
        src.tileSize = 256;
      }
    } else if (src.type === 'raster-dem') {
      if (src.url && src.url.startsWith('mapbox://')) {
        const demId = src.url.replace('mapbox://', '');
        delete src.url;
        src.tiles = ['https://api.mapbox.com/v4/' + demId + '/{z}/{x}/{y}.webp?access_token=' + MAPBOX_TOKEN];
        src.encoding = 'mapbox';
      }
    } else if (src.type === 'vector') {
      if (src.url && src.url.startsWith('mapbox://')) {
        const tileset = src.url.replace('mapbox://', '');
        delete src.url;
        src.tiles = ['https://api.mapbox.com/v4/' + tileset + '/{z}/{x}/{y}.vector.pbf?access_token=' + MAPBOX_TOKEN];
      }
    }
  });

  // Clean layers and sanitize Mapbox v3 unsupported expressions (e.g. pitch culling)
  if (Array.isArray(style.layers)) {
    // Strip out baked-in vector symbols for Materials so Gold, Nickel, Zinc, etc. are never displayed by default
    style.layers = style.layers.filter(layer => {
      if (layer.id === 'symbols') return false;
      if (layer['source-layer'] === 'Materials') return false;
      if (layer.source === 'esri-labels') return false;
      if (layer.id === 'labels' && layer.type === 'raster') return false;
      return true;
    });

    style.layers.forEach((layer, idx) => {
      delete layer.slot;
      if (layer.filter) {
        layer.filter = sanitizeExpr(layer.filter);
      }
      if (layer.paint) {
        layer.paint = sanitizeExpr(layer.paint);
      }
      if (layer.layout) {
        layer.layout = sanitizeExpr(layer.layout);
        // Enforce Arabic language across all map layers
        if (layer.layout['text-field']) {
          const tf = layer.layout['text-field'];
          if (typeof tf === 'string') {
            if (tf === '{name}' || tf === '{name_en}') {
              layer.layout['text-field'] = '{name_ar}';
            }
          } else if (Array.isArray(tf)) {
            if (tf[0] === 'get' && (tf[1] === 'name' || tf[1] === 'name_en')) {
              layer.layout['text-field'] = ['coalesce', ['get', 'name_ar'], ['get', 'name']];
            }
          }
        }
      }
    });
  }

  // Remove Mapbox v3 specific top-level fields not supported by MapLibre
  delete style.lights;
  delete style.projection;
  delete style.draft;
  delete style.visibility;
  delete style.protected;
  delete style.created;
  delete style.modified;
  delete style.owner;
  delete style.terrain;
  delete style.fog;

  // Transform glyphs
  if (style.glyphs && style.glyphs.startsWith('mapbox://fonts/')) {
    style.glyphs = 'https://api.mapbox.com/fonts/v1/' + style.glyphs.replace('mapbox://fonts/', '') + '?access_token=' + MAPBOX_TOKEN;
  }

  // Transform sprite
  if (style.sprite && style.sprite.startsWith('mapbox://sprites/')) {
    style.sprite = 'https://api.mapbox.com/styles/v1/' + style.sprite.replace('mapbox://sprites/', '') + '/sprite?access_token=' + MAPBOX_TOKEN;
  }

  return style;
}

// ---------------------------------------------------------------------------
// Resolve Flutter Web asset path  (Flutter dev server doubles the "assets/" prefix)
// Input:  "assets/assets/images/x.png"  → "assets/assets/images/x.png"
// Input:  "assets/images/x.png"         → "assets/assets/images/x.png"
// Input:  "images/x.png"                → "assets/assets/images/x.png"
// ---------------------------------------------------------------------------
function resolveAssetUrl(url) {
  if (!url) return '';
  if (/^(https?:|data:|blob:)/.test(url)) return url;
  let clean = url.replace(/^\.?\//, '');
  if (clean.startsWith('assets/assets/')) return clean;
  if (clean.startsWith('assets/')) return 'assets/' + clean;
  return 'assets/assets/' + clean;
}

// ---------------------------------------------------------------------------
// Internal: actually add a single marker to a ready map
// ---------------------------------------------------------------------------
function _doAddMarker(map, viewId, lng, lat, iconUrl, markerId, callbackName) {
  const SIZE = 38;
  const resolvedUrl = resolveAssetUrl(iconUrl);

  // MapLibre's Marker attaches translate(X, Y) to `el`. We must NEVER modify `el.style.transform`.
  const el = document.createElement('div');
  el.className = 'mapbox-custom-marker';
  el.setAttribute('data-marker-id', markerId);
  el.style.cssText = 'pointer-events:auto;cursor:pointer;user-select:none;-webkit-user-select:none;';

  // Inner container for styling, shadow, and scale animations
  const inner = document.createElement('div');
  inner.style.cssText =
    `width:${SIZE}px;height:${SIZE}px;` +
    'display:flex;align-items:center;justify-content:center;' +
    'filter:drop-shadow(0 3px 8px rgba(0,0,0,.65));' +
    'transition:transform .15s ease;pointer-events:auto;';

  inner.onmouseenter = () => { inner.style.transform = 'scale(1.25)'; };
  inner.onmouseleave = () => { inner.style.transform = 'scale(1.0)'; };

  const img = document.createElement('img');
  img.style.cssText = 'width:100%;height:100%;object-fit:contain;display:block;pointer-events:none;';
  img.src = resolvedUrl;

  // Resilient fallback chain: resolved → raw → assets/raw → dot
  const fallbacks = [iconUrl, 'assets/' + iconUrl, 'assets/assets/' + iconUrl];
  let fbIdx = 0;
  img.onerror = function () {
    if (fbIdx < fallbacks.length) {
      const next = fallbacks[fbIdx++];
      if (next !== this.src) { this.src = next; return; }
      fbIdx++;
      if (fbIdx <= fallbacks.length) { this.src = fallbacks[fbIdx - 1]; return; }
    }
    // Gold dot fallback
    inner.innerHTML =
      '<div style="width:22px;height:22px;background:#D4AF37;border:2px solid #fff;' +
      'border-radius:50%;box-shadow:0 0 10px rgba(212,175,55,.9);"></div>';
  };

  inner.appendChild(img);
  el.appendChild(inner);

  // ── Click (mouse) ──────────────────────────────────────────────────────────
  el.addEventListener('click', e => {
    e.stopPropagation();
    if (window[callbackName]) window[callbackName](markerId);
  });

  // ── Touch (mobile / tablet) ────────────────────────────────────────────────
  let touchMoved = false;
  let startX = 0, startY = 0;

  el.addEventListener('touchstart', e => {
    touchMoved = false;
    if (e.touches.length > 0) {
      startX = e.touches[0].clientX;
      startY = e.touches[0].clientY;
    }
    inner.style.transform = 'scale(1.25)';
  }, { passive: true });

  el.addEventListener('touchmove', e => {
    if (e.touches.length > 0) {
      const dx = Math.abs(e.touches[0].clientX - startX);
      const dy = Math.abs(e.touches[0].clientY - startY);
      if (dx > 8 || dy > 8) {
        touchMoved = true;
      }
    }
  }, { passive: true });

  el.addEventListener('touchend', e => {
    inner.style.transform = 'scale(1.0)';
    if (!touchMoved) {
      e.stopPropagation();
      if (window[callbackName]) window[callbackName](markerId);
    }
  });

  el.addEventListener('touchcancel', () => {
    inner.style.transform = 'scale(1.0)';
  });

  try {
    // anchor:'center' = the element's center sits exactly on [lng,lat]
    const marker = new maplibregl.Marker({ element: el, anchor: 'center' })
      .setLngLat([lng, lat])
      .addTo(map);

    window.mapboxGlobeMarkers[viewId] = window.mapboxGlobeMarkers[viewId] || [];
    window.mapboxGlobeMarkers[viewId].push(marker);
  } catch (e) {
    console.warn('[Globe] addMarker error:', e);
  }
}

// ---------------------------------------------------------------------------
// Disable GPU PBO readback error measurement loop on globe projection
// MapLibre's ProjectionErrorMeasurement runs a GPU readback loop every 6 frames
// which triggers ANGLE buffer fence warnings & "WebGL: too many errors" in Chromium.
// ---------------------------------------------------------------------------
function disableGlobeReadbackErrorMeasurement(map) {
  try {
    const proj = map && map.style && map.style.projection;
    const vp = proj && (proj._verticalPerspectiveProjection ||
      (proj.currentProjection && proj.currentProjection.name === 'vertical-perspective' ? proj.currentProjection : null));
    if (vp) {
      if (vp._errorMeasurement) {
        try { vp._errorMeasurement.destroy(); } catch (_) { }
        vp._errorMeasurement = null;
      }
      vp.updateGPUdependent = function () { };
      const proto = Object.getPrototypeOf(vp);
      if (proto && proto.updateGPUdependent) {
        proto.updateGPUdependent = function () { };
      }
    }
  } catch (_) { }
}

// ---------------------------------------------------------------------------
// Accessibility: prevent canvas from retaining focus inside Flutter platform views
// ---------------------------------------------------------------------------
function setupCanvasA11y(map, targetContainer) {
  const canvas = map && map.getCanvas && map.getCanvas();
  if (canvas) {
    canvas.removeAttribute('tabindex');
    try {
      Object.defineProperty(canvas, 'tabIndex', {
        get: () => -1,
        set: () => { },
        configurable: true
      });
    } catch (_) {
      canvas.tabIndex = -1;
    }
    canvas.addEventListener('focus', () => {
      try { canvas.blur(); } catch (_) { }
      if (document.activeElement === canvas && document.body) {
        document.body.focus();
      }
    }, true);
    canvas.addEventListener('pointerdown', () => {
      if (document.activeElement === canvas) {
        try { canvas.blur(); } catch (_) { }
      }
    }, true);
  }
  if (targetContainer) {
    targetContainer.removeAttribute('tabindex');
    targetContainer.tabIndex = -1;
  }
}

// ---------------------------------------------------------------------------
// Marker Icons: Provide immediate crisp fallback marker image for MapLibre
// ---------------------------------------------------------------------------
function createMarkerImageData() {
  const width = 24;
  const height = 36;
  const canvas = document.createElement('canvas');
  canvas.width = width;
  canvas.height = height;
  const ctx = canvas.getContext('2d');

  ctx.save();
  ctx.beginPath();
  ctx.arc(12, 12, 10, Math.PI, 0, false);
  ctx.bezierCurveTo(22, 18, 12, 34, 12, 34);
  ctx.bezierCurveTo(12, 34, 2, 18, 2, 12);
  ctx.closePath();
  ctx.fillStyle = '#C89D3C'; // Gold
  ctx.fill();
  ctx.lineWidth = 1.5;
  ctx.strokeStyle = '#FFFFFF';
  ctx.stroke();

  ctx.beginPath();
  ctx.arc(12, 12, 4, 0, 2 * Math.PI);
  ctx.fillStyle = '#FFFFFF';
  ctx.fill();
  ctx.restore();

  const imgData = ctx.getImageData(0, 0, width, height);
  return {
    width: width,
    height: height,
    data: imgData.data
  };
}

function registerDefaultMarkerImages(map) {
  if (!map) return;
  const defaultIds = ['marker', 'default-marker', 'pin', 'marker-15'];
  defaultIds.forEach(id => {
    try {
      if (!map.hasImage(id)) {
        map.addImage(id, createMarkerImageData(), { pixelRatio: 2 });
      }
    } catch (_) { }
  });
}

// ---------------------------------------------------------------------------
// initMapboxGlobeWeb
//   viewId       – the DOM id of the container element (domId from Dart)
//   containerEl  – the actual HTMLElement (passed from Dart via js interop)
//   lng, lat, zoom – initial camera
// ---------------------------------------------------------------------------
window.initMapboxGlobeWeb = function (viewId, containerEl, initialLng, initialLat, initialZoom, initialStyleJson) {
  let lng = initialLng, lat = initialLat, zoom = initialZoom;
  let targetContainer = null;

  if (containerEl && (typeof HTMLElement !== 'undefined') &&
    (containerEl instanceof HTMLElement || containerEl.nodeType === 1)) {
    targetContainer = containerEl;
  } else if (typeof containerEl === 'number') {
    // Old 5-arg call (no containerEl)
    lng = containerEl; lat = initialLng; zoom = initialLat;
  }

  // Also accept the div by ID immediately (sometimes JS receives it before Dart interop resolves)
  if (!targetContainer) {
    targetContainer = document.getElementById(viewId);
  }

  let attempts = 0;
  function tryInit() {
    if (++attempts > 80) {
      console.warn('[Globe] Giving up on container', viewId);
      return;
    }
    if (targetContainer && !targetContainer.isConnected) {
      targetContainer = null;
    }
    if (!targetContainer) {
      targetContainer = document.getElementById(viewId);
    }
    // Deep shadow-DOM search as last resort
    if (!targetContainer || !targetContainer.isConnected) {
      const all = document.querySelectorAll('*');
      for (let i = 0; i < all.length; i++) {
        if (all[i].id === viewId && all[i].isConnected) { targetContainer = all[i]; break; }
        if (all[i].shadowRoot) {
          const hit = all[i].shadowRoot.querySelector('[id="' + viewId + '"]');
          if (hit && hit.isConnected) { targetContainer = hit; break; }
        }
      }
    }

    if (!targetContainer || !targetContainer.isConnected || typeof maplibregl === 'undefined') {
      return setTimeout(tryInit, 80);
    }

    ensureRTLTextPlugin();

    // Style container to fill its slot
    Object.assign(targetContainer.style, {
      width: '100%', height: '100%',
      position: 'absolute', top: '0', left: '0', right: '0', bottom: '0',
      overflow: 'hidden', backgroundColor: '#0b0b19'
    });

    // Destroy existing instance
    if (window.mapboxGlobeInstances[viewId]) {
      try { window.mapboxGlobeInstances[viewId].remove(); } catch (_) { }
      delete window.mapboxGlobeInstances[viewId];
    }

    const activeStyle = initialStyleJson ? transformMapboxStyle(initialStyleJson) : DEFAULT_ARABIC_GLOBE_STYLE;

    const map = new maplibregl.Map({
      container: targetContainer,
      style: activeStyle,
      center: [lng || 47.189224, lat || 24.694291],
      zoom: zoom || 3.8,
      renderWorldCopies: false,
      attributionControl: false,
      doubleClickZoom: false
    });
    map._styleIsLoading = true;
    window.mapboxGlobeInstances[viewId] = map;

    try { map.doubleClickZoom.disable(); } catch (_) { }
    try { map.keyboard.disable(); } catch (_) { }

    setupCanvasA11y(map, targetContainer);
    map.on('load', () => setupCanvasA11y(map, targetContainer));
    map.on('render', () => setupCanvasA11y(map, targetContainer));

    targetContainer.addEventListener('pointerdown', () => {
      const canvas = map.getCanvas && map.getCanvas();
      if (canvas && document.activeElement === canvas) {
        try { canvas.blur(); } catch (_) { }
      }
    });

    map.on('styleimagemissing', (e) => {
      const id = e.id;
      if (map.hasImage && map.hasImage(id)) return;

      // Provide immediate fallback image synchronously so MapLibre never logs an error
      try {
        map.addImage(id, createMarkerImageData(), { pixelRatio: 2 });
      } catch (_) { }

      // Asynchronously load matching SVG asset if present
      const img = new Image();
      img.crossOrigin = 'anonymous';
      img.onload = () => {
        try {
          if (map.hasImage(id)) map.removeImage(id);
          map.addImage(id, img);
        } catch (_) { }
      };
      img.src = resolveAssetUrl(`assets/maps/saudi_geo/sprite_images/${id}.svg`);
    });

    map.on('style.load', () => {
      map._styleIsLoading = false;
      registerDefaultMarkerImages(map);
      setupCanvasA11y(map, targetContainer);
      // Globe projection (MapLibre v5 API)
      try {
        map.setProjection({ type: 'globe' });
        disableGlobeReadbackErrorMeasurement(map);
      } catch (e) {
        console.warn('[Globe] setProjection:', e);
      }
      disableGlobeReadbackErrorMeasurement(map);
      try { map.doubleClickZoom.disable(); } catch (_) { }
      if (map.setTerrain) {
        try { map.setTerrain(null); } catch (_) { }
      }
      map.resize();

      // ── Flush any markers that arrived before the map was ready ──
      window.mapboxGlobeInstances[viewId] = map;   // mark ready BEFORE flush
      const pending = window.mapboxGlobePendingCbs[viewId] || [];
      pending.forEach(fn => fn(map));
      delete window.mapboxGlobePendingCbs[viewId];
    });
    setTimeout(() => { if (map) map._styleIsLoading = false; }, 800);

    map.once('render', () => {
      disableGlobeReadbackErrorMeasurement(map);
    });

    map.on('error', e => {
      const s = e && e.error && e.error.status;
      if (s && s !== 401 && s !== 404) console.warn('[Globe] error:', e);
    });

    // ── Setup click listener for formation polygons & valleys on map ───────────────
    map.on('click', e => {
      if (window.flutterModalOpen) return;
      try {
        const formationLayers = [
          "Saq_Formation-657oal",
          "Tabuk_Formation-767mbq",
          "Wajid_Formation-0m41k3",
          "Minjur_Formation-cp2j29",
          "Biyadh_Formation-ciunt8",
          "Wasia_Formation-8gn6np",
          "Umm_er_radhuma_Formation-31a0hp",
          "Dammam_Formation-8o2pjs",
          "Neogene_Formation-98k03q",
          "Aruma_Formation-4kp806",
          "Jauf_Formation-3102c9"
        ];
        const activeLayers = formationLayers.filter(l => map.getLayer(l));
        if (activeLayers.length > 0) {
          const features = map.queryRenderedFeatures(e.point, { layers: activeLayers });
          if (features && features.length > 0) {
            const f = features[0];
            const layerKey = f.sourceLayer || (f.layer && f.layer.id);
            if (layerKey && typeof window.onFormationPolygonClicked === 'function') {
              window.onFormationPolygonClicked(layerKey);
              return;
            }
          }
        }
      } catch (_) { }
    });

    window.mapboxGlobeInstances[viewId] = map;   // also set immediately for resize calls
    window.mapboxGlobeMarkers[viewId] = [];

    // Progressive resize
    [50, 150, 300, 600, 1200, 2000].forEach(d =>
      setTimeout(() => { try { map.resize(); } catch (_) { } }, d)
    );
    if (typeof ResizeObserver !== 'undefined') {
      new ResizeObserver(() => { try { map.resize(); } catch (_) { } })
        .observe(targetContainer);
    }

    // ── Interaction Guard: Isolate Sidebar & Modals from Globe ───────────────
    function setGlobeInteractions(enabled) {
      if (!map) return;
      if (window.flutterModalOpen) {
        enabled = false;
      }
      try {
        if (enabled) {
          if (map.scrollZoom && !map.scrollZoom.isEnabled()) map.scrollZoom.enable();
          if (map.dragPan && !map.dragPan.isEnabled()) map.dragPan.enable();
          if (map.dragRotate && !map.dragRotate.isEnabled()) map.dragRotate.enable();
          if (map.touchZoomRotate && !map.touchZoomRotate.isEnabled()) map.touchZoomRotate.enable();
        } else {
          if (map.scrollZoom && map.scrollZoom.isEnabled()) map.scrollZoom.disable();
          if (map.dragPan && map.dragPan.isEnabled()) map.dragPan.disable();
          if (map.dragRotate && map.dragRotate.isEnabled()) map.dragRotate.disable();
          if (map.touchZoomRotate && map.touchZoomRotate.isEnabled()) map.touchZoomRotate.disable();
          if (map.doubleClickZoom && map.doubleClickZoom.isEnabled()) map.doubleClickZoom.disable();
        }
      } catch (_) { }
    }

    const onPointerCheck = (e) => {
      const overSidebar = isPointerOverSidebar(e);
      setGlobeInteractions(!overSidebar);
    };

    window.addEventListener('mousemove', onPointerCheck, { passive: true });
    window.addEventListener('pointermove', onPointerCheck, { passive: true });
    window.addEventListener('wheel', onPointerCheck, { passive: true });
  }

  tryInit();
};

// ── Global Sidebar Wheel & Touch Bridge for Flutter Web ────────────────────
function _getPointerX(e) {
  if (e.clientX !== undefined) return e.clientX;
  if (e.touches && e.touches.length > 0) return e.touches[0].clientX;
  if (e.changedTouches && e.changedTouches.length > 0) return e.changedTouches[0].clientX;
  return undefined;
}

function _getPointerY(e) {
  if (e.clientY !== undefined) return e.clientY;
  if (e.touches && e.touches.length > 0) return e.touches[0].clientY;
  if (e.changedTouches && e.changedTouches.length > 0) return e.changedTouches[0].clientY;
  return undefined;
}

function isPointerOverSidebar(e) {
  const w = window.innerWidth;
  const sidebarWidth = w < 600 ? Math.max(240, Math.min(w * 0.52, 350)) : 380;
  const x = _getPointerX(e);
  return x !== undefined && x >= (w - sidebarWidth);
}

let _sidebarTouchStartY = null;

// Global wheel listener: always forward wheel scroll over the sidebar to Flutter
window.addEventListener('wheel', (e) => {
  if (isPointerOverSidebar(e)) {
    let dy = e.deltaY;
    if (e.deltaMode === 1) dy *= 32;
    else if (e.deltaMode === 2) dy *= 320;
    if (typeof window.flutterSidebarScroll === 'function') {
      window.flutterSidebarScroll(dy);
    }
  }
}, { passive: true });

// Global touch listeners: forward touch swiping over the sidebar to Flutter
window.addEventListener('touchstart', (e) => {
  if (isPointerOverSidebar(e)) {
    _sidebarTouchStartY = _getPointerY(e);
  } else {
    _sidebarTouchStartY = null;
  }
}, { passive: true });

window.addEventListener('touchmove', (e) => {
  if (_sidebarTouchStartY !== null && isPointerOverSidebar(e)) {
    const currentY = _getPointerY(e);
    if (currentY !== undefined) {
      const deltaY = _sidebarTouchStartY - currentY;
      _sidebarTouchStartY = currentY;
      if (typeof window.flutterSidebarScroll === 'function') {
        window.flutterSidebarScroll(deltaY);
      }
    }
  }
}, { passive: true });

window.addEventListener('touchend', () => {
  _sidebarTouchStartY = null;
}, { passive: true });

// ---------------------------------------------------------------------------
// Modal State Bridge: Freezes map controls while modal dialogs are open
// ---------------------------------------------------------------------------
window.flutterModalOpen = false;
window.setModalOpenWeb = function (isOpen) {
  window.flutterModalOpen = !!isOpen;
  Object.values(window.mapboxGlobeInstances || {}).forEach(map => {
    if (map) {
      try {
        if (window.flutterModalOpen) {
          if (map.scrollZoom && map.scrollZoom.isEnabled()) map.scrollZoom.disable();
          if (map.dragPan && map.dragPan.isEnabled()) map.dragPan.disable();
          if (map.dragRotate && map.dragRotate.isEnabled()) map.dragRotate.disable();
          if (map.touchZoomRotate && map.touchZoomRotate.isEnabled()) map.touchZoomRotate.disable();
          if (map.doubleClickZoom && map.doubleClickZoom.isEnabled()) map.doubleClickZoom.disable();
        } else {
          if (map.scrollZoom && !map.scrollZoom.isEnabled()) map.scrollZoom.enable();
          if (map.dragPan && !map.dragPan.isEnabled()) map.dragPan.enable();
          if (map.dragRotate && !map.dragRotate.isEnabled()) map.dragRotate.enable();
          if (map.touchZoomRotate && !map.touchZoomRotate.isEnabled()) map.touchZoomRotate.enable();
        }
      } catch (_) { }
    }
  });
};

// ---------------------------------------------------------------------------
// flyTo
// ---------------------------------------------------------------------------
window.mapboxGlobeFlyToWeb = function (viewId, lng, lat, zoom) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;
  try {
    map.flyTo({ center: [lng, lat], zoom: zoom || 6.0, essential: true, duration: 1500 });
  } catch (e) { console.warn('[Globe] flyTo:', e); }
};

// ---------------------------------------------------------------------------
// setStyle — strips mapbox:// sources that need a token
// ---------------------------------------------------------------------------
window.mapboxGlobeSetStyleJSONWeb = function (viewId, styleJsonStr) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;
  try {
    const transformed = transformMapboxStyle(styleJsonStr);
    map._styleIsLoading = true;
    map.setStyle(transformed, { diff: false });
    let styleHandled = false;
    const onStyleDone = () => {
      if (styleHandled) return;
      styleHandled = true;
      map._styleIsLoading = false;
      registerDefaultMarkerImages(map);
      setupCanvasA11y(map);
      try {
        map.setProjection({ type: 'globe' });
        disableGlobeReadbackErrorMeasurement(map);
      } catch (_) { }
      disableGlobeReadbackErrorMeasurement(map);
      if (map.setTerrain) {
        try { map.setTerrain(null); } catch (_) { }
      }
      map.resize();
    };
    map.once('style.load', onStyleDone);
    setTimeout(onStyleDone, 500);
  } catch (e) {
    map._styleIsLoading = false;
    console.warn('[Globe] setStyle error:', e);
    try { map.setStyle(ESRI_SATELLITE_GLOBE_STYLE, { diff: false }); } catch (_) { }
  }
};

// ---------------------------------------------------------------------------
// Clear markers
// ---------------------------------------------------------------------------
window.mapboxGlobeClearMarkersWeb = function (viewId) {
  (window.mapboxGlobeMarkers[viewId] || []).forEach(m => { try { m.remove(); } catch (_) { } });
  window.mapboxGlobeMarkers[viewId] = [];
  // Also clear any pending queue
  delete window.mapboxGlobePendingCbs[viewId];
};

// ---------------------------------------------------------------------------
// Add marker — immediate if map exists, otherwise queues call
// ---------------------------------------------------------------------------
window.mapboxGlobeAddMarkerWeb = function (viewId, lng, lat, iconUrl, markerId, callbackName) {
  const map = window.mapboxGlobeInstances[viewId];
  if (map) {
    _doAddMarker(map, viewId, lng, lat, iconUrl, markerId, callbackName);
    return;
  }
  if (!window.mapboxGlobePendingCbs[viewId]) {
    window.mapboxGlobePendingCbs[viewId] = [];
  }
  window.mapboxGlobePendingCbs[viewId].push(
    readyMap => _doAddMarker(readyMap, viewId, lng, lat, iconUrl, markerId, callbackName)
  );
};

// ---------------------------------------------------------------------------
// Set markers in batch (clears existing markers and adds new markers)
// ---------------------------------------------------------------------------
window.mapboxGlobeSetMarkersBatchWeb = function (viewId, markersJsonStr, callbackName) {
  window.mapboxGlobeClearMarkersWeb(viewId);
  if (!markersJsonStr) return;

  function _applyBatch(map) {
    let items;
    try {
      items = (typeof markersJsonStr === 'string') ? JSON.parse(markersJsonStr) : markersJsonStr;
    } catch (e) {
      console.error('[Globe] setMarkersBatch JSON parse error:', e);
      return;
    }
    if (!Array.isArray(items) || items.length === 0) return;

    items.forEach(function (item) {
      _doAddMarker(map, viewId, item.lng, item.lat, item.iconUrl, item.id, callbackName);
    });
  }

  const map = window.mapboxGlobeInstances[viewId];
  if (map) {
    _applyBatch(map);
  } else {
    if (!window.mapboxGlobePendingCbs[viewId]) {
      window.mapboxGlobePendingCbs[viewId] = [];
    }
    window.mapboxGlobePendingCbs[viewId].push(_applyBatch);
  }
};

// ---------------------------------------------------------------------------
// Batch Valley line layers loader
// ---------------------------------------------------------------------------
window.mapboxGlobeLoadAllValleysWeb = function (viewId, valleysJsonStr, selectedValleyKey) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) {
    if (!window.mapboxGlobePendingCbs[viewId]) {
      window.mapboxGlobePendingCbs[viewId] = [];
    }
    window.mapboxGlobePendingCbs[viewId].push(function () {
      window.mapboxGlobeLoadAllValleysWeb(viewId, valleysJsonStr, selectedValleyKey);
    });
    return;
  }

  function _loadValleys() {
    let valleys;
    try {
      valleys = (typeof valleysJsonStr === 'string') ? JSON.parse(valleysJsonStr) : valleysJsonStr;
    } catch (e) {
      console.error('[Globe] loadAllValleys JSON parse error:', e);
      return;
    }
    if (!Array.isArray(valleys)) return;

    map._loadedValleyKeys = valleys.map(function (v) { return v.key; });

    valleys.forEach(function (v) {
      try {
        const layerId = v.key;
        const sourceId = 'source-' + v.key;
        if (map.getLayer(layerId)) map.removeLayer(layerId);
        if (map.getSource(sourceId)) map.removeSource(sourceId);

        const geoJson = (typeof v.geoJson === 'string') ? JSON.parse(v.geoJson) : v.geoJson;
        map.addSource(sourceId, { type: 'geojson', data: geoJson });

        const isSelected = (v.key === selectedValleyKey);
        map.addLayer({
          id: layerId,
          type: 'line',
          source: sourceId,
          layout: { 'line-cap': 'round', 'line-join': 'round' },
          paint: {
            'line-color': isSelected ? '#FF0000' : '#0000FF',
            'line-width': isSelected ? 4.5 : 3.0
          }
        });

        map.on('click', layerId, function (e) {
          if (window.flutterModalOpen) return;
          if (typeof window.onValleyLineClicked === 'function') {
            window.onValleyLineClicked(layerId);
          }
        });
        map.on('mouseenter', layerId, function () {
          if (!window.flutterModalOpen) map.getCanvas().style.cursor = 'pointer';
        });
        map.on('mouseleave', layerId, function () {
          map.getCanvas().style.cursor = '';
        });
      } catch (err) {
        console.error('Error adding valley ' + v.key, err);
      }
    });
  }

  function _safeLoad() {
    try {
      _loadValleys();
    } catch (e) {
      console.warn('[Globe] _loadValleys error, retrying in 150ms:', e);
      setTimeout(function () {
        try { _loadValleys(); } catch (err) { console.error('[Globe] _loadValleys retry failed:', err); }
      }, 150);
    }
  }

  if (map._styleIsLoading) {
    let done = false;
    const onReady = function () {
      if (done) return;
      done = true;
      _safeLoad();
    };
    map.once('style.load', onReady);
    setTimeout(onReady, 400);
  } else {
    _safeLoad();
  }
};

// ---------------------------------------------------------------------------
// Add GeoJSON line layer (for single valley line)
// ---------------------------------------------------------------------------
window.mapboxGlobeAddGeoJsonLineLayer = function (viewId, sourceId, layerId, geoJsonString, colorHex, lineWidth) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) {
    if (!window.mapboxGlobePendingCbs[viewId]) {
      window.mapboxGlobePendingCbs[viewId] = [];
    }
    window.mapboxGlobePendingCbs[viewId].push(function () {
      window.mapboxGlobeAddGeoJsonLineLayer(viewId, sourceId, layerId, geoJsonString, colorHex, lineWidth);
    });
    return;
  }

  function _doAdd() {
    try {
      if (map.getLayer(layerId)) map.removeLayer(layerId);
      if (map.getSource(sourceId)) map.removeSource(sourceId);

      let geoJson;
      try { geoJson = JSON.parse(geoJsonString); } catch (e) { console.error('GeoJSON parse error:', e); return; }

      map.addSource(sourceId, { type: 'geojson', data: geoJson });
      map.addLayer({
        id: layerId,
        type: 'line',
        source: sourceId,
        layout: { 'line-cap': 'round', 'line-join': 'round' },
        paint: {
          'line-color': colorHex,
          'line-width': lineWidth
        }
      });

      map.on('click', layerId, function (e) {
        if (window.flutterModalOpen) return;
        if (typeof window.onValleyLineClicked === 'function') {
          window.onValleyLineClicked(layerId);
        }
      });
      map.on('mouseenter', layerId, function () {
        if (!window.flutterModalOpen) map.getCanvas().style.cursor = 'pointer';
      });
      map.on('mouseleave', layerId, function () {
        map.getCanvas().style.cursor = '';
      });
    } catch (e) {
      console.error('addGeoJsonLineLayer error:', e);
    }
  }

  function _safeAdd() {
    try {
      _doAdd();
    } catch (e) {
      console.warn('[Globe] _doAdd error, retrying in 150ms:', e);
      setTimeout(function () {
        try { _doAdd(); } catch (err) { console.error('[Globe] _doAdd retry failed:', err); }
      }, 150);
    }
  }

  if (map._styleIsLoading) {
    let done = false;
    const onReady = function () {
      if (done) return;
      done = true;
      _safeAdd();
    };
    map.once('style.load', onReady);
    setTimeout(onReady, 400);
  } else {
    _safeAdd();
  }
};

// ---------------------------------------------------------------------------
// Update Valley line colors: selected valley is RED (#FF0000), others are BLUE (#0000FF)
// ---------------------------------------------------------------------------
window.mapboxGlobeUpdateValleyColors = function (viewId, selectedValleyKey) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;

  const valleyNames = [
    "Wadi_Aba_Al_Qu", "Wadi_Aba_Ar_Ruwath", "Wadi_Al_Ahsabah", "Wadi_Al_Akhda",
    "Wadi_Al_Amq", "Wadi_Al_Batin", "Wadi_Al_Farshah", "Wadi_Al_Gharr",
    "Wadi_al_Ghinah", "Wadi_Al_Hamal", "Wadi_Al_Hamd", "Wadi_Al_Hinu",
    "Wadi_Al_Jarir", "Wadi_Al_Jizil", "Wadi_al_Judwal", "Wadi_Al_Khurmah",
    "Wadi_Al_Lith", "Wadi_Al_Makhit", "Wadi_Al_Maqran", "Wadi_Al_Mira",
    "Wadi_al_Qimra", "Wadi_Ar_Raka", "Wadi_Ar_Risha", "Wadi_Ar_Rumah",
    "Wadi_Arar", "Wadi_As_Sahba", "Wadi_As_surrah", "Wadi_Ash_Shu-bah",
    "Wadi_Baysh", "Wadi_Bishah", "Wadi_Bitat", "Wadi_Damad",
    "Wadi_Dawqah", "Wadi_Fajr", "Wadi_Hali", "Wadi_Hamir",
    "Wadi_Hanifah", "Wadi_Hirjab", "Wadi_Hubuna", "Wadi_Itwad",
    "Wadi_Najran", "Wadi_Nayyal", "Wadi_Qatan", "Wadi_Ranyah",
    "Wadi_Rash", "Wadi_Shuwayhat", "Wadi_Tabalah", "Wadi_Tarif",
    "Wadi_Tarj", "Wadi_Tathlith", "Wadi_Turubah", "Wadi_Yabah"
  ];
  const keys = map._loadedValleyKeys || valleyNames;

  keys.forEach(function (vName) {
    try {
      if (map.getLayer(vName)) {
        const isSelected = (vName === selectedValleyKey);
        map.setPaintProperty(vName, 'line-color', isSelected ? '#FF0000' : '#0000FF');
        map.setPaintProperty(vName, 'line-width', isSelected ? 4.5 : 3.0);
      }
    } catch (_) { }
  });
};

// ---------------------------------------------------------------------------
// Update Dam marker icons: selected dam is RED (red_droplet), others are BLUE (droplet)
// ---------------------------------------------------------------------------
window.mapboxGlobeUpdateDamMarkers = function (viewId, selectedDamName) {
  const redIconUrl = resolveAssetUrl('assets/images/red_droplet.png');
  const blueIconUrl = resolveAssetUrl('assets/images/droplet.png');

  const markers = window.mapboxGlobeMarkers[viewId] || [];
  markers.forEach(function (m) {
    try {
      const el = m.getElement();
      if (!el) return;
      const markerId = el.getAttribute('data-marker-id');
      const img = el.querySelector('img');
      if (img && markerId) {
        if (markerId === selectedDamName) {
          img.src = redIconUrl;
          img.style.filter = 'drop-shadow(0 0 8px rgba(255,0,0,0.8))';
        } else {
          img.src = blueIconUrl;
          img.style.filter = 'none';
        }
      }
    } catch (_) { }
  });
};

// ---------------------------------------------------------------------------
// Clear GeoJSON line layers (e.g. when switching away from Valleys)
// ---------------------------------------------------------------------------
window.mapboxGlobeClearGeoJsonLineLayers = function (viewId, layerIdsStr, sourceIdsStr) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;
  const layerIds = layerIdsStr ? layerIdsStr.split(',') : [];
  const sourceIds = sourceIdsStr ? sourceIdsStr.split(',') : [];
  layerIds.forEach(id => { try { if (id && map.getLayer(id)) map.removeLayer(id); } catch (_) { } });
  sourceIds.forEach(id => { try { if (id && map.getSource(id)) map.removeSource(id); } catch (_) { } });
};
