angular.module('myApp').controller('ViewGeoOfficesController', ['$scope', '$routeParams', '$location', 'GeoOfficesService', function($scope, $routeParams, $location, GeoOfficesService) {

	function init() {
		$scope.geoOffices = {
			name : null, 
			country : null, 
			city : null, 
			address : null, 
			phone : null, 
			position : null, 
			imageUrl : null 
		
		};
		$scope.dataReceived = false;

		GeoOfficesService.getDocument($routeParams.id).then(function (httpResponse) {
			$scope.geoOffices = httpResponse.data;
			$scope.dataReceived = true;
		});

	}

	$scope.gotoList = function (event) {
		$location.path('/geoOffices/');
	};	
	$scope.edit = function (event) {
		$location.path('/geoOffices/edit/' + $scope.geoOffices._id );
	};

	init();

}]);
