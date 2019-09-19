![](https://media.giphy.com/media/kfLrsvExow4ixZ7ZLT/giphy.gif)

# SwiftyUnsplashKit

Lightweight Swift kit used to present Unsplash search view and select image along with its url. Adheres to [Unsplash API guidelines](https://help.unsplash.com/en/articles/2511245-unsplash-api-guidelines) of using hot-linked image urls and crediting author during image selection (similar to Trello). See [Unsplash API documentation](https://unsplash.com/documentation) for more details.

## Getting Started

### Prerequisites

* Must use Swift 4.2+
* Requires Unsplash API access token which requires a [developer account](https://unsplash.com/oauth/applications).

## Installation

#### CocoaPods

To integrate SwiftyUnsplashKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SwiftyUnsplashKit'
```
## Using application

Simply initiate a UnsplashSearchPresenter object , configure the delegate to whichever object will be using the Unsplash image/info, and call UnsplashSearchPresenter.openUnsplashView() to present the Unsplash search/picker view. 

## Architectural Pattern


## Dependencies

* No dependencies although may use Kingfisher in future for local persistence. 

## Authors

* [Ever Uribe](https://github.com/everuribe)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


