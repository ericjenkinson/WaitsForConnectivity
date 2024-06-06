//
//  ContentView.swift
//  WaitsForConnectivity
//
//  Created by Eric Jenkinson on 6/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var message: String = "Press the button to start the network request."
    @State private var isRequesting: Bool = false

    var body: some View {
        ZStack {
            VStack {
                Text(message)
                    .padding()

                Button(action: {
                    Task {
                        await startNetworkRequest()
                    }
                }) {
                    Text("Start Network Request")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(isRequesting)
            }
            if isRequesting {
                ProgressView()
                    .controlSize(.extraLarge)
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.red)
                    .padding()
            }
        }
        .padding()
    }

    func startNetworkRequest() async {
        isRequesting = true
        message = "Attempting to connect..."

        do {
            guard let url = URL(string: "https://collectionapi.metmuseum.org/public/collection/v1/objects") else {
                message = "Invalid URL"
                isRequesting = false
                return
            }

            let data = try await fetchData(from: url)
            // Process the data
            message = "Data received: \(data)"
        } catch {
            message = "Error: \(error.localizedDescription)"
        }

        isRequesting = false
    }

    func fetchData(from url: URL) async throws -> Data {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForResource = 60

        let session = URLSession(configuration: configuration)

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return data
    }
}


#Preview {
    ContentView()
}
