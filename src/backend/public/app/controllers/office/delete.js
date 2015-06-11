angular.module('myApp').controller('DeleteOfficeController', ['$scope', '$routeParams', '$location', 'OfficeService', function($scope, $routeParams, $location, OfficeService) {

	function init() {
		$scope.office = {};
		$scope.dataReceived = false;

		if($location.path() !== '/office/delete') {
			OfficeService.getDocument($routeParams.id).then(function (httpResponse) {
				$scope.office = httpResponse.data;
				$scope.dataReceived = true;
			});
		} else {
			$scope.dataReceived = true;
		}
	}

	$scope.delete = function () {
		OfficeService.delete($scope.office._id).then(function () {
			$location.path('/office/');
		});
	};

	$scope.cancel = function () {
		$location.path('/office/');
	};

	init();

}]);
