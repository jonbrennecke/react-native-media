'use strict'

const path = require('path');
const webpack = require('webpack');

// eslint-disable-next-line no-undef
const root = path.resolve(__dirname, '..');

const rules = [
  {
      test: /\.jsx?$/,
      exclude: /node_modules/,
      use: 'babel-loader'
  }
];

const outputPath = path.resolve(root, 'build');

const output = {
  path: outputPath,
  publicPath: outputPath,
  filename: 'index.js',
  libraryTarget: 'commonjs2'
};

const optimization = {
  minimize: true
};

const plugins = [
  new webpack.DefinePlugin({
    'process.env.NODE_ENV': JSON.stringify('production'),
  })
];

const aliases = {
  '~': path.resolve(root, 'src'),
};

const resolve = {
  modules: [
    'node_modules',
    path.resolve(root, './node_modules')
  ],
  extensions: ['.js', '.jsx'],
  alias: aliases
}

module.exports = {
  externals: {
    'react-native': 'react-native',
    'react': 'react'
  },
  mode: 'production',
  target: 'web',
  entry: {
    index: path.resolve(root, './src/index.js'),
  },
  context: path.resolve(root, 'src'),
  devtool: 'source-map',
  node: {
    __filename: true,
    __dirname: true,
    fs: 'empty'
  },
  output,
  resolve,
  module: {
    rules
  },
  plugins,
  optimization,
};
