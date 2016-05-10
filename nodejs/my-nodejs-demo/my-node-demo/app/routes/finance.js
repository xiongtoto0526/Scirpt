'use strict';

var express = require('express');
var router = express.Router();

/* GET users listing. */

// tes
router.get('/we', function(req, res, next) {
  res.render('finance-we');
});

router.get('/', function(req, res, next) {
  res.render('finance');
});


module.exports = router;


