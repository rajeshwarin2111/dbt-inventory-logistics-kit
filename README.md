# 🚀 Inventory & Logistics Analytics using dbt

### End-to-End Supply Chain Data Modeling Project

Design and implementation of a **production-style analytics pipeline** using dbt to model inventory movement, shipments, returns, and full asset lifecycle.

---

## 🔥 Project Overview

This project simulates a **real-world supply chain system** where data flows from operational tables into analytics-ready models.

It focuses on:

* Inventory movement tracking
* Shipment and delivery analysis
* Return order insights
* End-to-end asset lifecycle visibility

---

## 🏗️ Architecture

![Project Architecture](./architecture_diagram.png)

The project follows a **layered dbt modeling approach**:

* **Source Layer** → Raw operational tables
* **Intermediate Layer** → Cleaned, joined, enriched business logic
* **Marts Layer** → Fact, dimension, and KPI models
* **Consumption Layer** → Reporting & analytics

---

## ⚙️ Tech Stack

* dbt (data build tool)
* SQL
* Databricks (Delta Lake)
* Modern data modeling (ELT approach)

---

## 📂 Project Structure

```
models/
├── intermediate/
│   ├── int_move_orders_enriched.sql
│   ├── int_shipments_enriched.sql
│   ├── int_rev_orders_enriched.sql
│   └── int_asset_lifecycle.sql
│
└── marts/
    ├── dims/
    │   ├── dim_items.sql
    │   ├── dim_sites.sql
    │   └── dim_warehouses.sql
    │
    ├── facts/
    │   ├── fct_move_order_lines.sql
    │   ├── fct_shipment_lines.sql
    │   └── fct_return_lines.sql
    │
    └── kpis/
        ├── kpi_move_order_fulfillment.sql
        ├── kpi_shipment_delivery.sql
        ├── kpi_return_analysis.sql
        └── kpi_stock_health.sql
```

---

## 🔄 Data Modeling Approach

### 🔹 Intermediate Layer (Business Logic)

* `int_move_orders_enriched` → Combines move orders, lines, sites, warehouses, and items
* `int_shipments_enriched` → Enriches shipment data with company, engineer, and location
* `int_rev_orders_enriched` → Return orders with warehouse & item context
* `int_asset_lifecycle` → Full lifecycle tracking from order → shipment → return

---

### 🔹 Marts Layer

#### 📊 Dimension Models

* `dim_items` → Product attributes
* `dim_sites` → Business/site hierarchy
* `dim_warehouses` → Warehouse metadata

#### 📦 Fact Models (Grain defined)

* `fct_move_order_lines` → One row per move order line
* `fct_shipment_lines` → One row per shipment line
* `fct_return_lines` → One row per return line

#### 📈 KPI Models

* `kpi_move_order_fulfillment` → Fulfillment rate by order / site / service
* `kpi_shipment_delivery` → On-time delivery & damage rate
* `kpi_return_analysis` → Return trends by reason / item / site
* `kpi_stock_health` → Warehouse stock utilization

---

## 📊 Key Business Insights Enabled

* 📦 Inventory movement tracking across warehouses
* 🚚 Shipment performance and delivery efficiency
* 🔁 Return pattern analysis
* 🔍 End-to-end asset lifecycle visibility
* 📈 KPI-driven supply chain performance monitoring

---

## ⚡ How to Run

```bash
dbt run
dbt test
```

(Optional)

```bash
dbt docs generate
dbt docs serve
```

---

## 💼 Resume Highlights

* Built an **end-to-end supply chain analytics system using dbt**
* Designed **modular intermediate models for business logic abstraction**
* Implemented **fact & dimension modeling with defined grain**
* Created **KPI layer for business reporting and decision-making**
* Applied **real-world data engineering and analytics engineering practices**

---

## 🧠 Key Learnings

* Data modeling for logistics and inventory systems
* Designing scalable dbt project structures
* Building reusable and maintainable SQL transformations
* Translating business requirements into data models

---

## 🚀 Future Enhancements

* Add incremental models
* Implement dbt tests (schema & data quality)
* Build dashboards (Power BI / Tableau)
* Add orchestration (Airflow / Databricks Jobs)

---

## ⭐ Support

If you found this useful:

* ⭐ Star the repo
* Share with your network
* Connect on **LinkedIn**

---

## 🔥 Final Note

This project demonstrates how **modern data teams design analytics layers using dbt** to convert raw operational data into actionable insights.
