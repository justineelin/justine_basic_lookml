connection: "looker-private-demo"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: order_items {
  label: "Order Item Information"
  always_filter: {
    filters: [users.age: ">=18"]
    filters: [orders.is_order_returned: "Yes"]
    filters: [orders.delivered_date: "-NULL"]
  }
  join: orders {
    relationship: many_to_one
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
  }
  join: inventory_items {
    view_label: "Inventory Items"
    #Left Join only brings in items that have been sold as order_item
    type: full_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }
  join: users {
    view_label: "Users"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }
  join: products {
    view_label: "Products"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}

datagroup: products_datagroup {
  sql_trigger:  select DATE(NOW()) ;;
  max_cache_age: "4 hours"
}

explore: products {
  label: "Product Information"
  persist_with: products_datagroup
  fields: [inventory_items*, -inventory_items.product_sku, order_items*]
  sql_always_where: ${inventory_items.product_name} <> "steve" ;;
  join: inventory_items {
    relationship: many_to_one
    type: left_outer
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }

  join: order_items{
    relationship: many_to_one
    type: left_outer
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
  }
}

explore: inventory_items {
  label: "Inventory Item Information"
  join: distribution_centers {
    relationship: one_to_many
    type: left_outer
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
  }

  join: products {
    relationship: many_to_many
    type: left_outer
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
  }
}
