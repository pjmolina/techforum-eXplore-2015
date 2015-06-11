angular.module('myApp').controller('ViewOfficeController', ['$scope', '$routeParams', '$location', 'OfficeService', function($scope, $routeParams, $location, OfficeService) {

	function init() {
		$scope.office = {
			name : null, 
			country : null, 
			city : null, 
			address : null, 
			phone : null, 
			imageUrl : null 
		
		};
		$scope.dataReceived = false;

		OfficeService.getDocument($routeParams.id).then(function (httpResponse) {
			$scope.office = httpResponse.data;
			$scope.dataReceived = true;
		});

	}

	$scope.gotoList = function (event) {
		$location.path('/office/');
	};	
	$scope.edit = function (event) {
		$location.path('/office/edit/' + $scope.office._id );
	};

	init();

}]);
