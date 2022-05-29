# Series Catalog
App presentes the series and related episodes available at [TV Maze API](https://www.tvmaze.com/api). Main features are:
* List all series available
* Search series by name
* See Series Details
* See Episodes Details

### Demo
![Alt Text](/AppPreview.gif)

## Prerequisites
* [Xcode](https://developer.apple.com/xcode/) Version 13.4

## Dependency Manager
* Project uses [Swift Package Manager](https://www.swift.org/package-manager/) as the Dependency Manager.
* Dependencies used:
    * [SDWebImage](https://github.com/SDWebImage/SDWebImage)

## Architecture
* State MVVM + Combine Architecture

## UI
* App is based on pure TableView and Collections Views. To construct custom UIs, I've used Xibs for TableView and CollectionView Cells when necessary.
