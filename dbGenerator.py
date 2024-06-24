import random

import psycopg2
from psycopg2 import OperationalError
from faker import Faker

fake = Faker()
uuids = set()


def connect_to_db():
    connection = psycopg2.connect(
        database="postgres",
        user="postgres",
        password="postgres",
        host="localhost",
        port="5432",
    )

    print("connection successful")
    return connection


def generate_value(data_type, column_name):
    match data_type:
        case "uuid":
            return random.choice(list(uuids))
        case "character varying":
            if column_name == "name":
                return fake.name()
            else:
                return fake.paragraph()
        case "double precision":
            if column_name == "longitude":
                return fake.longitude()
            else:
                return fake.latitude()
        case "bigint":
            return fake.date_time_this_year().timestamp()
        case _:
            return None


def main():
    try:
        connection = connect_to_db()
    except OperationalError:
        print("could not connect to db")
        return

    cursor = connection.cursor()

    try:
        table_name = input("name of table: ")
        number_of_rows = int(input("how many rows do you want to generate? "))
        number_of_entities = int(number_of_rows / random.randint(2, 6))

        cursor.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = %s", (table_name,))
        schema = cursor.fetchall()

        print("generating data and inserting into table...")

        for _ in range(number_of_entities):
            uuids.add(fake.uuid4())

        for _ in range(number_of_rows):
            data = []
            columns = []

            for row in schema:
                data.append(generate_value(row[1], row[0]))
                columns.append(row[0])

            placeholders = ', '.join(['%s'] * len(data))
            columns = ', '.join(columns)

            query = f"INSERT INTO {table_name} ({columns}) VALUES ({placeholders})"
            cursor.execute(query, data)

        connection.commit()
        print(f"Inserted {number_of_rows} records into {table_name}.")

    except OperationalError as error:
        print(error)

    finally:
        cursor.close()
        connection.close()


if __name__ == '__main__':
    main()
