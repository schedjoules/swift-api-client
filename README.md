# Swift API Client

This repository contains the API client written in Swift, which is also used by our Swift SDK. Versions 0.8.0+ don't use any external libraries, in order to give our users complete freedom on their pick for Networking solutions.

# Usage
Currently, we support queries to retrieve a single page by an identifer, a localized home page and to search pages.

## Making a request
To send a request (query in our case), first initialize an instance of `SchedJoulesApiClient` with your API access token.
```swift
let apiClient = SchedJoulesApiClient(accessToken: "YOUR_API_ACCESS_TOKEN")
```

After you have an instance, use the `execute` function to execute a query.
```swift
apiClient.execute(query: HomePageQuery(), completion: { result in
            switch result {
            case let .success(page):
                // Do something with the retreived page object
            case let .failure(apiError):
                print(apiError)
            }
        })
 ```
The `execute` function uses a `completion handler` which returns a [Result]
type. Use a `switch` statement to deconstruct the result. 

## Models
The Api Client also includes model classes. These all conform to the `Decodable` protocol and can be decoded from `JSON` data.

## Legacy
If you want to use the latest version supported that includes [Alamofire](https://github.com/Alamofire/Alamofire) and [Result](https://github.com/antitypical/Result) you can point your pod file to the `legacy-0.7.8` branch.
``pod 'SchedJoulesApiClient', :git => 'https://github.com/schedjoules/swift-api-client.git', :branch => 'legacy-0.7.8'
