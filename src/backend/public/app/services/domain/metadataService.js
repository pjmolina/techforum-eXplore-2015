angular.module('myApp').service('MetadataService', [function () {
	var MetadataService = {};


	var metaData = {
		"office" 		: 	["name","country","city","address","phone","imageUrl"],
		"country" 		: 	["name"],
		"solution" 		: 	["category","service"],
		"geoOffices" 		: 	["name","country","city","address","phone","position","imageUrl"]	};

	MetadataService.getPropertiesFor = function (className) {
		return (metaData[className] || [] ).slice(0);
	};

	MetadataService.getResourceList = function() {
		return [{
			key: 'offices',
			value: 'Offices'	
		}, {
			key: 'countries',
			value: 'Countries'	
		}, {
			key: 'solutions',
			value: 'Solutions'	
		}, {
			key: 'geoOffices',
			value: 'GeoOffices'	
		}];
	};

	return MetadataService;

}]);
