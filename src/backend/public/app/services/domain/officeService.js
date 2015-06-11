angular.module('myApp').service('OfficeService', ['$http', '$q', 'baseApi', 'QueryBuilderService', function ($http, $q, baseApi, QueryBuilderService) {

	var OfficeService = {};

	var resourceUrl = baseApi + '/offices';
	var fields = null;

	function buildFields() {
		if (!fields) {
			fields = [
			{name: 'name', type: 'string'},
			{name: 'country', type: 'string'},
			{name: 'city', type: 'string'},
			{name: 'address', type: 'string'},
			{name: 'phone', type: 'string'},
			{name: 'imageUrl', type: 'string'}
				
			];
		}
		return fields;
	}

	//-- Public API -----

	OfficeService.getCount =  function (opts) {
		opts = opts || {};
		opts.fields = opts.fields || buildFields();
		opts.count = true;		
		return QueryBuilderService.buildBaucisQuery(opts).then(function(q) {
		    return $http.get(resourceUrl + q);
		}, function (err) {
		    return $q.reject(err);
		});
	};
	
	OfficeService.getList = function (opts) {
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

	OfficeService.getListAsCsv = function (opts) {
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

	OfficeService.getFileAsCsv = function (opts) {
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
	OfficeService.getFileAsXml = function (opts) {
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
	OfficeService.getFileAsXlsx = function (opts) {
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
	
	OfficeService.get = function (link) {
		return $http.get(link);
	};
	
	OfficeService.getDocument = function (id) {
		return OfficeService.get(resourceUrl + '/' + id );
	};

	OfficeService.add = function (item) {
		return $http.post(resourceUrl, JSON.stringify(item));
	};

	OfficeService.update = function (item) {
		return $http.put(resourceUrl + '/' + item._id, JSON.stringify(item));
	};

	OfficeService.delete = function (id) {
		return $http.delete(resourceUrl + '/' + id);
	};

	OfficeService.deleteMany = function (ids) {
		var msg = { 
			'ids'		: ids
		};	
		return $http.post(resourceUrl + '/deleteByIds', JSON.stringify(msg));
	};	

	OfficeService.deleteByQuery = function (opts) {
		opts = opts || {};
		opts.fields = opts.fields || buildFields();
		opts.paginate = false;		
		return QueryBuilderService.buildBaucisQuery(opts).then(function (q) {
			return $http.delete(resourceUrl + q);
		}, function (err) {
		    return $q.reject(err);
		});
	};
	
	return OfficeService;

}]);
