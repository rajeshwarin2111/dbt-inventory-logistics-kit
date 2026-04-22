# ⚙️ Setup Guide – Inventory & Logistics dbt Project

This guide helps you run the project using **dbt + Databricks**.

---

## 🚀 Prerequisites

* Python (<= 3.11)
* dbt installed
* Access to Databricks workspace
* Databricks SQL Warehouse / Cluster

---

## 🔧 Step 1: Install dbt

```bash
pip install dbt-databricks
```

---

## 🔐 Step 2: Configure `profiles.yml`

Create a dbt profile and connect it to your Databricks workspace.

Refer to dbt documentation for full configuration.

---

## 📂 Step 3: Clone Repository

```bash
git clone <repo-url>
cd dbt-inventory-logistics-kit
```

---

## 📊 Step 4: Data Setup

This project requires source data to run successfully.

👉 Sample data is **not included in this repository**.

You can:

* Use your own data
* Or use the full version with ready-to-use datasets

---

## ⚙️ Step 5: Run Models

```bash
dbt run
```

---

## 🧪 Step 6: Run Tests

```bash
dbt test
```

---

## 📚 Optional: View Docs

```bash
dbt docs generate
dbt docs serve
```

---

## 🎯 Outcome

* Intermediate models (business logic)
* Fact & dimension tables
* KPI models

---

## ⚠️ Troubleshooting

```bash
dbt debug
```

---

## 🔥 Note

This repository focuses on **data modeling and dbt structure**.

For a complete plug-and-play setup (data + detailed guide), refer to the full version.
