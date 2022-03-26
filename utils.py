import sqlite3
# from pprint import pprint as pp

DATABASE = "animal.db"
DB_NAME = 'animals_normal'


def get_db_result(sqlite_query):
    """
    Функция работы  с  БД
    :param sqlite_query: SQL запрос к  БД
    :return: Результат выполнения  запроса
    """
    con = sqlite3.connect(DATABASE)
    con.row_factory = sqlite3.Row
    try:
        cursor = con.cursor()
        try:
            cursor.execute(sqlite_query)
            executed_query = cursor.fetchall()
            if executed_query is not None:
                return executed_query
            return None
        finally:
            cursor.close()
    finally:
        con.close()


def get_data_animal_id(animal_id):
    sql_query = (""" SELECT
                    animals_normal.id,
                    dict_animal_types.name_type,
                    animals_normal.name,
                    dict_breeds.name_breed,
                    col1.name_color as color1,
                    col2.name_color as color2,
                    dict_outcome_subtype.name_subtype,
                    dict_outcome_type.name_outcome_type,
                    animals_normal.date_of_birth, animals_normal.outcome_month, animals_normal.outcome_year,  
                    age_animals.age_value, dict_age_measurement.name_measure
                    FROM animals_normal
                    LEFT JOIN age_animals ON animals_normal.id = age_animals.id
                    LEFT JOIN dict_age_measurement ON age_animals.age_measure_id  = dict_age_measurement.id
                    LEFT JOIN dict_breeds ON animals_normal.breed_id  = dict_breeds.id
                    LEFT JOIN dict_animal_types ON animals_normal.animal_type_id  = dict_animal_types.id
                    LEFT JOIN dict_colors as col1
                           ON col1.id = animals_normal.one_color_id 
                    LEFT JOIN dict_colors as col2
                           ON col2.id = animals_normal.two_color_id  
                    LEFT JOIN dict_outcome_subtype ON animals_normal.outcome_subtype_id  = dict_outcome_subtype.id
                    LEFT JOIN dict_outcome_type ON animals_normal.outcome_type_id = dict_outcome_type.id
                """)
    sql_query = sql_query + f' WHERE  animals_normal.id = {animal_id}'
    result = get_db_result(sql_query)
    # Переведём в json
    list_animal = []
    for item in result:
        dict_film = dict(item)
        list_animal.append(dict_film)
    return list_animal

# result_1 = (get_data_animal_id(6))
# for item in result_1:
#     print(dict(item))
