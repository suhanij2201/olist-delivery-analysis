# Data

The raw data is not stored in this repository.

Source: [Olist Brazilian E-Commerce Public Dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) on Kaggle, about 100,000 orders placed between 2016 and 2018.

To reproduce the analysis:

1. Download the CSV files from Kaggle.
2. Import them into one SQLite database (I used DB Browser for SQLite) with these table names: `orders`, `order_items`, `products`, `sellers`, `category_translation`.
3. Run the files in `queries/` in order.
