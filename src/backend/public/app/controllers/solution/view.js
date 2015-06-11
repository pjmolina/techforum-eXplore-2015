angular.module('myApp').controller('ViewSolutionController', ['$scope', '$routeParams', '$location', 'SolutionService', function($scope, $routeParams, $location, SolutionService) {

	function init() {
		$scope.solution = {
			category : null, 
			service : null 
		
		};
		$scope.dataReceived = false;

		SolutionService.getDocument($routeParams.id).then(function (httpResponse) {
			$scope.solution = httpResponse.data;
			$scope.dataReceived = true;
		});

	}

	$scope.gotoList = function (event) {
		$location.path('/solution/');
	};	
	$scope.edit = function (event) {
		$location.path('/solution/edit/' + $scope.solution._id );
	};

	init();

}]);
