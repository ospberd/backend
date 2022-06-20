const express = require('express');
const jwt = require('jsonwebtoken');
const auth = require('./middleware/auth');
const router = express.Router();
const mysql = require("mysql2");
const config = require("./config.js")
const connection = mysql.createConnection({
    host: config.db.host,
    user: config.db.user,
    database: config.db.database,
    password: config.db.password,
   
  });


// routes

router.get('/moneyall/:begper?/:endper?', auth, moneyall);
router.get('/moneyid/:id?/:begper?/:endper?', auth, moneyid);
router.get('/goodsall/:begper?/:endper?', auth, goodsall);
router.get('/goodsid/:id/:begper?/:endper?', auth, goodsid);

module.exports = router;

// route functions  req.params.begper
function moneyall(req, res, next) {
    let beginperiod = req.params.begper || '2000-01-01';
    let endperiod = req.params.endper || '2300-12-31';
    connection.query( "SET @beginperiod = ?",[beginperiod])
    connection.query( "SET @endperiod = ?",[endperiod])

    if (["admin","manager"].includes(req.payload.role) ){
        connection.query( "SELECT * FROM moneySumPeriod", function(err, results, fields) {
          
            res.status(200).json(results);  }); 
    } 
    else {

        connection.query("SELECT * FROM moneySumPeriod WHERE userid=?", [req.payload.id], function(err, results, fields) {
            res.status(200).json(results);  })
    }
}

function moneyid(req, res, next) {
    let beginperiod = req.params.begper || '2000-01-01';
    let endperiod = req.params.endper || '2300-12-31';
    let id = req.params.id || req.payload.id;
    connection.query( "SET @beginperiod = ?",[beginperiod])
    connection.query( "SET @endperiod = ?",[endperiod])

    if (["admin","manager"].includes(req.payload.role) ){
        connection.query( "SELECT * FROM moneyPeriod WHERE userid=? AND docdate>=? ORDER BY docdate", [id,beginperiod], function(err, results, fields) {
          
            res.status(200).json(results);  }); 
    } 
    else {

        connection.query("SELECT * FROM moneyPeriod WHERE userid=? AND docdate>=? ORDER BY docdate", [req.payload.id,beginperiod], function(err, results, fields) {
            res.status(200).json(results);  })
    }
}

function goodsall(req, res, next) {
    let beginperiod = req.params.begper || '2000-01-01';
    let endperiod = req.params.endper || '2300-12-31';
    
    connection.query( "SET @beginperiod = ?",[beginperiod])
    connection.query( "SET @endperiod = ?",[endperiod])

    if (["admin","manager"].includes(req.payload.role) ){
        connection.query( "SELECT * FROM turnoversSumPeriod", function(err, results, fields) {
          
            res.status(200).json(results);  }); 
    } 
 //   else  { res.status(403).send("Role is no permission")}  
    else  { 
        connection.query( "SET @theuserid = ?",[req.payload.id])
        connection.query( "SELECT * FROM turnoversSumPeriodUserID ",function(err, results, fields) {
          
        res.status(200).json(results);  })};
}

function goodsid(req, res, next) {
    let beginperiod = req.params.begper || '2000-01-01';
    let endperiod = req.params.endper || '2300-12-31';
    let id = req.params.id ;
    connection.query( "SET @beginperiod = ?",[beginperiod])
    connection.query( "SET @endperiod = ?",[endperiod])

    if (["admin","manager"].includes(req.payload.role) ){
        connection.query( "SELECT * FROM turnoversPeriod WHERE goodsid=? AND docdate>=? ORDER BY docdate", [id,beginperiod], function(err, results, fields) {
            
            res.status(200).json(results);  }); 
    } 
    else {

        connection.query("SELECT * FROM turnoversPeriod WHERE goodsid=? AND  userid=? AND docdate>=? ORDER BY docdate", [id, req.payload.id, beginperiod], function(err, results, fields) {
            res.status(200).json(results);  })
    }
}