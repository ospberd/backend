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
router.get('/',  auth, getAll); 
router.get('/:id',  auth, getById);
router.post('/', auth, create);
router.put('/:id', auth, update);
router.delete('/:id', auth, _delete);

module.exports = router;

// route functions
function getAll(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query("SELECT * FROM demandsHeadlist", function(err, results, fields) {
            res.status(200).json(results);  }); 
    } 
    else {
        connection.query("SELECT * FROM demandsHeadlist WHERE userid=?", [req.payload.id], function(err, results, fields) {
            res.status(200).json(results);  })
    }
}

function getById(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
    connection.query('SELECT *  FROM demandsHeadlist WHERE id=?' ,[ req.params.id ], 
        function (err, results) { 
            results[0].lines = []
            connection.query('SELECT *  FROM demandsLinelist WHERE headid=?' ,[ req.params.id ], 
                function (err, resultslines) { 
                     
                     resultslines.forEach(function(entry) {
                        results[0].lines.push(entry)

                    });
                    res.status(200).json(results); 
                    
                })

        }); 
          
    } 
    else {
        connection.query("SELECT * FROM demandsHeadlist WHERE id=? AND userid=?", [req.params.id , req.payload.id], function(err, results, fields) {
           if (results.length == 1) 
             {
                results[0].lines = []
                connection.query('SELECT *  FROM demandsLinelist WHERE headid=?' ,[ req.params.id ], 
                    function (err, resultslines) { 
                         
                         resultslines.forEach(function(entry) {
                            results[0].lines.push(entry)
    
                        });
                        res.status(200).json(results); 
                        
                    })
             }
           else {res.status(200).json(results); }
              })
        }
}

function create(req, res, next) {
    let nd = new Date();
    nd = new Date(nd.valueOf() - (nd.getTimezoneOffset()*60000));
    let newDate = nd.toISOString().slice(0, 19).replace('T', ' ');

    connection.query("SELECT * FROM demandsLastNumber", function(err, results, fields) {
       
        lastdocnumb =  results[0].docnumber; 
  
    if (["admin","manager"].includes(req.payload.role) ){
        connection.beginTransaction();
        let updateData=req.body;
        updateData.id = updateData.id || uuidv4();
        if (updateData.docdate == ''){ updateData.docdate = newDate };
        updateData.docnumber = updateData.docnumber || lastdocnumb+1;
        if (updateData.lines.length>0) {
             var DemandLines =  JSON.parse(JSON.stringify(updateData.lines)) ; 
             delete updateData.lines;}
        updateData= agree('demandsHead',updateData) ;
        let sql = `INSERT INTO demandsHead SET ?`;
        connection.query(sql, [updateData], function (err, data) {
            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
            else { 

                DemandLines.forEach((element) => {
                    element.id = element.id || uuidv4();
                    element.headid = updateData.id ;
                    let sqll = `INSERT INTO demandsLine SET ?`;
                    connection.query(sqll, agree('demandsLine',element), function (err, data) { 
                        if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)} }) 
            }) 
            connection.commit();
            { res.statusCode = 201; res.send("Demand created")}

            }
        });   
 
    }
    
    else {  let updateData=req.body;
          if (updateData.totalConfirm==0  && updateData.opened) {
        
           connection.beginTransaction();
          
           updateData.userid = req.payload.id;
           updateData.id = updateData.id || uuidv4();
           updateData.docnumber =  lastdocnumb+1;
           if (updateData.docdate == ''){ updateData.docdate = newDate };

           if (updateData.lines.length>0) {
                var DemandLines =  JSON.parse(JSON.stringify(updateData.lines)) ; 
                delete updateData.lines;}
           let sql = `INSERT INTO demandsHead SET ?`;
           connection.query(sql, [agree('demandsHead',updateData)], function (err, data) {
               if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
               else { 
   
                   DemandLines.forEach((element) => {
                       element.id = element.id || uuidv4();
                       element.quantityConfirm = 0; delete element.quantityConfirm ;
                       element.priceConfirm = 0; delete element.priceConfirm ;
                       element.totalConfirm = 0; delete element.totalConfirm ;
                       
                       element.headid = updateData.id ;
                       let sqll = `INSERT INTO demandsLine SET ?`;
                       connection.query(sqll, agree('demandsLine',element), function (err, data) { 
                           if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)} }) 
               }) 
               connection.commit();
               { res.statusCode = 201; res.send("Demand created")}
   
               }
           });    
        }  else { res.status(403).send("Role is no permission")}  
        
        }
    }); 
};
     
function update(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.beginTransaction();
        let updateData=req.body;
        // console.log(updateData);
        if (updateData.lines.length>0) {
             var DemandLines =  JSON.parse(JSON.stringify(updateData.lines)) ; 
             delete updateData.lines;}
        let sql = `UPDATE demandsHead SET ? WHERE id=?`;
        connection.query(sql, [agree('demandsHead',updateData), updateData.id], function (err, data) { 
            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
            else 
            {

                connection.query('SELECT *  FROM demandsLinelist WHERE headid=?' ,[ updateData.id ], 
                function (err, resultslines) { 
                     // Находим записи в БД отсутствующие в запросе и удаляем.
                     resultslines.forEach(function(entry) {
                        if (DemandLines.findIndex(x => x.id == entry.id ) == -1) {
                        connection.query('DELETE  FROM demandsLine WHERE id=?' ,[ entry.id], function (err, data) {
                            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                        });
                       }
                        
                    });
                    // Итерируя Строки в запросе добавляем или  обновляем зписи в Б.Д.
                    DemandLines.forEach(function(entry) {
                        entry.headid = updateData.id;
                        entry.id = entry.id || uuidv4();
                        if (resultslines.findIndex(x => x.id == entry.id ) == -1) {
                            connection.query('INSERT INTO  demandsLine SET ?' ,[agree('demandsLine',entry)], function (err, data) {
                                if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                            });
                           }
                           else{
                            connection.query('UPDATE demandsLine SET ? WHERE id=?' ,[agree('demandsLine',entry), entry.id], function (err, data) {
                                if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                            });
                           }
                    });
                })

            }
            connection.commit();
            { res.statusCode = 201; res.send("Demand updated")}

        })
        
  
    }  else { 
        let updateData=req.body;
        if (updateData.totalConfirm==0  && updateData.opened) {
        connection.beginTransaction();

        if (updateData.lines.length>0) {
             var DemandLines =  JSON.parse(JSON.stringify(updateData.lines)) ; 
             delete updateData.lines;}
        let sql = `UPDATE demandsHead SET ? WHERE id=?`;
        connection.query(sql, [agree('demandsHead',updateData), updateData.id], function (err, data) { 
            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
            else 
            {

                connection.query('SELECT *  FROM demandsLinelist WHERE headid=?' ,[ updateData.id ], 
                function (err, resultslines) { 
                     // Находим записи в БД отсутствующие в запросе и удаляем.
                     resultslines.forEach(function(entry) {
                        if (DemandLines.findIndex(x => x.id == entry.id ) == -1) {
                        connection.query('DELETE  FROM demandsLine WHERE id=?' ,[ entry.id], function (err, data) {
                            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                        });
                       }
                        
                    });
                    // Итерируя Строки в запросе добавляем или  обновляем зписи в Б.Д.
                    DemandLines.forEach(function(entry) {
                        entry.quantityConfirm = 0; delete entry.quantityConfirm ;
                        entry.priceConfirm = 0; delete entry.priceConfirm ;
                        entry.totalConfirm = 0; delete entry.totalConfirm ;
                        entry.headid = updateData.id;
                        entry.id = entry.id || uuidv4();
                        if (resultslines.findIndex(x => x.id == entry.id ) == -1) {
                            connection.query('INSERT INTO  demandsLine SET ?' ,[fagree('demandsLine',entry)], function (err, data) {
                                if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                            });
                           }
                           else{
                            connection.query('UPDATE demandsLine SET ? WHERE id=?' ,[agree('demandsLine',entry), entry.id], function (err, data) {
                                if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                            });
                           }
                    });
                })

            }
            connection.commit();
            { res.statusCode = 201; res.send("Demand updated")}

        })
    } else { res.status(403).send("Role is no permission")}  



    }  
}
   
function _delete(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query('DELETE FROM demandsHead WHERE id=?',[ req.params.id ], function (err, results) { 
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("Demand deleted")}  });   
    } 
    else {
        connection.query("SELECT * FROM demandsHeadlist WHERE id=? AND userid=?", [req.params.id , req.payload.id], function(err, results, fields) {
            if (results.length == 1) 
              {
                 results[0].lines = []

                 if (results[0].totalConfirm==0  && results[0].opened) {
                    connection.query('DELETE FROM demandsHead WHERE id=?',[ req.params.id ], function (err, results) { 
                        if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
                        else { res.statusCode = 201; res.send("Demand deleted")}  });   
        
                } else{res.status(403).send("Role is no permission")}   

              }
            else {res.status(200).json(results); }
               })

        
        }
}