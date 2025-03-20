# MyNewsApp

This app shows the news by fetching the data from the api and show it
# 📌 News App (SwiftUI 5)

## 📖 Overview
This is an advanced **news application** built using **SwiftUI 5** and **Core Data**
It follows **Apple's Human Interface Guidelines (HIG)**, focusing on **intuitive navigation, accessibility, and a modern UI**.

---

## 🚀 Features

### 📝 **News Article Management**
- ✅ **Fetching articles**: Articles are fetched using URLSession.
- ✅ **Offline saved articles**: Articles are saved offline when save button is clicked.

### 🔎 ** Filtering**
- **Sorting Options**:
  - **Filter by Category**:
    - 📍 **Business**
    - ⏳ **Technology**
    - ✔️ **Sports**

### 🎨 **Theming**
- 🌗 **Light & Dark Mode**: Supports theme switching.

### 🤝 **Interactions**
- ➡️ **Delete article**: Remove article by clicking delete icon.
- ✅ **Share articles**: Share article using share sheet.

### 📊 ** Progress Indicator**
- 🔵 **Circular Progress loading indicator**: Shows **loading progress view** dynamically.

### 🏆 **Engaging Empty State**
- 📌 **Illustrated Empty View**: Uses **SF Symbols** when no articles are loaded in the queue.

### 🚀 **Performance Optimization**
- ⚡ **Efficient Core Data Fetching**: Uses **@StateObject & @FetchRequest**.
- 📜 **LazyVStack and List for Scrolling**: Handles **100+ tasks** smoothly.

---

## **Core Data Setup**

### **Core Data Model**

```swift
import Foundation
import CoreData

@objc(NewsArticle)
public class NewsArticle: NSManagedObject {}

extension NewsArticle {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<NewsArticle>(entityName: "NewsArticle")
    }
    @NSManaged public var content: String?
    @NSManaged public var htmlContent: String?
    @NSManaged public var id: UUID?
    @NSManaged public var publishedAt: String?
    @NSManaged public var title: String?
    @NSManaged public var titleDescription: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
}
```


## 📦 **Setup Instructions**

### **📌 Prerequisites**
Ensure you have:
- 🖥 **macOS 14+ (Sonoma)**
- 🛠 **Xcode 16+** (SwiftUI 5, iOS 18)
- 🏎 **Swift 5.10**
- 📱 **iPhone Simulator / Physical Device running iOS 18**

### **📥 Installation**
1️⃣ **Clone the repository**  
```sh
git clone https://github.com/mdhaashim786/MyNewsApp.git
cd MyNewsApp
```

2️⃣ **Open the project in Xcode**
```sh
open MyNewsApp.xcodeproj
```

3️⃣ **Run the app**
Select any simulator 
Press Cmd + R to build and Run


## ** Design Architecture**

### 1️⃣  **UI Architecture (SwiftUI 5)**

* NavigationStack for modern navigation.
* Lists are used while fetching news articles from the api & LazyVStack for a saved news articles list.
* @StateObject & @FetchRequest to manage Core Data efficiently.
* Content for offline article will load and save only after saving the article.

### 2️⃣  **Theming & Adaptability**

* Supports light and dark mode theme.

### 3️⃣  **User Experience (UX)**

* Empty State Design: Encourages engagement when no tasks exist

