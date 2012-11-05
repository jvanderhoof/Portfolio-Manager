# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120421130604) do

  create_table "account_company_assets", :force => true do |t|
    t.integer  "investment_account_company_id"
    t.integer  "investment_asset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "account_company_assets", ["investment_account_company_id", "investment_asset_id"], :name => "account_company_assets_idx"

  create_table "asset_histories", :force => true do |t|
    t.integer  "investment_asset_id"
    t.float    "open"
    t.float    "close"
    t.float    "high"
    t.float    "low"
    t.date     "day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "dividend"
  end

  add_index "asset_histories", ["investment_asset_id", "day"], :name => "asset_day_idx", :unique => true
  add_index "asset_histories", ["investment_asset_id", "dividend"], :name => "asset_dividend_idx"
  add_index "asset_histories", ["investment_asset_id"], :name => "index_asset_histories_on_asset_id"

  create_table "asset_values", :force => true do |t|
    t.integer  "investment_asset_id"
    t.float    "value"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "asset_values", ["investment_asset_id"], :name => "index_asset_values_on_asset_id"

  create_table "buy_list_assets", :force => true do |t|
    t.integer  "buy_list_id"
    t.integer  "investment_asset_id"
    t.integer  "share_count",         :default => 0
    t.float    "share_price",         :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buy_list_assets", ["buy_list_id"], :name => "index_buy_list_assets_on_buy_list_id"
  add_index "buy_list_assets", ["investment_asset_id"], :name => "index_buy_list_assets_on_asset_id"

  create_table "buy_lists", :force => true do |t|
    t.integer  "investment_plan_id"
    t.date     "date"
    t.float    "total_amount",       :default => 0.0
    t.boolean  "purchased",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buy_lists", ["investment_plan_id"], :name => "index_buy_lists_on_investment_plan_id"

  create_table "buy_requests", :force => true do |t|
    t.integer  "portfolio_asset_id"
    t.float    "price"
    t.integer  "asset_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buy_requests", ["asset_id"], :name => "index_buy_requests_on_asset_id"
  add_index "buy_requests", ["portfolio_asset_id"], :name => "index_buy_requests_on_portfolio_asset_id"

  create_table "identities", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "index_investment_assets", :force => true do |t|
    t.integer  "investment_asset_id"
    t.integer  "index_id"
    t.date     "date_added"
    t.date     "date_removed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "indices", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "investment_account_companies", :force => true do |t|
    t.string   "name"
    t.text     "available_assets"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "investment_account_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "investment_account_types", ["name"], :name => "index_investment_account_types_on_name"

  create_table "investment_accounts", :force => true do |t|
    t.integer  "investment_account_type_id"
    t.integer  "person_id"
    t.float    "match",                         :default => 0.0
    t.string   "contribution_frequency"
    t.text     "available_funds"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "investment_account_company_id"
  end

  add_index "investment_accounts", ["investment_account_type_id"], :name => "index_investment_accounts_on_investment_account_type_id"
  add_index "investment_accounts", ["person_id"], :name => "index_investment_accounts_on_person_id"

  create_table "investment_asset_categories", :force => true do |t|
    t.string   "name"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  add_index "investment_asset_categories", ["key"], :name => "index_investment_asset_categories_on_key"

  create_table "investment_asset_category_plans", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "investment_asset_category_id"
    t.float    "allocation_percentage",        :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "investment_asset_category_plans", ["investment_asset_category_id"], :name => "inv_asset_category_plan_category_idx"
  add_index "investment_asset_category_plans", ["plan_id"], :name => "index_investment_asset_category_plans_on_plan_id"

  create_table "investment_asset_investment_accounts", :force => true do |t|
    t.integer  "investment_asset_id"
    t.integer  "investment_account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "investment_asset_investment_accounts", ["investment_account_id"], :name => "iaia_investment_account_idx"
  add_index "investment_asset_investment_accounts", ["investment_asset_id"], :name => "iaia_investment_asset_idx"

  create_table "investment_assets", :force => true do |t|
    t.string   "name"
    t.string   "symbol"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "expense_ratio"
    t.float    "current_value"
    t.string   "asset_category"
    t.float    "one_year_return"
    t.float    "three_year_return"
    t.float    "five_year_return"
    t.float    "ten_year_return"
    t.float    "twenty_year_return"
    t.integer  "investment_asset_category_id"
    t.integer  "investment_asset_type_id"
    t.string   "category_hierarchy"
  end

  add_index "investment_assets", ["category_hierarchy"], :name => "index_investment_assets_on_category_hierarchy"
  add_index "investment_assets", ["investment_asset_category_id", "investment_asset_type_id"], :name => "investment_assets_category_type_idx"
  add_index "investment_assets", ["investment_asset_category_id"], :name => "investment_asset_cat_idx"
  add_index "investment_assets", ["investment_asset_type_id"], :name => "index_investment_assets_on_investment_asset_type_id"
  add_index "investment_assets", ["symbol"], :name => "index_assets_on_symbol"

  create_table "investment_plan_assets", :force => true do |t|
    t.integer  "investment_plan_id"
    t.integer  "investment_asset_id"
    t.integer  "shares"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "investment_plan_assets", ["investment_asset_id"], :name => "index_investment_plan_assets_on_asset_id"
  add_index "investment_plan_assets", ["investment_plan_id", "investment_asset_id"], :name => "investment_plan_asset_idx", :unique => true
  add_index "investment_plan_assets", ["investment_plan_id"], :name => "index_investment_plan_assets_on_investment_plan_id"

  create_table "investment_plans", :force => true do |t|
    t.float    "initial_contribution",    :default => 0.0
    t.string   "time_period"
    t.date     "start_date"
    t.float    "banked_value",            :default => 0.0
    t.float    "total_contributed_value", :default => 0.0
    t.float    "contribution_amount",     :default => 0.0
    t.integer  "portfolio_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "user_id"
    t.boolean  "email_updates",           :default => false
  end

  add_index "investment_plans", ["user_id"], :name => "index_investment_plans_on_user_id"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.date     "birthday"
    t.float    "income"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_401k",   :default => true
  end

  create_table "plans", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["user_id"], :name => "index_plans_on_user_id"

  create_table "portfolio_assets", :force => true do |t|
    t.float    "percentage"
    t.integer  "investment_asset_id"
    t.integer  "portfolio_id"
    t.integer  "shares",              :default => 0
    t.float    "current_value",       :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "portfolio_assets", ["investment_asset_id"], :name => "index_portfolio_assets_on_asset_id"
  add_index "portfolio_assets", ["portfolio_id"], :name => "index_portfolio_assets_on_portfolio_id"

  create_table "portfolios", :force => true do |t|
    t.string   "name"
    t.float    "available_funds",    :default => 0.0
    t.float    "current_value",      :default => 0.0
    t.float    "contributed_value",  :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "template",           :default => false
    t.integer  "user_id"
    t.text     "description"
    t.integer  "order_by",           :default => 0
    t.float    "one_year_return"
    t.float    "three_year_return"
    t.float    "five_year_return"
    t.float    "ten_year_return"
    t.float    "twenty_year_return"
  end

  add_index "portfolios", ["order_by"], :name => "index_portfolios_on_order_by"
  add_index "portfolios", ["user_id"], :name => "index_portfolios_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",           :default => false
    t.string   "plan_level",      :default => "basic"
    t.float    "percent_to_save", :default => 10.0
    t.boolean  "send_emails",     :default => false,   :null => false
  end

  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid", :unique => true

end
