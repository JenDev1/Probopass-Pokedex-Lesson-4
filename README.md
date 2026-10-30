# Probopass Pokédex – Communicating with Services

## Project Description

This project is a Flutter-based Pokédex application that retrieves Pokémon information from the [PokéAPI](https://pokeapi.co/). Instead of relying only on hardcoded data, the application uses HTTP GET requests to fetch information from an online API.

The application initially displays Probopass and allows users to search for other Pokémon by name.

## Features

- Search for Pokémon by name.
- Retrieve Pokémon data using an HTTP GET request.
- Display Pokémon name, ID, height, weight, types, abilities, and image.
- Display additional information, including base experience, stats, and moves.
- Show a loading indicator while retrieving data.
- Prevent repeated requests while a request is in progress.
- Display an error message when a request fails.

## API Used

**PokéAPI**

API endpoint:

`https://pokeapi.co/api/v2/pokemon/{name}`

Example:

`https://pokeapi.co/api/v2/pokemon/probopass`

The application uses the HTTP package to send requests and `dart:convert` to decode the JSON response.

## How the Application Handles Requests

### 1. Successful Requests

When a user enters a valid Pokémon name, the application sends a GET request to PokéAPI. If the server returns a successful response, the JSON data is decoded and displayed in the application.

For example, searching for `probopass` displays its Pokémon information, including its image, types, abilities, stats, and moves.

### 2. Unsuccessful Responses

If the user searches for a Pokémon that does not exist, the API returns an unsuccessful HTTP response, such as a 404 Not Found. The application displays an error message instead of showing invalid Pokémon information.

### 3. Network Failures

If the device has no internet connection or the request cannot reach the API, the application catches the error and displays an appropriate error message.

### 4. Loading and Repeated Requests

A loading indicator is displayed while the application waits for the API response. The search action is disabled during this time to prevent repeated requests.

## Proposed Offline Strategy

If the application needs to work without an internet connection, a local database or local storage could be added to save previously retrieved Pokémon information.

When the device is offline, the application could display saved Pokémon data instead of requesting information from the API. Once the internet connection becomes available again, the application could retrieve updated information from PokéAPI.

This is a proposed improvement and is not currently implemented in the application.

## Technologies Used

- Flutter
- Dart
- HTTP package
- PokéAPI
- JSON

## Conclusion

This activity demonstrates how a Flutter application communicates with an external web service using HTTP GET requests. It also demonstrates JSON decoding, displaying API data, handling unsuccessful responses, and managing network errors.# probopass

A new Flutter project created with FlutLab - https://flutlab.io

## Getting Started

A few resources to get you started if this is your first Flutter project:

- https://flutter.dev/docs/get-started/codelab
- https://flutter.dev/docs/cookbook

For help getting started with Flutter, view our
https://flutter.dev/docs, which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Getting Started: FlutLab - Flutter Online IDE

- How to use FlutLab? Please, view our https://flutlab.io/docs
- Join the discussion and conversation on https://flutlab.io/residents
