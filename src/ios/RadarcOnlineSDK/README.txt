Before starting
---------------
1.- Install cocoapods (if needed) - http://guides.cocoapods.org/using/getting-started.html
    * sudo gem update --system
    * sudo gem install cocoapods
    * pod setup

2.- Create workspace
    * pod install

3.- Open workspace and enjoy  

Update RadarcOnlinSDK library (debug)
-------------------------------------

1.- Open workspace

2.- Apply changes

3.- Select BuildLibraryDebug target

4.- Run target

Create and add RadarcOnlineSDK library (production)
---------------------------------------------------

1.- Open workspace

2.- Apply changes (optional)

3.- Select BuildLibrary target

4.- Run target

5.- Open your app project

6.- Remove reference to debug library (in group IOSApp/RadarcOnlineSDK/)

7.- Add generated library to group IOSApp/RadarcOnlineSDK/

Libraries
---------
Your application have been created using Open Source software. Please double-check the source code of the application to determine which open source files are in your application and then comply with any license requirements. 

For more information on open source licenses used by Radarc Online, review the following:

    AFNetworking
    https://github.com/AFNetworking/AFNetworking

    SVProgressHUD
    https://github.com/TransitApp/SVProgressHUD

    ECSlidingViewController
    https://github.com/ECSlidingViewController/ECSlidingViewController

    XMLDictionary
    https://github.com/nicklockwood/XMLDictionary

    SVPullToRefresh
    https://github.com/samvermette/SVPullToRefresh

    Colours
    https://github.com/bennyguitar/Colours

    NSUserDefaults-AESEncryptor
    https://github.com/NZN/NSUserDefaults-AESEncryptor

    CorePlot
    https://github.com/core-plot/core-plot

    DCKeyValueObjectMapping
    https://github.com/dchohfi/KeyValueObjectMapping

    SDWebImage
    https://github.com/rs/SDWebImage

    UIActivityIndicator-for-SDWebImage
    https://github.com/JJSaccolo/UIActivityIndicator-for-SDWebImage