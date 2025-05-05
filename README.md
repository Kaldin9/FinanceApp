# FinanceApp (iOS)

**FinanceApp** — простое iOS-приложение для учёта доходов и расходов.  
Пока всё на ранней стадии (v0.1), но здесь уже есть базовая модель и CRUD-функционал. Вместе мы будем дорабатывать приложение и добавлять новые фичи!

---

## 🔍 Обзор

- Отслеживайте свои **транзакции**: доходы и расходы  
- Группируйте по **категориям** (бюджетным категориям)  
- Просматривайте **аналитику**: какой процент уходит на еду, транспорт и т.д.  
- Поддержка **тестов** для моделей и UI  



---

## ⚙️ Технологии

- **Swift 5.8+**  
- **SwiftUI** для интерфейса  
- **Combine** (вью-модель `ObservableObject`)  
- **UserDefaults** (пока что для хранения)  
- **Xcode 15+**

---


Структура проекта 

<pre>
FinanceApp/
│
├─ FinanceApp.xcodeproj     — Xcode-проект
├─ FinanceApp/              — исходники
│   ├─ Models/              — схемы данных (Transaction, Budget, ThemeManager)
│   ├─ Views/               — SwiftUI-экраны (MainTabViews, TransactionView, AddTransactionView, AnalyticsView, ChartsView)
│   ├─ Preview Content/     — ассеты для SwiftUI Preview
│   └─ Assets.xcassets      — иконки и цветовые схемы
│
├─ FinanceAppTests/         — модульные тесты
└─ FinanceAppUITests/       — UI-тесты
</pre>


<pre>
✔️ Текущие возможности (v0.1)
	•	Добавление / удаление транзакций
	•	Задание суммы, категории, типа (доход / расход), даты
	•	Просмотр списка транзакций
	•	Простая статистика в виде графика
	•	Тёмная и светлая тема (через ThemeManager)

</pre>


## 🚀 Быстрый старт

1. **Клонировать репозиторий**  
   ```bash
   git clone https://github.com/Kaldin9/FinanceApp.git
   cd FinanceApp



 © 2025 Kaldin9

