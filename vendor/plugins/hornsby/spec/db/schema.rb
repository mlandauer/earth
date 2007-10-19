ActiveRecord::Schema.define(:version => 0) do
  create_table :fruits do
    string :species
    integer :average_diameter
  end
end
