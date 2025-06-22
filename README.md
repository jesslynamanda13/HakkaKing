# 🌟 WangHakka — Bridging Generations Through Language and AI 🇨🇳🧠

> **Learn the Hakka Language with ML-Powered Pronunciation & a Dimsum Mascot 🍜**

[![SwiftUI](https://img.shields.io/badge/SwiftUI-Framework-orange?logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Machine Learning](https://img.shields.io/badge/Machine%20Learning-CreateML-green?logo=apple)](https://developer.apple.com/machine-learning/)
[![Voice Classification](https://img.shields.io/badge/Sound%20AI-Voice%20Classification-blue)](https://developer.apple.com/documentation/createml/mlsoundsclassifier)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 📖 Overview

**WangHakka** is a socially impactful iOS application built using **SwiftUI and Create ML**, designed to **preserve the Hakka language** and empower individuals like “S” who face communication barriers with older generations.

Inspired by the heartwarming story of someone who couldn’t communicate with his grandmother due to language gaps, this app uses **AI-powered voice classification** to **teach and assess Hakka pronunciation**, bridging families and cultures.

> _“If technology connects us to the world, why not to our roots?”_

---

## 💡 Key Features

| Feature                     | Description |
|----------------------------|-------------|
| 🔊 **ML-Based Voice Detection** | Built using **Create ML Sound Classifier** per Hakka sentence (12 custom-trained models). |
| 👂 **Pronunciation Feedback** | Real-time voice recognition to help users improve Hakka pronunciation. |
| 🎓 **Chapter-Based Learning** | Structured in 3 thematic chapters, split into 12 sentences. |
| 🧠 **150 Samples / Class** | Balanced male/female voices + background noise for robust training. |
| 🤖 **Data Augmentation** | Audio data enhanced with **Python + Eleven Labs + CapCut**. |
| 🥟 **Mascot “Wang”** | A friendly dimsum-shaped mascot to culturally represent Hakka family values. |

---

## 🧠 Technical Architecture

> The app is structured using clean MVVM principles.  
> Project architecture includes:

├── Controller/
├── Database/
├── Feature/
├── Mlmodel/ ← Custom-trained Create ML models (.mlmodel)
├── Model/
├── SwiftUI Views:
│ ├── ContentView.swift
│ ├── WordBubbleView.swift
│ ├── HakkaPracticeFlow.swift
│ └── WrappingHStack.swift
└── HakkaKingApp.swift


🔧 *Built 100% using SwiftUI and Apple’s native tools. No third-party ML frameworks were required.*

---

## 🎯 The ML Journey

- 🔍 **Data Scarcity? No Problem!**
   - We **manually recorded** Hakka words using native speakers.
   - Used **Eleven Labs** and **CapCut** for tonal/accent diversity.
   - Balanced gender representation for each class.

- 🧪 **Training Strategy**
   - Initially trained per chapter → shifted to per-sentence models for higher accuracy.
   - Each sentence model includes **120 augmented samples + 30 original = 150/class**.
   - Included **background noise** class per model to reduce false positives.

- 📈 **Results**
   - Achieved **90%+ accuracy** consistently across models.
   - Real-time feedback proves to be both responsive and reliable.

---

## 📱 UI Preview

| Home Screen | Practice View | Model Architecture |
|-------------|----------------|---------------------|
| *(Insert screenshot here)* | *(Insert screenshot here)* | *(Insert diagram here)* |

🖼️ *You can upload images and reference them using Markdown syntax like:*  
`![Alt Text](images/filename.png)`

---

## ❤️ Why This Matters

> Language is more than words—it’s love, memory, and heritage.

This project isn’t just about AI or SwiftUI. It’s about how **technology can heal relationships**, **revive dying languages**, and **make people feel at home again**. With the help of **sound classification**, even a lost generation can find its voice.

---

## 🏁 Built With

- 🍎 SwiftUI
- 🧠 Create ML (Sound Classification)
- 🔉 Eleven Labs (Synthetic voice generation)
- 🎞️ CapCut (Voice augmentation)
- 🐍 Python (Audio augmentation scripts)
- 👨‍👩‍👧‍👦 Cultural Research (Hakka language & customs)

---

## ⏱ Timeline

✅ Completed in **just 2 weeks**  
💼 Designed for real-world deployment with efficient, iterative development.

---

## 🚀 Future Improvements

- ✅ Add more Hakka dialects and words
- 🔜 Gamification: Points, streaks, badges
- 🔜 Real-time speech-to-text interaction
- 🔜 Model versioning & OTA updates via CoreML & Swift Package

---

## 🤝 Let’s Collaborate

If you are a company, non-profit, or institution working in **education**, **language revitalization**, or **AI for good**, I’d love to work with you.

---

## 📜 License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

---

> _“When you teach someone to speak, you don’t just give them words. You give them a voice.”_
