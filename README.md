# Домашняя работа по 15 уроку

## 15.2 SQL возвращается

***
Ход выполнения
1. Определился какие поля  должны  стать отдельными таблицами и  быть вынесены  в  виде справочников.
2. Поле age_upon_outcome решил не только вынести в обдельную таблицу, но и сделать для неё отдельный
справочник по наименованию возрастного периода. Это улучшить возможности поиска по значению времени и
наименованию периода которым записан возраст животного.
3. Создал скрипты  для создания   и заполнения всех справочников уникальными значениями.
4. Создал новую таблицу animals_normal как основную. Для заполнения её данными из справочников оставил
некоторые поля в ней (после заполнения синхронизации данных со справочниками поля удаляются за ненадобностью).
5. В таблице animals_normal создал внешние ключи для ссылки на справочники
6. В таблице справочнике age_animals так же создан внешний ключь  к справочнику наименований  возрастного периода
7. Вся работа по разработке новой модели базы выполнялась в DBeaver. Применялся только SQL.
Схема связей (скриншот) нормализированной БД находится в папке \Screen\Схема связей в БД.jpg.

8. Вьюшка сделана  на http://127.0.0.1:5000/animals/<animals_id>
   Результат выполнения вьюшки  \Screen\результат выполнения вьюшки.jpg
		
### Выполнено:
* Шаг 0
* Шаг 1
* Шаг 2
* Шаг 3
* Шаг 4
* Шаг 5 
* Шаг 6 
* Шаг 7 
***

