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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170727181627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.integer "level"
    t.string "stream"
    t.string "subject"
    t.integer "teacher_id"
    t.string "content"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "associations", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fees", force: :cascade do |t|
    t.integer "total_fees"
    t.integer "amount_paid"
    t.boolean "settled"
    t.datetime "due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "student_id"
  end

  create_table "grades", force: :cascade do |t|
    t.integer "cat1"
    t.integer "cat2"
    t.integer "cat3"
    t.integer "total"
    t.string "grade"
    t.integer "position"
    t.string "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject_name"
  end

  create_table "parents", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "email"
    t.string "username"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "perfomances", force: :cascade do |t|
    t.integer "student_id"
    t.integer "grade_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.integer "subject_id"
    t.integer "grade_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.string "stream"
    t.string "fee"
    t.string "dormitory"
    t.string "clubs"
    t.string "events"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.integer "student_id"
    t.integer "assignment_id"
    t.boolean "editing"
    t.boolean "revision"
    t.boolean "approved"
    t.boolean "rejected"
    t.binary "file"
    t.string "content"
    t.boolean "under_review"
  end

end
