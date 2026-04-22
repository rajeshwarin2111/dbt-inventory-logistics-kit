# 📦 dbt Inventory & Logistics Starter Kit

A production-grade dbt project modelling a complete warehouse-to-site asset movement system — built by a practitioner who has delivered this in a real client engagement.

---

## 🧠 What This Kit Models

A real-world logistics operation where:

- Customers raise **installation requests** (WiFi, LAN, CCTV, Power Backup)
- **Move orders** are created to dispatch required items from warehouse to site
- A **shipment company** delivers items to the site engineer
- The engineer **receives, validates, and installs** items
- **Excess, faulty, or uninstalled** items are returned via return orders
- **Stock levels** are tracked per item per warehouse throughout

This is the same data flow used by telecom, ISP, infrastructure, and facilities management companies worldwide.

---

## 🗄️ Data Architecture

### Source Tables (13 tables)

**Master**
| Table | Description |
|---|---|
| `items` | All trackable assets — routers, cables, switches etc |
| `warehouses` | Warehouse locations |
| `sites` | Installation site locations |
| `engineers` | Internal field engineers |
| `shipment_companies` | Approved third-party delivery companies |

**Transactional**
| Table | Description |
|---|---|
| `requests` | Customer installation requests |
| `move_orders` | Orders to dispatch items from warehouse to site |
| `move_order_lines` | Line items per move order |
| `shipments` | Physical shipments — covers both FORWARD and REVERSE |
| `shipment_lines` | Line items per shipment for receipt validation |
| `return_orders` | Return requests — Excess, Faulty, or Uninstallation |
| `return_order_lines` | Line items per return order |
| `stock` | Current inventory levels per item per warehouse |

---

### dbt Layer Structure

```
models/
├── intermediate/
│   ├── int_move_orders_enriched.sql      → Move order + lines + site + warehouse + items
│   ├── int_shipments_enriched.sql        → Shipments + lines + company + engineer + location
│   ├── int_rev_orders_enriched.sql       → Return orders + lines + site + warehouse + items
│   └── int_asset_lifecycle.sql           → Full item journey from order to return
│
└── marts/
    ├── dims/
    │   ├── dim_items.sql
    │   ├── dim_sites.sql
    │   └── dim_warehouses.sql
    │
    ├── facts/
    │   ├── fct_move_order_lines.sql      → Grain: one row per move order line
    │   ├── fct_shipment_lines.sql        → Grain: one row per shipment line
    │   └── fct_return_lines.sql          → Grain: one row per return line
    │
    └── kpis/
        ├── kpi_move_order_fulfillment.sql → Fulfillment rate per order / site / service
        ├── kpi_shipment_delivery.sql      → On-time rate, damage rate per company
        ├── kpi_return_analysis.sql        → Return patterns by reason / item / site
        └── kpi_stock_health.sql           → Stock utilization per warehouse
```

---

## 📊 KPI Models — What You Can Answer

| KPI Model | Questions Answered |
|---|---|
| `kpi_move_order_fulfillment` | What % of orders are fully fulfilled? Which sites have pending orders? Which service types have most delays? |
| `kpi_shipment_delivery` | Which company delivers on time? What is the average delay? Where is damage happening? |
| `kpi_return_analysis` | What items are returned most? Are returns excess, faulty, or uninstallation? What condition do items arrive in? |
| `kpi_stock_health` | Which warehouses are low on stock? What items are fully reserved? How much stock is damaged and idle? |

---

## ⚙️ Setup

### Prerequisites

- dbt Core `>= 1.5` or dbt Cloud
- Databricks workspace with cluster or SQL warehouse
- Python `<= 3.8`

### 1. Clone the project

```bash
git clone https://github.com/rajeshwarin2111/dbt-inventory-logistics-kit.git
cd dbt-inventory-logistics-kit
```

### 2. Install dbt Databricks adapter

```bash
pip install dbt-databricks
```

### 3. Configure `profiles.yml`

Add this to your `~/.dbt/profiles.yml`:

```yaml
inventory_logistics:
  target: dev
  outputs:
    dev:
      type: databricks
      host: your-workspace.azuredatabricks.net
      http_path: /sql/1.0/warehouses/your-warehouse-id
      token: your-personal-access-token
      catalog: hive_metastore         # or your Unity Catalog name
      schema: raw
```

### 4. Set environment variables

```bash
export DBT_DATABASE=hive_metastore
export DBT_SCHEMA=inventory_dev
```

### 5. Load sample data

Upload the included `inventory_logistics_sample_data.xlsx` to your warehouse. Each sheet maps directly to a source table.

### 6. Run dbt

```bash
# Test source connections
dbt debug

# Run source tests
dbt test --select source:*

# Build all models
dbt run

# Run all tests
dbt test

# Generate and serve docs
dbt docs generate
dbt docs serve
```

---

## 🧪 Data Quality Tests

Every model includes tests for:

- **Uniqueness** — all primary keys
- **Not null** — all mandatory columns
- **Accepted values** — all status, flag, and enum columns
- **Referential integrity** — all foreign key relationships
- **Nullable FK handling** — optional relationships use `where` config

Run tests at any layer:

```bash
dbt test --select marts.*
dbt test --select intermediate.*
dbt test --select source:raw.*
```

---

## 🔑 Key Design Decisions

**Why one `shipments` table for FORWARD and REVERSE?**
Both directions share the same structure — shipment company, engineer, line items, dates. Separating them would duplicate logic. A `shipment_type` flag cleanly differentiates direction.

**Why is `move_order_id` nullable on `return_orders`?**
Uninstallation returns have no originating move order — the item may have been installed months ago with no traceable move order in the system. Making it nullable handles this real-world case cleanly.

**Why intermediate models reference each other?**
`int_shipments_enriched` pulls location from `int_move_orders_enriched` and `int_rev_orders_enriched` via `COALESCE` — so location is always populated regardless of shipment direction. This avoids re-joining the same tables in every downstream model.

**Why `quantity_variance` uses `COALESCE`?**
In-transit shipments have `NULL` received quantity. Without `COALESCE(received_quantity, 0)`, variance returns `NULL` instead of the dispatched amount — masking potential data issues.

---

## 🚀 Next Steps & Production Enhancements

This kit is intentionally kept clean for learning. In a production project you would add:

- **Surrogate keys** using `dbt_utils.generate_surrogate_key()`
- **SCD Type 2** on dimension tables for historical tracking
- **Incremental models** on fact tables for large data volumes
- **CI/CD pipeline** using GitHub Actions + dbt Cloud
- **Exposures** in `schema.yml` to document downstream BI tools
- **Macros** for reusable logic like status mapping and date handling

---

## 📁 What's Included

```
├── models/
│   ├── intermediate/         → 4 enriched intermediate models
│   └── marts/                → 3 dims + 3 facts + 4 KPI models
├── sources.yml               → Source definitions with data tests
├── marts/schema.yml          → Mart model documentation and tests
├── sample_data/
│   └── inventory_logistics_sample_data.xlsx
└── README.md
```

---

## 🙋 Support

If you have questions about setup or want to understand a specific model's logic, raise an issue on the GitHub repo or reach out directly.

---

*Built with real-world ETL experience. Not a tutorial — a production pattern.*
