class CreateVacationProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :vacation_properties do |t|
      t.string :description
      t.string :image_url

      t.timestamps
    end
  end
end
