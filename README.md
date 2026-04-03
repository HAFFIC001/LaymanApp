# Layman — AI News Simplifier iOS App

Layman is an AI-powered news reading app that simplifies business, tech, and startup news into beginner-friendly summaries and conversations.

## Features

* Swipe onboarding experience
* Email authentication using Supabase
* AI-generated 3-card article summaries
* Ask Layman chatbot assistant (Gemini API)
* Save / unsave bookmarks
* Persistent user profiles
* Reading streak tracking
* Clean SwiftUI glass tab navigation

## Tech Stack

SwiftUI
Supabase (Auth + Database)
Google Gemini API
News REST API

## Setup Instructions

### 1. Clone Repository

```
git clone <repo-url>
```

### 2. Configure Supabase

Open:

```
SupabaseManager.swift
```

Replace:

```
SUPABASE_URL
SUPABASE_ANON_KEY
```

with your credentials.

### 3. Configure Gemini API

Open:

```
AIService.swift
```

Replace:

```
GEMINI_API_KEY
```

with your key.

### 4. Configure News API

Open:

```
NewsService.swift
```

Replace:

```
NEWS_API_KEY
```

with your key.

### 5. Run Project

Open in Xcode:

```
Layman.xcodeproj
```

Run on simulator or device.

---

## Screenshots

Add simulator screenshots here:

* Welcome Screen
* Authentication
* Home Feed
* Article Detail
* AI Summary Cards
* Ask Layman Chat
* Saved Articles
* Profile Screen

---

## Architecture

MVVM architecture

Services:

* AIService
* SupabaseManager
* NewsService

ViewModels:

* AuthViewModel
* BookmarkViewModel

Views:

* WelcomeView
* AuthView
* HomeView
* ArticleDetailView
* ChatView
* SavedView
* ProfileView

---

## Notes

Environment variables are not committed for security.
Please configure keys locally before running.
