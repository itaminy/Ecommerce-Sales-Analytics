
from pathlib import Path
import pandas as pd


PROJECT_DIR = Path(__file__).resolve().parent.parent
INPUT_FILE = PROJECT_DIR / "data" / "processed" / "sales_for_sql.csv"
OUTPUT_FILE = PROJECT_DIR / "data" / "processed" / "rfm_customer_segments.csv"


def calculate_rfm(df: pd.DataFrame) -> pd.DataFrame:
    reference_date = df["InvoiceDate"].max() + pd.Timedelta(days=1)

    rfm = (
        df.dropna(subset=["CustomerID"])
        .groupby("CustomerID")
        .agg(
            Recency=("InvoiceDate", lambda x: (reference_date - x.max()).days),
            Frequency=("InvoiceNo", "nunique"),
            Monetary=("Revenue", "sum")
        )
    )

    rfm["R_Score"] = pd.qcut(
        rfm["Recency"].rank(method="first"),
        4,
        labels=[4, 3, 2, 1]
    ).astype(int)

    rfm["F_Score"] = pd.qcut(
        rfm["Frequency"].rank(method="first"),
        4,
        labels=[1, 2, 3, 4]
    ).astype(int)

    rfm["M_Score"] = pd.qcut(
        rfm["Monetary"].rank(method="first"),
        4,
        labels=[1, 2, 3, 4]
    ).astype(int)

    rfm["RFM_Score"] = (
        rfm["R_Score"].astype(str)
        + rfm["F_Score"].astype(str)
        + rfm["M_Score"].astype(str)
    )

    def segment_customer(row):
        r = int(row["R_Score"])
        f = int(row["F_Score"])
        m = int(row["M_Score"])

        if r >= 3 and f >= 3 and m >= 3:
            return "Champions"
        elif r >= 2 and f >= 3 and m >= 2:
            return "Loyal Customers"
        elif r >= 3 and f <= 2:
            return "Potential Loyalists"
        elif r <= 2 and f >= 2 and m >= 3:
            return "At Risk"
        elif r <= 2 and f <= 2 and m <= 2:
            return "Lost Customers"
        else:
            return "Other"

    rfm["Segment"] = rfm.apply(segment_customer, axis=1)

    return rfm.reset_index()


def main():
    if not INPUT_FILE.exists():
        raise FileNotFoundError(f"Dataset not found: {INPUT_FILE}")

    df = pd.read_csv(INPUT_FILE, parse_dates=["InvoiceDate"])
    rfm = calculate_rfm(df)

    OUTPUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    rfm.to_csv(OUTPUT_FILE, index=False, encoding="utf-8-sig")

    print(f"Customers analyzed: {len(rfm):,}")
    print("\nCustomer segments:")
    print(rfm["Segment"].value_counts())
    print(f"\nSaved to: {OUTPUT_FILE}")


if __name__ == "__main__":
    main()
