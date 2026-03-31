#!/bin/bash

#SBATCH --job-name=assignment1_p2c
#SBATCH --output=assignment1_problem2c.out
#SBATCH --error=assignment1_problem2c.err
#SBATCH --time=00:05:00

set -euo pipefail

JOB_DIR="${SLURM_SUBMIT_DIR:-$(pwd)}"
cd "$JOB_DIR"

export JOB_DIR

apptainer exec --bind "$JOB_DIR:$JOB_DIR" --bind /data:/data "$JOB_DIR/assignment1.sif" python3 - <<'PY'
import duckdb

dataset = "/data/courses/2026_dat471_dit066/datasets/bike_sharing_hourly.csv"
dataset_sql = dataset.replace("'", "''")

con = duckdb.connect()

con.execute(
    f"""
    CREATE OR REPLACE VIEW bike_sharing AS
    SELECT *
    FROM read_csv_auto('{dataset_sql}', header=True);
    """,
)

row_count = con.execute(
    """
    SELECT COUNT(*)
    FROM bike_sharing;
    """
).fetchone()[0]

avg_hourly_count = con.execute(
    """
    SELECT AVG(cnt)
    FROM bike_sharing;
    """
).fetchone()[0]

top_5_busiest_hours = con.execute(
    """
    SELECT hr, AVG(cnt) AS avg_bike_rentals
    FROM bike_sharing
    GROUP BY hr
    ORDER BY avg_bike_rentals DESC, hr ASC
    LIMIT 5;
    """
).fetchall()

january_2012_avg_daily_count = con.execute(
    """
    SELECT AVG(daily_total)
    FROM (
      SELECT dteday, SUM(cnt) AS daily_total
      FROM bike_sharing
      WHERE strftime(CAST(dteday AS DATE), '%Y-%m') = '2012-01'
      GROUP BY dteday
    ) AS january_2012_daily_totals;
    """
).fetchone()[0]

print(f"Number of rows: {row_count}")
print(f"Average hourly bike rentals: {avg_hourly_count:.2f}")
print("Top-5 busiest hours by average bike rentals:")
for hour, avg_count in top_5_busiest_hours:
    print(f"{hour}:00 -> {avg_count:.2f}")
print(f"Average daily bike rentals in January 2012: {january_2012_avg_daily_count:.2f}")
PY
