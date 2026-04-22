# ⚙️ Setup Guide – Inventory & Logistics dbt Project

This guide will help you run the project end-to-end using **dbt + Databricks**.

---

## 🚀 Prerequisites

Make sure you have:

* Python (<= 3.11)
* dbt installed
* Access to Databricks workspace
* Databricks SQL Warehouse / Cluster

---

## 🔧 Step 1: Install dbt (Databricks Adapter)

```bash
pip install dbt-databricks
```

Verify installation:

```bash
dbt --version
```

---

## 🔐 Step 2: Configure `profiles.yml`

Create or update your dbt profile file:

📍 Location:

* Mac/Linux → `~/.dbt/profiles.yml`
* Windows → `C:\Users\<your_user>\.dbt\profiles.yml`

---

### Example Configuration

```yaml
inventory_project:
  target: dev
  outputs:
    dev:
      type: databricks
      catalog: your_catalog
      schema: your_schema
      host: https://<databricks-host>
      http_path: /sql/1.0/warehouses/<warehouse-id>
      token: <your-access-token>
```

---

## 📂 Step 3: Clone the Repository

```bash
git clone <dbt-inventory-logistic-kit-repo-url>
cd dbt-inventory-logistics-kit
```

---

## 📊 Step 4: Load Sample Data (Excel → dbt Seeds)

This project includes **sample data in Excel format**, where each sheet represents a source table.

---

### 🔹 How it works

* Each sheet = one table
* Sheet name = table name
* Data will be loaded into your warehouse using dbt seeds

---

### 🔹 Step 4.1: Convert Excel to CSV

dbt only supports CSV for seeds.

👉 Convert each sheet into CSV files:

Example:

| Excel Sheet Name | CSV File Name  |
| ---------------- | -------------- |
| items            | items.csv      |
| warehouses       | warehouses.csv |
| shipments        | shipments.csv  |

---

### 🔹 Step 4.2: Place files in `seeds/` folder

```id="j8pb5v"
seeds/
├── items.csv
├── warehouses.csv
├── sites.csv
├── shipments.csv
├── shipment_lines.csv
├── move_orders.csv
├── move_order_lines.csv
├── return_orders.csv
├── return_order_lines.csv
├── stock.csv
```

---

### 🔹 Step 4.3: Load data using dbt

```bash id="c98r05"
dbt seed
```

This will create tables in your target schema.

---

### 🔹 Step 4.4: Verify

Run:

```bash id="bb99d4"
dbt run
```

👉 Models should now build successfully using the seeded data.

---

### 🔹 Optional (Recommended)

If you're using Excel frequently, you can:

* Export all sheets as CSV in one go
* Keep them version-controlled in `seeds/`

---

## 🎯 Outcome

You now have:

* Fully populated source tables
* Ready-to-run dbt models
* End-to-end working pipeline

---

## ⚙️ Step 5: Run dbt Models

```bash
dbt run
```

This will:

* Build intermediate models
* Create fact & dimension tables
* Generate KPI models

---

## 🧪 Step 6: Run Data Tests

```bash
dbt test
```

This validates:

* Data integrity
* Relationships
* Business rules

---

## 📚 Step 7: View Documentation (Optional)

```bash
dbt docs generate
dbt docs serve
```

Open in browser:
👉 http://localhost:8080

---

## 📈 Expected Output

After successful run, you will have:

### Intermediate Models

* Enriched datasets for orders, shipments, and returns

### Fact Tables

* Move orders, shipments, returns (line-level grain)

### Dimension Tables

* Items, sites, warehouses

### KPI Models

* Fulfillment rate
* Shipment performance
* Return analysis
* Stock utilization

---

## ⚠️ Troubleshooting

### Issue: Connection Error

* Verify Databricks host and token
* Check SQL warehouse is running

### Issue: Models not building

* Run:

```bash
dbt debug
```

### Issue: Missing tables

* Ensure seeds are loaded
* Verify schema permissions

---

## 💡 Tips

* Use `dbt run --select <model_name>` to run specific models
* Use `dbt test --select <model_name>` for targeted validation
* Explore lineage using dbt docs

---

## 🎯 Outcome

After setup, you will have a **production-style analytics system** capable of:

* Tracking inventory movement
* Monitoring shipment performance
* Analyzing return behavior
* Generating business KPIs

---

## 🔥 You're Ready!

You now have a working **end-to-end dbt project on Databricks** 🚀
