// -*- coding: utf-8, tab-width: 2 -*-
'use strict';

const fixt = require('./examples/anno-all.json');

Object.assign(fixt, {

  all() { return fixt.filter(Boolean); },

});

module.exports = fixt;
