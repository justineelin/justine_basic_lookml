view: order_items {
  sql_table_name: `looker-private-demo.thelook.order_items`
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  measure: lowest_sales_price {
    type: min
    value_format_name: usd_0
    sql: ${sale_price} ;;
    drill_fields: [order_id, users.last_name, users.id, users.first_name, order_items.count]
  }

  measure: highest_sales_price {
    type: max
    value_format_name: usd_0
    drill_fields: [order_id, users.last_name, users.id, users.first_name, order_items.count]
    sql: ${sale_price} ;;
  }

  dimension: order_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  measure: percetange_of_inventory_returned {
    type: percent_of_total
    sql:  ${TABLE}.returned_at;;
    drill_fields: [order_id]
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  measure: total_sales_price {
    type: sum
    value_format_name: usd_0
    drill_fields: [order_id, users.last_name, users.id, users.first_name, order_items.count]
    sql: ${sale_price} ;;
  }

  measure: average_sales_price {
    type: average
    value_format_name:usd_0
    drill_fields: [order_id, users.last_name, users.id, users.first_name, order_items.count]
    sql: ${sale_price} ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.last_name,
      users.id,
      users.first_name,
      inventory_items.id,
      inventory_items.product_name,
      orders.order_id
    ]
  }
}
