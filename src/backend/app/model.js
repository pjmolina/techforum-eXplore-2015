//Data model for Backend-Services  ---------------

var conf = require('./conf/configuration').getConfiguration();
var mongoose = require('mongoose');
var crypto = require('crypto');

var ObjectId = mongoose.Schema.Types.ObjectId;

// Create Mongoose schemas
var OfficeSchema = new mongoose.Schema({ 
  	name: { type: String, required: true },
	country: { type: String, required: true },
	city: { type: String, required: true },
	address: { type: String, required: true },
	phone: { type: String, required: true },
	imageUrl: { type: String, required: true }
});

var CountrySchema = new mongoose.Schema({ 
  	name: { type: String, required: true }
});

var SolutionSchema = new mongoose.Schema({ 
  	category: { type: String, required: true },
	service: { type: String, required: true }
});

var GeoOfficesSchema = new mongoose.Schema({ 
  	name: { type: String, required: true },
	country: { type: String, required: true },
	city: { type: String, required: true },
	address: { type: String, required: true },
	phone: { type: String, required: true },
	position: { 
        type: {
          type: String,
          required: true,
          enum: ['Point', 'LineString', 'Polygon'],
          default: 'Point'
        },
        coordinates: { type: [Number], required: true }
      }
,
	imageUrl: { type: String, required: true }
});

GeoOfficesSchema.index({ 'position': '2dsphere' });  

//Internal setting -----
var ConfigSchemaInternal = new mongoose.Schema({ 
    key: { type: String, required: true },
    value: { type: String, required: false }
});

var WebParameterSchemaInternal = new mongoose.Schema({ 
    type:  { type: String, required: true },
    key:   { type: String, required: true },
    value: { type: String, required: false }
});

var WebhooksSchemaInternal = new mongoose.Schema({ 
    resource: { type: String, required: true },
    operation: { type: String, required: true },
    httpMethod: { type: String, required: true },
    urlTemplate: { type: String, required: true },
    parameters: [ WebParameterSchemaInternal ]
});

var ApiKeysSchemaInternal = new mongoose.Schema({ 
    username: { type: String, required: true },
    password: { type: String, required: true }, //get: decryptField, set: encryptField
    createdAt: { type: Date, required: true, default: Date.now },
    lastAccessOn: { type: Date, required: false },
    enabled: { type: Boolean, required: true },
    role: { type: String, required: true },
    description: { type: String, required: false }
});


//Create full text indexes (experimental)--- 
/*
    OfficeSchema.index({
    	name: 'text',
		country: 'text',
		city: 'text',
		address: 'text',
		phone: 'text',
		imageUrl: 'text'    
    });
    CountrySchema.index({
    	name: 'text'    
    });
    SolutionSchema.index({
    	category: 'text',
		service: 'text'    
    });
    GeoOfficesSchema.index({
    	name: 'text',
		country: 'text',
		city: 'text',
		address: 'text',
		phone: 'text',
		imageUrl: 'text'    
    });
*/

//--- Encription 
var cryptProtocolPrefix = "_#cryp0:";  //do not change <- constant

function decryptField(text){
    if (text === null || typeof text === 'undefined') {
        return text;
    }
    if (!startsWith(text, cryptProtocolPrefix)) {
        return text; //stored as plain text
    }

    var inputData = text.substr(cryptProtocolPrefix.length);  //retrieve payload
    return decrypt2(inputData);
}

function encryptField(text){
    if (text === null || typeof text === 'undefined') {
        return text;
    }
    if (startsWith(text, cryptProtocolPrefix)) {
        return text; //alredy encrypted
    }
    return cryptProtocolPrefix + encrypt2(text);  //encrypt always
} 

function startsWith(str, substrTarget){
    if (str == null) {
        return false;
    }
    var res = str.substr(0, substrTarget.length) == substrTarget;
    return res;
}

//AES Cryp function AES-256-CBC
function encrypt2(text){
    var cipher = crypto.createCipher('aes-256-cbc', conf.security.serverSecret);
    var crypted = cipher.update(text,'utf8','base64');
    crypted += cipher.final('base64');
    return crypted;
} 

function decrypt2(text){
    if (text === null || typeof text === 'undefined') {
        return text;
    }
    var decipher = crypto.createDecipher('aes-256-cbc', conf.security.serverSecret);
    var dec = decipher.update(text,'base64','utf8');
    dec += decipher.final('utf8');
    return dec;
}



// Sample to inject operations into mongoose schemas
//UserSchema.pre('save', function (next) {
//  console.log('A User was saved to MongoDB: %s.', this.get('firstName'));
//  next();
//});

var propertiesForClass = {
	"office" : ['name', 'country', 'city', 'address', 'phone', 'imageUrl'],
	"country" : ['name'],
	"solution" : ['category', 'service'],
	"geoOffices" : ['name', 'country', 'city', 'address', 'phone', 'position', 'imageUrl']  
};
 
function buildModelForSchema(container, entityName, pluralName, schema) {
  var entityModel = mongoose.model(entityName, schema);
  entityModel.plural(pluralName);

  container[entityName] = {
    'name': entityName,
    'plural': pluralName,
    'schema': schema, 
    'model': entityModel
  };
}
function getModelForClass(className) {
  var item = models[className];
  if (item == null) {
    return null;
  }
  return item.model;
}
function getMetadataForClass(className) {
  var item = models[className];
  return item;
}

//Models --------------------------------
var models = {};

buildModelForSchema(models, '_config',   'admin-config',   ConfigSchemaInternal);
buildModelForSchema(models, '_webhooks', 'admin-webhooks', WebhooksSchemaInternal);
buildModelForSchema(models, '_apikeys',  'admin-apikeys',  ApiKeysSchemaInternal);

// Register the schema and export it
buildModelForSchema(models, 'office', 'offices', OfficeSchema);
buildModelForSchema(models, 'country', 'countries', CountrySchema);
buildModelForSchema(models, 'solution', 'solutions', SolutionSchema);
buildModelForSchema(models, 'geoOffices', 'geoOffices', GeoOfficesSchema);

// Register the schema and export it
module.exports.models         = models;
module.exports.getModelForClass   = getModelForClass;
module.exports.propertiesForClass   = propertiesForClass;
module.exports.getMetadataForClass = getMetadataForClass;

