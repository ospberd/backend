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
router.get('/chktoken' ,auth, chktoken);
router.get('/',  auth, getAll); 
router.get('/:id', getById);

router.post('/', create);
router.post('/login', login);
router.put('/:id', update);
router.put('/password/:id', setPassword);
router.delete('/:id', _delete);

module.exports = router;

// route functions

function chktoken(req, res, next) {
    res.statusCode = 200;
    res.send('Token OK');
}

function login(req, res, next) {
    connection.query('SELECT *  FROM users WHERE login = ?',[req.body.login], 
    function (err, results) { 
      if (results.length ==1) {
        // Пользователь найден проверяем пароль если верен возвращаем токен
        if (results[0].password == req.body.password) 
           { delete results[0].password;
             delete results[0].login;
             const token = jwt.sign( results[0],config.token.password ,{expiresIn: "12h", } );
            results[0].token = token;
                res.json(results[0]);}
        else {res.statusCode = 401;
            res.send("Incorect password !!!!!!")};
        }
        else {res.statusCode = 401;
            res.send("Login not found")};
    })

}

function getAll(req, res, next) {
    if (["client"].includes(req.payload.role) ){
        connection.query("SELECT * FROM userslist WHERE id=?",[ req.payload.id],  function(err, results, fields) {
            res.statusCode = 200;
            res.json(results.map(item => {
                delete item.password ;
                return item  }));
        }); 
    }
    else if (["admin","manager"].includes(req.payload.role) ) {   
        connection.query("SELECT * FROM userslist", function(err, results, fields) {
            res.statusCode = 200;
            res.json(results.map(item => {
                delete item.password ;
                return item  }));
        }); }
    else { res.statusCode = 403;
           res.send = "Forbidden" }

}

function getById(req, res, next) {
    connection.query('SELECT *  FROM userslist WHERE id=?',[ req.params.id ], 
        function (err, results) { 
          if (results.length ==1)   delete results[0].password ;
          res.statusCode = 200;
            res.json(results);}); 
}

function create(req, res, next) {
    let updateData=req.body;
    updateData.id = uuidv4();
    let sql = `INSERT INTO users SET ?`;
    
    connection.query(sql, [updateData], function (err, data)  { 
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 201; res.send("User created")}  });   
}; 
     
function update(req, res, next) {
    
    let id= req.params.id;
    let updateData=req.body;
    updateData.id = ""; delete updateData.id;
    updateData.password = ""; delete updateData.password;
    updateData.login = ""; delete updateData.login;
    let sql = `UPDATE users SET ? WHERE id= ?`;
    connection.query(sql, [updateData, id], function (err, data) {
        if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
        else { res.statusCode = 202; res.send("User updated")}  });   

    
}
   
function setPassword(req, res, next) {
    
    let id= req.params.id;
    let newPassword=req.body;

    let sql = `UPDATE users SET ? WHERE id= ?`;

    connection.query(sql, [newPassword, id], function (err, data) {
    if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
    else { res.statusCode = 202; res.send("Password updated")}  });   

}

function _delete(req, res, next) {
    connection.query(
        'DELETE FROM users WHERE id=?',[ req.params.id ], function (err, results) { 
            if (err)  {res.statusCode = 409; return res.send(err.sqlMessage)}
            else { res.statusCode = 202; res.send("User deleted")}  });  
}