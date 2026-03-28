# AVISHU Superapp

**FashionMode Hackathon 2026**

---

## 🇰🇿 Қазақша

### Жоба туралы

AVISHU Superapp — fashion-индустрияға арналған кешенді мобильді қосымша. Бір жүйеде үш рөл біріктірілген: клиент, франчайзи және өндіріс. Клиент тауар тапсырыс береді — ол лезде франчайзиге, содан соң өндіріске жетеді. Өндіріс аяқтаған сәтте клиент нақты уақытта статус өзгерісін көреді.

### Технологиялар

| Технология | Мақсаты |
|---|---|
| Flutter | Кросс-платформалық UI |
| Firebase Auth | Аутентификация |
| Cloud Firestore | Нақты уақыттағы дерекқор |
| Riverpod | Күй басқару |
| go_router | Рөлге негізделген навигация |
| Google Fonts (Inter) | Типография |

### Тест аккаунттары

| Email | Құпия сөз | Рөл |
|---|---|---|
| client@avishu.kz | test123 | Клиент |
| franchisee@avishu.kz | test123 | Франчайзи |
| production@avishu.kz | test123 | Өндіріс |

### Іске қосу

```bash
flutter pub get
flutter run
```

### Нақты уақыттағы ағын

```
Клиент тапсырыс береді
        ↓
Франчайзи onSnapshot → тапсырыс лезде пайда болады
        ↓
Франчайзи қабылдайды → статус: "sewing"
        ↓
Өндіріс onSnapshot → тігін кезегіне түседі
        ↓
Өндіріс "ЗАВЕРШИТЬ" басады → статус: "ready"
        ↓
Клиент прогресс жолағы лезде жаңарады
```

---

## 🇷🇺 Русский

### О проекте

AVISHU Superapp — комплексное мобильное приложение для fashion-индустрии. В одной системе объединены три роли: клиент, франчайзи и производство. Клиент размещает заказ — он мгновенно появляется у франчайзи, затем уходит в производство. Как только производство завершает работу, клиент видит обновление статуса в реальном времени.

### Технологический стек

| Технология | Назначение |
|---|---|
| Flutter | Кросс-платформенный UI |
| Firebase Auth | Аутентификация пользователей |
| Cloud Firestore | База данных реального времени |
| Riverpod | Управление состоянием |
| go_router | Ролевая маршрутизация |
| Google Fonts (Inter) | Типографика |

### Тестовые аккаунты

| Email | Пароль | Роль |
|---|---|---|
| client@avishu.kz | test123 | Клиент |
| franchisee@avishu.kz | test123 | Франчайзи |
| production@avishu.kz | test123 | Производство |

### Запуск

```bash
flutter pub get
flutter run
```

### Поток реального времени

```
Клиент размещает заказ
        ↓
Франчайзи onSnapshot → заказ появляется мгновенно
        ↓
Франчайзи принимает → статус: "sewing"
        ↓
Производство onSnapshot → заказ попадает в очередь
        ↓
Производство нажимает "ЗАВЕРШИТЬ" → статус: "ready"
        ↓
Прогресс-бар клиента обновляется мгновенно
```

---

## 🇬🇧 English

### About the Project

AVISHU Superapp is a full-cycle mobile application built for the fashion industry. Three roles operate within a single system: client, franchisee, and production. A client places an order — it appears instantly on the franchisee's screen, then moves to the production queue. The moment production marks it complete, the client's order tracker updates in real time without a page refresh.

### Tech Stack

| Technology | Purpose |
|---|---|
| Flutter | Cross-platform UI |
| Firebase Auth | User authentication |
| Cloud Firestore | Real-time database with onSnapshot listeners |
| Riverpod | State management |
| go_router | Role-based routing |
| Google Fonts (Inter) | Typography |

### Test Accounts

| Email | Password | Role |
|---|---|---|
| client@avishu.kz | test123 | Client — catalog, orders, loyalty bar |
| franchisee@avishu.kz | test123 | Franchisee — dashboard metrics, order management |
| production@avishu.kz | test123 | Production — sewing queue, order completion |

### How to Run

```bash
flutter pub get
flutter run
```

> Requires Flutter 3.x and a configured Firebase project.
> Run `flutterfire configure` to regenerate `firebase_options.dart` for your environment.

### Real-Time Flow

```
Client places order  →  Firestore write
        ↓
Franchisee onSnapshot fires  →  order appears instantly
        ↓
Franchisee taps "ACCEPT → SEWING"  →  status: "sewing"
        ↓
Production onSnapshot fires  →  order enters the queue
        ↓
Production taps "ЗАВЕРШИТЬ"  →  status: "ready"
        ↓
Client progress bar updates instantly  →  no reload required
```

### Design System

The UI follows a strict brutalist monochrome palette with zero border-radius and no Material Design defaults.

| Token | Value |
|---|---|
| Primary | `#000000` |
| Background | `#FFFFFF` |
| Surface | `#F5F5F5` |
| Muted | `#888888` |
| Dark surface | `#1A1A1A` |
| Divider | `#333333` |
| Font | Inter (Google Fonts) |
| Border radius | `0` everywhere |
| Min padding | `24px` |

---

*AVISHU Superapp — FashionMode Hackathon 2026*
