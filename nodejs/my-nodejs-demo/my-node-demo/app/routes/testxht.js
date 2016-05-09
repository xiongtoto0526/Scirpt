'use strict';

var express = require('express');
var router = express.Router();

/* GET users listing. */

// tes
router.get('/', function(req, res, next) {
  res.render('testxht');
});

module.exports = router;
