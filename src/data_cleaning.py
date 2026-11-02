
from pathlib import Path
import pandas as pd


# Paths
PROJECT_DIR = Path(__file__).resolve().parent.parent
RAW_FILE = PROJECT_DIR / "data" / "raw" / "Online Retail.xlsx"
OUTPUT_FILE = PROJECT_DIR / "data" / "processed" / "sales_for_sql.csv"


def load_data(file_path: Path) -> pd.DataFrame:
    """Load the original Excel dataset."""
    return pd.read_excel(file_path)


def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """Prepare transaction data for sales analysis."""

    df = df.copy()

    df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"])
    

    df = df[
        (df["Quantity"] > 0)
        & (df["UnitPrice"] > 0)
        & (df["CustomerID"].notna())
        & (~df["InvoiceNo"].astype(str).str.startswith("C"))
    ].copy()

    df["CustomerID"] = df["CustomerID"].astype("int64")
    df["Revenue"] = df["Quantity"] * df["UnitPrice"]

    return df


def main():
    if not RAW_FILE.exists():
        raise FileNotFoundError(
            f"Dataset not found: {RAW_FILE}"
        )

    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)

    df = load_data(RAW_FILE)
    cleaned_df = clean_data(df)

    cleaned_df.to_csv(
        OUTPUT_FILE,
        index=False,
        encoding="utf-8-sig"
    )

    print(f"Original rows: {len(df):,}")
    print(f"Cleaned rows: {len(cleaned_df):,}")
    print(f"Revenue: £{cleaned_df['Revenue'].sum():,.2f}")
    print(f"Saved to: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
