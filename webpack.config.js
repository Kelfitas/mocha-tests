var path = require('path')
var webpack = require('webpack')
var BundleTracker = require('webpack-bundle-tracker')

const TARGET = process.env.TARGET ? process.env.TARGET : 'web'
const ASSETS_DIR = path.join(__dirname, 'assets')
const BUILD_DIR = path.join(__dirname, 'test', TARGET)

var pluginsWebpack = [
    new BundleTracker({filename: './webpack-stats.json'}),
    new webpack.NamedModulesPlugin(),
];

var config = {
    target: TARGET,
    entry: ASSETS_DIR + '/main.js',
    output: {
        filename: 'tests.js',
        path: BUILD_DIR,
    },
    context: __dirname,
    devtool: 'eval-source-map',
    module: {
        loaders: [
            {
                test: /\.js$/,
                use: ['mocha-loader', 'babel-loader', 'eslint-loader'],
                enforce: 'pre',
                exclude: /node_modules/
            }
        ],
    },
    plugins: pluginsWebpack,
    resolve: {
        extensions: ['.js'],
    },
};

module.exports = config;
