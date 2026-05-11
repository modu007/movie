# movie
# Movie Commons - Flutter Developer Assignment

## ✨ Key Features

- Fully **Offline-First** (Add users & save movies without internet)
- Real-time **Matches** page
- Robust retry logic for weak connections
- Smooth Hero animations, shimmer loading, and staggered list animations

## 📥 Download APK
https://i.diawi.com/aN6LgM

## 🛠 Tech Stack

- Flutter + Riverpod (MVVM)
- Hive (Local Database)
- Dio
- GoRouter + CachedNetworkImage

## 📁 Project Structure

(See full structure in code)

## 🗄 Local Database

- **Users**: User details + `pendingSync` flag
- **Movies**: TMDB movie data
- **UserMovieSaves**

## 🤖 AI Usage

I used ChatGPT as a coding assistant to help generate boilerplate, fix bugs, and polish UI/UX.

**Full AI Conversation:**  
https://chatgpt.com/share/6a011833-8b78-8322-8acc-777162fb227b

---

### How to Use:

1. Build APK:
   ```bash
   flutter build apk --release
