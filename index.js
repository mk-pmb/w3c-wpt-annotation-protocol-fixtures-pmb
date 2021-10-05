// -*- coding: utf-8, tab-width: 2 -*-
'use strict';

const fixt = require('./examples/anno-all.json');

Object.assign(fixt, {

  allAsList() { return fixt.filter(Boolean); },

  allAsMap() {
    const m = new Map();
    fixt.forEach(function add(data, idx) {
      if (!data) { return; }
      const name = ('anno' + idx + '.json');
      m.set(name, data);
    });
    return m;
  },

});

module.exports = fixt;
