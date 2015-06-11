//Create test data for backend services
var mongoose = require('mongoose');

var models = require('./model');

var dbName = process.env.MONGOLAB_URI || 'mongodb://localhost:27017/DemoDb';
mongoose.connect(dbName);


// Clear the database of old data
mongoose.model('office').remove(function (error) {
  if (error) {
  	throw error;
  }
});
mongoose.model('country').remove(function (error) {
  if (error) {
  	throw error;
  }
});
mongoose.model('solution').remove(function (error) {
  if (error) {
  	throw error;
  }
});
mongoose.model('geoOffices').remove(function (error) {
  if (error) {
  	throw error;
  }
});

console.log('Data deleted on: ' + dbName);

// Put the fresh data in the database
//Data for Office ---------------------------
console.log('  Creating data for  Office.');

mongoose.model('office').create( {
		name: 'Name0',
		country: 'Country1',
		city: 'City2',
		address: 'Address3',
		phone: 'Phone4',
		imageUrl: 'ImageUrl5'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('office').create( {
		name: 'Name6',
		country: 'Country7',
		city: 'City8',
		address: 'Address9',
		phone: 'Phone10',
		imageUrl: 'ImageUrl11'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('office').create( {
		name: 'Name12',
		country: 'Country13',
		city: 'City14',
		address: 'Address15',
		phone: 'Phone16',
		imageUrl: 'ImageUrl17'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('office').create( {
		name: 'Name18',
		country: 'Country19',
		city: 'City20',
		address: 'Address21',
		phone: 'Phone22',
		imageUrl: 'ImageUrl23'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('office').create( {
		name: 'Name24',
		country: 'Country25',
		city: 'City26',
		address: 'Address27',
		phone: 'Phone28',
		imageUrl: 'ImageUrl29'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
//Data for Country ---------------------------
console.log('  Creating data for  Country.');

mongoose.model('country').create( {
		name: 'Name30'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('country').create( {
		name: 'Name31'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('country').create( {
		name: 'Name32'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('country').create( {
		name: 'Name33'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('country').create( {
		name: 'Name34'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
//Data for Solution ---------------------------
console.log('  Creating data for  Solution.');

mongoose.model('solution').create( {
		category: 'Category35',
		service: 'Service36'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('solution').create( {
		category: 'Category37',
		service: 'Service38'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('solution').create( {
		category: 'Category39',
		service: 'Service40'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('solution').create( {
		category: 'Category41',
		service: 'Service42'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('solution').create( {
		category: 'Category43',
		service: 'Service44'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
//Data for GeoOffices ---------------------------
console.log('  Creating data for  GeoOffices.');

mongoose.model('geoOffices').create( {
		name: 'Name45',
		country: 'Country46',
		city: 'City47',
		address: 'Address48',
		phone: 'Phone49',
		position: 'Position geopoint 50',
		imageUrl: 'ImageUrl51'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('geoOffices').create( {
		name: 'Name52',
		country: 'Country53',
		city: 'City54',
		address: 'Address55',
		phone: 'Phone56',
		position: 'Position geopoint 57',
		imageUrl: 'ImageUrl58'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('geoOffices').create( {
		name: 'Name59',
		country: 'Country60',
		city: 'City61',
		address: 'Address62',
		phone: 'Phone63',
		position: 'Position geopoint 64',
		imageUrl: 'ImageUrl65'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('geoOffices').create( {
		name: 'Name66',
		country: 'Country67',
		city: 'City68',
		address: 'Address69',
		phone: 'Phone70',
		position: 'Position geopoint 71',
		imageUrl: 'ImageUrl72'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);
mongoose.model('geoOffices').create( {
		name: 'Name73',
		country: 'Country74',
		city: 'City75',
		address: 'Address76',
		phone: 'Phone77',
		position: 'Position geopoint 78',
		imageUrl: 'ImageUrl79'
	}, function (error) { 
		if (error) {
			throw error;
		} 
	}
);

console.log('Fake Data created on: ' + dbName);
