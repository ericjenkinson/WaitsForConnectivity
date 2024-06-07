# Network Connectivity Demo with SwiftUI

This SwiftUI app demonstrates how to use `URLSessionConfiguration.waitsForConnectivity` to handle network requests when there is no connectivity. The app includes a button to initiate a network request and provides feedback to the user about the network status using messages and an activity indicator.

## Features

- A button to start a network request.
- An activity indicator to show the request is in progress.
- Messages to inform the user about the network status and request outcome.
- Use of `waitsForConnectivity` to wait for network availability instead of failing immediately.

## Explanation of `waitsForConnectivity`

The `waitsForConnectivity` property of `URLSessionConfiguration` allows the app to wait for network connectivity if the device is currently offline. This is useful for making network requests more resilient to temporary connectivity issues.

### Example Usage

Here's a snippet demonstrating the use of `waitsForConnectivity` in the app:

```swift
func fetchData(from url: URL) async throws -> Data {
    let configuration = URLSessionConfiguration.default
    configuration.waitsForConnectivity = true
    configuration.timeoutIntervalForResource = 60 // 60 seconds timeout for the whole resource load

    let session = URLSession(configuration: configuration)

    let (data, response) = try await session.data(from: url)

    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }

    return data
}

In this example:

- `waitsForConnectivity` is set to `true`, meaning the request will wait for network connectivity to be restored rather than failing immediately.
- `timeoutIntervalForResource` is set to 60 seconds, specifying the maximum amount of time to wait for the request to complete, including waiting for connectivity.

## App Structure

- **ContentView**: The main view containing the button, activity indicator, and messages.
- **startNetworkRequest**: A function that initiates the network request and updates the UI state.
- **fetchData**: A function that performs the actual network request using `URLSession`.

## How to Run the App

1. Clone the repository.
2. Open the project in Xcode.
3. Run the app on a simulator or a real device.
4. Press the "Start Network Request" button to initiate a network request.

## Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.3+

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Apple Developer Documentation on [URLSessionConfiguration](https://developer.apple.com/documentation/foundation/urlsessionconfiguration)
- SwiftUI documentation and examples

## Contact

For any questions or feedback, please open an issue or contact the maintainer.

