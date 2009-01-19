# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090119171343) do

  create_table "case_discussions", :force => true do |t|
    t.datetime "meeting_date"
    t.string   "external_id"
    t.string   "external_link"
    t.integer  "stage_sequence_number"
    t.integer  "sequence_number"
    t.datetime "to_time"
    t.datetime "from_time"
    t.string   "transcript_url"
    t.string   "listen_url"
    t.string   "meeting_info"
    t.string   "meeting_type"
    t.string   "meeting_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "case_id"
  end

  create_table "case_documents", :force => true do |t|
    t.datetime "external_date"
    t.string   "external_id"
    t.string   "external_link"
    t.integer  "stage_sequence_number"
    t.integer  "sequence_number"
    t.string   "external_type"
    t.string   "external_author"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "case_id"
  end

  create_table "case_types", :force => true do |t|
    t.string   "case_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cases", :force => true do |t|
    t.string   "external_link"
    t.string   "external_name"
    t.integer  "case_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "info_1"
    t.text     "info_2"
    t.text     "info_3"
    t.string   "presenter"
    t.integer  "external_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_comments", :force => true do |t|
    t.integer  "document_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "bias"
    t.integer  "user_id"
    t.integer  "document_element_id"
  end

  create_table "document_elements", :force => true do |t|
    t.integer  "sequence_number"
    t.integer  "document_id"
    t.integer  "parent_id"
    t.binary   "content",           :limit => 2147483647
    t.binary   "content_text_only", :limit => 2147483647
    t.string   "content_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "content_type"
    t.boolean  "original_version"
  end

  create_table "document_states", :force => true do |t|
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_type"
  end

  create_table "documents", :force => true do |t|
    t.integer  "category_id"
    t.integer  "issue_id"
    t.integer  "document_state_id"
    t.integer  "document_type_id"
    t.datetime "voting_close_time"
    t.boolean  "published"
    t.string   "external_name"
    t.string   "external_author"
    t.string   "external_state"
    t.datetime "external_creation_date"
    t.string   "external_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "document_frozen"
    t.integer  "user_id"
    t.integer  "case_id"
    t.integer  "case_document_id"
    t.boolean  "original_version"
  end

  create_table "issues", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "law_document_comments", :force => true do |t|
    t.integer  "law_document_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "bias"
    t.integer  "user_id"
  end

  create_table "law_document_states", :force => true do |t|
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "law_document_types", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "law_document_type"
  end

  create_table "law_documents", :force => true do |t|
    t.integer  "category_id"
    t.integer  "issue_id"
    t.integer  "law_document_state_id"
    t.integer  "law_document_type_id"
    t.datetime "voting_close_time"
    t.boolean  "published"
    t.string   "original_external_name"
    t.string   "original_external_author"
    t.string   "original_external_state"
    t.datetime "original_external_creation_date"
    t.string   "original_external_link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "law_document_frozen"
    t.binary   "legal_text",                      :limit => 2147483647
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rating",                      :default => 0
    t.datetime "created_at",                                  :null => false
    t.integer  "rateable_id",                 :default => 0,  :null => false
    t.integer  "user_id",                     :default => 0,  :null => false
    t.string   "rateable_type", :limit => 50, :default => "", :null => false
  end

  add_index "ratings", ["user_id"], :name => "fk_ratings_user"

  create_table "rights", :force => true do |t|
    t.string "name"
    t.string "controller"
    t.string "action"
  end

  create_table "rights_roles", :id => false, :force => true do |t|
    t.integer "right_id"
    t.integer "role_id"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "citizen_id"
    t.float    "reputation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hashed_password"
    t.string   "salt"
  end

  create_table "vote_proxies", :force => true do |t|
    t.integer  "from_user_id"
    t.integer  "to_user_id"
    t.integer  "category_id"
    t.integer  "issue_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "votes", :force => true do |t|
    t.integer  "document_id"
    t.integer  "user_id"
    t.boolean  "agreed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "proxy_vote_count"
    t.boolean  "vote_frozen"
  end

end
