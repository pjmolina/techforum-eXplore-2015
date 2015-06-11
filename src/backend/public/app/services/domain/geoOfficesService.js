angular.module('myApp').service('GeoOfficesService', ['$http', '$q', 'baseApi', 'QueryBuilderService', function ($http, $q, baseApi, QueryBuilderService) {

	var GeoOfficesService = {};

	var resourceUrl = baseApi + '/geoOffices';
	var fields = null;

	function buildFields() {
		if (!fields) {
			fields = [
			{name: 'name', type: 'string'},
			{name: 'country', type: 'string'},
			{name: 'city', type: 'string'},
			{name: 'address', type: 'string'},
			{name: 'phone', type: 'string'},
			{name: 'position', type: 'geopoint'},
			{name: 'imageUrl', type: 'string'}
				
			];
		}
		return fields;
	}

	//-- Public API -----

	GeoOfficesService.getCount =  function (opts) {
		opts = opts || {};
		opts.fields = opts.fields || buildFields();
		opts.count = true;		
		return QueryBuilderService.buildBaucisQuery(opts).then(function(q) {
		    return $http.get(resourceUrl + q);
		}, function (err) {
		    return $q.reject(err);
		});
	};
	
	GeoOfficesService.getList = function (opts) {
		opts = opts || {};
		opts.fields = opts.fields || buildFields();
		return QueryBuilderService.buildBaucisQuery(opts).then(function(q) {
		    return $http.get(resourceUrl + q);
		}, function (err) {
		    return $q.reject(err);
		});
	};

	function exportQuery(opts) {
		opts = opts || {};
		opts.paginate = false;
		opts.fields = opts.fields || buildFields();
		return QueryBuilderService.buildBaucisQuery(opts).then(function (q) {
		    return q;
		}, function (err) {
		    return $q.reject(err);
		});
	}

	GeoOfficesService.getListAsCsv = function (opts) {
		return exportQuery(opts).then(function (q) {
			return $http({
				method: 'GET', 
				url: resourceUrl + q, 
				headers: {'Accept': 'text/csv'} 
			});
		}, function (err) {
	        return $q.reject(err);
	    });
	};	

	GeoOfficesService.getFileAsCsv = function (opts) {
		return exportQuery(opts).then(function (q) {
			return $http({
				method: 'GET', 
				url: resourceUrl + q, 
				headers: {'Accept': 'text/csv'} 
			});
		}, function (err) {
	        return $q.reject(err);
	    });
	};	
	GeoOfficesService.getFileAsXml = function (opts) {
		return exportQuery(opts).then(function (q) {
			return $http({
				method: 'GET', 
				url: resourceUrl + q, 
				headers: {'Accept': 'text/xml'} 
			});
		}, function (err) {
	        return $q.reject(err);
	    });
	};		
	GeoOfficesService.getFileAsXlsx = function (opts) {
		return exportQuery(opts).then(function (q) {
			return $http({
				method: 'GET', 
				url: resourceUrl + q, 
				headers: {'Accept': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'},
				responseType: 'blob' 
			});
		}, function (err) {
	        return $q.reject(err);
	    });
	};		
	
	GeoOfficesService.get = function (link) {
		return $http.get(link);
	};
	
	GeoOfficesService.getDocument = function (id) {
		return GeoOfficesService.get(resourceUrl + '/' + id );
	};

	GeoOfficesService.add = function (item) {
		return $http.post(resourceUrl, JSON.stringify(item));
	};

	GeoOfficesService.update = function (item) {
		return $http.put(resourceUrl + '/' + item._id, JSON.stringify(item));
	};

	GeoOfficesService.delete = function (id) {
		return $http.delete(resourceUrl + '/' + id);
	};

	GeoOfficesService.deleteMany = function (ids) {
		var msg = { 
			'ids'		: ids
		};	
		return $http.post(resourceUrl + '/deleteByIds', JSON.stringify(msg));
	};	

	GeoOfficesService.deleteByQuery = function (opts) {
		opts = opts || {};
		opts.fields = opts.fields || buildFields();
		opts.paginate = false;		
		return QueryBuilderService.buildBaucisQuery(opts).then(function (q) {
			return $http.delete(resourceUrl + q);
		}, function (err) {
		    return $q.reject(err);
		});
	};
	
	return GeoOfficesService;

}]);
