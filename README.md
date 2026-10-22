# ReadPath

A learning iOS project for searching books and managing a personal library.
Built using the Open Library API.

## Features

- Book search with pagination
- Book details and cover images
- Saving books to a local library
- Reading statuses and filtering
- Reading statistics

## Technologies

- Swift, UIKit and Auto Layout
- SwiftUI for the statistics screen
- Core Data
- URLSession and async/await
- Swift Testing

## Project Structure

The project uses MVVM.
Navigation is handled by a Coordinator.
Dependencies are created in a DependencyContainer.

Services load data from the API, repositories map it into domain models,
and LibraryStore manages access to saved books.

## Tests

Tests cover mapping, repositories, ViewModels, pagination
and Core Data storage.

## Running

Open ReadPath.xcodeproj in Xcode, select a compatible iOS simulator
and run the ReadPath scheme.

Internet access is required to search books and load their details
and images.

## What I Practiced

This project helped me practice UIKit, integrating SwiftUI,
local persistence, dependency injection and testing.
