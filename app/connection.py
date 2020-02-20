import asyncio
import edgedb
import itertools

from edgedb import AsyncIOConnection


c = itertools.count()


async def create_table(connection: AsyncIOConnection, name: str) -> None:
    mig_name = f"m{next(c)}"
    async with connection.transaction():
        await connection.execute(
            f"""CREATE MIGRATION {mig_name} TO {{ 
                module default {{ 
                    type {name} {{ 
                        property name -> str 
                    }} 
                }} 
            }}; 
            COMMIT MIGRATION {mig_name};"""
        )
        print(f"Table {name} created.")


async def check_table(connection: AsyncIOConnection, name: str) -> None:
    async with connection.transaction():
        print(await connection.fetchall(
            f"""WITH MODULE schema 
            SELECT ObjectType {{ name }} 
            FILTER .name = 'default::{name}';"""
        ))


async def main():
    pool = await edgedb.create_async_pool(host='edgedb', port=5656, user='edgedb', database='edgedb')
    async with pool.acquire() as connection:
        await create_table(connection, 'A')
        await check_table(connection, 'A')
        await create_table(connection, 'B')
        await check_table(connection, 'B')
        await check_table(connection, 'A')

asyncio.run(main())
