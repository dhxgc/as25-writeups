**Полная пошаговая инструкция с учётом порядка и особенностей устройств:**

---

### **Этап 0: Предварительная подготовка**
1. **На RADIUS-сервере (DC-A):**
   - Убедитесь, что служба RADIUS (например, NPS в Windows Server) настроена:
     - Добавьте клиента RADIUS (Huawei AR) с IP-адресом и общим ключом (например, `SecretKey123`).
     - Настройте политику аутентификации для пользователя `radadmin` из базы `ALD office.atom25.local`.
     - Укажите атрибут `Vendor-Specific (Huawei) 26-57` со значением `15` (уровень привилегий).

---

### **Этап 1: Настройка RADIUS на Huawei AR**
```bash
system-view

# Шаг 1.1: Создание RADIUS-шаблона
radius-server template RADIUS_OFFICE
 radius-server shared-key SecretKey123  # Должен совпадать с ключом на DC-A
 radius-server authentication 192.168.1.100 1812  # IP DC-A
 radius-server accounting 192.168.1.100 1813
 radius-server retry 3  # Повторы при ошибках

# Шаг 1.2: Настройка AAA-схемы с приоритетом RADIUS
aaa
 authentication-scheme RADIUS_AUTH
  authentication-mode radius local  # Сначала RADIUS, потом локальный
 authorization-scheme RADIUS_AUTH
  authorization-mode radius local
 domain default
  authentication-scheme RADIUS_AUTH
  authorization-scheme RADIUS_AUTH
  radius-server RADIUS_OFFICE  # Привязка шаблона к домену
```

---

### **Этап 2: Настройка SSH на Huawei AR**
```bash
# Шаг 2.1: Включение SSH и генерация ключей
ssh server enable
ssh user radadmin authentication-type radius  # RADIUS-аутентификация для radadmin
ssh user atom authentication-type password   # Локальная аутентификация для atom
rsa local-key-pair create  # Сгенерировать ключи (подтвердить длину 2048)

# Шаг 2.2: Настройка VTY-линий
user-interface vty 0 4
 protocol inbound ssh  # Только SSH
 authentication-mode aaa  # Использовать AAA
 user privilege level 15  # Автоматические права для всех (можно уточнить)

# Шаг 2.3: Создание локального пользователя atom (фолбэк)
local-user atom
 password irreversible-cipher P@ssw0rdSkills  # Шифрование пароля
 service-type ssh terminal  # Доступ через SSH и консоль
 privilege level 15  # Максимальные права
```

---

### **Этап 3: Настройка Huawei USG**
```bash
system-view

# Шаг 3.1: Включение SSH
ssh server enable
rsa local-key-pair create  # Сгенерировать ключи

# Шаг 3.2: Настройка VTY-линий
user-interface vty 0 4
 protocol inbound ssh
 authentication-mode aaa

# Шаг 3.3: Создание пользователя atom (если не существует)
local-user atom
 password irreversible-cipher P@ssw0rdSkills
 service-type ssh
 privilege level 15
```

---

### **Этап 4: Настройка автоматических прав для atom**
**Для консольного доступа на AR и USG:**
```bash
user-interface con 0
 authentication-mode scheme  # Использовать AAA
# Убедитесь, что пользователь atom имеет level 15 в локальной базе.
```

---

### **Этап 5: Проверки и важные нюансы**
1. **Проверка RADIUS:**
   - На AR выполните:
     ```bash
     test-aaa radadmin radpass radius-template RADIUS_OFFICE  # Проверка аутентификации
     ```
   - Убедитесь, что ответ от DC-A содержит атрибут с `privilege level 15`.

2. **Проверка SSH:**
   - С CLI-A (Astra Linux):
     ```bash
     ssh -oKexAlgorithms=+diffie-hellman-group14-sha1 atom@<AR_IP>  # Для Huawei
     ssh atom@<USG_IP>
     ```
   - Если возникает ошибка алгоритма, обновите клиент SSH или добавьте опции совместимости.

3. **Фолбэк-проверка:**
   - Отключите DC-A от сети и попробуйте войти как `radadmin` — должно быть отказано (пользователь не существует локально).
   - Войдите как `atom` — доступ должен быть предоставлен через локальную аутентификацию.

4. **Межсетевой экран USG:**
   - Разрешите входящий SSH на USG:
     ```bash
     firewall packet-filter default permit  # Временно для теста
     или
     policy interzone trust untrust inbound permit ssh
     ```

---

### **Критические замечания:**
1. **Совместимость RADIUS:**
   - Убедитесь, что DC-A отправляет правильные атрибуты (Vendor-ID Huawei: 2011).
   - Пример атрибута для прав: `Huawei-Exec-Privilege = 15`.

2. **Безопасность:**
   - Измените `SecretKey123` на сложный ключ.
   - На USG ограничьте доступ по SSH только с CLI-A.

3. **Время синхронизации:**
   - Убедитесь, что время на AR, USG и DC-A синхронизировано (NTP).

---

**Итог:**  
После выполнения этих шагов вы получите:
- Доступ к AR через SSH с аутентификацией через RADIUS (radadmin) и локальным фолбэком (atom).
- Локальный доступ atom с максимальными правами на AR и USG.
- Автоматическое повышение прав для atom при входе.
