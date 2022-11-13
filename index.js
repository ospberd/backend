
const mysql = require("mysql2");
const config = require("./config.js")
var cors = require('cors')
const express = require('express'),
        app = express();
        app.use(cors());
        app.options('*', cors());
        app.use(express.json());
        

        app.use('/api/users', require('./users.controller'));
        app.use('/api/goods', require('./goods.controller'));
        app.use('/api/payments', require('./payments.controller'));
        app.use('/api/demands', require('./demands.controller'));
        app.use('/api/turnovers', require('./turnovers.controller'));
        app.use('/api/reports', require('./reports.controller'));
        app.use('/api/compositions', require('./compositions.controller'));


//Слушание запросов на порту 3000, и в качестве каллбака функция, которая пишет в лог
app.listen(config.app.port, config.app.host, () => console.log(`Server listens http://${config.app.host}:${config.app.port}`));
