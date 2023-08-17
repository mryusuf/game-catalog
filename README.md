# Game Catalog iOS App

See Catalog of various available games, and save to favorite.

## Features
- Fetching Games Catalogs
- Search Games
- Save and Unsave to local Coredata for favorites products 


## 🔧 Setting up Local Development

Required:

- Add RAWG API Key to: `GameCatalog/Data/Config.xcconfig`
- [Xcode 14+](https://developer.apple.com/download) This project was compiled using Xcode 14.2.
- iOS 13 minimum deployment.

## Project Structure

```
GameCatalog                     # Root
 -[Features]                    # User-facing classes (ViewControllers, Views, ViewModels)
 -[Data]                        # API configs, CoreDataModel, Repositories
   -[Remote]                    # Data from API
   -[Local]                     # Local Data
 -[Utils]                       # Utility class. e.g extensions
 -[SupportingFiles]             # AppDelegate, SceneDelegate, Assets
```

## Screenshots

![home](https://raw.githubusercontent.com/mryusuf/game-catalog/main/screenshots/home.png)

![detail](https://raw.githubusercontent.com/mryusuf/game-catalog/main/screenshots/detail.png)


### Built with
- **Swift 5** - compiled on XCode 14.2
- **MVVM** - Model-View-ViewModel Design Pattern
- **UIKit** - Apple UI Framework, both xib and programmatically
- **XCTest** - Unit Testing
- **API from: https://api.rawg.io/docs/**
