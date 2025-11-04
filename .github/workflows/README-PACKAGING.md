# DMTools Application Packaging Workflows

## ✅ Main Workflow: `package-apps.yml`

**Это основной workflow для создания production артефактов.**

### Что он делает:
- ✅ Собирает Flutter приложение для macOS (arm64 + x64) и Windows (x64)
- ✅ Скачивает **standalone server bundles** из [dmtools-server](https://github.com/IstiN/dmtools-server/releases)
- ✅ Упаковывает приложение с embedded server
- ✅ Создаёт готовые к распространению пакеты:
  - `DMTools-{version}-macos-arm64.dmg`
  - `DMTools-{version}-macos-x64.dmg`
  - `DMTools-{version}-windows-x64.zip`

### Как запустить:

#### Через GitHub UI (рекомендуется):
1. Перейдите на [GitHub Actions](../../actions)
2. Выберите "Package DMTools Apps"
3. Нажмите "Run workflow"
4. Заполните параметры:
   - **server_version**: `v1.7.78` (версия из dmtools-server releases)
   - **flutter_version**: оставьте пустым для latest stable
   - **create_release**: ☑️ если хотите автоматически создать GitHub release

#### Результат:
- **Artifacts** доступны в разделе Artifacts (хранятся 7 дней)
- **Release** создаётся автоматически если `create_release = true`

---

## 📦 Структура артефактов:

### macOS DMG:
```
DMTools-v1.7.87-macos-arm64.dmg
└── DMTools.app/
    ├── Contents/
    │   ├── MacOS/
    │   │   └── dmtools (wrapper script)
    │   │   └── dmtools.bin (Flutter app)
    │   └── Resources/
    │       └── server/
    │           ├── run.sh (server launcher)
    │           ├── start-server.sh (port checker + launcher)
    │           ├── jre/ (embedded JRE)
    │           └── dmtools-standalone.jar
```

**Установка:**
- Перетащите DMTools.app в Applications
- Первый запуск: сервер стартует на порту 8080
- Если порт занят: диалог предложит выбрать другой порт

### Windows ZIP:
```
DMTools-v1.7.87-windows-x64.zip
└── DMTools-v1.7.87-windows-x64/
    ├── launch.cmd (main launcher)
    ├── dmtools.exe (Flutter app)
    ├── server/
    │   ├── run.cmd (server launcher)
    │   ├── jre/ (embedded JRE)
    │   └── dmtools-standalone.jar
    └── README.txt
```

**Установка:**
- Распакуйте ZIP
- Запустите `launch.cmd`
- Сервер стартует на порту 8080

---

## 🔧 Локальное тестирование:

### macOS:
```bash
# 1. Скачайте standalone server bundle
curl -L -o dmtools-standalone-macos-aarch64-v1.7.78.zip \
  "https://github.com/IstiN/dmtools-server/releases/download/v1.7.78/dmtools-standalone-macos-aarch64-v1.7.78.zip"

# 2. Соберите Flutter app
flutter build macos --release

# 3. Упакуйте
./scripts/pack-macos.sh \
  build/macos/Build/Products/Release/dmtools.app \
  dmtools-standalone-macos-aarch64-v1.7.78.zip \
  dist \
  v1.7.87

# 4. Результат:
# dist/DMTools-v1.7.87-macos-arm64.dmg
```

### Windows (на macOS/Linux через WSL):
```bash
# 1. Скачайте standalone server bundle
curl -L -o dmtools-standalone-windows-x64-v1.7.78.zip \
  "https://github.com/IstiN/dmtools-server/releases/download/v1.7.78/dmtools-standalone-windows-x64-v1.7.78.zip"

# 2. Соберите Flutter app (на Windows машине или через cross-compile)
flutter build windows --release

# 3. Упакуйте
./scripts/pack-windows.sh \
  build/windows/x64/runner/Release \
  dmtools-standalone-windows-x64-v1.7.78.zip \
  dist \
  v1.7.87

# 4. Результат:
# dist/DMTools-v1.7.87-windows-x64.zip
```

---

## 🔍 Troubleshooting:

### Workflow failed: "Failed to download server bundle"
**Причина:** Версия сервера не найдена в dmtools-server releases

**Решение:**
1. Проверьте что версия существует: https://github.com/IstiN/dmtools-server/releases
2. Используйте точное имя тега (например: `v1.7.78`, не `1.7.78`)
3. Убедитесь что standalone bundle опубликован (не API-only)

### macOS app crashes on startup
**Причина:** Server не может стартовать

**Диагностика:**
1. Проверьте лог: `~/Library/Logs/DMTools/dmtools-server.log`
2. Проверьте порт: `lsof -i :8080`
3. Убедитесь что используется **standalone** bundle (не API-only)

### Windows app shows "Server failed to start"
**Причина:** Порт занят или конфигурация отсутствует

**Решение:**
1. Закройте процессы на порту 8080
2. Проверьте лог: `server\dmtools-server.log`
3. Попробуйте другой порт:
   ```cmd
   set DMTOOLS_PORT=8081
   launch.cmd
   ```

---

## 📋 Checklist перед релизом:

- [ ] DMTools server version опубликована и включает **standalone** bundles
- [ ] Flutter app собирается без ошибок: `flutter build macos --release`
- [ ] Packaging scripts работают локально
- [ ] Протестировано на чистой системе (без dev dependencies)
- [ ] Credentials сохраняются и автоматический логин работает
- [ ] Titlebar padding правильный (12px на macOS)
- [ ] Icon отображается корректно (DM.ai icon)

---

## 🚀 Release процесс:

### 1. Подготовка server bundle:
```bash
cd ../dmtools-server
git tag v1.7.78
git push origin v1.7.78
# Wait for GitHub Actions to build and publish standalone bundles
```

### 2. Packaging Flutter app:
```bash
# GitHub Actions → Package DMTools Apps → Run workflow
# server_version: v1.7.78
# create_release: true
```

### 3. Результат:
- GitHub Release создан автоматически
- DMG и ZIP доступны в Releases
- Changelog можно добавить вручную

---

## 📝 Notes:

- **Standalone vs API-only bundles**: Всегда используйте **standalone** для desktop приложений
- **Server lifecycle**: Сервер стартует при запуске приложения и останавливается при закрытии
- **Port management**: Приложение автоматически предлагает выбрать другой порт если 8080 занят
- **Credentials**: Сохраняются в SharedPreferences (fallback для Keychain на macOS)
- **Auto-login**: Работает при повторном запуске

