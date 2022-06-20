const express = require('express');
const jwt = require('jsonwebtoken');
const auth = require('./middleware/auth');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');
const mysql = require("mysql2");
const config = require("./config.js")
const connection = mysql.createConnection({
    host: config.db.host,
    user: config.db.user,
    database: config.db.database,
    password: config.db.password,
   
  });


// routes
router.get('/',  auth, getAll); 
router.get('/:id', auth, getById);
router.post('/', auth, create);
router.put('/:id', auth, update);
router.delete('/:id', auth, _delete);

module.exports = router;

// route functions
function getAll(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query("SELECT * FROM paymentslist", function(err, results, fields) {
            res.status(200).json(results);  }); 
    } 
    else {
        connection.query("SELECT * FROM paymentslist WHERE userid=?", [req.payload.id], function(err, results, fields) {
            res.status(200).json(results);  })
    }
}

function getById(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
    connection.query('SELECT *  FROM paymentslist WHERE id=?' ,[ req.params.id ], 
        function (err, results) { 
            res.status(200).json(results);}); 
    } 
    else {
        connection.query("SELECT * FROM paymentslist WHERE id=? AND userid=?", [req.params.id , req.payload.id], function(err, results, fields) {
            res.status(200).json(results);  })
        }
}

function create(req, res, next) {
    let nd = new Date();
    nd = new Date(nd.valueOf() - (nd.getTimezoneOffset()*60000));
    let newDate = nd.toISOString().slice(0, 19).replace('T', ' ');
    if (["admin","manager"].includes(req.payload.role) ){
        let updateData=req.body;
        updateData.id = uuidv4();
        if (updateData.docdate == ''){ updateData.docdate = newDate };
        let sql = `INSERT INTO payments SET ?`;
        connection.query(sql, [updateData], function (err, data) { 
            if (err)  {res.statusCode = 409; {console.log(err.sqlMessage); return res.send(err.sqlMessage)}}
            else { res.statusCode = 201; res.send("Payment created")}  });   
 
    } else { res.status(403).send("Role is no permission")}
}; 
     
function update(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        let id= req.params.id;
        let updateData=req.body;
        updateData.id = ""; delete updateData.id;
        let sql = `UPDATE payments SET ? WHERE id= ?`;
        connection.query(sql, [updateData, id], function (err, data) {
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("Payment updated")}  });    
    }  else { res.status(403).send("Role is no permission")}        
}
   
function _delete(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query('DELETE FROM payments WHERE id=?',[ req.params.id ],   function (err, results) {
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("Payment deleted")}  });   
    } else { res.status(403).send("Role is no permission")}
}