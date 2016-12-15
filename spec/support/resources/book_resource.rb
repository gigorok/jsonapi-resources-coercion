class BookResource < JSONAPI::Resource

  filter :title, type: :string
  filter :qty, type: :integer
  filter :available, type: :boolean
  filter :weight, type: :float
  filter :price, type: :decimal, precision: 8
  filter :published_at, type: :time

end
