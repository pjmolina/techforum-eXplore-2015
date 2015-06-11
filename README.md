# Techforum eXplore 2015 Materials
-----------------------------------

Material presented in **Worldline TechForum eXplore 2015** at Seclin, France, EU on June 3rd, 2015. 

1. Slides at `slides/` folder.
2. Sample data at `data/eXplore.xlsx`
3. Data was imported into [AppNow](https://appnow.radarconline.com) to derive the following model `model/appnow-model.txt`

	Model:

	```
	class Office
	{
		string Name;
		string Country;
		string City;
		string Address;
		string Phone;
		string ImageUrl;
	}
	class Country
	{
		string Name;
	}
	class Solution
	{
		string Category;
		string Service;
	}
	class GeoOffices
	{
		string Name;
		string Country;
		string City;
		string Address;
		string Phone;
		geopoint Position;
		string ImageUrl;
	}
	```

4. Derived from the model, a backend was deployed on heroku: [https://techforum-explore.herokuapp.com](https://techforum-explore.herokuapp.com) User/pass: `admin/icinetic` 
   - See full source code at `src/backend`. 
   - Main features: 
		- MEAN Stack
		- Microservice oriented
		- Swagger API Docs v. 1.1 & 2.0
		- Scripts for docker & docker compose provided
		- Ready to deploy on cloud infrastructure: heroku, IBM Bluemix, Cloudshare, localhost
		- AngularJS Administrative UI 
5. [RadarcOnline](https://www.radarconline.com) was used to create and generate an iOS and Android native mobile apps.
   - See full source code at `src/ios` and `src/android` 
   
-----------------------------------

## More info:

- [AppNow](https://appnow.radarconline.com)
- [Radarc Online](https://www.radarconline.com)
- [Essential](http://pjmolina.com/essential)
 
