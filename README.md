# Pokedex

Progetto app test per Spindox.
Pokedex è un'app costruita in **SwiftUI** con architettura **MVVM + Coordinator**, progettata per fornire informazioni dettagliate su Pokemon, abilità e mosse.

---

## 🚀 Funzionalità

- 🔍 **Ricerca Pokemon** con searchbar `.searchable`
- 📜 **Lista Pokemon** con caricamento incrementale (pagination)
- 📄 **Dettagli Pokemon**: abilità, mosse, altezza e peso
- 📘 **Dettagli Abilità/Move** con Pokemon correlati
- 🔁 Navigazione gestita via **Coordinator Pattern**
- 📲 UI 100% in SwiftUI

---

## 🧠 Architettura

L'app è strutturata seguendo il pattern **MVVM** e utilizza un **Coordinator** per gestire la navigazione tra schermate.

```
Views ──▶ ViewModels ──▶ Services
  │           │             │
  ▼           ▼             ▼
Coordinator  State       API Layer
```

### 📂 Moduli principali

- `Views/<Feature>/View/` – Interfacce utente SwiftUI divise per feature
- `Views/<Feature>/ViewModel/` – ViewModel associati, organizzati nella stessa feature
- `APIs/Models` – Strutture dati
- `APIs/Services` – Accesso ai servizi REST
- `Coordinators/` – Logica di navigazione
- `Utils/` – Componenti riutilizzabili ed estensioni utili

---

## 🧪 Test

✅ **Unit Test** (`PokedexTests`):  
- `HomePageViewModelTests`
- `DetailPokemonViewModelTests`
- `DetailCharacteristicViewModelTests`  
🧪 I test unitari sono costruiti usando dei servizi ad-hoc che estendono il protocollo `StubServiceProtocol`.
Ogni stub service carica risposte da file `.json` localizzati nella cartella `PokedexTests/Resources/`.

✅ **UI Test** (`PokedexUITests`):  
- Interazioni utente end-to-end
- Test presenza elementi per tutte le View

---

## 📲 Requisiti

- Xcode 15+
- iOS 17+
- Swift 5.9+

---

## 📌 Note aggiuntive

- Tutte le `View` sono testabili via `accessibilityIdentifier`
- Codice documentato secondo le linee guida Xcode

---

## 👨‍💻 Autore

Realizzato da **Elia Crocetta**  
🗓️ Aprile 2025
