import pandas as pd
df = pd.read_csv('customer_shopping_behavior.csv')

# print(df.head())
# print(df.info())
# print(df.describe(include='all'))

# data cleaning
print(df.isnull().sum())

df['Review Rating'] = df.groupby('Category')['Review Rating'].transform(lambda x: x.fillna(x.median()))

print(df.isnull().sum())

df.columns = df.columns.str.lower()
df.columns = df.columns.str.replace(' ', '_')

print(df.columns)

df = df.rename(columns={'purchase_amount_(usd)':'purchase_amount'})

print(df.columns)

labels = ['Young Adult', 'Adult', 'Middle-aged', 'Senior']
df['age_group'] = pd.qcut(df['age'], q=4, labels = labels)

print(df[['age', 'age_group']].head(10))

frequency_mapping = {
    'Fortnightly': 14,
    'Weekly': 7,
    'Monthly': 30,
    'Quarterly': 90,
    'Bi-Weekly': 14,
    'Annually': 365,
    'Every 3 Months': 90, 
}

df['purchase_frequency_days'] = df['frequency_of_purchases'].map(frequency_mapping)

print(df[['purchase_frequency_days', 'frequency_of_purchases']].head(10))

print(df[['discount_applied', 'promo_code_used']].head(10))

print((df['discount_applied'] == df['promo_code_used']).all())

df = df.drop('promo_code_used', axis=1)

print(df.columns)