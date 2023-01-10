const express = require('express');
const jwt = require('jsonwebtoken');
const auth = require('./middleware/auth');
const router = express.Router();
const { v4: uuidv4 } = require('uuid');
const mysql = require("mysql2");
const config = require("./config.js");
const agree = require("./fields.description.js");

const connection = mysql.createConnection({
    host: config.db.host,
    user: config.db.user,
    database: config.db.database,
    password: config.db.password
  });


// routes
router.get('/',  getAll); 
router.get('/:id', getById);
router.post('/', auth, create);
router.put('/:id', auth, update);
router.delete('/:id', auth, _delete);

module.exports = router;

// route functions
function getAll(req, res, next) {
        connection.query("SELECT * FROM goodslist ORDER BY groupname, goods", function(err, results, fields) {
              
            res.statusCode = 200;
            res.json(results);
        }); 
}

function getById(req, res, next) {
    connection.query('SELECT *  FROM goodslist WHERE id=?',[ req.params.id ], 
        function (err, results) { 
            res.json(results);}); 
}

function create(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        let updateData=req.body;
        updateData.id = uuidv4();
        let sql = `INSERT INTO goods SET ?`;
        connection.query(sql, [agree('goods',updateData)], function (err, data) { 
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("Goods created")}  });   
 
    } else { res.statusCode = 403; res.send("Role no permission")}
}; 
     
function update(req, res, next) {
    
    if (["admin","manager"].includes(req.payload.role) ){
        let id= req.params.id;
        let updateData=req.body;
        updateData.id = ""; delete updateData.id;
        let sql = `UPDATE goods SET ? WHERE id= ?`;
        connection.query(sql, [agree('goods',updateData), id], function (err, data) {
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("Goods updated")}  });   

    }  else {res.statusCode = 403; res.send("Role no permission")}        
}
   
function _delete(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query('DELETE FROM goods WHERE id=?',[ req.params.id ],  function (err, results) { 
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("Goods deleted")}  });   

    } else {res.statusCode = 403;  res.send("Role no permission")}
}