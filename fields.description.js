const fields = {
        goods:  { id: 'string', groupname: 'string',  goods: 'string',  description: 'string',
                picture: 'string',  measure: 'string',  price: 'decimal', barcode: 'string'  },

        demandsHead:  { id: 'string', docdate: 'datetime',  docnumber: 'integer',  userid: 'string',
                totalDemand: 'decimal',  totalConfirm: 'decimal',  comment: 'string', opened: 'integer'  },

        demandsLine:  { id: 'string', headid: 'string',  goodsid: 'string',  
                quantityDemand: 'decimal', priceDemand: 'decimal', totalDemand: 'decimal',
                quantityConfirm: 'decimal', priceConfirm: 'decimal', totalConfirm: 'decimal',  },

        payments:  { id: 'string', docdate: 'datetime',  userid: 'string',  
                inpay: 'decimal',  outpay: 'decimal',  comment: 'string'  },

        turnoversHead:  { id: 'string', demandid: 'string', docdate: 'datetime',  docnumber: 'integer',  userid: 'string',
                totalin: 'decimal',  totalout: 'decimal',  comment: 'string', delivered: 'integer', returned: 'integer'  },

        turnoversLine:  { id: 'string', headid: 'string',  goodsid: 'string',  
                quantityin: 'decimal', quantityout: 'decimal', pricein: 'decimal', priceout: 'decimal',
                totalin: 'decimal', totalout: 'decimal' },

        users:  { id: 'string', fullname: 'string',  phonenumber: 'string',  email: 'string',
                deliveryaddress: 'string',  role: 'string',  login: 'string',  password: 'string'  },
        };


function agree(tableName,incoming) {
    let outcoming = {};
    let tableStructure ={};
    if (fields.hasOwnProperty(tableName)) 
        { //ToDo: If table does not exist then read table structure from database
             tableStructure = fields[tableName];
        }; 
        
    Object.entries(incoming).forEach(field => {
        const [dataName,dataValue] = field;
        if (tableStructure.hasOwnProperty(dataName)) 
            { //ToDo: Convert dataValue to right type
            outcoming[dataName] = dataValue; };  
            });
    return outcoming ;
  } 
  module.exports = agree ;
 
