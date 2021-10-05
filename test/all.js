// -*- coding: utf-8, tab-width: 2 -*-
'use strict';

require('p-fatal');
require('usnam-pmb');

const eq = require('equal-pmb');
const fixt = require('..').all();

const expectCount = 41;

eq(Object.keys(fixt).length, expectCount);
eq(fixt.slice(-1)[0].id, 'http://example.org/anno' + expectCount);

console.info('+OK all tests passed.');
