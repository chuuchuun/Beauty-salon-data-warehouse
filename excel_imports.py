import pandas as pd

# Load data from Excel
file_path = "C:\\Users\\alla\\Desktop\\hd\\task5\\database\\data\\data_2.xls"
staff_data = pd.read_excel(file_path, sheet_name="Staff members")

# Select only the desired columns by index (1, 4, 6, 7)
# Adjust the indices if needed based on your Excel file's structure
selected_columns = staff_data.iloc[:, [0, 3, 5, 6]]

# Round the third column (which is the 'Salary' column) to 2 decimal places
selected_columns.iloc[:, 2] = selected_columns.iloc[:, 2].round(2)

# Save selected columns to CSV file
output_csv_path = "C:\\Users\\alla\\Desktop\\hd\\task5\\database\\data\\staff_members_details_2.csv"
selected_columns.to_csv(output_csv_path, index=False)

print(f"Staff data exported to: {output_csv_path}")

import pandas as pd

# Load data from Excel
file_path = "C:\\Users\\alla\\Desktop\\hd\\task5\\database\\data\\data.xlsx"
product_data = pd.read_excel(file_path, sheet_name="Products")

# Clean up the data to ensure proper alignment
# Dropping rows with missing values in crucial columns
product_data.dropna(subset=[product_data.columns[0], product_data.columns[1]], inplace=True)

# Ensure all values are strings or properly formatted
product_data = product_data.applymap(lambda x: str(x).strip() if isinstance(x, str) else x)

# Round the 4th column (Price, assumed to be the 4th column) to 2 decimal places
if product_data.shape[1] >= 4:
    product_data.iloc[:, 3] = product_data.iloc[:, 3].round(2)

# Save cleaned data to CSV file
output_csv_path = "C:\\Users\\alla\\Desktop\\hd\\task5\\database\\data\\products_details.csv"
product_data.to_csv(output_csv_path, index=False)

print(f"Product data exported to: {output_csv_path}")

