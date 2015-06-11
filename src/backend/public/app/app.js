
// SampleBackend
angular.module('myApp', ['ngRoute', 'ngCookies', 'ui.bootstrap', 'textAngular', 'pascalprecht.translate', 'translateApp', 'geolocation', 'ngMap'])
	.config(['$routeProvider', function ($routeProvider) {
		$routeProvider
			.when('/',	                   		{ templateUrl: 'views/main.html',  controller: 'MainController' })
			.when('/login',                   	{ templateUrl: 'views/login.html',  controller: 'LoginController' })
			.when('/logout',                    { templateUrl: 'views/logout.html', controller: 'LogoutController' })
			.when('/import/:class', 			{ templateUrl: 'views/import.html', controller: 'ImportController' })

			.when('/office/',			 { templateUrl: 'views/office/list.html',   controller: 'ListOfficeController' })
			.when('/office/select',	 { templateUrl: 'views/office/select.html', controller: 'SelectOfficeController' })
			.when('/office/add',        { templateUrl: 'views/office/edit.html',   controller: 'EditOfficeController' })
			.when('/office/edit/:id', 	 { templateUrl: 'views/office/edit.html',   controller: 'EditOfficeController' })
			.when('/office/delete/:id', { templateUrl: 'views/office/edit.html', 	 controller: 'EditOfficeController' })
			.when('/office/view/:id', 	 { templateUrl: 'views/office/edit.html', 	 controller: 'EditOfficeController' })
			.when('/country/',			 { templateUrl: 'views/country/list.html',   controller: 'ListCountryController' })
			.when('/country/select',	 { templateUrl: 'views/country/select.html', controller: 'SelectCountryController' })
			.when('/country/add',        { templateUrl: 'views/country/edit.html',   controller: 'EditCountryController' })
			.when('/country/edit/:id', 	 { templateUrl: 'views/country/edit.html',   controller: 'EditCountryController' })
			.when('/country/delete/:id', { templateUrl: 'views/country/edit.html', 	 controller: 'EditCountryController' })
			.when('/country/view/:id', 	 { templateUrl: 'views/country/edit.html', 	 controller: 'EditCountryController' })
			.when('/solution/',			 { templateUrl: 'views/solution/list.html',   controller: 'ListSolutionController' })
			.when('/solution/select',	 { templateUrl: 'views/solution/select.html', controller: 'SelectSolutionController' })
			.when('/solution/add',        { templateUrl: 'views/solution/edit.html',   controller: 'EditSolutionController' })
			.when('/solution/edit/:id', 	 { templateUrl: 'views/solution/edit.html',   controller: 'EditSolutionController' })
			.when('/solution/delete/:id', { templateUrl: 'views/solution/edit.html', 	 controller: 'EditSolutionController' })
			.when('/solution/view/:id', 	 { templateUrl: 'views/solution/edit.html', 	 controller: 'EditSolutionController' })
			.when('/geoOffices/',			 { templateUrl: 'views/geoOffices/list.html',   controller: 'ListGeoOfficesController' })
			.when('/geoOffices/select',	 { templateUrl: 'views/geoOffices/select.html', controller: 'SelectGeoOfficesController' })
			.when('/geoOffices/add',        { templateUrl: 'views/geoOffices/edit.html',   controller: 'EditGeoOfficesController' })
			.when('/geoOffices/edit/:id', 	 { templateUrl: 'views/geoOffices/edit.html',   controller: 'EditGeoOfficesController' })
			.when('/geoOffices/delete/:id', { templateUrl: 'views/geoOffices/edit.html', 	 controller: 'EditGeoOfficesController' })
			.when('/geoOffices/view/:id', 	 { templateUrl: 'views/geoOffices/edit.html', 	 controller: 'EditGeoOfficesController' })

			.when('/admin/webHooks/', { templateUrl: 'views/admin/webHooks.html', controller: 'AdminWebHooksController' })
			.when('/admin/apiKeys/',  { templateUrl: 'views/admin/apiKeys.html', controller: 'AdminApiKeysController' })

			.when('/403',  		 	 { templateUrl: 'views/403.html' })

			.otherwise({ redirectTo: '/login' });
	}])

	.constant('AUTH_EVENTS', {
		loginSuccess: 'auth-login-success',
		loginFailed: 'auth-login-failed',
		logoutSuccess: 'auth-logout-success',
		sessionTimeout: 'auth-session-timeout',
		notAuthenticated: 'auth-not-authenticated',
		notAuthorized: 'auth-not-authorized'
	})

	.constant('USER_ROLES', {
		admin: 'admin'
	})

	.run(['$rootScope', '$location', 'Session', function($rootScope, $location, Session) {
		// register listener to watch route changes
		$rootScope.$on( "$routeChangeStart", function(event, next, current) {
			if ( $rootScope.isLogged !== true  ) {
				if ( next.templateUrl == "views/login.html" ) {
				  // already going to #login, no redirect needed
				} else {
					// not going to #login, we should redirect now (and store current route for later redirect)
					$rootScope.requestedRoute = $location.path();
					$location.path( "/login" );
				}
			}
			else {
				//logged. Check Role Authorization
				if ( next.templateUrl && (next.templateUrl.substr(0, 12) === "views/admin/") ) {
					if (!Session.userHasRole("Admin")) {
						$location.path( "/403" );
					}
				}
			}		  			
		});
	}])
;

angular.module('myApp').value('baseUrl', 			'');
angular.module('myApp').value('baseApi', 			'/api');
angular.module('myApp').value('documentationUrl', 	'/api/documentation');

