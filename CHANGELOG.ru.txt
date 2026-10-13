# Equinox Kernel BakaSU and NoMount Edition: список изменений

Версия от Nanairo8890, с разрешения LF52406. Основана на Equinox Kernel 5.10.269 для POCO F5 Pro / Redmi K60 (`mondrian`).
Проблемы с этой версией сообщайте Nanairo8890, а не LF52406.

---

## 5.10.269 r3 (2026-10-13)

**Совместимость**
- Совместимо с MistOS 5.1 Beta 17.0 (сборка 20261011), у которой штатное ядро 5.10.269 (собрано Clang r596125).
- Контрольные суммы CRC модулей вендора совпадают с 337 модулями `vendor_boot` и 390 модулями `vendor_dlkm` MistOS 5.1 Beta 20261011, а также с MistOS 5.0 Alpha 20260914.
- Установка не изменилась: zip AnyKernel3 заменяет только `Image` и сохраняет ramdisk, заголовок и bootconfig прошивки. После обновления MistOS прошейте zip заново, так как прошивка содержит собственное ядро.

**Изменения**
- BakaSU обновлён до версии 35229 (коммит `e1682a28`, v4.2.0-rc3 + 58 коммитов). Взят из PR #624 «kernel: sync for latest susfs», который ещё не влит. Ветка `main` у BakaSU блокирует сборку с SUSFS с 10 октября.
- Подтянуты последние исправления из `main` до `64814408`: защита от определения по сторонним каналам во `selinux_hide`, исправления обнаружения через sidtab, отложенный `track_throne` (task_work), и `su` больше не перенаправляется, если нет `ksud`.
- Менеджер BakaSU 35229 (`BakaSU_v4.2.0-rc3_35229-arm64-v8a-release.apk`) из CI BakaSU, подписан тем же ключом, что и 35217. Менеджер 35217 тоже работает, но обновиться рекомендуется.
- SUSFS обновлён до `82f08351` (v2.3.0). Изменились только хуки в `security/selinux/hooks.c`, `security/selinux/selinuxfs.c` и `fs/exec.c`. `fs/susfs.c` и команды `ksu_susfs` такие же, как в r2, поэтому BRENE и другие модули SUSFS работают как прежде.
- NoMount обновлён до v2.1.1 от maxsteeel (`7046c7a`): быстрее поиск правил и листинг каталогов, правила хранятся в одном выделении на каталог, виртуальные inode не зависят от правил, освобождение через `call_rcu()`, исправления use-after-free и чтения за пределами диапазона. Исправление `7e7342c` от deref3046 включено.
- Фильтр `/proc/kallsyms` теперь также скрывает `dummy_key_instantiate` и `dummy_key_free_preparse`, которые в r2 были видны.
- Три изменения этой версии для NoMount сохранены: приложения, для которых SUSFS/BakaSU размонтирует модули, видят исходную систему; нет `/sys/module/nomount/version`; фильтр kallsyms SUSFS скрывает символы NoMount.
- NoMount собирается с `-O3`, как в upstream, но без `-fno-stack-protector`, который upstream использует только для своих `.ko`.
- Установщик: AnyKernel3 показывает ASCII-арт девушки-мышки и логотип EQUINOX с надписью «BakaSU and NoMount Edition by Nanairo8890» перед данными ядра.

**Проверено на телефоне** (POCO F5 Pro, MistOS 5.1 Beta 20261011)
- Загружается. 0 модулей вендора отклонено (385 загружено). Ошибок в dmesg нет.
- BakaSU работает с менеджером 35229. SUSFS v2.3.0 со всеми функциями. BRENE работает.
- SELinux в режиме Enforcing.
- В `/proc/kallsyms` нет символов `dummy_key_`, `nm_`, `nomount`, `ksu_` и `susfs_`.
- Проверка после установки: `adb shell su -c "dmesg | grep -i 'disagrees about version'"` (должно быть пусто).

**Известные проблемы NoMount (upstream, открыты)**
- [#75](https://github.com/maxsteeel/nomount/issues/75): файл `.replace` или непрозрачный каталог внутри модуля может привести к исчезновению всего каталога и бутлупу. Перед использованием NoMount проверьте, что модули их не используют: `su -c "find /data/adb/modules -name .replace"`.
- [#71](https://github.com/maxsteeel/nomount/issues/71): не используйте NoMount для замены `.ko` вендора.

---

## 5.10.269 r2 (2026-10-08)

**Новое: NoMount встроен в ядро**
- [NoMount](https://github.com/maxsteeel/nomount) v2.1.0 от maxsteeel, встроен (`CONFIG_NOMOUNT=y`), с исправлением `7e7342c` от deref3046. NoMount перенаправляет пути на уровне VFS вместо монтирования через OverlayFS или Magic Mount, поэтому в `/proc/mounts` ничего не появляется.
- Установите официальный метамодуль `NoMount-v2.1.0-release-500.zip` из менеджера BakaSU: https://github.com/maxsteeel/nomount/releases/tag/v2.1.0. KernelSU поддерживает только один метамодуль за раз, поэтому сначала удалите Hybrid Mount или другой.
- Изменения версии для лучшего скрытия root: процессы, для которых BakaSU/SUSFS размонтируют модули, видят исходную систему; нет `/sys/module/nomount/version` (`nm version` работает); фильтр kallsyms SUSFS скрывает `nm_*`, `nomount*` и `__initstub__kmod_kernelsu`.

**Проверено**
- Загружено через `fastboot boot` на MistOS 5.0 Alpha 20260914 с менеджером 35217: 0 модулей вендора отклонено (385 загружено), root, модули zygisk, SUSFS и BRENE работают, SELinux в Enforcing, ошибок ядра нет.
- NoMount проверен с правилами для `/system`: внедрение, замена, скрытие, изоляция UID и очистка, без предупреждений ядра.

**Известные проблемы NoMount (upstream)**: [#75](https://github.com/maxsteeel/nomount/issues/75) и [#71](https://github.com/maxsteeel/nomount/issues/71), см. выше.

---

## 5.10.269 r1 (2026-10-07)

**Изменения относительно Equinox 5.10.269**
- **Root: BakaSU** вместо KernelSU-Next 3.4.0. BakaSU — новое название ReSukiSU с 5 октября 2026 года, используется коммит `c9246641` (v4.2.0-rc3 + 46 коммитов, версия 35217).
  - **Требуется менеджер BakaSU 35217 или новее.** С 4 октября BakaSU использует версию 5 интерфейса ядра и `ksud`.
- **SUSFS v2.3.0** из ветки `gki-android12-5.10` simonpunk, последний коммит `9892175` (26 сентября), с собственной поддержкой SUSFS в BakaSU.
- **BBR** как алгоритм управления перегрузкой TCP по умолчанию (Equinox включает BBR, но стартует с CUBIC). CUBIC доступен и переключается на ходу.

**Как в Equinox**
- Linux 5.10.269 с конфигурацией mondrian из Equinox.
- DroidSpaces с безопасным для KMI профилем Equinox.
- Исправления сенсорного экрана Goodix, Clang CFI и MODVERSIONS.
- Установка через AnyKernel3.

**Технические детали**
- Собрано Clang из AOSP (`clang-r584948`) и ThinLTO.
- Перед упаковкой: проверка KMI против чистого Equinox (0 изменённых CRC, 0 удалённых символов) и CRC модулей вендора против MistOS 5.0 Alpha 20260914 (337 модулей `vendor_boot` и 390 модулей `vendor_dlkm`).
- `/proc/version` показывает `Nanairo@Equinox`. `set_uname` в SUSFS меняет только то, что возвращает `uname`.

**Совместимость**
- Проверено на POCO F5 Pro с MistOS 5.0 Alpha 20260914 и менеджером 35217: загружается, 0 модулей вендора отклонено (386 загружено), root, модули zygisk, SUSFS и BRENE работают, SELinux в Enforcing, ошибок ядра нет.

---

## Благодарности
- **[LF52406](https://github.com/LF52406)**: Equinox Kernel, основа этой версии. Поддержать: [PayPal](https://www.paypal.me/LF52406) · [Patreon](https://patreon.com/InfernalGT) · [Boosty](https://boosty.to/infernalgt/donate)
- [LineageOS](https://github.com/LineageOS/android_kernel_xiaomi_sm8450) и [Android Common Kernel](https://android.googlesource.com/kernel/common).
- [BakaSU](https://github.com/Baka-SU/BakaSU) (ранее ReSukiSU) и [KernelSU](https://github.com/tiann/KernelSU) от tiann.
- [SUSFS](https://gitlab.com/simonpunk/susfs4ksu) от **simonpunk**.
- [DroidSpaces](https://github.com/ravindu644/Droidspaces-OSS) от **ravindu644**.
- [NoMount](https://github.com/maxsteeel/nomount) от **maxsteeel**, с исправлением `7e7342c` от **deref3046**.
- [AnyKernel3](https://github.com/osm0sis/AnyKernel3) от **osm0sis**.
- **[Nanairo8890](https://github.com/nanairo8890)**: интеграция BakaSU, SUSFS, BBR и NoMount в Equinox.
