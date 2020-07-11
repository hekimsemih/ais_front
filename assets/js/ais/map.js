import "../../css/map.scss"
import 'ol/ol.css';

import {Map, View, Feature} from 'ol';
import TileLayer from 'ol/layer/Tile';
import VectorLayer from 'ol/layer/Vector';
import VectorSource from 'ol/source/Vector';
import OSM from 'ol/source/OSM';
import GeoJSON from 'ol/format/GeoJSON';
import Renderer from 'ol/renderer/webgl/PointsLayer';

import {defaults as defaultInteractions, DragRotateAndZoom} from 'ol/interaction';
import {RegularShape, Fill, Style, Stroke} from 'ol/style';

import MousePosition from 'ol/control/MousePosition';
import {defaults as defaultControls} from 'ol/control';
import {createStringXY} from 'ol/coordinate';
import {fromLonLat} from 'ol/proj';

import sync from 'ol-hashed';

const mousePositionControl = new MousePosition({
  coordinateFormat: createStringXY(4),
  projection: 'EPSG:3857',
  // comment the following two lines to have the mouse position
  // be placed within the map.
  // className: 'custom-mouse-position',
  // target: document.getElementById('mouse-position'),
  undefinedHTML: '&nbsp;'
});

const osmLayer = new TileLayer({
    source: new OSM()
});
const focusSource = new VectorSource();
const focusLayer = new VectorLayer({
    source: focusSource,
    style: new Style({
        image: new RegularShape({
            fill: new Fill({color: 'rgba(255, 255, 255, 0)'}),
            stroke: new Stroke({
                color: 'red',
                width: 1,
            }),
            points: 4,
            radius: 20,
            angle: Math.PI / 4,
        })
    })
})

const focusArrayBuffer = new ArrayBuffer(Float32Array.BYTES_PER_ELEMENT);
const selectedFeature = new DataView(focusArrayBuffer);
selectedFeature.setInt32(0,-1);

// We need size, angle, color, shape to properly draw a ship
const customLayerAttributes = [{
    name: 'size',
    callback: function (feature) {
        return 30;
    },
    notForTemplates: true,
},{
    name: 'iscircle',
    callback: function (feature) {
        const sog = feature.get('sog');

        if (sog < 0.5)
            return true;
        return false;
    },
    toFragment: true,
},{
    name: 'id',
    callback: function (feature) {
        const b = new ArrayBuffer(Float32Array.BYTES_PER_ELEMENT);
        const dv = new DataView(b,0);
        dv.setInt32(0, parseInt(feature.getId().split('.')[1]));
        return dv.getFloat32(0);
    },
    toFragment: true,
},{
    name: 'angle',
    callback: function (feature) {
        return feature.get('cog')*Math.PI/180;
    }
}
];
const customLayerAttributeArrays = [];

function numTwoFloats(num){
    const significantDigits = 6;

    const sign = Math.sign(num);
    const sciRep = Math.abs(num).toExponential();
    const [mantissa, exponent] = sciRep.split('e');
    const significant = mantissa.replace('.','');
    const [first, second] = [significant.slice(0,significantDigits), significant.slice(significantDigits, 2*significantDigits)];
    const firstMantissa = first.slice(0,1) + '.' + first.slice(1) + '0';
    const secondMantissa = second.slice(0,1) + '.' + second.slice(1) + '0';
    const secondExponent = Number(exponent) - significantDigits;

    const firstFloat = sign * Number(firstMantissa + 'e' + exponent);
    const secondFloat = sign * Number(secondMantissa + 'e' + secondExponent);

    return [firstFloat, secondFloat];
}
function matrixTwoFloats(matrix){
    const firstMatrix = new Array(6);
    const secondMatrix = new Array(6);
    for (let i = 0; i < matrix.length; i++){
        const twoFloats = numTwoFloats(matrix[i]);
        firstMatrix[i] = twoFloats[0];
        secondMatrix[i] = twoFloats[1];
    }
    return [firstMatrix, secondMatrix];
}
let webglLayerRenderer;
const uniforms = {
    u_selectedId: function(framestate){
        return selectedFeature.getFloat32(0);
    },
    u_eyepos: function(framestate){
        const center = framestate.viewState.center;
        const xs = numTwoFloats(center[0]);
        const ys = numTwoFloats(center[1]);
        return [xs[0], ys[0]];
    },
    u_eyeposlow: function(framestate){
        const center = framestate.viewState.center;
        const xs = numTwoFloats(center[0]);
        const ys = numTwoFloats(center[1]);
        return [xs[1], ys[1]];
    },
    u_projTransform: function(framestate){
        const size = framestate.size;
        const rotation = framestate.viewState.rotation;
        const resolution = framestate.viewState.resolution;
        const center = framestate.viewState.center;
        const sx = 2 / (resolution * size[0]);
        const sy = 2 / (resolution * size[1]);
        const dx2 = -center[0];
        const dy2 = -center[1];
        const sin = Math.sin(-rotation);
        const cos = Math.cos(-rotation);

        const transform = new Array(6);
        transform[0] = sx * cos;
        transform[1] = sy * sin;
        transform[2] = - sx * sin;
        transform[3] = sy * cos;
        transform[4] = 0;
        transform[5] = 0;

        // console.log(transform);
        return transform;
    },
};

function fetchTemplate(url) {
    return fetch(url).then(response => response.text())
}
const vertexShaderTemplate = fetchTemplate('/shaders/ais.vert');
const fragmentShaderTemplate = fetchTemplate('/shaders/ais.frag');
const hitVertexShaderTemplate = fetchTemplate('/shaders/hitais.vert');
const hitFragmentShaderTemplate = fetchTemplate('/shaders/hitais.frag');

// not pretty...
Promise.all([vertexShaderTemplate, fragmentShaderTemplate,
    hitVertexShaderTemplate, hitFragmentShaderTemplate,
    null])
    .then(function(results){
        return {
            vertex: results[0],
            fragment: results[1],
            hitvertex: results[2],
            hitfragment: results[3],
            options: results[4],
        }
    }).then(function(results){
        class CustomLayer extends VectorLayer{
            createRenderer() {
                const options = {
                    attributes: customLayerAttributes,
                    uniforms: uniforms,
                    vertexShader:  results.vertex,
                    fragmentShader: results.fragment,
                    hitVertexShader:  results.hitvertex,
                    hitFragmentShader: results.hitfragment,
                };
                console.log(options.hitVertexShader);
                console.log(options.hitFragmentShader);
                return new Renderer(this, options);
            }
        }

        const webglSource = new VectorSource({
            format: new GeoJSON(),
            // url: 'http://192.168.8.157:8600/geoserver/ais/wms?service=WMS&version=1.1.1&request=GetMap&layers=ais%3Ashipinfos&bbox=-180.0%2C-90.0%2C180.0%2C90.0&width=768&height=384&srs=EPSG%3A4326&format=geojson&time=PT2H/PRESENT',
            url: 'data/geojson/ais.json',
            crossOrigin: 'anonymous',
        });
        const webglLayer = new CustomLayer({
            source: webglSource,
        });
        webglLayerRenderer = webglLayer.getRenderer();
        // webglLayer.isAisLayer = true;
        const webglError = webglLayer.getRenderer().getShaderCompileErrors();
        if (webglError) {
            console.log(webglError)
        }

        const map = new Map({
            controls: defaultControls().extend([mousePositionControl]),
            target: 'map',
            interactions: defaultInteractions().extend([
                new DragRotateAndZoom()
            ]),
            layers: [
                osmLayer,
                webglLayer,
                focusLayer,
            ],
            view: new View({
                center: fromLonLat([0, 0]),
                zoom: 2
            })
        });

        const lvData = document.getElementById("liveview-data");
        const isShowInfos = () =>
            lvData.dataset.showInfos.toLowerCase() === "true";

        map.on('pointermove', function(evt) {
            selectedFeature.setInt32(0,-1);
            map.forEachFeatureAtPixel(evt.pixel, function(feature) {
                selectedFeature.setInt32(0, parseInt(feature.getId().split('.')[1]));

                if (!isShowInfos()) return false;

                // move that to live view
                const positionStr = feature.get('geometry').getCoordinates().join(", ");
                const filterKeys = ['time','name','callsign','imo','cog'];
                const properties = feature.getKeys()
                    .filter(k => filterKeys.includes(k))
                    .map(k => `<li><b>${k}:</b> <i>${feature.get(k)}</i></li>`)
                    .join('\n');
                shipinfos.innerHTML = `<li><b>id:</b> <i>${feature.getId()}</i></li>\n
                <li><b>mmsi:</b> <i>${feature.getId().split('.')[1]}</i></li>\n
                <li><b>position:</b> <i>${positionStr}</i></li>\n
                ${properties}`;

                return true;
            }, {
                layerFilter: function(layer){
                    return layer.ol_uid == webglLayer.ol_uid;
                },

            });
            map.render();
        });

        map.on('moveend', function(evt){
            if (!isShowInfos()) return;

            const extent = map.getView().calculateExtent(map.getSize());
            shipcount.innerHTML = webglSource.getFeaturesInExtent(extent).length;
        });

        // setInterval(function(){
        //     map.render();
        // }, 1000/30);

        sync(map);
    });
