// -*- coding: utf-8, tab-width: 2 -*-
'use strict';

require('p-fatal');
require('usnam-pmb');

const eq = require('equal-pmb');
const fixtModule = require('..');

const fixtList = fixtModule.allAsList();
const fixtMap = fixtModule.allAsMap();
const expectCount = 41;

eq(Object.keys(fixtList).length, expectCount);
eq(fixtList.slice(-1)[0].id, 'http://example.org/anno' + expectCount);
eq(fixtMap.get('anno3.json').id, fixtModule[3].id);

console.info('+OK all tests passed.');
