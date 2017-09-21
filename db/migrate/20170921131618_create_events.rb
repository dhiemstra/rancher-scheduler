class CreateEvents < ActiveRecord::Migration[5.1]
  def up
    create_table :events do |t|
      t.integer :frequency_quantity, null: false
      t.string :period, null: false
      t.string :at

      # t.string :stack, null: false
      t.string :image, null: false
      t.string :command, null: false

      t.timestamp :last_run_at
      t.integer :last_exit_code
      t.text :last_error_message

      t.timestamps
    end

    execute "ALTER TABLE events ADD CONSTRAINT period_values CHECK (period IN ('second', 'minute', 'hour', 'day', 'week', 'month'))"
  end

  def down
    drop_table :events
  end
end
