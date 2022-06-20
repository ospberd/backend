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
router.get('/:id',  auth, getById);
router.post('/', auth, create);
router.put('/:id', auth, update);
router.delete('/:id', auth, _delete);

module.exports = router;

// route functions
function getAll(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query("SELECT * FROM turnoversHeadlist", function(err, results, fields) {
            res.status(200).json(results);  }); 
    } 
    else {
        connection.query("SELECT * FROM turnoversHeadlist WHERE userid=?", [req.payload.id], function(err, results, fields) {
            res.status(200).json(results);  }); 
    }
}

function getById(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
    connection.query('SELECT *  FROM turnoversHeadlist WHERE id=?' ,[ req.params.id ], 
        function (err, results) { 
            results[0].lines = []
            connection.query('SELECT *  FROM turnoversLinelist WHERE headid=?' ,[ req.params.id ], 
                function (err, resultslines) { 
                     
                     resultslines.forEach(function(entry) {
                        results[0].lines.push(entry)

                    });
                    res.status(200).json(results); 
                    
                })

        }); 
          
    } 
    else {
        connection.query("SELECT * FROM turnoversHeadlist WHERE id=? AND userid=?", [req.params.id , req.payload.id], function(err, results, fields) {
           if (results.length == 1) 
             {
                results[0].lines = []
                connection.query('SELECT *  FROM turnoversLinelist WHERE headid=?' ,[ req.params.id ], 
                    function (err, resultslines) { 
                         
                         resultslines.forEach(function(entry) {
                                  results[0].lines.push(entry)    });
                        res.status(200).json(results); 
                    })
             }
           else {res.status(200).json(results);  }
              })
        }
}

    function create(req, res, next) {
    let nd = new Date();
    nd = new Date(nd.valueOf() - (nd.getTimezoneOffset()*60000));
    let newDate = nd.toISOString().slice(0, 19).replace('T', ' ');
    let lastdocnumb = 0;
    
    connection.query("SELECT * FROM turnoversLastNumber", function(err, results, fields) {
       
        lastdocnumb =  results[0].docnumber; 


   /*   connection.query("SELECT * FROM turnoversLastNumber", function(err, results, fields) {
        console.log(JSON.stringify(results[0]));
        lastdocnumb =  results[0].docnumber; 
        console.log(lastdocnumb)
    }); */
  
    if (["admin","manager"].includes(req.payload.role) ){
        connection.beginTransaction();
        let updateData=req.body;
        updateData.id = updateData.id || uuidv4();
        updateData.docnumber = updateData.docnumber || lastdocnumb+1;
        if (updateData.docdate == ''){ updateData.docdate = newDate };
        if (updateData.lines.length>0) {
             var TurnoverLines =  JSON.parse(JSON.stringify(updateData.lines)) ; 
             delete updateData.lines;}
        let sql = `INSERT INTO turnoversHead SET ?`;
        connection.query(sql, [updateData], function (err, data) { 
            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
            else { 
                TurnoverLines.forEach((element) => {
                    element.id = element.id || uuidv4();
                    element.headid = updateData.id ;
                    let sqll = `INSERT INTO turnoversLine SET ?`;
                    
                    connection.query(sqll, element, function (err, data) { 
                    if (err)  { res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)} }) 
                }) 
            connection.commit();
            { res.statusCode = 201; res.send("Turnover created")}
        }
});  
  
        }  else { res.status(403).send("Role is no permission")}  
    }); 
};
     


function update(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.beginTransaction();
        let updateData=req.body;
 
        if (updateData.lines.length>0) {
             var TurnoverLines =  JSON.parse(JSON.stringify(updateData.lines)) ; 
             delete updateData.lines;}
        let sql = `UPDATE turnoversHead SET ? WHERE id=?`;
        connection.query(sql, [updateData, updateData.id], function (err, data) { 
            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
            else 
            {

                connection.query('SELECT *  FROM turnoversLinelist WHERE headid=?' ,[ updateData.id ], 
                function (err, resultslines) { 
                     // Находим записи в БД отсутствующие в запросе и удаляем.
                     resultslines.forEach(function(entry) {
                        if (TurnoverLines.findIndex(x => x.id == entry.id ) == -1) {
                        connection.query('DELETE  FROM turnoversLine WHERE id=?' ,[ entry.id], function (err, data) {
                            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                        });
                       }
                        
                    });
                    // Итерируя Строки в запросе добавляем или  обновляем зписи в Б.Д.
                    TurnoverLines.forEach(function(entry) {
                        entry.headid = updateData.id;
                        entry.id = entry.id || uuidv4();
                        if (resultslines.findIndex(x => x.id == entry.id ) == -1) {
                            connection.query('INSERT INTO  turnoversLine SET ?' ,[entry], function (err, data) {
                                if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                            });
                           }
                           else{
                            connection.query('UPDATE turnoversLine SET ? WHERE id=?' ,[entry, entry.id], function (err, data) {
                            if (err)  {res.statusCode = 409; connection.rollback(); return res.send(err.sqlMessage)}
                        });
                       }
                });
            })

        }
        connection.commit();
        { res.statusCode = 201; res.send("Turnover updated")}

    })
    

  
        }  else { res.status(403).send("Role is no permission")}      
}
   
function _delete(req, res, next) {
    if (["admin","manager"].includes(req.payload.role) ){
        connection.query('DELETE FROM turnoversHead WHERE id=?',[ req.params.id ],  function (err, results) { 
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("Turnover deleted")}  });   
    } else { res.status(403).send("Role is no permission")}
}