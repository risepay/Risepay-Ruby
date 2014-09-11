class CreateRisepays < ActiveRecord::Migration
  def change
    create_table :risepays do |t|

      t.timestamps
    end
  end
end
