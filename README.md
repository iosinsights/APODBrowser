# 🌌 APOD Browser SwiftUI Architecture Focused Take Home Exercise

APOD Browser is a SwiftUI application that displays NASA’s Astronomy Picture of the Day (APOD) using the public NASA API.  
The project prioritises separation of concerns and testability.

It demonstrates a layered architecture using protocols async/await networking, and caching with fallback on failure.

---

## 🚀 Features

- Loads today’s APOD on launch  
- Displays:
  - Date  
  - Title  
  - Explanation  
  - Image or Video (depending on APOD type)  
- Browse APOD by selecting any past date  
- Video handling:
  - Native playback for direct video URLs  
  - External playback for YouTube/Vimeo  
  - WebView fallback for unknown embeds  
- Last successful APOD + image cached on disk  
- Cached APOD returned automatically when network fails  
- Loading and error states  
- Basic accessibility support  
- Tab bar navigation (Today / Browse)

---

## 🧱 Architecture Overview

This project follows a layered, protocol-driven MVVM style architecture.

The emphasis is on:

- Dependency injection  

---

## 🗂 Folder / Layer Responsibilities

```
.
├── App
│   └── APODBrowser
│
├── Composition
│   └── AppContainer
│
├── Models
│   └── APOD
│
├── Networking
│   ├── HTTPClient
│   ├── NASAClient
│   └── APODAPI
│
├── Caching
│   ├── APODCache
│   ├── FileSystem
│
├── Repository
│   └── APODRepository
│
├── ViewModels
│   └── APODViewModel
│
├── Views
│   ├── ContentView
│   ├── TodayView
│   ├── BrowseView
│   ├── APODDetailView
│   └── APODMediaView
│
├── Utilities
│   ├── MediaResolver
│   └── DateFormatter
│
```

---

## 🛠 Technologies

- Swift  
- SwiftUI  
- Async/Await  
- XCTest  
- AVKit  
- WebKit  

---

## 🔄 Design Patterns & Techniques Used

### ✅ MVVM (ViewModel-First)

- Views contain no networking or persistence logic  
- APODViewModel owns UI state  
- Views bind to ViewModel properties using Observation  

---

### ✅ Repository Pattern

APODRepository coordinates:

- Remote fetch  
- Disk cache  
- Fallback behaviour  

Views and ViewModels never talk directly to networking or disk.

---

### ✅ Dependency Injection (Constructor-Based)

- Repository injected into ViewModels  
- Client + Cache injected into Repository  
- FileSystem injected into Cache  

---

### ✅ Protocol-Oriented Boundaries

Protocols exist for:

- HTTPClient  
- APODFetching  
- APODCaching  
- FileSystem  
- APODRepositoryProtocol  

This allows swapping real implementations for fakes in tests.

---

### ✅ Strategy-like Media Resolution

MediaResolver decides:

- Image  
- Native video  
- External video  
- Web embed  

---

### ✅ Single Responsibility Principle (Mostly)

Each type has a focused purpose:

- NASAClient → Networking  
- APODCache → Persistence  
- Repository → Coordination  
- ViewModel → State & UI logic  
 
Some files are long and could be split further, but responsibilities remain clear.

---

## 🧪 Testing

This project is designed for unit testing.

Three high value unit tests are recommended:

1. Repository returns cached APOD when network fails  
2. Video APOD loads thumbnail instead of video URL  
3. ViewModel does not clear last successful content on failure  

---

## 📦 Caching Behaviour

- APOD JSON saved to disk  
- Image / thumbnail saved separately by date  
- On network failure:
  - Last cached APOD returned  
  - Last cached image returned  

No expiration policy.  
Cache stores only the last APOD.

---

## 📱 Accessibility

- Accessibility labels on key text  
- Dynamic Type supported   

---

## ⚠️ Known Limitations

- No offline browsing of arbitrary past dates  
- No pagination or APOD history list  
- No image memory cache (only disk)  
- No retry / backoff logic  
- No UI tests  
- No cache expiry strategy  
