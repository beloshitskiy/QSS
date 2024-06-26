# Queueing System Simulation macOS app project
Приложение является симуляцией системы массового обслуживания.

## Характеристики системы
* Бесконечный источник с равномерным распределением
* Время обслуживания подчиняется экспоненциальному закону распределения
* Выбор прибора происходит по кольцу, а выбор заявки из буфера происходит в соответствии с приоритетом заявки в пакете
* Буферизация происходит в порядке поступления
* Отказ происходит в соответствии с приоритетом источника

Результат работы можно получить как в виде сводной таблицы результатов, так и временной диаграммы

## Скриншоты

### Автоматический режим
<img src="resources/qss_auto.png" width="700"/>

### Ручной режим
<img src="resources/qss_manual.png" width="700"/>

**Стек приложения**: Swift, SwiftUI, Swift Charts
