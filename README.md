# E-commerce Sales Analytics

## Описание проекта

Аналитический проект по исследованию продаж интернет-магазина на основе датасета [UCI Online Retail](https://archive.ics.uci.edu/dataset/352/online+retail).

Цель проекта — изучить динамику продаж, определить наиболее прибыльные товары и рынки, исследовать покупательское поведение и сегментировать клиентов с помощью RFM-анализа.

## Данные

**Источник:** [UCI Machine Learning Repository — Online Retail](https://archive.ics.uci.edu/dataset/352/online+retail)

- Период: декабрь 2010 — декабрь 2011.
- Исходный объём: 541 909 строк.
- Количество исходных признаков: 8.
- Валюта анализа: GBP (£).

Исходный файл `Online Retail.xlsx` необходимо скачать самостоятельно и поместить в `data/raw/`.

Подготовленные данные доступны в репозитории в папке `data/processed/`:

- `sales_for_sql.csv` — очищенные данные о продажах для загрузки в PostgreSQL.
- `rfm_customer_segments.csv` — результаты RFM-сегментации клиентов.
- `segment_analysis.csv` — сводный анализ клиентских сегментов.

## Используемые инструменты

- **Python:** Pandas, NumPy, Matplotlib, Seaborn.
- **SQL:** PostgreSQL.
- **BI:** Microsoft Power BI.
- **Jupyter Notebook:** исследовательский анализ данных.

## Power BI Dashboard

Интерактивный дашборд с анализом выручки, заказов, стран, товаров и RFM-сегментов клиентов.

Файл отчёта: [Ecommerce_Sales_Analytics.pbix](reports/Ecommerce_Sales_Analytics.pbix).

Для просмотра и взаимодействия с отчётом необходимо открыть файл в Microsoft Power BI Desktop.

## Этапы работы

1. Загрузка и первичное исследование данных.
2. Анализ качества данных и выявление аномалий.
3. Очистка и подготовка данных с помощью Python.
4. Загрузка подготовленных данных в PostgreSQL.
5. Анализ продаж с использованием SQL.
6. Сегментация клиентов методом RFM.
7. Создание интерактивного отчёта в Power BI.
8. Формирование бизнес-выводов и рекомендаций.

## Основные результаты

- Подготовлено 397 884 записи о продажах.
- Общая выручка подготовленной выборки — £8 911 407,90.
- Исследована динамика продаж по месяцам, странам и товарам.
- Выявлена высокая концентрация выручки среди ограниченной группы клиентов.
- Проведена RFM-сегментация 4 338 клиентов на шесть групп.
- Обнаружена аномальная операция с товаром `23843`, исключённая из рейтинга товаров в Power BI.

## Структура проекта

```text
Ecommerce-Sales-Analytics/
│
├── data/
│   ├── raw/                   # Исходный датасет (локально)
│   └── processed/             # Подготовленные данные 
│
├── notebooks/
│   └── 01_data_overview.ipynb
│
├── sql/
│   ├── 01_data_quality.sql
│   ├── 02_sales_analysis.sql
│   ├── 03_customer_analysis.sql
│   └── 04_product_analysis.sql
│
├── src/
│   ├── data_cleaning.py
│   └── rfm_analysis.py
│
├── reports/
│   ├── business_insights.md
│   └── Ecommerce_Sales_Analytics.pbix
│
├── requirements.txt
├── .gitignore
└── README.md
```

## Запуск проекта

1. Склонировать репозиторий:

```bash
git clone https://github.com/itaminy/Ecommerce-Sales-Analytics.git
```

2. Перейти в папку проекта:

```bash
cd Ecommerce-Sales-Analytics
```

3. Установить зависимости:

```bash
pip install -r requirements.txt
```

4. Скачать датасет UCI Online Retail и поместить файл `Online Retail.xlsx` в папку `data/raw/`.

5. Запустить подготовку данных:

```bash
python src/data_cleaning.py
```

6. Запустить RFM-анализ:

```bash
python src/rfm_analysis.py
```

Для выполнения SQL-запросов необходимо установить PostgreSQL и создать базу данных. Файл Power BI можно открыть отдельно в Microsoft Power BI Desktop.

## Бизнес-выводы

Подробные результаты исследования и рекомендации представлены в файле [business_insights.md](reports/business_insights.md).

## Автор

**Гусев Кирилл**

Студент Кубанского государственного университета (КубГУ).

Направление: Математическое обеспечение и администрирование информационных систем.