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
    password: config.db.password
  });


// routes
router.get('/',  auth, getAll); 
router.get('/:productid',  auth, getById);
router.post('/', auth, create);
router.put('/:productid', auth, update);
router.delete('/:productid', auth, _delete);

module.exports = router;

// route functions
function getAll(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query("SELECT * FROM compositionHeadlist", function(err, results, fields) {
            res.status(200).json(results);  }); 
    } 
    else {
        res.status(403).send("Role is no permission")
    }
}

function getById(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
    connection.query('SELECT *  FROM compositionHeadlist WHERE productid=?' ,[ req.params.productid ], 
        function (err, results) { 
            results[0].lines = []
            connection.query('SELECT *  FROM compositionLinelist WHERE productid=?' ,[ req.params.productid ], 
                function (err, resultslines) { 
                     
                     resultslines.forEach(function(entry) {
                        results[0].lines.push(entry)

                    });
                    res.status(200).json(results); 
                    
                })

        }); 
          
    } 
    else {
        res.status(403).send("Role is no permission")
        }
}

    function create(req, res, next) {

    if (["admin","manager"].includes(req.payload.role) ){
        connection.beginTransaction();
        let updateData=req.body;
        updateData.productid = updateData.productid;
        if (updateData.lines.length>0) {
             var CompositionLines =  JSON.parse(JSON.stringify(updateData.lines)) ; 
             delete updateData.lines;}
        let sql = `INSERT INTO compositionHead SET ?`;
        connection.query(sql, [updateData], function (err, data) { 
            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
            else { 
                CompositionLines.forEach((element) => {
                    element.productid = updateData.productid ;
                    let sqll = `INSERT INTO compositionLine SET ?`;
                    
                    connection.query(sqll, element, function (err, data) { 
                    if (err)  { res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)} }) 
                }) 
            connection.commit();
            { res.statusCode = 201; res.send("Composition created")}
        }
});  
  
        }  else { res.status(403).send("Role is no permission")}  

};
     


function update(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.beginTransaction();
        let updateData=req.body;
 
        if (updateData.lines.length>0) {
             var compositionLines =  JSON.parse(JSON.stringify(updateData.lines)) ; 
             delete updateData.lines;}
        let sql = `UPDATE compositionHead SET ? WHERE productid=?`;
        connection.query(sql, [updateData, updateData.productid], function (err, data) { 
            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
            else 
            {

                connection.query('SELECT *  FROM compositionLine WHERE productid=?' ,[ updateData.productid ], 
                function (err, resultslines) { 
                     // Находим записи в БД отсутствующие в запросе и удаляем.
                     resultslines.forEach(function(entry) {
                        if (compositionLines.findIndex(x => x.ingredientid == entry.ingredientid ) == -1) {

                            
                        connection.query('DELETE  FROM compositionLine WHERE ingredientid=? AND productid=?' ,[ entry.ingredientid, entry.productid], function (err, data) {
                            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                        });
                       }
                        
                    });
                    // Итерируя Строки в запросе добавляем или  обновляем зписи в Б.Д.
                    compositionLines.forEach(function(entry) {
                        entry.productid = updateData.productid;
                        entry.ingredientid = entry.ingredientid;
                        if (resultslines.findIndex(x => x.ingredientid == entry.ingredientid ) == -1) {
                            connection.query('INSERT INTO  compositionLine SET ?' ,[entry], function (err, data) {
                                if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                            });
                           }
                           else{
                            connection.query('UPDATE compositionLine SET ? WHERE ingredientid=? AND productid=?' ,[entry,  entry.ingredientid, entry.productid], function (err, data) {
                            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                        });
                       }
                });
            })

        }
        connection.commit();
        { res.statusCode = 201; res.send("Composition updated")}

    })
    

  
        }  else { res.status(403).send("Role is no permission")}      
}
   
function _delete(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query('DELETE FROM compositionHead WHERE productid=?',[ req.params.productid ],  function (err, results) { 
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("Composition deleted")}  });   
    } else { res.status(403).send("Role is no permission")}
}