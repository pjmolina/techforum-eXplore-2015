angular.module('myApp').controller('DeleteGeoOfficesController', ['$scope', '$routeParams', '$location', 'GeoOfficesService', function($scope, $routeParams, $location, GeoOfficesService) {

	function init() {
		$scope.geoOffices = {};
		$scope.dataReceived = false;

		if($location.path() !== '/geoOffices/delete') {
			GeoOfficesService.getDocument($routeParams.id).then(function (httpResponse) {
				$scope.geoOffices = httpResponse.data;
				$scope.dataReceived = true;
			});
		} else {
			$scope.dataReceived = true;
		}
	}

	$scope.delete = function () {
		GeoOfficesService.delete($scope.geoOffices._id).then(function () {
			$location.path('/geoOffices/');
		});
	};

	$scope.cancel = function () {
		$location.path('/geoOffices/');
	};

	init();

}]);
