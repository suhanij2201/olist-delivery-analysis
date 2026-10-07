# Olist Delivery Performance Analysis

SQL analysis of 96,470 delivered orders from a Brazilian e-commerce marketplace, examining whether a strong on-time delivery rate actually reflects reliable delivery.

**[View the dashboard](https://datastudio.google.com/reporting/080027a2-afe3-43e7-9c4c-10b8159b7fd0)** (Looker Studio)

---

## Headline finding

The marketplace reports a **91.9% on-time delivery rate**, which looks healthy.

It isn't what it appears to be. **73.9% of orders arrive seven or more days early**, and the average order lands around **11 days ahead of its estimated date**. The estimates are padded, so the on-time metric is measuring how conservative the promise was, not how reliable the delivery is.

This matters operationally. An on-time rate built on padding will stay high even as real performance degrades, because the buffer absorbs the slippage. It's a metric that hides problems rather than surfacing them.

---

## Dataset

Olist Brazilian E-Commerce ([Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)) — nine linked tables covering orders, order items, products, sellers and delivery dates.

Analysis run in SQLite. Scope: orders with status `delivered` and a non-null delivery date.

**Note on date range.** The dashboard is filtered to January 2017 onward. 2016 data is sparse — a few hundred orders across scattered months — and the resulting monthly averages were too noisy to read. Excluding it moves the headline figures by less than a tenth of a percentage point, so the finding holds either way.

---

## Questions and findings

| # | Question | Finding |
|---|---|---|
| [1](queries/01_on_time_rate.sql) | What proportion of orders arrive by the estimated date? | 91.89% across 96,470 delivered orders |
| [2](queries/02_delivery_distribution.sql) | How is delivery performance distributed? | 73.9% arrive 7+ days early — the on-time rate is an artefact of padded estimates |
| [3](queries/03_lead_time_by_category.sql) | Which categories take longest from order to delivery? | Office furniture at 20.8 days against roughly 13 for everything else |
| [4](queries/04_severely_late_orders.sql) | Which orders missed the promise by more than a week? | The extreme tail is a bulk status-update artefact, not genuine delay — these should be flagged and excluded before drawing conclusions about worst-case performance |
| [5](queries/05_seller_scorecard.sql) | Which sellers perform worst, and how much revenue sits behind them? | One seller: 389 orders, R$36k revenue, 76.9% on-time — the largest single revenue exposure |
| [6](queries/06_monthly_trend.sql) | Is delivery performance improving or deteriorating? | On-time rate fell from 94.7% to 85.7% in November 2017 as order volume rose 63% — a capacity constraint at Black Friday |
| [7](queries/07_freight_vs_delay.sql) | Does higher freight cost mean more reliable delivery? | No relationship. Freight cost doesn't predict reliability once estimate padding is accounted for |

---

## Technical notes

**The seller scorecard join (Q5).** `order_items` holds one row per item, so an order containing three items from the same seller appears three times. Joining it directly to `orders` would count that order three times and distort the on-time percentage — fan-out. The CTE collapses `order_items` to one row per order-seller pair before the join, so the metric is calculated at order level rather than line level.

**Date arithmetic.** SQLite has no native date subtraction, so `julianday()` converts dates to numbers before subtracting.

**Minimum thresholds.** Queries 3 and 5 use `HAVING` to drop categories and sellers with small order counts, where averages are noise rather than signal.

---

## What I'd do differently

- The 2016 exclusion is a judgement call. A more thorough approach would model the sparse months explicitly rather than dropping them.
- Q4's finding — that the extreme late tail is a recording artefact — came out of inspecting the results rather than being anticipated. A cleaner process would check for status-update batching before running the exception analysis.
- Freight cost returned a null result. Testing delivery distance instead would probably be more informative, since Brazil's geography is a plausible driver of lead time variation.

---

## Repository structure

```
queries/     One .sql file per business question, each with the question as a header comment
data/        Notes on the source dataset
```
