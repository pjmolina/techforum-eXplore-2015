angular.module('myApp').controller('DeleteSolutionController', ['$scope', '$routeParams', '$location', 'SolutionService', function($scope, $routeParams, $location, SolutionService) {

	function init() {
		$scope.solution = {};
		$scope.dataReceived = false;

		if($location.path() !== '/solution/delete') {
			SolutionService.getDocument($routeParams.id).then(function (httpResponse) {
				$scope.solution = httpResponse.data;
				$scope.dataReceived = true;
			});
		} else {
			$scope.dataReceived = true;
		}
	}

	$scope.delete = function () {
		SolutionService.delete($scope.solution._id).then(function () {
			$location.path('/solution/');
		});
	};

	$scope.cancel = function () {
		$location.path('/solution/');
	};

	init();

}]);
